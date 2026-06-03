# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_remark.4gl
# Descriptions...: 备注栏位
# Date & Author..: darcy:2026/06/03


globals "../../../tiptop/config/top.global"

type uiDefine record
    col     varchar(20),
    name    varchar(100),
    type    varchar(100),
    ctrlp   varchar(100),
    value   varchar(1000),
    desc    varchar(1000),
    default varchar(200),
    require varchar(1)
end record
type tc_rem record
    tc_remprog      like tc_rem_file.tc_remprog,
    tc_remdocno     like tc_rem_file.tc_remdocno,
    tc_remseq       like tc_rem_file.tc_remseq,
    tc_remdate      like tc_rem_file.tc_remdate,
    tc_rem01        like tc_rem_file.tc_rem01,
    tc_rem02        like tc_rem_file.tc_rem02,
    tc_rem03        like tc_rem_file.tc_rem03,
    tc_rem04        like tc_rem_file.tc_rem04,
    tc_rem05        like tc_rem_file.tc_rem05,
    tc_rem06        like tc_rem_file.tc_rem06,
    tc_rem07        like tc_rem_file.tc_rem07,
    tc_rem08        like tc_rem_file.tc_rem08,
    tc_rem09        like tc_rem_file.tc_rem09,
    tc_rem10        like tc_rem_file.tc_rem10,
    tc_rem11        like tc_rem_file.tc_rem11,
    tc_rem12        like tc_rem_file.tc_rem12,
    tc_rem13        like tc_rem_file.tc_rem13,
    tc_rem14        like tc_rem_file.tc_rem14,
    tc_rem15        like tc_rem_file.tc_rem15,
    tc_rem16        like tc_rem_file.tc_rem16,
    tc_rem17        like tc_rem_file.tc_rem17,
    tc_rem18        like tc_rem_file.tc_rem18,
    tc_rem19        like tc_rem_file.tc_rem19,
    tc_rem20        like tc_rem_file.tc_rem20,
    tc_rem21        like tc_rem_file.tc_rem21,
    tc_rem22        like tc_rem_file.tc_rem22,
    tc_rem23        like tc_rem_file.tc_rem23,
    tc_rem24        like tc_rem_file.tc_rem24,
    tc_rem25        like tc_rem_file.tc_rem25,
    tc_rem26        like tc_rem_file.tc_rem26,
    tc_rem27        like tc_rem_file.tc_rem27,
    tc_rem28        like tc_rem_file.tc_rem28,
    tc_rem29        like tc_rem_file.tc_rem29,
    tc_rem30        like tc_rem_file.tc_rem30,
    tc_rem31        like tc_rem_file.tc_rem31,
    tc_rem32        like tc_rem_file.tc_rem32,
    tc_rem33        like tc_rem_file.tc_rem33,
    tc_rem34        like tc_rem_file.tc_rem34,
    tc_rem35        like tc_rem_file.tc_rem35,
    tc_rem36        like tc_rem_file.tc_rem36,
    tc_rem37        like tc_rem_file.tc_rem37,
    tc_rem38        like tc_rem_file.tc_rem38,
    tc_rem39        like tc_rem_file.tc_rem39,
    tc_rem40        like tc_rem_file.tc_rem40,
    tc_rem41        like tc_rem_file.tc_rem41,
    tc_rem42        like tc_rem_file.tc_rem42,
    tc_rem43        like tc_rem_file.tc_rem43,
    tc_rem44        like tc_rem_file.tc_rem44,
    tc_rem45        like tc_rem_file.tc_rem45,
    tc_rem46        like tc_rem_file.tc_rem46,
    tc_rem47        like tc_rem_file.tc_rem47,
    tc_rem48        like tc_rem_file.tc_rem48,
    tc_rem49        like tc_rem_file.tc_rem49,
    tc_rem50        like tc_rem_file.tc_rem50,
    tc_rem51        like tc_rem_file.tc_rem51,
    tc_rem52        like tc_rem_file.tc_rem52,
    tc_rem53        like tc_rem_file.tc_rem53,
    tc_rem54        like tc_rem_file.tc_rem54,
    tc_rem55        like tc_rem_file.tc_rem55,
    tc_rem56        like tc_rem_file.tc_rem56,
    tc_rem57        like tc_rem_file.tc_rem57,
    tc_rem58        like tc_rem_file.tc_rem58,
    tc_rem59        like tc_rem_file.tc_rem59,
    tc_rem60        like tc_rem_file.tc_rem60,
    tc_rem61        like tc_rem_file.tc_rem61,
    tc_rem62        like tc_rem_file.tc_rem62,
    tc_rem63        like tc_rem_file.tc_rem63,
    tc_rem64        like tc_rem_file.tc_rem64,
    tc_rem65        like tc_rem_file.tc_rem65,
    tc_rem66        like tc_rem_file.tc_rem66,
    tc_rem67        like tc_rem_file.tc_rem67,
    tc_rem68        like tc_rem_file.tc_rem68,
    tc_rem69        like tc_rem_file.tc_rem69,
    tc_rem70        like tc_rem_file.tc_rem70,
    tc_rem71        like tc_rem_file.tc_rem71,
    tc_rem72        like tc_rem_file.tc_rem72,
    tc_rem73        like tc_rem_file.tc_rem73,
    tc_rem74        like tc_rem_file.tc_rem74,
    tc_rem75        like tc_rem_file.tc_rem75,
    tc_rem76        like tc_rem_file.tc_rem76,
    tc_rem77        like tc_rem_file.tc_rem77,
    tc_rem78        like tc_rem_file.tc_rem78,
    tc_rem79        like tc_rem_file.tc_rem79,
    tc_rem80        like tc_rem_file.tc_rem80,
    tc_rem81        like tc_rem_file.tc_rem81,
    tc_rem82        like tc_rem_file.tc_rem82,
    tc_rem83        like tc_rem_file.tc_rem83,
    tc_rem84        like tc_rem_file.tc_rem84,
    tc_rem85        like tc_rem_file.tc_rem85,
    tc_rem86        like tc_rem_file.tc_rem86,
    tc_rem87        like tc_rem_file.tc_rem87,
    tc_rem88        like tc_rem_file.tc_rem88,
    tc_rem89        like tc_rem_file.tc_rem89,
    tc_rem90        like tc_rem_file.tc_rem90,
    tc_rem91        like tc_rem_file.tc_rem91,
    tc_rem92        like tc_rem_file.tc_rem92,
    tc_rem93        like tc_rem_file.tc_rem93,
    tc_rem94        like tc_rem_file.tc_rem94,
    tc_rem95        like tc_rem_file.tc_rem95,
    tc_rem96        like tc_rem_file.tc_rem96,
    tc_rem97        like tc_rem_file.tc_rem97,
    tc_rem98        like tc_rem_file.tc_rem98,
    tc_rem99        like tc_rem_file.tc_rem99,
    tc_rem100       like tc_rem_file.tc_rem100
