# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aemp102.4gl
# Descriptions...: 設備改良作業
# Date & Author..: 04/08/13 By Elva
# Modify.........: No.FUN-550024 05/05/20 By Trisy 單據編號加大
# Modify.........: No.FUN-560014 05/06/03 By jackie 單據編號修改
# Modify.........: No.MOD-530629 05/06/08 By Carrier 更改單據查詢
# Modify.........: No.MOD-560238 05/07/27 By vivien 自動編號修改
# Modify.........: No.TQC-5C0048 05/12/09 By Claire 無法切換語言別
# Modify.........: No.TQC-630104 06/03/14 By Smapmin DISPLAY ARRAY無控制單身筆數
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680072 06/08/24 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-770003 07/07/01 By hongmei 新增help
# Modify.........: No.TQC-930031 09/03/06 By mike 將DISPLAY BY NAME g_fay01 改成 DISPLAY g_fay01 TO FORMONLY.o
# Modify.........: No.FUN-980002 09/08/20 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No.FUN-B90075 11/09/15 By zhangll 單號控管改善
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    l_cmd           LIKE type_file.chr1000,             #string command variable        #No.FUN-680072char(100)
          g_t1            LIKE type_file.chr5,                #No.FUN-550024          #No.FUN-680072CHAR(05)
          g_fay           RECORD LIKE fay_file.*,#No.FUN-550024   
        g_fil  RECORD
            fil01               LIKE fil_file.fil01,
            fil03               LIKE fil_file.fil03,
            fia02               LIKE fia_file.fia02,
            fia011              LIKE fia_file.fia011,
            fia012              LIKE fia_file.fia012
        END RECORD,
        g_fay01    LIKE fay_file.fay01,
        g_fil01    LIKE fil_file.fil01,
        g_fil03    LIKE fil_file.fil03,
        g_fil05    LIKE fil_file.fil05,
        g_fia02    LIKE fia_file.fia02,
        g_fia011   LIKE fia_file.fia011,
        g_fia012   LIKE fia_file.fia012,
        g_fiw DYNAMIC ARRAY OF RECORD            #
             fiw03    LIKE fiw_file.fiw03,
             ima02    LIKE ima_file.ima02,
             ima25    LIKE ima_file.ima25,
             qty      LIKE fiw_file.fiw08,
             a        LIKE fiw_file.fiw11,
             b        LIKE fiw_file.fiw11
        END RECORD,
        g_cmd        LIKE type_file.chr1000,       #No.FUN-680072 VARCHAR(60)
        g_sql        STRING,        #No.FUN-580092 HCN
        g_rec_b      LIKE type_file.num5,          #No.FUN-680072 SMALLINT
        s_t          LIKE type_file.num5,          #No.FUN-680072 SMALLINT
        l_no         LIKE type_file.num5,          #No.FUN-680072 SMALLINT
        l_ac         LIKE type_file.num5,          #No.FUN-680072 SMALLINT
        l_fac        LIKE pml_file.pml09,          #No.FUN-680072 DEC(16,8)
        l_tot        LIKE fiw_file.fiw11
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680072 INTEGER
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
 
   OPEN WINDOW p102_w WITH FORM "aem/42f/aemp102"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL p102_cmd()          #condition input
 
   CLOSE WINDOW p102_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
 
END MAIN
 
FUNCTION p102_cmd()
 
    DEFINE l_flag     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
    DEFINE l_filacti  LIKE fil_file.filacti
    DEFINE l_fiaacti  LIKE fia_file.fiaacti
    DEFINE li_result   LIKE type_file.num5         #No.FUN-560014        #No.FUN-680072 SMALLINT
 
    CALL cl_opmsg('z')
    WHILE TRUE
        IF s_shut(0) THEN RETURN END IF
        CLEAR FORM
        CALL g_fiw.clear()
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
           EXIT PROGRAM
        END IF
        INPUT g_fil01,g_fay01 WITHOUT DEFAULTS FROM fil01,o
           AFTER FIELD fil01
             IF NOT cl_null(g_fil01) THEN
                SELECT fil03,fil05,filacti INTO g_fil03,g_fil05,l_filacti
                         FROM fil_file  WHERE fil01 = g_fil01
                CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aem-028'
                     WHEN l_filacti = 'N'     LET g_errno = '9028'
