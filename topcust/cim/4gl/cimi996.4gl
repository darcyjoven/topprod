database ds

GLOBALS "../../../tiptop/config/top.global"

main

    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("CIM")) THEN
       EXIT PROGRAM
    END IF

    CALL  cl_used(g_prog,g_time,1) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068

    call  remark()
    

    CALL  cl_used(g_prog,g_time,2) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
      RETURNING g_time    #No.FUN-6A0068
end main

--
function remark()

    call cl_remark('aeci100','xybtest',0)
    call cl_remark_chk('aeci100','xybtest',0)
    call cl_remark_show('aeci100','xybtest',0)

end function

--
function gobi_xml()

    type param record
        name string,
        description string,
        type integer
    end record
    type cfunction record
        name string,
        description string,
        params dynamic array of param,
        returns dynamic array of param
    end record
    type gofunction record
        name string,
        description string,
        params dynamic array of param,
        return param
    end record
    type functions dynamic array of record
        c cfunction,
        go gofunction
    end record

    type project record
        name string,
        dir string,
        description string,
        export string,
        go_export string,
        link_lab dynamic array of string,
        out_dir string,
        fgl_dir dynamic array of string,
        use_dir dynamic array of string
    end record

    type config record
        project project,
        functions functions,
        remote_ip string,
        go_cmd string,
        gcc_cmd string
    end record

    define  a           config,
            addC        cfunction,
            addGo       gofunction,
            absC        cfunction,
            absGo       gofunction,
            l_xml       om.DomNode

    let addC.name = "add"
    let addC.description = "求和"
    let addC.params[1].name = 'a'
    let addC.params[1].type = 2
    let addC.params[2].name = 'b'
    let addC.params[2].type = 2
    let addC.returns[1].name = 'c'
    let addC.returns[1].type = 2

    let addGo.name = "addGo"
    let addGo.description = "求和"
    let addGo.params[1].name = 'a'
    let addGo.params[1].type = 2
    let addGo.params[2].name = 'b'
    let addGo.params[2].type = 2
    let addGo.return.name = 'c'
    let addGo.return.type = 2

    let absC.name = "abs"
    let absC.description = "绝对值"
    let absC.params[1].name = 'a'
    let absC.params[1].type = 1
    let absC.returns[1].name = 'c'
    let absC.returns[1].type = 1

    let absGo.name = "absGo"
    let absGo.description = "绝对值"
    let absGo.params[1].name = 'a'
    let absGo.params[1].type = 1
    let absGo.return.name = 'c'
    let absGo.return.type = 1

    let a.functions[1].c.* = addC.*
    let a.functions[2].c.* = absC.*
    let a.functions[1].go.* = addGo.*
    let a.functions[2].go.* = absGo.*

    let l_xml = base.typeinfo.create(a)
    display l_xml.toString()

end function
