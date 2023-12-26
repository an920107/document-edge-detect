import cv2
import numpy as np
import imutils.contours as ct


def crop(binary: bytes, intensity: int = 11) -> bytes:
    # 讀檔
    image = cv2.imdecode(np.fromstring(binary, np.uint8), cv2.IMREAD_COLOR)

    # 轉灰階
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # 高斯模糊
    blur = cv2.GaussianBlur(gray, (intensity, intensity), 0)

    # Opening & Closing
    kernel = np.ones((intensity, intensity), np.uint8)
    opening = cv2.morphologyEx(blur, cv2.MORPH_OPEN, kernel)
    closing = cv2.morphologyEx(closing, cv2.MORPH_OPEN, kernel)

    # Canny
    edged = cv2.Canny(opening, 30, 70)

    # 尋找輪廓
    contours, _ = cv2.findContours(edged.copy(),
                                   cv2.RETR_EXTERNAL,
                                   cv2.CHAIN_APPROX_SIMPLE)
    contours, _ = ct.sort_contours(contours)
    preview = cv2.cvtColor(edged, cv2.COLOR_GRAY2RGB)
    cv2.drawContours(preview, contours, -1, (0, 0, 255), 3)

    # 取得頂點
    points = np.concatenate(np.concatenate(contours))

    tl_br = np.array(list(map(lambda x: x[0] ** 2 + x[1] ** 2, points)))
    tr_bl = np.array(
        list(map(lambda x: (image.shape[1] - x[0]) ** 2 + x[1] ** 2, points)))
    vertex_indexs = [
        np.argmin(tl_br),
        np.argmin(tr_bl),
        np.argmax(tl_br),
        np.argmax(tr_bl),
    ]
    vertexs = np.array(
        list(map(lambda x: points[x], vertex_indexs)), dtype=np.float32)

    preview = cv2.cvtColor(edged, cv2.COLOR_GRAY2RGB)
    for v in vertexs:
        cv2.circle(preview, v.astype(np.int64), 10, (255, 0, 0), -1)

    # 裁切與梯形校正
    def distance(x: np.ndarray, y: np.ndarray) -> int:
        return np.sqrt([(x[0] - y[0]) ** 2 + (x[1] - y[1]) ** 2])[0]

    width = min(distance(vertexs[0], vertexs[1]),
                distance(vertexs[2], vertexs[3]))
    height = min(distance(vertexs[1], vertexs[2]),
                 distance(vertexs[3], vertexs[0]))

    dst_vertexs = np.array([
        [0, 0],
        [width - 1, 0],
        [width - 1, height - 1],
        [0, height - 1],
    ], dtype=np.float32)

    perspective_matrix = cv2.getPerspectiveTransform(vertexs, dst_vertexs)
    warped = cv2.warpPerspective(
        image, perspective_matrix, (int(width), int(height)))

    # 轉檔
    _, encoded = cv2.imencode(".jpg", warped)
    return encoded.tobytes()