end record

define g_cols               dynamic array of uiDefine
define g_tc_rem,g_tc_rem_t  tc_rem

-- 录入额外字段
function cl_remark(p_prog,p_doc,p_seq)
    define p_prog   varchar(100),
           p_doc    varchar(20),
           p_seq    integer
    define l_cnt ,i integer

    OPEN WINDOW cl_remark_w1 AT 2,2 WITH FORM "clib/42f/cl_remark"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

    call cl_remark_get(p_prog,p_doc,p_seq)

    call cl_remark_ui_init(p_prog)

    while true
        call cl_remark_i()

        if int_flag then
            let int_flag = false
            return
        end if
        call cl_remark_chk(p_prog,p_doc,p_seq)
        if g_success = 'Y' then
            exit while
        end if
    end while

    select count(*) into l_cnt from tc_rem_file
     where tc_remprog = g_tc_rem.tc_remprog
       and tc_remdocno = g_tc_rem.tc_remdocno
       and tc_remseq = g_tc_rem.tc_remseq

    if l_cnt > 0 then
        update tc_rem_file
           set tc_rem01 = g_tc_rem.tc_rem01,tc_rem02 = g_tc_rem.tc_rem02,tc_rem03 = g_tc_rem.tc_rem03,tc_rem04 = g_tc_rem.tc_rem04,tc_rem05 = g_tc_rem.tc_rem05,tc_rem06 = g_tc_rem.tc_rem06,tc_rem07 = g_tc_rem.tc_rem07,tc_rem08 = g_tc_rem.tc_rem08,tc_rem09 = g_tc_rem.tc_rem09,tc_rem10 = g_tc_rem.tc_rem10,
               tc_rem11 = g_tc_rem.tc_rem11,tc_rem12 = g_tc_rem.tc_rem12,tc_rem13 = g_tc_rem.tc_rem13,tc_rem14 = g_tc_rem.tc_rem14,tc_rem15 = g_tc_rem.tc_rem15,tc_rem16 = g_tc_rem.tc_rem16,tc_rem17 = g_tc_rem.tc_rem17,tc_rem18 = g_tc_rem.tc_rem18,tc_rem19 = g_tc_rem.tc_rem19,tc_rem20 = g_tc_rem.tc_rem20,
               tc_rem21 = g_tc_rem.tc_rem21,tc_rem22 = g_tc_rem.tc_rem22,tc_rem23 = g_tc_rem.tc_rem23,tc_rem24 = g_tc_rem.tc_rem24,tc_rem25 = g_tc_rem.tc_rem25,tc_rem26 = g_tc_rem.tc_rem26,tc_rem27 = g_tc_rem.tc_rem27,tc_rem28 = g_tc_rem.tc_rem28,tc_rem29 = g_tc_rem.tc_rem29,tc_rem30 = g_tc_rem.tc_rem30,
               tc_rem31 = g_tc_rem.tc_rem31,tc_rem32 = g_tc_rem.tc_rem32,tc_rem33 = g_tc_rem.tc_rem33,tc_rem34 = g_tc_rem.tc_rem34,tc_rem35 = g_tc_rem.tc_rem35,tc_rem36 = g_tc_rem.tc_rem36,tc_rem37 = g_tc_rem.tc_rem37,tc_rem38 = g_tc_rem.tc_rem38,tc_rem39 = g_tc_rem.tc_rem39,tc_rem40 = g_tc_rem.tc_rem40,
               tc_rem41 = g_tc_rem.tc_rem41,tc_rem42 = g_tc_rem.tc_rem42,tc_rem43 = g_tc_rem.tc_rem43,tc_rem44 = g_tc_rem.tc_rem44,tc_rem45 = g_tc_rem.tc_rem45,tc_rem46 = g_tc_rem.tc_rem46,tc_rem47 = g_tc_rem.tc_rem47,tc_rem48 = g_tc_rem.tc_rem48,tc_rem49 = g_tc_rem.tc_rem49,tc_rem50 = g_tc_rem.tc_rem50,
               tc_rem51 = g_tc_rem.tc_rem51,tc_rem52 = g_tc_rem.tc_rem52,tc_rem53 = g_tc_rem.tc_rem53,tc_rem54 = g_tc_rem.tc_rem54,tc_rem55 = g_tc_rem.tc_rem55,tc_rem56 = g_tc_rem.tc_rem56,tc_rem57 = g_tc_rem.tc_rem57,tc_rem58 = g_tc_rem.tc_rem58,tc_rem59 = g_tc_rem.tc_rem59,tc_rem60 = g_tc_rem.tc_rem60,
               tc_rem61 = g_tc_rem.tc_rem61,tc_rem62 = g_tc_rem.tc_rem62,tc_rem63 = g_tc_rem.tc_rem63,tc_rem64 = g_tc_rem.tc_rem64,tc_rem65 = g_tc_rem.tc_rem65,tc_rem66 = g_tc_rem.tc_rem66,tc_rem67 = g_tc_rem.tc_rem67,tc_rem68 = g_tc_rem.tc_rem68,tc_rem69 = g_tc_rem.tc_rem69,tc_rem70 = g_tc_rem.tc_rem70,
               tc_rem71 = g_tc_rem.tc_rem71,tc_rem72 = g_tc_rem.tc_rem72,tc_rem73 = g_tc_rem.tc_rem73,tc_rem74 = g_tc_rem.tc_rem74,tc_rem75 = g_tc_rem.tc_rem75,tc_rem76 = g_tc_rem.tc_rem76,tc_rem77 = g_tc_rem.tc_rem77,tc_rem78 = g_tc_rem.tc_rem78,tc_rem79 = g_tc_rem.tc_rem79,tc_rem80 = g_tc_rem.tc_rem80,
               tc_rem81 = g_tc_rem.tc_rem81,tc_rem82 = g_tc_rem.tc_rem82,tc_rem83 = g_tc_rem.tc_rem83,tc_rem84 = g_tc_rem.tc_rem84,tc_rem85 = g_tc_rem.tc_rem85,tc_rem86 = g_tc_rem.tc_rem86,tc_rem87 = g_tc_rem.tc_rem87,tc_rem88 = g_tc_rem.tc_rem88,tc_rem89 = g_tc_rem.tc_rem89,tc_rem90 = g_tc_rem.tc_rem90,
               tc_rem91 = g_tc_rem.tc_rem91,tc_rem92 = g_tc_rem.tc_rem92,tc_rem93 = g_tc_rem.tc_rem93,tc_rem94 = g_tc_rem.tc_rem94,tc_rem95 = g_tc_rem.tc_rem95,tc_rem96 = g_tc_rem.tc_rem96,tc_rem97 = g_tc_rem.tc_rem97,tc_rem98 = g_tc_rem.tc_rem98,tc_rem99 = g_tc_rem.tc_rem99,tc_rem100 = g_tc_rem.tc_rem100,
               tc_remdate = g_today
        where tc_remprog = g_tc_rem.tc_remprog
          and tc_remdocno = g_tc_rem.tc_remdocno
          and tc_remseq = g_tc_rem.tc_remseq
    else
        insert into tc_rem_file (
                tc_remprog,tc_remdocno,tc_remseq,
                tc_rem01,tc_rem02,tc_rem03,tc_rem04,tc_rem05,tc_rem06,tc_rem07,tc_rem08,tc_rem09,tc_rem10,
                tc_rem11,tc_rem12,tc_rem13,tc_rem14,tc_rem15,tc_rem16,tc_rem17,tc_rem18,tc_rem19,tc_rem20,
                tc_rem21,tc_rem22,tc_rem23,tc_rem24,tc_rem25,tc_rem26,tc_rem27,tc_rem28,tc_rem29,tc_rem30,
                tc_rem31,tc_rem32,tc_rem33,tc_rem34,tc_rem35,tc_rem36,tc_rem37,tc_rem38,tc_rem39,tc_rem40,
                tc_rem41,tc_rem42,tc_rem43,tc_rem44,tc_rem45,tc_rem46,tc_rem47,tc_rem48,tc_rem49,tc_rem50,
                tc_rem51,tc_rem52,tc_rem53,tc_rem54,tc_rem55,tc_rem56,tc_rem57,tc_rem58,tc_rem59,tc_rem60,
                tc_rem61,tc_rem62,tc_rem63,tc_rem64,tc_rem65,tc_rem66,tc_rem67,tc_rem68,tc_rem69,tc_rem70,
                tc_rem71,tc_rem72,tc_rem73,tc_rem74,tc_rem75,tc_rem76,tc_rem77,tc_rem78,tc_rem79,tc_rem80,
                tc_rem81,tc_rem82,tc_rem83,tc_rem84,tc_rem85,tc_rem86,tc_rem87,tc_rem88,tc_rem89,tc_rem90,
                tc_rem91,tc_rem92,tc_rem93,tc_rem94,tc_rem95,tc_rem96,tc_rem97,tc_rem98,tc_rem99,tc_rem100,
                tc_remdate
            )
            values (
                g_tc_rem.tc_remprog,g_tc_rem.tc_remdocno,g_tc_rem.tc_remseq,
                g_tc_rem.tc_rem01,g_tc_rem.tc_rem02,g_tc_rem.tc_rem03,g_tc_rem.tc_rem04,g_tc_rem.tc_rem05,g_tc_rem.tc_rem06,g_tc_rem.tc_rem07,g_tc_rem.tc_rem08,g_tc_rem.tc_rem09,g_tc_rem.tc_rem10,
                g_tc_rem.tc_rem11,g_tc_rem.tc_rem12,g_tc_rem.tc_rem13,g_tc_rem.tc_rem14,g_tc_rem.tc_rem15,g_tc_rem.tc_rem16,g_tc_rem.tc_rem17,g_tc_rem.tc_rem18,g_tc_rem.tc_rem19,g_tc_rem.tc_rem20,
                g_tc_rem.tc_rem21,g_tc_rem.tc_rem22,g_tc_rem.tc_rem23,g_tc_rem.tc_rem24,g_tc_rem.tc_rem25,g_tc_rem.tc_rem26,g_tc_rem.tc_rem27,g_tc_rem.tc_rem28,g_tc_rem.tc_rem29,g_tc_rem.tc_rem30,
                g_tc_rem.tc_rem31,g_tc_rem.tc_rem32,g_tc_rem.tc_rem33,g_tc_rem.tc_rem34,g_tc_rem.tc_rem35,g_tc_rem.tc_rem36,g_tc_rem.tc_rem37,g_tc_rem.tc_rem38,g_tc_rem.tc_rem39,g_tc_rem.tc_rem40,
                g_tc_rem.tc_rem41,g_tc_rem.tc_rem42,g_tc_rem.tc_rem43,g_tc_rem.tc_rem44,g_tc_rem.tc_rem45,g_tc_rem.tc_rem46,g_tc_rem.tc_rem47,g_tc_rem.tc_rem48,g_tc_rem.tc_rem49,g_tc_rem.tc_rem50,
                g_tc_rem.tc_rem51,g_tc_rem.tc_rem52,g_tc_rem.tc_rem53,g_tc_rem.tc_rem54,g_tc_rem.tc_rem55,g_tc_rem.tc_rem56,g_tc_rem.tc_rem57,g_tc_rem.tc_rem58,g_tc_rem.tc_rem59,g_tc_rem.tc_rem60,
                g_tc_rem.tc_rem61,g_tc_rem.tc_rem62,g_tc_rem.tc_rem63,g_tc_rem.tc_rem64,g_tc_rem.tc_rem65,g_tc_rem.tc_rem66,g_tc_rem.tc_rem67,g_tc_rem.tc_rem68,g_tc_rem.tc_rem69,g_tc_rem.tc_rem70,
                g_tc_rem.tc_rem71,g_tc_rem.tc_rem72,g_tc_rem.tc_rem73,g_tc_rem.tc_rem74,g_tc_rem.tc_rem75,g_tc_rem.tc_rem76,g_tc_rem.tc_rem77,g_tc_rem.tc_rem78,g_tc_rem.tc_rem79,g_tc_rem.tc_rem80,
                g_tc_rem.tc_rem81,g_tc_rem.tc_rem82,g_tc_rem.tc_rem83,g_tc_rem.tc_rem84,g_tc_rem.tc_rem85,g_tc_rem.tc_rem86,g_tc_rem.tc_rem87,g_tc_rem.tc_rem88,g_tc_rem.tc_rem89,g_tc_rem.tc_rem90,
                g_tc_rem.tc_rem91,g_tc_rem.tc_rem92,g_tc_rem.tc_rem93,g_tc_rem.tc_rem94,g_tc_rem.tc_rem95,g_tc_rem.tc_rem96,g_tc_rem.tc_rem97,g_tc_rem.tc_rem98,g_tc_rem.tc_rem99,g_tc_rem.tc_rem100,
                g_today
            )
    end if

    if sqlca.sqlcode then
        call cl_err('ins/upd tc_rem_file',sqlca.sqlcode,1)
    end if

    close WINDOW cl_remark_w1