#                     WHEN g_fil05<>'3'        LET g_errno = 'aem-036'
                      WHEN g_fil05<>'3'        LET g_errno = 'aem-046' #No.MOD-530629
                     WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
                END CASE
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fil01,g_errno,0)
                  NEXT FIELD fil01
                END IF
 
                SELECT fia02,fia011,fia012,fiaacti
                  INTO g_fia02,g_fia011,g_fia012,l_fiaacti
                  FROM fia_file  WHERE fia01 = g_fil03
#                CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aem-037'
                  CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aem-047' #No.MOD-530629
                     WHEN l_fiaacti = 'N'     LET g_errno = '9028'
                     WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
                END CASE
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fil03,g_errno,0)
                  NEXT FIELD fil01
                END IF
                DISPLAY g_fil03 TO fil03
                DISPLAY g_fia02 TO FORMONLY.fia02
                DISPLAY g_fia011 TO FORMONLY.fia011
                DISPLAY g_fia012 TO FORMONLY.fia012
             END IF
 
           AFTER FIELD o
             IF NOT cl_null(g_fay01) THEN
#No.FUN-560014 --start--                                                        
#              LET g_t1=g_fay01[1,3]
               LET g_t1=g_fay01[1,g_doc_len]  #No.FUN-560014    
               CALL s_check_no("afa",g_fay01,"","7","","","")  #FUN-B90075 mod g_t1->g_fay01
               RETURNING li_result,g_fay01                  #FUN-B90075 mod g_t1->g_fay01
#               LET g_t1=g_fay01[1,g_doc_len]  #No.FUN-560014    
               IF (NOT li_result) THEN                                          
                   NEXT FIELD o                                             
               END IF  
#              CALL s_afaslip(g_t1,'7','AFA')       #檢查外送單別
#              IF NOT cl_null(g_errno) THEN         #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 NEXT FIELD o
#              END IF
#No.FUN-560014 --end--
             END IF
 
            #TQC-5C0048-begin
            ON ACTION locale
               CALL cl_dynamic_locale()
            #TQC-5C0048-end
 
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
 
            ON ACTION help          #TQC-770003                                                                                       
             CALL cl_show_help()    #TQC-770003
 
            ON ACTION CONTROLG
               CALL cl_cmdask()
 
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(fil01)   #工單編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_fil1"
                     LET g_qryparam.arg1 = '3'
                     CALL cl_create_qry() RETURNING g_fil01
                     DISPLAY BY NAME g_fil01
                     NEXT FIELD fil01
 
                  WHEN INFIELD(o)
#                   LET g_t1=g_fay01[1,3]
                    LET g_t1=s_get_doc_no(g_fay01)     #No.FUN-560014  
                    CALL q_fah(FALSE,TRUE,g_t1,'7','AFA')
                          RETURNING g_t1
#                   LET g_fay01[1,3]=g_t1
                    LET g_fay01 = g_t1                 #No.FUN-550024 
                   #DISPLAY BY NAME g_fay01 #TQC-930031
                    DISPLAY g_fay01 TO FORMONLY.o #TQC-930031  
                    NEXT FIELD o
               END CASE
 
            ON ACTION query_wo_data
                IF NOT cl_null(g_fil01) THEN
                   LET g_cmd = "aemi200"," '",g_fil01 CLIPPED,"'"
                   CALL cl_cmdrun(g_cmd)   
                END IF
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
            ON ACTION exit                            #加離開功能
               LET INT_FLAG = 1
               EXIT INPUT
        END INPUT
 
        IF INT_FLAG THEN 
           LET INT_FLAG = 0
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
           EXIT PROGRAM
        END IF
        CALL p102_fill() returning s_t    #抓取符合資料填入陣列
        IF  s_t <=0 THEN                  #無符合之資料
            CALL cl_err( ' ','mfg3122',0)
            CONTINUE  WHILE
        END IF
        CALL p102_b_tot()
 
        CALL p102_array()
        IF cl_sure(0,0) THEN
           BEGIN WORK
           LET g_success='Y'
           CALL p102_gen()
           IF g_success = 'Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              EXIT WHILE
           END IF
        ELSE
           EXIT  WHILE
        END IF
    END WHILE
    ERROR ""
