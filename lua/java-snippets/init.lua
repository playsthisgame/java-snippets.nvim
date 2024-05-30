local function split_str(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

local function starts_with(str, start)
	return str:sub(1, #start) == start
end

local function get_package_from_path(path)
	local packageName = ""
	if starts_with(path, "src/main/java/") then
		path = string.sub(path, 15)
		local splitFile = split_str(path, "/")
		table.remove(splitFile, #splitFile)
		for _, name in ipairs(splitFile) do
			if packageName == "" then
				packageName = name
			else
				packageName = packageName .. "." .. name
			end
		end
	end
	return packageName
end

local function create_name_map()
	local path = vim.fn.expand("%:.")
	local fileName = vim.fn.expand("%:t")
	local splitFileName = split_str(fileName, ".")
	local className = splitFileName[1]
	local packageName = get_package_from_path(path)
	local nameMap = {
		["package"] = packageName,
		["class"] = className,
	}
	return nameMap
end

local function create_main()
	local nameMap = create_name_map()
	local classArr = {
		[1] = "package " .. nameMap["package"] .. ";",
		[2] = "",
		[3] = "public class " .. nameMap["class"] .. " {",
		[4] = "  public static void main(String[] args){",
		[5] = "  }",
		[6] = "}",
	}
	vim.api.nvim_buf_set_lines(0, -1, -1, true, classArr)
end

local function create_class()
	local nameMap = create_name_map()
	local classArr = {
		[1] = "package " .. nameMap["package"] .. ";",
		[2] = "",
		[3] = "public class " .. nameMap["class"] .. " {",
		[4] = "",
		[5] = "}",
	}
	vim.api.nvim_buf_set_lines(0, -1, -1, true, classArr)
end

local function create_interface()
	local nameMap = create_name_map()
	local classArr = {
		[1] = "package " .. nameMap["package"] .. ";",
		[2] = "",
		[3] = "public interface " .. nameMap["class"] .. " {",
		[4] = "",
		[5] = "}",
	}
	vim.api.nvim_buf_set_lines(0, -1, -1, true, classArr)
end

local function create_abstract()
	local nameMap = create_name_map()
	local classArr = {
		[1] = "package " .. nameMap["package"] .. ";",
		[2] = "",
		[3] = "public abstract class " .. nameMap["class"] .. " {",
		[4] = "",
		[5] = "}",
	}
	vim.api.nvim_buf_set_lines(0, -1, -1, true, classArr)
end

local function create_enum()
	local nameMap = create_name_map()
	local classArr = {
		[1] = "package " .. nameMap["package"] .. ";",
		[2] = "",
		[3] = "public enum " .. nameMap["class"] .. " {",
		[4] = "",
		[5] = "}",
	}
	vim.api.nvim_buf_set_lines(0, -1, -1, true, classArr)
end

return {
	create_main = create_main,
	create_class = create_class,
	create_interface = create_interface,
	create_abstract = create_abstract,
	create_enum = create_enum,
}