end function

-- 检查必要栏位
function cl_remark_chk(p_prog,p_doc,p_seq)
    define  p_prog      varchar(100),
            p_doc       varchar(20),
            p_seq       integer
    define  l_require   boolean,
            l_name      varchar(20)
    define  l_str       string
    let g_success = 'Y'

    let l_str = ''
    call cl_remark_require('tc_rem01') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem01) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem02') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem02) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem03') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem03) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem04') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem04) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem05') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem05) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem06') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem06) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem07') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem07) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem08') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem08) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem09') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem09) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem10') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem10) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem11') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem11) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem12') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem12) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem13') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem13) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem14') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem14) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem15') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem15) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem16') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem16) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem17') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem17) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem18') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem18) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem19') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem19) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem20') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem20) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem21') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem21) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem22') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem22) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem23') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem23) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem24') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem24) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem25') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem25) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem26') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem26) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem27') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem27) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem28') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem28) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem29') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem29) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem30') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem30) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem31') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem31) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem32') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem32) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem33') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem33) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem34') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem34) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem35') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem35) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem36') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem36) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem37') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem37) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem38') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem38) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem39') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem39) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem40') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem40) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem41') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem41) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem42') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem42) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem43') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem43) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem44') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem44) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem45') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem45) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem46') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem46) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem47') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem47) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem48') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem48) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem49') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem49) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem50') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem50) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem51') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem51) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem52') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem52) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem53') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem53) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem54') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem54) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem55') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem55) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem56') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem56) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem57') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem57) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem58') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem58) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem59') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem59) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem60') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem60) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem61') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem61) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem62') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem62) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem63') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem63) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem64') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem64) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem65') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem65) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem66') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem66) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem67') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem67) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem68') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem68) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem69') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem69) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem70') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem70) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem71') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem71) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem72') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem72) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem73') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem73) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem74') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem74) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem75') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem75) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem76') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem76) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem77') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem77) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem78') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem78) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem79') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem79) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem80') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem80) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem81') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem81) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem82') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem82) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem83') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem83) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem84') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem84) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem85') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem85) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem86') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem86) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem87') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem87) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem88') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem88) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem89') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem89) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem90') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem90) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem91') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem91) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem92') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem92) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem93') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem93) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem94') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem94) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem95') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem95) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem96') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem96) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem97') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem97) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem98') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem98) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem99') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem99) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if
    call cl_remark_require('tc_rem100') returning l_require,l_name
    if l_require and cl_null(g_tc_rem.tc_rem100) then
        let g_success ='N' let l_str = l_str , ',' ,l_name
    end if

    if g_success = 'N' then
        call cl_err(l_str,'clib-06',1)
    end if

