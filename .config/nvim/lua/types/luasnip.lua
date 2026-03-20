---@meta

---@class LSNode : any
---@alias LSNodes LSNode[]

---@type fun(context:any, nodes:LSNodes, opts?:any): LSNode
s = nil

---@type fun(pos:number, nodes:LSNodes, opts?:any): LSNode
sn = nil

---@type fun(pos:number, nodes:LSNodes, indent:string, opts?:any): LSNode
isn = nil

---@type fun(text:string|string[], opts?:any): LSNode
t = nil

---@type fun(pos:number, default?:string|string[], opts?:any): LSNode
i = nil

---@type fun(fn:function, args?:any, opts?:any): LSNode
f = nil

---@type fun(pos:number, choices:LSNodes, opts?:any): LSNode
c = nil

---@type fun(pos:number, fn:function, args?:any, opts?:any): LSNode
d = nil

---@type fun(pos:number, key:string, nodes:LSNodes, opts?:any): LSNode
r = nil

---@type fun(...): LSNode
fmt = nil

---@type fun(...): LSNode
fmta = nil

---@type fun(...): LSNode
rep = nil

---@type fun(...): LSNode
p = nil

---@type fun(...): LSNode
m = nil

---@type fun(...): LSNode
n = nil

---@type fun(...): LSNode
dl = nil

---@type fun(...): LSNode
l = nil

---@type fun(...): any
postfix = nil

---@type fun(...): any
parse = nil

---@type fun(...): any
ms = nil

events = nil
conds = nil
types = nil
extras = nil
ai = nil
opt = nil
k = nil