END FUNCTION
 
FUNCTION p102_fill()
#     DEFINE    l_time LIKE type_file.chr8         #No.FUN-6A0068
DEFINE     l_wc       LIKE type_file.chr1000,        # RDSQL STATEMENT        #No.FUN-680072 VARCHAR(200)
           l_sql      LIKE type_file.chr1000,        # RDSQL STATEMENT        #No.FUN-680072 VARCHAR(610)
           l_fiw07    LIKE fiw_file.fiw07,
           l_fiw08_1  LIKE fiw_file.fiw08,
           l_fiw08_2  LIKE fiw_file.fiw08,
           l_fiw08    LIKE fiw_file.fiw08,
           l_fiw11    LIKE fiw_file.fiw11,
           l_a        LIKE fiw_file.fiw11,
           l_ima25    LIKE ima_file.ima25,
           l_cnt      LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
    LET l_sql = "  SELECT UNIQUE fiw03,ima02,ima25,'','',''",
                "  FROM fiv_file,fiw_file ",
                "  LEFT OUTER JOIN ima_file ON fiw_file.fiw03=ima_file.ima01",
                "   WHERE fiw01 = fiv01 ",
                "    AND fiv02 = '",g_fil01,"'",
                "    AND fiw09 = 'Y' AND fivpost = 'Y' ",
                "  ORDER BY fiw03 "
 
    PREPARE p102_prepare FROM l_sql #prepare it
    DECLARE p102_cur CURSOR FOR p102_prepare
    CALL g_fiw.clear()
    LET l_ac = 1
    FOREACH p102_cur INTO g_fiw[l_ac].*
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('cannot foreach ',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        LET l_fiw08 = 0
        LET l_a = 0
        SELECT ima25 INTO l_ima25 FROM ima_file
         WHERE ima01 = g_fiw[l_ac].fiw03
        LET l_fac = 1
        LET g_sql = "SELECT fiw07,fiw08,fiw11 FROM fiv_file,fiw_file",#發料
                    " WHERE fiw01 = fiv01 ",
                    "   AND fiv02 = '",g_fil01,"'",
                    "   AND fiw09 = 'Y' AND fivpost = 'Y' ",
                    "   AND fiw03 = '",g_fiw[l_ac].fiw03,"'",
                    "   AND fiv00 = '1' "
        PREPARE p102_pre_1 FROM g_sql #prepare it
        DECLARE p102_fiw_1 CURSOR FOR p102_pre_1
        FOREACH p102_fiw_1 INTO l_fiw07,l_fiw08_1,l_fiw11
            LET l_fac = 1
            CALL s_umfchk(g_fiw[l_ac].fiw03,l_fiw07,l_ima25)
                 RETURNING g_cnt,l_fac
            IF g_cnt=1 THEN
               CALL cl_err('','abm-731',0)
               LET l_fac = 1
            END IF
            IF cl_null(l_fiw08_1) THEN LET l_fiw08_1 = 0 END IF
         #  IF cl_null(l_fiw08) THEN LET l_fiw08 = 0 END IF
            IF cl_null(l_fiw11) THEN LET l_fiw11 = 0 END IF
            LET l_fiw08_1 = l_fiw08_1 * l_fac
            LET l_fiw08 = l_fiw08_1 + l_fiw08
            LET l_a = l_a + l_fiw11
        END FOREACH
        LET g_sql = "SELECT fiw07,fiw08,fiw11 FROM fiv_file,fiw_file,",#退料
                    " WHERE fiw01 = fiv01 ",
                    "   AND fiv02 = '",g_fil01,"'",
                    "   AND fiw09 = 'Y' AND fivpost = 'Y' ",
                    "   AND fiw03 = '",g_fiw[l_ac].fiw03,"'",
                    "   AND fiv00 = '2' "
        PREPARE p102_pre_2 FROM g_sql #prepare it
        DECLARE p102_fiw_2 CURSOR FOR p102_pre_2
        FOREACH p102_fiw_2 INTO l_fiw07,l_fiw08_2,l_fiw11
            LET l_fac = 1
            CALL s_umfchk(g_fiw[l_ac].fiw03,l_fiw07,l_ima25)
                 RETURNING g_cnt,l_fac
            IF g_cnt=1 THEN
               CALL cl_err('','abm-731',0)
               LET l_fac = 1
            END IF
            IF cl_null(l_fiw08_2) THEN LET l_fiw08_2 = 0 END IF
            IF cl_null(l_fiw11) THEN LET l_fiw11 = 0 END IF
            LET l_fiw08_2 = l_fiw08_2 * l_fac
            LET l_fiw08 = l_fiw08 - l_fiw08_2
            LET l_a = l_a - l_fiw11
        END FOREACH
        LET g_fiw[l_ac].qty = l_fiw08
        LET g_fiw[l_ac].a = l_a
        LET g_fiw[l_ac].b = l_a
        LET l_ac = l_ac + 1
        #-----TQC-630104---------
        #IF l_ac > g_max_rec THEN EXIT FOREACH END IF   
        IF l_ac > g_max_rec THEN 
           CALL cl_err('',9035,0)
           EXIT FOREACH 
        END IF   
        #-----END TQC-630104-----
    END FOREACH
    LET g_rec_b=l_ac-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    RETURN g_rec_b
END FUNCTION
 
FUNCTION p102_array()
    DEFINE
          l_ac    LIKE type_file.num5,           #No.FUN-680072 SMALLINT
          j       LIKE type_file.num5,           #No.FUN-680072 SMALLINT
          l_allow_delete  LIKE type_file.num5    #可刪除否        #No.FUN-680072 SMALLINT
 
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_fiw WITHOUT DEFAULTS FROM s_fiw.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=l_allow_delete,APPEND ROW=FALSE)
        BEFORE ROW
            LET l_ac = ARR_CURR()
 
        AFTER FIELD b
            IF NOT cl_null(g_fiw[l_ac].b) THEN
               IF g_fiw[l_ac].b > g_fiw[l_ac].a THEN
                  CALL cl_err(g_fiw[l_ac].b,'aem-026',0)
                  LET g_fiw[l_ac].b = g_fiw[l_ac].a
                  NEXT FIELD b
               END IF
            END IF
            CALL p102_b_tot()
 
       BEFORE DELETE
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           LET g_rec_b=g_rec_b-1
           DISPLAY g_rec_b TO FORMONLY.cn2
           MESSAGE "Delete Ok"
 
       AFTER DELETE
           CALL p102_b_tot()
 
       ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
           CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
    END INPUT
    IF INT_FLAG THEN 
       LET INT_FLAG = 0
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
       EXIT PROGRAM
    END IF