end function

-- UI初始化
function cl_remark_ui_init(p_prog)
    define p_prog   varchar(100)
    define l_cnt,i    integer

    declare cl_remark_ui_init1 cursor for
    select tc_sma04, tc_sma06, tc_ren03,tc_sma07,tc_sma18,tc_sma19,tc_sma09,tc_sma05
      from tc_sma_file, tc_ren_file
     where tc_sma04 = tc_ren01
       and tc_sma01 = 'csmi136'
       and tc_sma02 = p_prog
       and tc_sma20 = 'Y'

    let i = 1
    call g_cols.clear()
    foreach cl_remark_ui_init1 into g_cols[i].*
        if sqlca.sqlcode then
            call cl_err('cl_remark_ui_init1',sqlca.sqlcode,1)
            exit foreach
        end if
        -- 说明栏位
        call cl_set_comp_att_text(g_cols[i].col,g_cols[i].name)
        -- 显示
        call cl_set_comp_visible(g_cols[i].col,true)
        -- 必要性
        call cl_set_comp_required(g_cols[i].col,g_cols[i].require =='Y')
        -- 下拉框设定
        if g_cols[i].type == '下拉框' then
            call cl_set_combo_items(g_cols[i].col,g_cols[i].value,g_cols[i].desc)
        end if
        let i = i + 1
    end foreach
    call g_cols.deleteElement(i)

