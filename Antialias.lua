local newImage = app.activeImage:clone();
local oldImage = newImage:clone();

local aaColor = app.fgColor.rgbaPixel;

local width = newImage.width;
local height = newImage.height;

local function getPixel(x, y)
    return oldImage:getPixel(x, y);
end

local function fillPixel(x, y)
    newImage:drawPixel(x, y, aaColor);
end

local function isTransparent(pixel)
    return pixel == 0;
end

for x = 0, width do
    for y = 0, height do
        if isTransparent(getPixel(x, y)) then
            local left   = x > 0          and not isTransparent(getPixel(x - 1, y));
            local right  = x < width - 1  and not isTransparent(getPixel(x + 1, y));
            local top    = y > 0          and not isTransparent(getPixel(x, y - 1));
            local bottom = y < height - 1 and not isTransparent(getPixel(x, y + 1));

            if (top and left) or (top and right) or (bottom and left) or (bottom and right) then
                fillPixel(x, y);
            end
        end
    end
end

app.activeImage:putImage(newImage);
