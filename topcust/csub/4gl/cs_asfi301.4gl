# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cs_asfi301_confirm.4gl
# Descriptions...: 
# Date & Author..:darcy:2023/05/15 add


function cs_asfi301_confirm(p_prog,p_docno,p_transaction)
    define p_prog like type_file.chr20
    define p_docno like sfb_file.sfb01
    define p_transaction like type_file.num5

    define l_sfb   record like sfb_file.*
    define l_cnt,l_i  integer
    define l_sfb01      like sfb_file.sfb01

    select * into l_sfb.* from sfb_file  where sfb01 = p_docno

    IF l_sfb.sfb01[1,3] ='MSY' THEN
        update sfb_file
        set sfbud08 = (
                select oeb12
                    from oeb_file
                    where oeb01 = l_sfb.sfb22
                        and oeb03 = l_sfb.sfb221
                )
        where sfb01 = l_sfb.sfb01

        update sfb_file
        set sfbud09 = (
        select oeb12 / sfb08 * 100
                from sfb_file,
        (
                        select oeb01,
                            oeb03,
                            oeb04,
                            oeb12
                        from oeb_file
                        where oeb01 = l_sfb.sfb22
                            and oeb03 = l_sfb.sfb221
                    )
                where sfb22 = oeb01
                    and sfb221 = oeb03
                    and sfb05 = oeb04
                    and sfb01 = l_sfb.sfb01
            )
        where sfb01 = l_sfb.sfb01
    end if
    
    let l_cnt=0
    select count(*) into l_cnt
    from sfd_file
    where sfd01 = l_sfb.sfb85
        and sfd03 = l_sfb.sfb01
        and (
            sfd07 is not null
            and sfd07 <> ' '
        )
    if not p_transaction then
        begin work
    end if

    if not cl_null(l_sfb.sfb85) and l_cnt > 0 then
        let g_success='Y'
        call i301sub_sfb85(l_sfb.sfb85)
        if l_sfb.sfbud06='Y' then
            #block
            let g_success='Y'
        end if
        
        IF g_success='Y' THEN
            CALL i301sub_selsfd(l_sfb.sfb85)
        END IF
        IF g_success='Y' THEN
            DECLARE firm_cs CURSOR FOR
            SELECT DISTINCT sfd03 FROM sfd_file WHERE sfd01=l_sfb.sfb85 AND sfdconf='N'
            LET g_b_confirm='Y'
            FOREACH firm_cs INTO l_sfb01
                CALL i301sub_firm1_chk(l_sfb01,TRUE)
                IF g_success='N' THEN EXIT FOREACH END IF  #FUN-A80060
                IF g_success='Y' THEN
                    CALL i301sub_firm1_upd(l_sfb01,"confirm",TRUE)
                    IF g_success='N' THEN EXIT FOREACH END IF  #FUN-A80060
                END IF
            END FOREACH
            LET g_b_confirm='N'
        END IF
    else
        CALL i301sub_firm1_chk(l_sfb.sfb01,TRUE)   #FUN-C30274
        IF g_success='Y' THEN
            CALL i301sub_firm1_upd(l_sfb.sfb01,"confirm",FALSE)  #CALL原確認的update段 #FUN-8C0081 add #FUN-940008 add false                      
            #COMMIT WORK     #FUN-C30274   #TQC-C60025 mark
            #str TQC-C60025 mod
            if not p_transaction then
                IF g_success='Y' THEN
                    COMMIT WORK
                ELSE
                    ROLLBACK WORK         
                END IF
            end if
            #end TQC-C60025 mod
        ELSE               #FUN-C30274
            if not p_transaction then
                ROLLBACK WORK   #FUN-C30274
            end if
        END IF
    end if
    return ''
end function
