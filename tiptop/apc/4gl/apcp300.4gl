# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: apcp300.4gl
# Descriptions...: 差異調整自動批處理
# Date & Author..: No:FUN-CB0028 12/11/09 By xumm
# Modify.........: No.FUN-CB0118 12/12/05 By xumm 服务状态增加4:异常（ERP处理失败）
# Modify.........: No.FUN-CC0135 13/01/05 By xumm INSERT rxt_file时给rxt18赋值
# Modify.........: No.FUN-D10095 13/01/29 By xumm XML格式调整
# Modify.........: No.FUN-D40052 13/04/15 By xumm XML解析逻辑修改

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE g_wc           STRING
DEFINE g_bgjob         LIKE type_file.chr1
DEFINE g_sql           STRING
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_change_lang   LIKE type_file.chr1
DEFINE g_posdbs        LIKE ryg_file.ryg00,
       g_db_links      LIKE ryg_file.ryg02
DEFINE g_request_root  om.DomNode
DEFINE g_wap02         LIKE wap_file.wap02
DEFINE g_wc_plant      STRING 
DEFINE g_rec_b         LIKE type_file.num5
DEFINE g_rxu           DYNAMIC ARRAY OF RECORD
            rxu03      LIKE rxu_file.rxu03,  #門店編號
            rxu13      LIKE rxu_file.rxu13,
            rxu14      LIKE rxu_file.rxu14,
            rxu04      LIKE rxu_file.rxu04,
            etype      LIKE type_file.chr1,
            rxu01      LIKE rxu_file.rxu01,  
            rxu06      LIKE rxu_file.rxu06,
            rxu07      LIKE rxu_file.rxu07,
            rxu08      LIKE rxu_file.rxu08,
            rxu09      LIKE rxu_file.rxu09,
            rxu10      LIKE rxu_file.rxu10,
            rxu15      LIKE rxu_file.rxu15,
            rxu16      LIKE rxu_file.rxu16,     #FUN-CC0135 add
            rxu11      LIKE rxu_file.rxu11,
            rxu12      LIKE rxu_file.rxu12,
            stype      LIKE type_file.chr1,
            rxu02      LIKE rxu_file.rxu02
                       END RECORD

