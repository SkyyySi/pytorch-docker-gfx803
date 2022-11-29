# Source: https://huggingface.co/Linaqruf/anything-v3.0
from diffusers import StableDiffusionPipeline
import torch

model_id = "Linaqruf/anything-v3.0"
pipe = StableDiffusionPipeline.from_pretrained(model_id, torch_dtype=torch.float16)
pipe = pipe.to("cuda")

prompt = "pikachu"
image = pipe(prompt).images[0]

image.save("./pikachu.png")
