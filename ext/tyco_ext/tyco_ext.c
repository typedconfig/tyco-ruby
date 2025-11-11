#include "ruby.h"
#include "../../tyco-c/include/tyco_c.h"

static VALUE rb_tyco_load_file(VALUE self, VALUE path) {
    Check_Type(path, T_STRING);
    tyco_json_result result = tyco_parse_file_json(StringValueCStr(path));
    if (result.status != TYCO_OK) {
        const char* message = result.error ? result.error : "Tyco parse error";
        tyco_json_result_free(&result);
        rb_raise(rb_eRuntimeError, "%s", message);
    }
    VALUE str = rb_utf8_str_new_cstr(result.json ? result.json : "");
    tyco_json_result_free(&result);
    return str;
}

static VALUE rb_tyco_load_string(VALUE self, VALUE content, VALUE name) {
    Check_Type(content, T_STRING);
    if (NIL_P(name)) {
        name = rb_utf8_str_new_cstr("<string>");
    }
    tyco_json_result result = tyco_parse_string_json(StringValueCStr(content), StringValueCStr(name));
    if (result.status != TYCO_OK) {
        const char* message = result.error ? result.error : "Tyco parse error";
        tyco_json_result_free(&result);
        rb_raise(rb_eRuntimeError, "%s", message);
    }
    VALUE str = rb_utf8_str_new_cstr(result.json ? result.json : "");
    tyco_json_result_free(&result);
    return str;
}

void Init_tyco_ext(void) {
    VALUE mTyco = rb_define_module("TycoNative");
    rb_define_singleton_method(mTyco, "load_file_json", rb_tyco_load_file, 1);
    rb_define_singleton_method(mTyco, "load_string_json", rb_tyco_load_string, 2);
}
