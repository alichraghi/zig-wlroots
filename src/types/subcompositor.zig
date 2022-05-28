const wlr = @import("../wlroots.zig");

const wayland = @import("wayland");
const wl = wayland.server.wl;

pub const Subcompositor = extern struct {
    global: *wl.Global,

    server_destroy: wl.Listener(*wl.Server),

    events: extern struct {
        destroy: wl.Signal(*wlr.Compositor),
    },

    extern fn wlr_subcompositor_create(server: *wl.Server) ?*Subcompositor;
    pub fn create(server: *wl.Server) !*Subcompositor {
        return wlr_subcompositor_create(server) orelse error.OutOfMemory;
    }
};

pub const Subsurface = extern struct {
    pub const ParentState = extern struct {
        x: i32,
        y: i32,
        /// Surface.State.subsurfaces_above/subsurfaces_below
        link: wl.list.Link,
    };

    resource: *wl.Subsurface,
    surface: *Surface,
    parent: ?*Surface,

    current: ParentState,
    pending: ParentState,

    cached_seq: u32,
    has_cache: bool,

    synchronized: bool,
    reordered: bool,
    mapped: bool,
    added: bool,

    surface_client_commit: wl.Listener(void),
    surface_destroy: wl.Listener(*Surface),
    parent_destroy: wl.Listener(*Surface),

    events: extern struct {
        destroy: wl.Signal(*Subsurface),
        map: wl.Signal(*Subsurface),
        unmap: wl.Signal(*Subsurface),
    },

    data: usize,
};
