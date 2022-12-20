# Source: https://huggingface.co/Linaqruf/anything-v3.0
from datetime import datetime
from diffusers import StableDiffusionPipeline
import torch
import pathlib

def gen_img(prompt: str="pikachu", negative_prompt: str="", count: int=1):
	model_id = "Linaqruf/anything-v3.0"
	pipe = StableDiffusionPipeline.from_pretrained(model_id, torch_dtype=torch.float16).to("cuda")

	# Disables NSFW filtering; grow up and don't be a crybaby about some potentially naughty content ;)
	# Also, this filter seems to be somewhat aggressive when it comes to false alarms.
	pipe.safety_checker = lambda images, **kwargs: (images, False)
	images = pipe(prompt, negative_prompt=negative_prompt).images

	output_path = "/data/stable-diffusion/out"
	pathlib.Path(output_path).mkdir(parents=True, exist_ok=True)
	datetime_str = datetime.now().strftime("%d.%m.%Y_%H:%M:%S")
	for i, img in enumerate(images):
		p = prompt.replace(" ", "_")
		img.save(f"${output_path}/{datetime_str}___{p}___{i:04d}.png")

gen_img()
