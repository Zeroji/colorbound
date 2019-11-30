shader_type canvas_item;
render_mode unshaded;

uniform float shift = 0.5;

vec3 rgbtohsl(vec3 c) {
    float mx = max(c.r, max(c.g, c.b));
    float mn = min(c.r, min(c.g, c.b));
    float l = (mx+mn)/2f;
    float h = 0f;
    float s = 0f;
    if(mx != mn) {
        float d = mx-mn;
        s = l > 0.5 ? d / (2.0-mx-mn) : d / (mx + mn);
        if(mx == c.r) h = (c.g - c.b) / d;
        if(mx == c.r && c.g < c.b) h += 6f;
        if(mx == c.g) h = (c.b - c.r) / d + 2.0;
        if(mx == c.b) h = (c.r - c.g) / d + 4.0;
        h/=6f;
    }
    c.x = h; c.y = s; c.z = l;
    return c;
}

float hue2rgb(float p, float q, float t) {
    if(t<0f) t++;
    if(t>1f) t--;
    if(t<1f/6f) return p + (q - p) * 6f * t;
    if(t<1f/2f) return q;
    if(t<2f/3f) return p + (q - p) * (2f/3f - t) * 6f;
    return p;
}

vec3 hsltorgb(vec3 c) {
    float h = c.x, s = c.y, l = c.z;
    if(s == 0f) {
        c.r = l; c.g = l; c.b = l;
    } else {
        float q = l < 0.5 ? l * (1f + s) : l + s - l * s;
        float p = 2f * l - q;
        c.r = hue2rgb(p, q, h + 1f/3f);
        c.g = hue2rgb(p, q, h);
        c.b = hue2rgb(p, q, h - 1f/3f);
    }
    return c;
}

void fragment() {
    vec4 IN = textureLod(TEXTURE, UV, 0f);
    vec3 in_col = IN.rgb;
    in_col = rgbtohsl(in_col);
    in_col.x += shift;
    if(in_col.x >= 1f) in_col.x -= 1f;
    in_col = hsltorgb(in_col);
    COLOR.rgb = in_col;
    COLOR.a = IN.a;
}