end function

-- 默认值
function cl_remark_default(p_col)
    define p_col    varchar(100)
    define i            integer
    for i = 1 to g_cols.getLength()
        if g_cols[i].col == p_col then
            return g_cols[i].default
        end if
    end for
    return ''
end function

-- 必须录入
function cl_remark_require(p_col)
    define p_col    varchar(100)
    define i            integer
    for i = 1 to g_cols.getLength()
        if g_cols[i].col == p_col then
            return g_cols[i].require=='Y',g_cols[i].name
        end if
    end for
    return false,''
end function

-- 开窗
function cl_remark_ctrlp(p_col)
    define p_col    varchar(100)
    define i            integer
    for i = 1 to g_cols.getLength()
        if g_cols[i].col == p_col then
            return g_cols[i].ctrlp
        end if
    end for
    return ''
end function

function cl_remark_get(p_prog,p_doc,p_seq)
    define p_prog   varchar(100),
           p_doc    varchar(20),
           p_seq    integer

    if cl_null(p_seq) then
        let p_seq = 0
    end if

    select  tc_remprog,tc_remdocno,tc_remseq,tc_remdate,
            tc_rem01,tc_rem02,tc_rem03,tc_rem04,tc_rem05,tc_rem06,tc_rem07,tc_rem08,tc_rem09,tc_rem10,
            tc_rem11,tc_rem12,tc_rem13,tc_rem14,tc_rem15,tc_rem16,tc_rem17,tc_rem18,tc_rem19,tc_rem20,
            tc_rem21,tc_rem22,tc_rem23,tc_rem24,tc_rem25,tc_rem26,tc_rem27,tc_rem28,tc_rem29,tc_rem30,
            tc_rem31,tc_rem32,tc_rem33,tc_rem34,tc_rem35,tc_rem36,tc_rem37,tc_rem38,tc_rem39,tc_rem40,
            tc_rem41,tc_rem42,tc_rem43,tc_rem44,tc_rem45,tc_rem46,tc_rem47,tc_rem48,tc_rem49,tc_rem50,
            tc_rem51,tc_rem52,tc_rem53,tc_rem54,tc_rem55,tc_rem56,tc_rem57,tc_rem58,tc_rem59,tc_rem60,
            tc_rem61,tc_rem62,tc_rem63,tc_rem64,tc_rem65,tc_rem66,tc_rem67,tc_rem68,tc_rem69,tc_rem70,
            tc_rem71,tc_rem72,tc_rem73,tc_rem74,tc_rem75,tc_rem76,tc_rem77,tc_rem78,tc_rem79,tc_rem80,
            tc_rem81,tc_rem82,tc_rem83,tc_rem84,tc_rem85,tc_rem86,tc_rem87,tc_rem88,tc_rem89,tc_rem90,
            tc_rem91,tc_rem92,tc_rem93,tc_rem94,tc_rem95,tc_rem96,tc_rem97,tc_rem98,tc_rem99,tc_rem100
     into g_tc_rem.*
     from tc_rem_file where tc_remprog = p_prog and tc_remdocno = p_doc and tc_remseq = p_seq
    if sqlca.sqlcode then
        call cl_err("",sqlca.sqlcode,0)
        let g_tc_rem.tc_remprog = p_prog
        let g_tc_rem.tc_remdocno = p_doc
        let g_tc_rem.tc_remseq = p_seq
    end if
