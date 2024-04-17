local NOT, AND, OR, XOR, ROL, ROR, SHL, SAR, SHR, SWAP; do
    local bit = require("bit")
    NOT = bit.bnot
    AND = bit.band
    OR = bit.bor
    XOR = bit.bxor
    ROL = bit.rol
    ROR = bit.ror
    SHL = bit.lshift
    SAR = bit.arshift
    SHR = bit.rshift
    SWAP = bit.bswap
end

local sand = function(grid, x, y)
    local below = grid[y + 1]
    if below[x] == 0 then -- mid
        return x, y + 1
    elseif below[x - 1] == 0 then -- left
        return x - 1, y + 1
    elseif below[x + 1] == 0 then -- right
        return x + 1, y + 1
    else
        return x, y
    end
end

local commsand = function(grid, x, y)
    local below = grid[y + 1]
    local left, mid, right =  below[x - 1], below[x], below[x + 1]
    local life = XOR(AND(left, mid, right), 1) -- (left&mid&right)^1
    local dir = AND(AND(left - 2, -right) + 1, -mid)
    
    return x + dir, y + life
end

local bsand = function(grid, x, y, side) -- side == -1 or +1
    local below = grid[y + 1]
    local a, mid, b =  below[x + side], below[x], below[x - side]
    
    local life = XOR(AND(a, mid, b), 1) -- (a&mid&b)^1
    a, b = AND(side, a + side), AND(-side, b - side)
    local dir = AND(XOR(a, b, AND(-a, b)), -mid) -- (a^b^(-a&b))&-mid
    
    return x + dir, y + life
end

local grid = { -- [y][x] = v; start at index 1
    {0, 0, 0},
    {0, 1, 0},
    {0, 1, 1}
}
local x, y = 2, 2
local below = grid[3]

local start = 1
local finish = 10^9 -- 1'000'000'000
local step = 1

local time = os.clock()
for i = start, finish, step do
    
    --sand(grid, x, y) -- ~4.396's == 5.336 - 0.94
    --commsand(grid, x, y) -- ~0.782's == 1.722 - 0.94
    --bsand(grid, x, y, -1) -- ~0.782's == 1.722 - 0.94
    
    -- 0.94's
    below[1] = XOR(below[1], 1)
    below[2] = XOR(below[2], 1)
    below[3] = XOR(below[3], 1)
end
print(os.clock() - time)