END FUNCTION
 
FUNCTION p102_bp(p_ud)
 
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_fiw TO s_fiw.* ATTRIBUTE(COUNT=g_rec_b)
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION confirm
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY
 
        ON ACTION accept
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY
 
        ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice="exit"
           EXIT DISPLAY
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION exit
           LET g_action_choice="exit"
           RETURN
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION  p102_gen()
DEFINE  l_faj33   LIKE faj_file.faj33,
        l_faj30   LIKE faj_file.faj30,
        l_faj31   LIKE faj_file.faj31,
        l_faj68   LIKE faj_file.faj68,
        l_faj65   LIKE faj_file.faj65,
        l_faj66   LIKE faj_file.faj66,
        l_faz02   LIKE faz_file.faz02,
        li_result LIKE type_file.num5,     #No.FUN560014        #No.FUN-680072 SMALLINT
        l_n       LIKE type_file.chr1,     #No.FUN-680072CHAR(1)
        g_i       LIKE type_file.num10,    #No.FUN-680072INTEGER
        i         LIKE type_file.num10     #No.FUN-680072INTEGER
DEFINE  l_faj332  LIKE faj_file.faj332,   #No:FUN-AB0088
        l_faj302  LIKE faj_file.faj302,   #No:FUN-AB0088
        l_faj312  LIKE faj_file.faj312    #No:FUN-AB0088
 