end function


-- 输入
function cl_remark_i()
    display by name g_tc_rem.tc_remprog,g_tc_rem.tc_remdocno,g_tc_rem.tc_remseq,
                    g_tc_rem.tc_rem01,g_tc_rem.tc_rem02,g_tc_rem.tc_rem03,g_tc_rem.tc_rem04,g_tc_rem.tc_rem05,g_tc_rem.tc_rem06,g_tc_rem.tc_rem07,g_tc_rem.tc_rem08,g_tc_rem.tc_rem09,g_tc_rem.tc_rem10,
                    g_tc_rem.tc_rem11,g_tc_rem.tc_rem12,g_tc_rem.tc_rem13,g_tc_rem.tc_rem14,g_tc_rem.tc_rem15,g_tc_rem.tc_rem16,g_tc_rem.tc_rem17,g_tc_rem.tc_rem18,g_tc_rem.tc_rem19,g_tc_rem.tc_rem20,
                    g_tc_rem.tc_rem21,g_tc_rem.tc_rem22,g_tc_rem.tc_rem23,g_tc_rem.tc_rem24,g_tc_rem.tc_rem25,g_tc_rem.tc_rem26,g_tc_rem.tc_rem27,g_tc_rem.tc_rem28,g_tc_rem.tc_rem29,g_tc_rem.tc_rem30,
                    g_tc_rem.tc_rem31,g_tc_rem.tc_rem32,g_tc_rem.tc_rem33,g_tc_rem.tc_rem34,g_tc_rem.tc_rem35,g_tc_rem.tc_rem36,g_tc_rem.tc_rem37,g_tc_rem.tc_rem38,g_tc_rem.tc_rem39,g_tc_rem.tc_rem40,
                    g_tc_rem.tc_rem41,g_tc_rem.tc_rem42,g_tc_rem.tc_rem43,g_tc_rem.tc_rem44,g_tc_rem.tc_rem45,g_tc_rem.tc_rem46,g_tc_rem.tc_rem47,g_tc_rem.tc_rem48,g_tc_rem.tc_rem49,g_tc_rem.tc_rem50,
                    g_tc_rem.tc_rem51,g_tc_rem.tc_rem52,g_tc_rem.tc_rem53,g_tc_rem.tc_rem54,g_tc_rem.tc_rem55,g_tc_rem.tc_rem56,g_tc_rem.tc_rem57,g_tc_rem.tc_rem58,g_tc_rem.tc_rem59,g_tc_rem.tc_rem60,
                    g_tc_rem.tc_rem61,g_tc_rem.tc_rem62,g_tc_rem.tc_rem63,g_tc_rem.tc_rem64,g_tc_rem.tc_rem65,g_tc_rem.tc_rem66,g_tc_rem.tc_rem67,g_tc_rem.tc_rem68,g_tc_rem.tc_rem69,g_tc_rem.tc_rem70,
                    g_tc_rem.tc_rem71,g_tc_rem.tc_rem72,g_tc_rem.tc_rem73,g_tc_rem.tc_rem74,g_tc_rem.tc_rem75,g_tc_rem.tc_rem76,g_tc_rem.tc_rem77,g_tc_rem.tc_rem78,g_tc_rem.tc_rem79,g_tc_rem.tc_rem80,
                    g_tc_rem.tc_rem81,g_tc_rem.tc_rem82,g_tc_rem.tc_rem83,g_tc_rem.tc_rem84,g_tc_rem.tc_rem85,g_tc_rem.tc_rem86,g_tc_rem.tc_rem87,g_tc_rem.tc_rem88,g_tc_rem.tc_rem89,g_tc_rem.tc_rem90,
                    g_tc_rem.tc_rem91,g_tc_rem.tc_rem92,g_tc_rem.tc_rem93,g_tc_rem.tc_rem94,g_tc_rem.tc_rem95,g_tc_rem.tc_rem96,g_tc_rem.tc_rem97,g_tc_rem.tc_rem98,g_tc_rem.tc_rem99,g_tc_rem.tc_rem100

    input by name
            g_tc_rem.tc_rem01,g_tc_rem.tc_rem02,g_tc_rem.tc_rem03,g_tc_rem.tc_rem04,g_tc_rem.tc_rem05,g_tc_rem.tc_rem06,g_tc_rem.tc_rem07,g_tc_rem.tc_rem08,g_tc_rem.tc_rem09,g_tc_rem.tc_rem10,
            g_tc_rem.tc_rem11,g_tc_rem.tc_rem12,g_tc_rem.tc_rem13,g_tc_rem.tc_rem14,g_tc_rem.tc_rem15,g_tc_rem.tc_rem16,g_tc_rem.tc_rem17,g_tc_rem.tc_rem18,g_tc_rem.tc_rem19,g_tc_rem.tc_rem20,
            g_tc_rem.tc_rem21,g_tc_rem.tc_rem22,g_tc_rem.tc_rem23,g_tc_rem.tc_rem24,g_tc_rem.tc_rem25,g_tc_rem.tc_rem26,g_tc_rem.tc_rem27,g_tc_rem.tc_rem28,g_tc_rem.tc_rem29,g_tc_rem.tc_rem30,
            g_tc_rem.tc_rem31,g_tc_rem.tc_rem32,g_tc_rem.tc_rem33,g_tc_rem.tc_rem34,g_tc_rem.tc_rem35,g_tc_rem.tc_rem36,g_tc_rem.tc_rem37,g_tc_rem.tc_rem38,g_tc_rem.tc_rem39,g_tc_rem.tc_rem40,
            g_tc_rem.tc_rem41,g_tc_rem.tc_rem42,g_tc_rem.tc_rem43,g_tc_rem.tc_rem44,g_tc_rem.tc_rem45,g_tc_rem.tc_rem46,g_tc_rem.tc_rem47,g_tc_rem.tc_rem48,g_tc_rem.tc_rem49,g_tc_rem.tc_rem50,
            g_tc_rem.tc_rem51,g_tc_rem.tc_rem52,g_tc_rem.tc_rem53,g_tc_rem.tc_rem54,g_tc_rem.tc_rem55,g_tc_rem.tc_rem56,g_tc_rem.tc_rem57,g_tc_rem.tc_rem58,g_tc_rem.tc_rem59,g_tc_rem.tc_rem60,
            g_tc_rem.tc_rem61,g_tc_rem.tc_rem62,g_tc_rem.tc_rem63,g_tc_rem.tc_rem64,g_tc_rem.tc_rem65,g_tc_rem.tc_rem66,g_tc_rem.tc_rem67,g_tc_rem.tc_rem68,g_tc_rem.tc_rem69,g_tc_rem.tc_rem70,
            g_tc_rem.tc_rem71,g_tc_rem.tc_rem72,g_tc_rem.tc_rem73,g_tc_rem.tc_rem74,g_tc_rem.tc_rem75,g_tc_rem.tc_rem76,g_tc_rem.tc_rem77,g_tc_rem.tc_rem78,g_tc_rem.tc_rem79,g_tc_rem.tc_rem80,
            g_tc_rem.tc_rem81,g_tc_rem.tc_rem82,g_tc_rem.tc_rem83,g_tc_rem.tc_rem84,g_tc_rem.tc_rem85,g_tc_rem.tc_rem86,g_tc_rem.tc_rem87,g_tc_rem.tc_rem88,g_tc_rem.tc_rem89,g_tc_rem.tc_rem90,
            g_tc_rem.tc_rem91,g_tc_rem.tc_rem92,g_tc_rem.tc_rem93,g_tc_rem.tc_rem94,g_tc_rem.tc_rem95,g_tc_rem.tc_rem96,g_tc_rem.tc_rem97,g_tc_rem.tc_rem98,g_tc_rem.tc_rem99,g_tc_rem.tc_rem100
    without defaults

        before input

        on action controlp
            -- 开窗
            case
                when infield(tc_rem01)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem01') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem01
                    end if
                    display by name g_tc_rem.tc_rem01
                when infield(tc_rem02)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem02') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem02
                    end if
                    display by name g_tc_rem.tc_rem02
                when infield(tc_rem03)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem03') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem03
                    end if
                    display by name g_tc_rem.tc_rem03
                when infield(tc_rem04)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem04') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem04
                    end if
                    display by name g_tc_rem.tc_rem04
                when infield(tc_rem05)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem05') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem05
                    end if
                    display by name g_tc_rem.tc_rem05
                when infield(tc_rem06)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem06') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem06
                    end if
                    display by name g_tc_rem.tc_rem06
                when infield(tc_rem07)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem07') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem07
                    end if
                    display by name g_tc_rem.tc_rem07
                when infield(tc_rem08)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem08') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem08
                    end if
                    display by name g_tc_rem.tc_rem08
                when infield(tc_rem09)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem09') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem09
                    end if
                    display by name g_tc_rem.tc_rem09
                when infield(tc_rem10)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem10') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem10
                    end if
                    display by name g_tc_rem.tc_rem10
                when infield(tc_rem11)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem11') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem11
                    end if
                    display by name g_tc_rem.tc_rem11
                when infield(tc_rem12)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem12') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem12
                    end if
                    display by name g_tc_rem.tc_rem12
                when infield(tc_rem13)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem13') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem13
                    end if
                    display by name g_tc_rem.tc_rem13
                when infield(tc_rem14)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem14') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem14
                    end if
                    display by name g_tc_rem.tc_rem14
                when infield(tc_rem15)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem15') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem15
                    end if
                    display by name g_tc_rem.tc_rem15
                when infield(tc_rem16)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem16') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem16
                    end if
                    display by name g_tc_rem.tc_rem16
                when infield(tc_rem17)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem17') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem17
                    end if
                    display by name g_tc_rem.tc_rem17
                when infield(tc_rem18)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem18') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem18
                    end if
                    display by name g_tc_rem.tc_rem18
                when infield(tc_rem19)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem19') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem19
                    end if
                    display by name g_tc_rem.tc_rem19
                when infield(tc_rem20)
                    call cl_init_qry_var()
                    call cl_remark_ctrlp('tc_rem20') returning g_qryparam.form
                    if not cl_null(g_qryparam.form) then
                        call cl_create_qry() returning g_tc_rem.tc_rem20
                    end if
                    display by name g_tc_rem.tc_rem20

                otherwise
            end case

        on action controlr
            call cl_show_req_fields()

        on action controlf
            -- 切换语言
            call cl_set_focus_form(ui.Interface.getRootNode()) returning g_fld_name,g_frm_name
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        on action controlg
            call cl_cmdask()

        on idle g_idle_seconds
            -- 超时退出
            call cl_on_idle()
            continue input

        on action about
            call cl_about()

        on action help
            call cl_show_help()

    end input
