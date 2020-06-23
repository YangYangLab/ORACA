## Pseudo-code for register_stack_CalSee

```matlab
function [shifts, newstack] = register_stack(moving, template, maxshift)

	imagesize = size(template);
	template = normalise(template);
	tflip = rotate(template, 180 degrees);
	tfliplarge = expandzeros(tplflip, maxshift in 4 directions);
	
	sumtpl2 = 2Dconvolution(tplfliplarge, ones(imagesize), 'valid');
	
	for a = each frame in moving
		
		a = normalise(a);
		alarge = expandzeros(a, maxshift in 4 directions);
		suma2 = 2Dconvolution(alarge, ones(imagesize), 'valid');
		
		sumat = 2Dconvolution(alarge, tflip, 'valid');
		
		val = suma2 + sumt2 - 2*sumat;
		[minval, shifts] = min(val);
		newstack = moverigid(a, shifts);
	end
	
end

function data = normalise(data)
data = (data - mean(data)) / std(data) / sqrt(2);
end
```

