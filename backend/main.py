from fastapi import FastAPI, UploadFile, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from util.crop import crop
from typing import Any

app = FastAPI()
app.add_middleware(CORSMiddleware,
                   allow_origins=["*"],
                   allow_credentials=True,
                   allow_methods=["*"],
                   allow_headers=["*"],)

@app.get("/")
async def get_server_status():
    return {"detail": "The server is working fine."}

@app.post("/crop", response_class=StreamingResponse)
async def crop_image(file: UploadFile, blur_intensity: int = 11):
    if (file.content_type not in ["image/jpeg", "image/png"]):
        raise HTTPException(status.HTTP_415_UNSUPPORTED_MEDIA_TYPE,
                            "Only images in the JPG or PNG format are accepted.")
    cropped = crop(await file.read(), blur_intensity)
    def file_iter():
        yield cropped
    return StreamingResponse(file_iter(), media_type="image/jpeg")