end function

-- 仅显示
function cl_remark_show(p_prog,p_doc,p_seq)
    define p_prog   varchar(100),
        p_doc    varchar(20),
        p_seq    integer

    OPEN WINDOW cl_remark_w1 AT 2,2 WITH FORM "clib/42f/cl_remark"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

    call cl_remark_get(p_prog,p_doc,p_seq)
    call cl_remark_ui_init(p_prog)

    display by name g_tc_rem.tc_remprog,g_tc_rem.tc_remdocno,g_tc_rem.tc_remseq,
                    g_tc_rem.tc_rem01,g_tc_rem.tc_rem02,g_tc_rem.tc_rem03,g_tc_rem.tc_rem04,g_tc_rem.tc_rem05,g_tc_rem.tc_rem06,g_tc_rem.tc_rem07,g_tc_rem.tc_rem08,g_tc_rem.tc_rem09,g_tc_rem.tc_rem10,
                    g_tc_rem.tc_rem11,g_tc_rem.tc_rem12,g_tc_rem.tc_rem13,g_tc_rem.tc_rem14,g_tc_rem.tc_rem15,g_tc_rem.tc_rem16,g_tc_rem.tc_rem17,g_tc_rem.tc_rem18,g_tc_rem.tc_rem19,g_tc_rem.tc_rem20,
                    g_tc_rem.tc_rem21,g_tc_rem.tc_rem22,g_tc_rem.tc_rem23,g_tc_rem.tc_rem24,g_tc_rem.tc_rem25,g_tc_rem.tc_rem26,g_tc_rem.tc_rem27,g_tc_rem.tc_rem28,g_tc_rem.tc_rem29,g_tc_rem.tc_rem30,
                    g_tc_rem.tc_rem31,g_tc_rem.tc_rem32,g_tc_rem.tc_rem33,g_tc_rem.tc_rem34,g_tc_rem.tc_rem35,g_tc_rem.tc_rem36,g_tc_rem.tc_rem37,g_tc_rem.tc_rem38,g_tc_rem.tc_rem39,g_tc_rem.tc_rem40,
                    g_tc_rem.tc_rem41,g_tc_rem.tc_rem42,g_tc_rem.tc_rem43,g_tc_rem.tc_rem44,g_tc_rem.tc_rem45,g_tc_rem.tc_rem46,g_tc_rem.tc_rem47,g_tc_rem.tc_rem48,g_tc_rem.tc_rem49,g_tc_rem.tc_rem50,
                    g_tc_rem.tc_rem51,g_tc_rem.tc_rem52,g_tc_rem.tc_rem53,g_tc_rem.tc_rem54,g_tc_rem.tc_rem55,g_tc_rem.tc_rem56,g_tc_rem.tc_rem57,g_tc_rem.tc_rem58,g_tc_rem.tc_rem59,g_tc_rem.tc_rem60,
                    g_tc_rem.tc_rem61,g_tc_rem.tc_rem62,g_tc_rem.tc_rem63,g_tc_rem.tc_rem64,g_tc_rem.tc_rem65,g_tc_rem.tc_rem66,g_tc_rem.tc_rem67,g_tc_rem.tc_rem68,g_tc_rem.tc_rem69,g_tc_rem.tc_rem70,
                    g_tc_rem.tc_rem71,g_tc_rem.tc_rem72,g_tc_rem.tc_rem73,g_tc_rem.tc_rem74,g_tc_rem.tc_rem75,g_tc_rem.tc_rem76,g_tc_rem.tc_rem77,g_tc_rem.tc_rem78,g_tc_rem.tc_rem79,g_tc_rem.tc_rem80,
                    g_tc_rem.tc_rem81,g_tc_rem.tc_rem82,g_tc_rem.tc_rem83,g_tc_rem.tc_rem84,g_tc_rem.tc_rem85,g_tc_rem.tc_rem86,g_tc_rem.tc_rem87,g_tc_rem.tc_rem88,g_tc_rem.tc_rem89,g_tc_rem.tc_rem90,
                    g_tc_rem.tc_rem91,g_tc_rem.tc_rem92,g_tc_rem.tc_rem93,g_tc_rem.tc_rem94,g_tc_rem.tc_rem95,g_tc_rem.tc_rem96,g_tc_rem.tc_rem97,g_tc_rem.tc_rem98,g_tc_rem.tc_rem99,g_tc_rem.tc_rem100

    menu 'show'
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
        ON ACTION about
            CALL cl_about()
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION close
            LET INT_FLAG=FALSE
            LET g_action_choice = "exit"
            EXIT MENU
    end menu

    close WINDOW cl_remark_w1
end function
