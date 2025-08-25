utils={}
function utils:PrintTable(node)
    if not node or type(node) ~= "table" then
        return tostring(node)
    end
    local depthBufferHelper = {}
    local function tab(amt)
        if not depthBufferHelper[amt] then
            local t = {}
            for i = 1, amt do
                table.insert(t,"\t")
            end
            depthBufferHelper[amt] = table.concat(t)
        end
        return depthBufferHelper[amt]
    end
    local bufferHelper = {}
    local function __P(_node,_depth,_buffer)
        bufferHelper[_node] = true
        table.insert(_buffer,tab(_depth-1))
        table.insert(_buffer," {\n")
        for k,v in pairs(_node)  do
            local output = {}
            table.insert(output,tab(_depth))
            if (type(k) == "number" or type(k) == "boolean") then
                table.insert(output,"[")
                table.insert(output,tostring(k))
                table.insert(output,"]")
            else
                table.insert(output,"['")
                table.insert(output,tostring(k))
                table.insert(output,"']")
            end

            table.insert(output," = ")
            table.insert(output,tostring(v))
            table.insert(output,"\n")
            table.insert(_buffer,table.concat(output))
            if (type(v) == "table") then
                if bufferHelper[v] == nil then
                    __P(v,_depth + 1,_buffer)
                end
            end
        end
        table.insert(_buffer,tab(_depth-1))
        table.insert(_buffer," }\n")
    end

    local depth = 1
    local buffer = {}
    __P(node,depth,buffer)
    print(table.concat(buffer))
    --return table.concat(buffer)
end

function utils:SayHello()
    print("hello world")
end

local api = vim.api
function utils:create_float_window()
    local buf = api.nvim_create_buf(false, true) -- 创建一个新的缓冲区
    local width = 40
    local height = 10
    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2,
        style = 'minimal', -- 最小化窗口
    }
    api.nvim_open_win(buf, true, opts) -- 创建浮动窗口
    api.nvim_buf_set_lines(buf, 0, -1, false, {"Hello, Neovim!"}) -- 设置缓冲区内容
end


return utils
