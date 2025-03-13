# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Program name...: scxmt520_sub.4gl
# Description....: 提供cxmt520.4gl使用的sub routine
# Date & Author..:darcy:2023/04/04

database ds
 
globals "../../../tiptop/config/top.global"

function t520sub_lock_cl()
    define l_forupd_sql string
 
    let l_forupd_sql = "select * from tc_xme_file where tc_xme00 = ? for update"
    let l_forupd_sql = cl_forupd_sql(l_forupd_sql)

    declare t520sub_cl cursor from l_forupd_sql
    # let l_forupd_sql = "select * from occ_file where occ01 = ? for update"
    # let l_forupd_sql = cl_forupd_sql(l_forupd_sql)

    # declare t400sub_cl2 cursor from l_forupd_sql
end function

function t520sub_y_chk(p_tc_xme00)
    define p_tc_xme00   like tc_xme_file.tc_xme00
    define l_tc_xme     record like tc_xme_file.*

    whenever error continue

    let g_success = 'Y'
    
    if cl_null(p_tc_xme00) then
        call cl_err('',-400,0)
        # run "echo '"||p_tc_xme00||" -400 \n"||"' >> /u1/out/darcy.txt"
        let g_success ='N'
        return
    end if

    select * into l_tc_xme.* from tc_xme_file where tc_xme00 = p_tc_xme00
    if l_tc_xme.tc_xmeconf = 'Y' then
        call cl_err('',9023,0)
        # run "echo '"||p_tc_xme00||" 9023 \n"||"' >> /u1/out/darcy.txt"
        let g_success = 'N'
        return
    end if

    if l_tc_xme.tc_xmeconf = 'X' then
        call cl_err('',9024,0)
        # run "echo '"||p_tc_xme00||" 9024 \n"||"' >> /u1/out/darcy.txt"
        let g_success = 'N'   #fun-580155
        return
    end if

    if g_action_choice clipped = "confirm" or
        g_action_choice clipped = "insert" then
        # run "echo '"||p_tc_xme00||" confirm \n"||"' >> /u1/out/darcy.txt"
        if not cl_confirm("axm-108") then
            let g_success = 'N'
            return
        end if
    end if
end function

function t520sub_y_upd(p_tc_xme00,p_inTransaction)
    define p_tc_xme00   like tc_xme_file.tc_xme00
    define l_tc_xme     record like tc_xme_file.*
    define p_inTransaction like type_file.num5 
    if not p_inTransaction then
        begin work
    end if
    
    call t520sub_lock_cl()
    open t520sub_cl using p_tc_xme00
    if status then
        call cl_err("open t520sub_cl:", status, 1)
        # run "echo '"||p_tc_xme00||" open t520sub_cl \n"||"' >> /u1/out/darcy.txt"
        close t520sub_cl
        rollback work
        let g_success = 'N'                                #chi-b80050
        return
    end if

    fetch t520sub_cl into l_tc_xme.*
    if sqlca.sqlcode then
        call cl_err(l_tc_xme.tc_xme00,sqlca.sqlcode,0)     # 資料被他人lock
        rollback work
        # run "echo '"||p_tc_xme00||sqlca.sqlcode||" \n"||"' >> /u1/out/darcy.txt"
        let g_success = 'N'
        return
    end if

    let g_success = 'Y'

    if g_action_choice clipped = "confirm" or
        g_action_choice clipped = "insert" then
        if l_tc_xme.tc_xme07 = 'Y' then
            if l_tc_xme.tc_xmeacti !='1' then
                call cl_err('','aws-078',1)
                # run "echo '"||p_tc_xme00||" aws-078 \n"||"' >> /u1/out/darcy.txt"
                let g_success = 'N'
                rollback work
                return
            end if
        end if
    end if

    if g_success ='Y' then
        call t520sub_ins(p_tc_xme00)
    end if

    call t520sub_ins_ims(p_tc_xme00)

    update tc_xme_file 
       set tc_xmeconf = 'Y',
           tc_xmemodu = g_user,
           tc_xmedate=g_today 
     where tc_xme00 = l_tc_xme.tc_xme00
    if sqlca.sqlcode or sqlca.sqlerrd[3] = 0 then 
        # CALL cl_err3("upd","tc_xme_file",g_tc_xme.tc_xme00,"",SQLCA.sqlcode,"","",0)
        call cl_err('upd tc_xme_file',sqlca.sqlcode,1)
        # run "echo '"||p_tc_xme00||" upd tc_xme_file \n"||"' >> /u1/out/darcy.txt"
        let g_success = 'N'
        return
    end if 

    if g_success ='Y' then
        if not p_inTransaction then
            commit work
        end if
    else
        rollback work
    end if
end function