MAIN
DEFINE l_flag LIKE type_file.chr1
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_wc = ARG_VAL(1)
   LET g_bgjob = ARG_VAL(2)
   IF NOT cl_user() THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF NOT cl_setup("APC") THEN
      EXIT PROGRAM
   END IF

   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   ERROR ""
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p300_tm()
         IF cl_sure(18,20) THEN
            CALL p300_crt_tmp()     #FUN-CC0135 add
            BEGIN WORK
            CALL s_showmsg_init()
            LET g_success = 'Y'
            CALL apcp300()
            CALL s_showmsg()
            IF g_success = 'Y' THEN 
               IF g_cnt > 0 THEN
                  COMMIT WORK
                  DROP TABLE lpj_tmp  #FUN-CC0135 add
                  CALL cl_end2(1) RETURNING l_flag
               ELSE
                  ROLLBACK WORK
                  DROP TABLE lpj_tmp  #FUN-CC0135 add
                  CALL cl_err('','aco-058',0) #無符合的資料
                  LET l_flag = TRUE
               END IF
            ELSE
               ROLLBACK WORK
               DROP TABLE lpj_tmp  #FUN-CC0135 add
               CALL cl_end2(2) RETURNING l_flag
            END IF 
            IF l_flag THEN
               CONTINUE WHILE 
            ELSE
               CLOSE WINDOW p300_w
               EXIT WHILE 
            END IF 
         ELSE
            CONTINUE WHILE 
         END IF
      ELSE
         BEGIN WORK
         CALL s_showmsg_init()
         LET g_success = 'Y'
         IF cl_null(g_wc) THEN
            LET g_wc = " 1=1"
         END IF
         CALL apcp300()
         CALL s_showmsg()
         IF g_success = 'Y' THEN
            COMMIT WORK 
         ELSE
            ROLLBACK WORK 
         END IF 
         EXIT WHILE 
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p300_tm()
DEFINE lc_cmd  STRING
DEFINE l_zz08  LIKE zz_file.zz08

   IF s_shut(0) THEN RETURN END IF

   OPEN WINDOW p300_w WITH FORM "apc/42f/apcp300"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_opmsg('z')

   WHILE TRUE 
      CLEAR FORM 
      LET g_bgjob = 'N'
      DIALOG
         CONSTRUCT g_wc ON shop,machine,rdate
                      FROM shop,mach,rdate
            BEFORE CONSTRUCT
                CALL cl_qbe_init()

            ON ACTION controlp
                CASE
                    WHEN INFIELD(shop)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_azw01_2"
                        LET g_qryparam.arg1 =g_plant
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO shop
                        NEXT FIELD shop
                    OTHERWISE
                        EXIT CASE
                END CASE
         END CONSTRUCT
         INPUT g_bgjob FROM bgjob ATTRIBUTE(WITHOUT DEFAULTS)

            AFTER FIELD bgjob
               IF g_bgjob NOT MATCHES "[YN]" OR cl_null(g_bgjob) THEN 
                  NEXT FIELD bgjob            
               END IF
         END INPUT 

         ON ACTION accept
            ACCEPT DIALOG

         ON ACTION cancel
            LET INT_FLAG = 1
            EXIT DIALOG

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()

         ON ACTION HELP
            CALL cl_show_help()

         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT DIALOG 

         ON ACTION qbe_save
            CALL cl_qbe_save()

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
      END DIALOG

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 
      END IF 

      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO l_zz08 FROM zz_file
          WHERE zz01 = "apcp300"
         IF SQLCA.sqlcode OR cl_null(l_zz08) THEN
            CALL cl_err('apcp300','9031',1)
         ELSE
            LET g_wc  = cl_replace_str(g_wc,"'","\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"' ",
                         " '",g_bgjob CLIPPED,"' "
            CALL cl_cmdat('apcp300',g_time,lc_cmd CLIPPED)
         END IF 
         CLOSE WINDOW p300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 
      END IF
      EXIT WHILE 
   END WHILE 
END FUNCTION 

FUNCTION apcp300()
DEFINE l_posdbs       LIKE ryg_file.ryg00,
       l_db_links     LIKE ryg_file.ryg02
DEFINE l_request_xml  VARCHAR(4000),
       l_service_name LIKE type_file.chr20

    SELECT DISTINCT ryg00,ryg02 INTO l_posdbs,l_db_links FROM ryg_file
    LET g_posdbs = s_dbstring(l_posdbs)
    LET g_db_links = p300_dblinks(l_db_links)
    CALL p300_get_plant()
    LET g_sql = "SELECT DISTINCT shop,machine,'','','1','',",
                "       '','','','',0,0,'',CAST(rdate AS DATE), ",                  #FUN-CC0135 add ''
                "       rtime[1,2]||':'||rtime[3,4]||':'||rtime[5,6],servicestate,",
                "       '',requestxml,methodname",
                "  FROM ",g_posdbs,"tk_wslog",g_db_links,
                #" WHERE ",g_wc CLIPPED," AND servicestate IN('2','3')",             #FUN-CB0118 mark
               #" WHERE ",g_wc CLIPPED," AND servicestate IN('2','3','4')",          #FUN-CB0118 add  #FUN-CC0135 Mark
                " WHERE ",g_wc CLIPPED,                                                               #FUN-CC0135 Add
                "   AND condition2 = 'A' AND cnfflg = 'Y'",
                "   AND methodname = 'WritePoint' AND UPPER(trans_id) NOT IN ",
                "  (SELECT DISTINCT UPPER(replace(rxu01,'-','')) FROM rxu_file",
                "    WHERE rxuacti = 'Y' AND rxu05 = 'WritePoint')"
    IF NOT cl_null(g_wc_plant) THEN
        LET g_sql = g_sql CLIPPED," AND shop IN (",g_wc_plant,")"
    END IF 
    LET g_sql = g_sql CLIPPED," UNION ALL ",
                "SELECT DISTINCT shop,machine,rxu14,rxu04,'2',rxu01,",
                "       rxu06,rxu07,rxu08,rxu09,rxu10,rxu15,rxu16,CAST(rdate AS DATE), ",  #FUN-CC0135 add rxu16
                "       rtime[1,2]||':'||rtime[3,4]||':'||rtime[5,6],servicestate,",
                "       rxu02,requestxml,methodname",
                "  FROM ",g_posdbs,"tk_wslog",g_db_links,",rxu_file ",
                #" WHERE ",g_wc CLIPPED," AND servicestate IN('2','3')",             #FUN-CB0118 mark
               #" WHERE ",g_wc CLIPPED," AND servicestate IN('2','3','4')",          #FUN-CB0118 add  #FUN-CC0135 Mark
                " WHERE ",g_wc CLIPPED,                                                               #FUN-CC0135 Add
                "   AND condition2 = 'A' AND cnfflg = 'Y'",
                "   AND UPPER(replace(rxu01,'-','')) = UPPER(trans_id)",
                "   AND rxuacti = 'Y' AND methodname <> 'WritePoint'"
    IF NOT cl_null(g_wc_plant) THEN
        LET g_sql = g_sql CLIPPED," AND shop IN (",g_wc_plant,")"
    END IF 
    LET g_sql = g_sql CLIPPED," ORDER BY 1,4,6 "
    PREPARE p300_pb FROM g_sql
    DECLARE tk_wslog_curs CURSOR WITH HOLD FOR p300_pb
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH tk_wslog_curs INTO g_rxu[g_cnt].*,l_request_xml,l_service_name
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_request_root = NULL
        IF g_rxu[g_cnt].etype = '1' THEN 
           #FUN-D40052-----mark&add---str
           #SELECT wap02 INTO g_wap02 FROM wap_file
           #IF g_wap02 = 'Y' THEN
           #   LET l_request_xml = cl_coding_de(l_request_xml)
           #END IF
            LET l_request_xml = cl_get_plaintext(l_request_xml)
            IF l_request_xml="-1" THEN
               CALL cl_err('','Decode error',1)
               CONTINUE FOREACH
            END IF
           #FUN-D40052-----mark&add---end   
            LET l_request_xml = sapcq300_xml_process(l_request_xml)
            LET g_request_root = sapcq300_xml_stringToXml(l_request_xml)
            IF g_request_root IS NOT NULL THEN    #根XML節點不可為空
                CALL p300_getXmlData(l_service_name,g_cnt)
            ELSE
                CONTINUE FOREACH
            END IF
        END IF 
        LET g_cnt = g_cnt + 1
    END FOREACH
    LET g_cnt = g_cnt - 1
    LET g_rec_b = g_cnt
    CALL p300_ins_rxs()
END FUNCTION

FUNCTION p300_getXmlData(p_server_name,p_i)
DEFINE p_server_name  STRING,
       p_i            INTEGER 
DEFINE l_len1         INTEGER,    #XML單頭筆數
       l_len2         INTEGER     #XML單身筆數
DEFINE l_node1        om.DomNode,
       l_node2        om.DomNode
DEFINE l_paytype      STRING      #請求類型
DEFINE l_type         LIKE rxu_file.rxu14,
       l_saleno       LIKE rxu_file.rxu04
DEFINE l_n            INTEGER,
       l_m            INTEGER
DEFINE l_guid         LIKE rxu_file.rxu01 
DEFINE l_cnt          LIKE type_file.num10
DEFINE l_node         om.DomNode  #FUN-D10095 Add

    LET l_guid = sapcq300_xml_get_ConnectionMsg(g_request_root,"guid")
    CASE p_server_name
        WHEN "DeductSPayment"
           #FUN-D10095 Mark&Add STR-------
           #LET l_len1 = sapcq300_xml_getMasterRecordLength(g_request_root,"PAY")
           #FOR l_n = 1 TO l_len1
           #    LET l_node1 = sapcq300_xml_getMasterRecord(g_request_root,l_n,"PAY")
           #    LET l_type = sapcq300_xml_getRecordField(l_node1, "Type")
           #    LET l_saleno = sapcq300_xml_getRecordField(l_node1, "SaleNO")
           #    LET l_len2 = sapcq300_xml_getDetailRecordLength(l_node1)
           #    FOR l_m = 1 TO l_len2
           #        LET l_node2 = sapcq300_xml_getDetail(l_node1, l_m)
            LET l_len1 = sapcq300_xml_getTreeMasterRecordLength(g_request_root,"Pay")
            FOR l_n = 1 TO l_len1
                LET l_node1 = sapcq300_xml_getTreeMasterRecord(g_request_root,l_n,"Pay")
                LET l_type = sapcq300_xml_getRecordField(l_node1, "Type")
                LET l_saleno = sapcq300_xml_getRecordField(l_node1, "SaleNO")
                LET l_len2 = sapcq300_xml_getTreeRecordLength(l_node1,"Pay")
                FOR l_m = 1 TO l_len2
                    LET l_node2 = sapcq300_xml_getTreeRecord(l_node1, l_m ,"Pay")
           #FUN-D10095 Mark&Add END-------
                    LET l_paytype = l_node2.getAttribute("name")
                    LET g_rxu[p_i].* = g_rxu[g_cnt].*
                    LET g_rxu[p_i].rxu14 = l_type
                    LET g_rxu[p_i].rxu04 = l_saleno
                    LET g_rxu[p_i].etype = '1'
                    LET g_rxu[p_i].rxu01 = l_guid
                    CASE
                        WHEN(l_paytype = "Card")
                            LET g_rxu[p_i].rxu06 = '4'
                            LET g_rxu[p_i].rxu07 = sapcq300_xml_getDetailRecordField(l_node2,"CardNO")
                            LET g_rxu[p_i].rxu10 = sapcq300_xml_getDetailRecordField(l_node2,"DeductAmount")
                            IF g_rxu[p_i].rxu14 MATCHES '[03]' THEN LET g_rxu[p_i].rxu10 = -1*g_rxu[p_i].rxu10 END IF 
                        WHEN(l_paytype = "Coupon")
                            LET g_rxu[p_i].rxu06 = '5'
                            LET g_rxu[p_i].rxu07 = sapcq300_xml_getDetailRecordField(l_node2,"CouponNO")
                        WHEN(l_paytype = "Score")
                            LET g_rxu[p_i].rxu06 = '3'
                            LET g_rxu[p_i].rxu07 = sapcq300_xml_getDetailRecordField(l_node2,"CardNO")
                        WHEN(l_paytype = "WritePoint")
                            LET g_rxu[p_i].rxu06 = '2'
                            LET g_rxu[p_i].rxu07 = sapcq300_xml_getDetailRecordField(l_node2,"CardNO")
                            LET g_rxu[p_i].rxu10 = sapcq300_xml_getDetailRecordField(l_node2, "POINT_QTY")
                            LET g_rxu[p_i].rxu15 = sapcq300_xml_getDetailRecordField(l_node2, "TOT_AMT")
                            IF g_rxu[p_i].rxu14 MATCHES '[124]' THEN LET g_rxu[p_i].rxu10 = -1*g_rxu[p_i].rxu10 END IF 
                    END CASE
                    LET p_i = p_i + 1
                END FOR
                CALL g_rxu.deleteElement(p_i)
                LET p_i = p_i - 1
                LET p_i = p_i + 1
            END FOR
            CALL g_rxu.deleteElement(p_i)
            LET p_i = p_i - 1
        WHEN "WritePoint"
            LET g_rxu[p_i].* = g_rxu[g_cnt].*
            LET g_rxu[p_i].etype = '1'
            LET g_rxu[p_i].rxu06 = '2'
           #FUN-D10095 Mark&Add STR-------
           #LET g_rxu[p_i].rxu07 = sapcq300_xml_getParameter(g_request_root,"CardNO") 
           #LET g_rxu[p_i].rxu14 = sapcq300_xml_getParameter(g_request_root,"Type")
           #LET g_rxu[p_i].rxu15 = sapcq300_xml_getParameter(g_request_root,"TOT_AMT")
           #LET g_rxu[p_i].rxu04 = sapcq300_xml_getParameter(g_request_root,"SaleNO")
           #LET g_rxu[p_i].rxu10 = sapcq300_xml_getParameter(g_request_root,"POINT_QTY")
            LET l_node = sapcq300_xml_getTreeMasterRecord(g_request_root,1,"WritePoint")
            LET g_rxu[p_i].rxu07 = sapcq300_xml_getDetailRecordField(l_node,"CardNO")
            LET g_rxu[p_i].rxu14 = sapcq300_xml_getDetailRecordField(l_node,"Type")
            LET g_rxu[p_i].rxu15 = sapcq300_xml_getDetailRecordField(l_node,"TOT_AMT")
            LET g_rxu[p_i].rxu04 = sapcq300_xml_getDetailRecordField(l_node,"SaleNO")
            LET g_rxu[p_i].rxu10 = sapcq300_xml_getDetailRecordField(l_node,"POINT_QTY")
           #FUN-D10095 Mark&Add END-------
            LET g_rxu[p_i].rxu01 = l_guid
        WHEN "ModPassWord"
            LET g_rxu[p_i].* = g_rxu[g_cnt].*
            LET g_rxu[p_i].etype = '1'
            LET g_rxu[p_i].rxu06 = '1'
           #FUN-D10095 Mark&Add STR-------
           #LET g_rxu[p_i].rxu07 = sapcq300_xml_getParameter(g_request_root,"OPNO")
           #LET g_rxu[p_i].rxu09 = sapcq300_xml_getParameter(g_request_root,"npsw")
            LET l_node = sapcq300_xml_getTreeMasterRecord(g_request_root,1,"ModPassWord")
            LET g_rxu[p_i].rxu07 = sapcq300_xml_getDetailRecordField(l_node,"OPNO")
            LET g_rxu[p_i].rxu09 = sapcq300_xml_getDetailRecordField(l_node,"npsw")
           #FUN-D10095 Mark&Add END-------
            LET g_rxu[p_i].rxu01 = l_guid
    END CASE 
    LET g_cnt = p_i
END FUNCTION

FUNCTION p300_ins_rxs() 
DEFINE l_rxs RECORD LIKE rxs_file.*
DEFINE li_result    LIKE type_file.num5
DEFINE l_cnt        LIKE type_file.num10

    IF g_rec_b = 0 THEN RETURN END IF 
    IF g_bgjob = 'N' THEN
       IF NOT cl_confirm('apc-203') THEN
          RETURN
       END IF
    END IF
   #FUN-CC0135---mark---str
   #LET g_success = 'Y'
   #CALL s_showmsg_init()
   #DROP TABLE lpj_tmp
   #CREATE TEMP TABLE lpj_tmp(
   #    lpj03 LIKE lpj_file.lpj03,
   #    lpj07 LIKE lpj_file.lpj07,
   #    lpj15 LIKE lpj_file.lpj15)
   #BEGIN WORK
   #FUN-CC0135---mark---end
   
    CALL s_get_defslip('art','F4',g_plant,'N') RETURNING l_rxs.rxs01 

    IF cl_null(l_rxs.rxs01) THEN
        CALL s_errmsg('rxs01',l_rxs.rxs01,'sel_rye','art-330',1)
        LET g_success = 'N'
    END IF
    CALL s_auto_assign_no("art",l_rxs.rxs01,g_today,"F4","rxs_file","rxs01","","","")   
        RETURNING li_result,l_rxs.rxs01
    IF (NOT li_result) THEN
        LET g_success = 'N'
        RETURN
    END IF
    LET l_rxs.rxs02 = g_today
    LET l_rxs.rxs03 = g_user
    LET l_rxs.rxs04 = ' '
    LET l_rxs.rxs05 = '0'
    LET l_rxs.rxsconf = 'N'
    LET l_rxs.rxscond = NULL
    LET l_rxs.rxspost = 'N'
    LET l_rxs.rxsmksg = 'N'
    LET l_rxs.rxsacti = 'Y'
    LET l_rxs.rxscrat = g_today
    LET l_rxs.rxsdate = g_today
    LET l_rxs.rxsgrup = g_grup
    LET l_rxs.rxsuser = g_user
    LET l_rxs.rxsoriu = g_user
    LET l_rxs.rxsorig = g_grup
    LET l_rxs.rxsplant = g_plant
    LET l_rxs.rxslegal = g_legal
    
    CALL p300_ins_rxt(l_rxs.rxs01)
    IF g_success = 'Y' THEN  
        SELECT COUNT(*) INTO l_cnt FROM rxt_file WHERE rxt01 = l_rxs.rxs01
        IF l_cnt > 0 THEN 
            INSERT INTO rxs_file VALUES(l_rxs.*)
            IF sqlca.sqlcode THEN 
                CALL s_errmsg('rxs01',l_rxs.rxs01,'INSERT rxs_file',sqlca.sqlcode,1)
                LET g_success = 'N'
            END IF
        ELSE 
            CALL s_errmsg('rxt01',l_rxs.rxs01,'INSERT rxt_file','',1)
            LET g_success = 'N'
        END IF
    END IF  
   
    CALL t300sub_y(l_rxs.rxs01,FALSE)
    CALL t300sub_s(l_rxs.rxs01,FALSE) 
   #FUN-CC0135---mark---str
   #CALL s_showmsg()
   #IF g_success = 'N' THEN 
   #    ROLLBACK WORK
   #ELSE
   #    COMMIT WORK
   #    IF g_bgjob = 'N' THEN
   #       CALL cl_err(l_rxs.rxs01,'apc-204',1)
   #    END IF
   #    DROP TABLE lpj_tmp
   #END IF 
   #FUN-CC0135---mark---end
END FUNCTION

FUNCTION p300_ins_rxt(p_rxs01)
DEFINE p_rxs01 LIKE rxs_file.rxs01
DEFINE l_rxt   RECORD LIKE rxt_file.*
DEFINE l_i     LIKE type_file.num10
DEFINE l_guid  STRING 
DEFINE l_rxt07_rxu STRING 
DEFINE l_rxt07_tk  STRING 
    FOR l_i = g_rec_b TO 1 STEP -1   #將所有的設為選擇
        INITIALIZE l_rxt.* TO NULL
        LET l_rxt.rxt01 = p_rxs01
        SELECT MAX(rxt02) INTO l_rxt.rxt02 FROM rxt_file
         WHERE rxt01 = p_rxs01
        IF cl_null(l_rxt.rxt02) THEN
           LET l_rxt.rxt02 = 1 
        ELSE 
           LET l_rxt.rxt02 = l_rxt.rxt02 + 1
        END IF 
        LET l_rxt.rxt03 = g_rxu[l_i].rxu03
        LET l_rxt.rxt04 = g_rxu[l_i].rxu13
        LET l_rxt.rxt05 = g_rxu[l_i].rxu14
        LET l_rxt.rxt06 = g_rxu[l_i].rxu04
        LET l_rxt.rxt07 = g_rxu[l_i].rxu01
        LET l_rxt.rxt08 = g_rxu[l_i].rxu06
        LET l_rxt.rxt09 = g_rxu[l_i].rxu07
        LET l_rxt.rxt10 = g_rxu[l_i].rxu08
        LET l_rxt.rxt11 = g_rxu[l_i].rxu09
        LET l_rxt.rxt12 = g_rxu[l_i].rxu10
        LET l_rxt.rxt13 = g_rxu[l_i].rxu15
        LET l_rxt.rxt14 = g_rxu[l_i].rxu11
        LET l_rxt.rxt15 = g_rxu[l_i].rxu12
        LET l_rxt.rxt16 = g_rxu[l_i].etype
        LET l_rxt.rxt17 = g_rxu[l_i].stype
        LET l_rxt.rxt18 = g_rxu[l_i].rxu16     #FUN-CC0135 add
        LET l_rxt.rxtplant = g_plant
        LET l_rxt.rxtlegal = g_legal
        INSERT INTO rxt_file VALUES(l_rxt.*)
        IF sqlca.sqlcode THEN 
           CALL s_errmsg('rxs01',l_rxt.rxt01,'INSERT rxt_file',sqlca.sqlcode,1)
           LET g_success = 'N'
           RETURN
        END IF 
        #組rxu01條件
        IF cl_null(l_rxt07_rxu) THEN 
            LET l_rxt07_rxu = "'",l_rxt.rxt07,"'"
        ELSE 
            LET l_rxt07_rxu = l_rxt07_rxu,",'",l_rxt.rxt07,"'"
        END IF 
        #組中間庫trans_id條件
        CALL cl_replace_str(l_rxt.rxt07, "-", "") RETURNING l_rxt.rxt07
        IF cl_null(l_rxt07_tk) THEN 
            LET l_rxt07_tk = "'",l_rxt.rxt07,"'"
        ELSE 
            LET l_rxt07_tk = l_rxt07_tk,",'",l_rxt.rxt07,"'"
        END IF 
    END FOR
    IF g_success = 'Y' AND NOT cl_null(l_rxt07_tk) THEN 
       CALL p300_upd_tk_wslog(l_rxt07_tk)
    END IF 
    IF g_success = 'Y' AND NOT cl_null(l_rxt07_rxu) THEN
       CALL p300_upd_rxu(l_rxt07_rxu)
    END IF 
END FUNCTION 

#更新tk_wslog資料狀態
FUNCTION p300_upd_tk_wslog(p_rxt07_tk)
    DEFINE p_rxt07_tk STRING
    DEFINE l_buf    base.StringBuffer
    DEFINE l_guid   STRING 

    IF cl_null(p_rxt07_tk) THEN RETURN END IF 
    CALL cl_replace_str(p_rxt07_tk,"-","") RETURNING l_guid
    LET l_buf = base.StringBuffer.create()
    CALL l_buf.append(p_rxt07_tk)
    CALL l_buf.toUpperCase()
    LET l_guid = l_buf.toString()
    LET g_sql = "UPDATE ",g_posdbs,"tk_wslog",g_db_links,
                "   SET condition2 = 'B'",
                #" WHERE servicestate IN('2','3')",         #FUN-CB0118 mark
               #" WHERE servicestate IN('2','3','4')",      #FUN-CB0118 add    #FUN-CC0135 Mark
               #"   AND condition2 = 'A' AND UPPER(trans_id) IN (",l_guid,")"  #FUN-CC0135 Mark
                " WHERE condition2 = 'A' AND UPPER(trans_id) IN (",l_guid,")"  #FUN-CC0135 Add
    PREPARE upd_tk_wslog_pre FROM g_sql
    EXECUTE upd_tk_wslog_pre
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN 
        CALL s_errmsg('GUID','','update tk_wslog',SQLCA.sqlcode,1) 
        LET g_success = 'N'
        RETURN 
    END IF
END FUNCTION 

#更新rxu_file資料狀態
FUNCTION p300_upd_rxu(p_rxt07_rxu)
    DEFINE p_rxt07_rxu STRING

    IF cl_null(p_rxt07_rxu) THEN RETURN END IF 
    
    LET g_sql = "UPDATE rxu_file ",
                "   SET rxuacti = 'N'",
                " WHERE rxuacti = 'Y' AND rxu01 IN (",p_rxt07_rxu,")"
    PREPARE upd_rxu_pre FROM g_sql
    EXECUTE upd_rxu_pre
    IF SQLCA.sqlcode THEN 
        CALL s_errmsg('GUID','','UPDATE rxu_file',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN 
    END IF
END FUNCTION 

FUNCTION p300_get_plant()
DEFINE l_azw01  LIKE azw_file.azw01
    LET g_wc_plant = NULL
    DECLARE p300_plant_cs CURSOR FOR 
     SELECT azw01 FROM azw_file
      WHERE azw01 = g_plant OR azw07 = g_plant
        AND azwacti = 'Y'
    FOREACH p300_plant_cs INTO l_azw01
        IF cl_null(g_wc_plant) THEN
            LET g_wc_plant = "'",l_azw01,"'"
        ELSE 
            LET g_wc_plant = g_wc_plant,",'",l_azw01,"'"
        END IF  
    END FOREACH
END FUNCTION 

FUNCTION p300_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02

  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF
END FUNCTION
#FUN-CB0028
#FUN-CC0135----add---str
FUNCTION p300_crt_tmp()
   DROP TABLE lpj_tmp
   CREATE TEMP TABLE lpj_tmp(
       lpj03 LIKE lpj_file.lpj03,
       lpj07 LIKE lpj_file.lpj07,
       lpj15 LIKE lpj_file.lpj15)   
END FUNCTION
#FUN-CC0135----add---end
