local base64 = {
	chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
}

function base64.encode(input)
	local result = {}
	local padding = ""

	local remainder = #input % 3
	if remainder > 0 then
		padding = string.rep("=", 3 - remainder)
		input = input..string.rep("\0", 3 - remainder)
	end

	for i = 1, #input, 3 do
		local a = string.byte(input, i)
		local b = string.byte(input, i + 1)
		local c = string.byte(input, i + 2)

		local value1 = math.floor(a / 4)
		local value2 = ((a % 4) * 16) + math.floor(b / 16)
		local value3 = ((b % 16) * 4) + math.floor(c / 64)
		local value4 = c % 64

		result[#result + 1] = base64.chars:sub(value1 + 1, value1 + 1)
		result[#result + 1] = base64.chars:sub(value2 + 1, value2 + 1)
		result[#result + 1] = base64.chars:sub(value3 + 1, value3 + 1)
		result[#result + 1] = base64.chars:sub(value4 + 1, value4 + 1)
	end

	if padding ~= "" then
		for i = 1, #padding do
			result[#result - (i - 1)] = "="
		end
	end

	return table.concat(result)
end

return base64