# 方便调用,和t520_ins()逻辑一样
FUNCTION t520sub_ins(p_tc_xme00)
    define p_tc_xme00   like tc_xme_file.tc_xme00
    define l_xme        record like xme_file.*
    define l_tc_xme     record like tc_xme_file.*
    define l_x,l_i      like type_file.num5
    define l_sql        string 
    define l_tc_xmf     record like tc_xmf_file.*
    define l_xmf        record like xmf_file.*


    select * into l_tc_xme.* from tc_xme_file where tc_xme00 = p_tc_xme00

     SELECT COUNT(*) INTO l_x FROM xme_file WHERE xme01 = l_tc_xme.tc_xme01 AND xme02 = l_tc_xme.tc_xme02 AND xme00='1'  AND ta_xme01 = l_tc_xme.tc_xme06
     IF l_x >0 THEN 
        LET l_sql = "SELECT * FROM tc_xmf_file WHERE tc_xmf00 = '",l_tc_xme.tc_xme00,"'"
        PREPARE t520_tc_xmf_prepare1 FROM l_sql
        IF STATUS THEN
           CALL cl_err('pre',STATUS,1)
        #    run "echo '"||p_tc_xme00||" pre \n"||"' >> /u1/out/darcy.txt"
           LET g_success = 'N'
           RETURN
        END IF
        DECLARE t520_tc_xmf_cs1 CURSOR FOR t520_tc_xmf_prepare1 
        LET l_i = 1
        INITIALIZE l_tc_xmf.* TO NULL
        INITIALIZE l_xmf.* TO NULL
        FOREACH t520_tc_xmf_cs1 INTO l_tc_xmf.*
           SELECT COUNT(*) INTO l_i FROM xmf_file 
            WHERE xmf01 = l_tc_xme.tc_xme01 
              AND xmf02 = l_tc_xme.tc_xme02 
              AND xmf03 = l_tc_xmf.tc_xmf03
              AND xmf04 = l_tc_xmf.tc_xmf04
              AND xmf05 = g_today
              AND ta_xmf02 = l_tc_xme.tc_xme06   #add by guanyao160711
           IF l_i > 0 THEN 
              UPDATE xmf_file SET xmf07 = l_tc_xmf.tc_xmf05
                                  ,ta_xmf03 = l_tc_xmf.tc_xmf06  #darcy:2023/04/04 add 应该是更新，而不是作为条件查询。
                               WHERE xmf01 = l_tc_xme.tc_xme01 
                                 AND xmf02 = l_tc_xme.tc_xme02 
                                 AND xmf03 = l_tc_xmf.tc_xmf03
                                 AND xmf04 = l_tc_xmf.tc_xmf04
                                 AND xmf05 = g_today
                                 AND ta_xmf02 = l_tc_xme.tc_xme06   #add by guanyao160711
                                #  AND ta_xmf03 = l_tc_xmf.tc_xmf06   #add by guanyao160715 #darcy:2023/04/04 mark
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
                 CALL cl_err3("upd","xmf_file",l_tc_xme.tc_xme01,l_tc_xme.tc_xme02,SQLCA.sqlcode,"","",0)
                #  run "echo '"||p_tc_xme00||" upd xmf_file \n"||"' >> /u1/out/darcy.txt"
                 LET g_success = 'N'
                 EXIT FOREACH 
              END IF
           ELSE 
              LET l_xmf.xmf01 = l_tc_xme.tc_xme01
              LET l_xmf.xmf02 = l_tc_xme.tc_xme02
              LET l_xmf.xmf03 = l_tc_xmf.tc_xmf03
              LET l_xmf.xmf04 = l_tc_xmf.tc_xmf04
              LET l_xmf.xmf05 = g_today
              LET l_xmf.xmf07 = l_tc_xmf.tc_xmf05
              LET l_xmf.xmf08 = 100
              LET l_xmf.ta_xmf01 = l_tc_xme.tc_xme03    #str—add by huanglf 160707
              LET l_xmf.ta_xmf02 = l_tc_xme.tc_xme06   #add by guanyao160711
              LET l_xmf.ta_xmf03 = l_tc_xmf.tc_xmf06   #add by guanyao160715
              LET l_xmf.ta_xmf04 = l_tc_xmf.tc_xmf07   #add by huanglf170317  
              LET l_xmf.ta_xmf05 = l_tc_xmf.tc_xmf08   #add by huanglf170317
              INSERT INTO xmf_file VALUES l_xmf.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","xmf_file",l_xmf.xmf01,l_xmf.xmf02,SQLCA.sqlcode,"","",1) 
                #  run "echo '"||p_tc_xme00||" ins xmf_file \n"||"' >> /u1/out/darcy.txt"
                 LET g_success = 'N'
                 EXIT FOREACH 
              END IF
           END IF  
        END FOREACH 
     ELSE 
        INITIALIZE l_xme.* TO NULL
        LET l_xme.xme00 = '1'
        LET l_xme.xme01 = l_tc_xme.tc_xme01
        LET l_xme.xme02 = l_tc_xme.tc_xme02
        LET l_xme.xmeuser=g_user
        LET l_xme.xmeoriu = g_user #FUN-980030
        LET l_xme.xmeorig = g_grup #FUN-980030
        LET l_xme.xmegrup=g_grup
        LET l_xme.xmedate=g_today  
        LET l_xme.ta_xme01 = l_tc_xme.tc_xme06  #add by guanyao161711
        LET l_xmf.ta_xmf03 = l_tc_xmf.tc_xmf06   #add by guanyao160715
        INSERT INTO xme_file VALUES (l_xme.*)
        IF SQLCA.sqlcode THEN                         
           CALL cl_err3("ins","xme_file",l_tc_xme.tc_xme01,l_tc_xme.tc_xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
           LET g_success = 'N'
        #    run "echo '"||p_tc_xme00||" ins xme_file \n"||"' >> /u1/out/darcy.txt"
           RETURN 
        END IF
        LET l_sql = "SELECT * FROM tc_xmf_file WHERE tc_xmf00 = '",l_tc_xme.tc_xme00,"'"
        PREPARE t520_tc_xmf_prepare FROM l_sql
        IF STATUS THEN
           CALL cl_err('pre',STATUS,1)
        #    run "echo '"||p_tc_xme00||" pre 231 \n"||"' >> /u1/out/darcy.txt"
           LET g_success = 'N'
           RETURN
        END IF
        DECLARE t520_tc_xmf_cs CURSOR FOR t520_tc_xmf_prepare 
        LET l_i = 1
        INITIALIZE l_tc_xmf.* TO NULL
        INITIALIZE l_xmf.* TO NULL
        FOREACH t520_tc_xmf_cs INTO l_tc_xmf.*
           LET l_xmf.xmf01 = l_tc_xme.tc_xme01
           LET l_xmf.xmf02 = l_tc_xme.tc_xme02
           LET l_xmf.xmf03 = l_tc_xmf.tc_xmf03
           LET l_xmf.xmf04 = l_tc_xmf.tc_xmf04
           LET l_xmf.xmf05 = g_today
           LET l_xmf.xmf07 = l_tc_xmf.tc_xmf05
           LET l_xmf.xmf08 = 100
           LET l_xmf.ta_xmf01 = l_tc_xme.tc_xme03    #str—add by huanglf 160707
           LET l_xmf.ta_xmf02 = l_tc_xme.tc_xme06   #add by guanyao160711
           LET l_xmf.ta_xmf03 = l_tc_xmf.tc_xmf06   #add by guanyao160715
           INSERT INTO xmf_file VALUES l_xmf.*
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","xmf_file",l_xmf.xmf01,l_xmf.xmf02,SQLCA.sqlcode,"","",1) 
            #   run "echo '"||p_tc_xme00||" 253 ins xmf_file \n"||"' >> /u1/out/darcy.txt"
              LET g_success = 'N'
              EXIT FOREACH 
           END IF 
        END FOREACH 
     END IF 
END FUNCTION 

function t520sub_ins_ims(p_tc_xme00)
    define p_tc_xme00  like tc_xme_file.tc_xme00
    define l_sql    string
    define l_ac,l_num         like type_file.num5
    define l_tc_xmf  dynamic array of record like tc_xmf_file.*

    let l_sql = " SELECT * FROM tc_xmf_file ",
              " WHERE tc_xmf00 = '",p_tc_xme00,"'" 
    prepare t520sub_pb1 from l_sql
    declare t520sub_bcs1 cursor with hold for t520sub_pb1
    let l_ac = 1
    foreach t520sub_bcs1 into l_tc_xmf[l_ac].* 

        if cl_null(l_tc_xmf[l_ac].tc_xmf09) then
                continue foreach 
        end if 
        select count(*) into l_num from tc_ims_file where tc_ims01 = l_tc_xmf[l_ac].tc_xmf03
            if l_num >0 then 
                update tc_ims_file set tc_ims02 = l_tc_xmf[l_ac].tc_xmf09 
                where tc_ims01 = l_tc_xmf[l_ac].tc_xmf03 
            else 
                insert into tc_ims_file (tc_ims01,tc_ims02) 
                values (l_tc_xmf[l_ac].tc_xmf03,l_tc_xmf[l_ac].tc_xmf09)
            end if
        let l_ac = l_ac + 1
    end foreach 
end function