#No.FUN-560014--begin
   CALL s_auto_assign_no("afa",g_fay01,g_today,"7","fay_file","fay01","","","")
   RETURNING li_result,g_fay01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
    DISPLAY g_fay01 TO FORMONLY.o  #MOD-560238 
 
#  CALL s_afaauno(g_fay01,g_today) RETURNING g_i,g_fay01
#  IF g_i THEN LET g_success='N' RETURN END IF	#有問題
#No.FUN-560014--end   
 
   INSERT INTO fay_file(fay01,fay02,fay03,fayconf,faypost,faypost2,
                        fayuser,faygrup,faydate,
                        faylegal,fayoriu,fayorig) #FUN-980002
                 VALUES(g_fay01,g_today,g_fil03,'N','N','N',
                        g_user,g_grup,g_today,
                        g_legal, g_user, g_grup) #FUN-980002      #No.FUN-980030 10/01/04  insert columns oriu, orig
   IF SQLCA.sqlcode THEN
#     CALL cl_err('insert fay_file',SQLCA.sqlcode,0)   #No.FUN-660092
      CALL cl_err3("ins","fay_file",g_fay01,"",SQLCA.sqlcode,"","insert fay_file",0)   #No.FUN-660092
      LET g_success='N'
      RETURN
   END IF
   LET g_sql = "SELECT faj33,faj30,faj31,faj68,faj65,faj66 ",
               "       faj332,faj302,faj312 ",   #No:FUN-AB0088
               "  FROM faj_file ",
               " WHERE faj02 = '",g_fia011,"'",
               "   AND faj022 = '",g_fia012,"'"
   PREPARE p102_pre FROM g_sql #prepare it
   DECLARE p102_faj CURSOR FOR p102_pre
   OPEN p102_faj
   FETCH p102_faj INTO l_faj33,l_faj30,l_faj31,l_faj68,l_faj65,l_faj66,l_faj332,l_faj302,l_faj312  #No:FUN-AB0088
   IF SQLCA.sqlcode THEN
      CALL cl_err('fetch p102_faj',SQLCA.sqlcode,0)
      LET g_success='N'
      RETURN
   END IF
   SELECT max(faz02)+1 INTO l_faz02
    FROM faz_file
   WHERE faz01 = g_fay01
   IF l_faz02 IS NULL THEN
      LET l_faz02 = 1
   END IF
   INSERT INTO faz_file(faz01,faz02,faz03,faz031,faz04,faz05,faz06,faz08,
                        faz09,faz10,faz13,faz14,faz15,faz17,faz18,faz19,
                        faz042,faz052,faz062,faz082,faz092,faz102,fazlegal) #FUN-980002  #No:FUN-AB0088
                VALUES(g_fay01,l_faz02,g_fia011,g_fia012,l_faj33,l_faj30,
                       l_faj31,l_tot,l_faj30,l_faj31,l_faj68,l_faj65,
                       l_faj66,l_tot,l_faj65,l_faj66,
                       l_faj33,l_faj30,l_faj31,l_tot,l_faj30,l_faj31,         #No:FUN-AB0088
                       g_legal) #FUN-980002
   IF SQLCA.sqlcode THEN
      LET g_success='N'
#     CALL cl_err('insert faz_file',SQLCA.sqlcode,0)   #No.FUN-660092
      CALL cl_err3("ins","faz_file",g_fay01,l_faz02,SQLCA.sqlcode,"","insert faz_file",0)   #No.FUN-660092
      RETURN
   END IF
{  UPDATE fil_file SET fil05 = '4'
   WHERE fil01 = g_fil01
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL cl_err('update fil_file',SQLCA.sqlcode,0)
   END IF
}
END FUNCTION
 
FUNCTION p102_b_tot()
 DEFINE j       LIKE type_file.num10     #No.FUN-680072INTEGER
 
   LET l_tot = 0
   FOR j=1 TO g_rec_b
       IF NOT cl_null(g_fiw[j].b) THEN
          LET l_tot = l_tot + g_fiw[j].b
       END IF
   END FOR
 
   IF l_tot IS NULL THEN LET l_tot =0 END IF
   DISPLAY l_tot TO FORMONLY.c
END FUNCTION
