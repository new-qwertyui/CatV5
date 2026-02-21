--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.
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

function base64.decode(input)
	input = input:gsub("[^A-Za-z0-9+/=]", "")
	local result = {}
	local bytes = {}

	for i = 1, #input, 4 do
		local c1 = input:sub(i, i)
		local c2 = input:sub(i + 1, i + 1)
		local c3 = input:sub(i + 2, i + 2)
		local c4 = input:sub(i + 3, i + 3)

		local v1 = base64.chars:find(c1, 1, true)
		local v2 = base64.chars:find(c2, 1, true)
		local v3 = base64.chars:find(c3, 1, true)
		local v4 = base64.chars:find(c4, 1, true)

		if not v1 or not v2 then break end
		v1, v2 = v1 - 1, v2 - 1
		v3 = v3 and (v3 - 1) or 0
		v4 = v4 and (v4 - 1) or 0

		local b1 = (v1 * 4) + math.floor(v2 / 16)
		local b2 = ((v2 % 16) * 16) + math.floor(v3 / 4)
		local b3 = ((v3 % 4) * 64) + v4

		bytes[#bytes + 1] = string.char(b1)
		if c3 ~= "=" then bytes[#bytes + 1] = string.char(b2) end
		if c4 ~= "=" then bytes[#bytes + 1] = string.char(b3) end
	end

	return table.concat(bytes)
end

return base64