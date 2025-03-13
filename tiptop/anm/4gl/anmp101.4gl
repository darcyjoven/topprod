# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmp101.4gl
# Descriptions...: 網銀對帳碼設置作業 
# Date & Author..: #FUN-B50159 11/05/24 By lutingting 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_type       LIKE type_file.chr1,          #類型.1:企業帳;2:銀行帳
        g_nag        DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
           chk1      LIKE type_file.chr1,          # 對帳碼
           nag04     LIKE nag_file.nag04,          # 對帳方式
           nag03     LIKE nag_file.nag03,          # 企業賬/銀行帳流水號--隱藏
           nmu03     LIKE nmu_file.nmu03,          # 銀行帳號
           nag05     LIKE nag_file.nag05,          # 異動單號
           nag06     LIKE nag_file.nag06,          # 異動項次
           nme05     LIKE nme_file.nme05,          # 摘要
           nme16     LIKE nme_file.nme16,          # 異動日期
           dc1       LIKE nmu_file.nmu09,          # 借貸別
           nme08     LIKE nme_file.nme08           # 异动金額
                     END RECORD,
        l_ac         LIKE type_file.num5,
        g_wc         LIKE type_file.chr1000,      
        g_rec_b      LIKE type_file.num5,
        g_cnt        LIKE type_file.num10,
        l_flag       LIKE type_file.chr1,
        p_row,p_col  LIKE type_file.num5    
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   CALL p101_tm()				# 
   CLOSE WINDOW p101_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p101_tm()
 
   OPEN WINDOW p101_w AT p_row,p_col WITH FORM "anm/42f/anmp101" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("nag03",FALSE)
   CALL cl_opmsg('z')
   IF s_shut(0) THEN RETURN END IF
 
   WHILE TRUE
     CLEAR FORM 
     CALL g_nag.clear()
 
     LET g_type = NULL
     ERROR ''
     CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
     LET g_type = '1'
     DIALOG ATTRIBUTE(unbuffered)

        INPUT g_type FROM type ATTRIBUTE(WITHOUT DEFAULTS)
           AFTER FIELD type
              IF g_type<>'1' AND g_type<>'2' THEN
                 NEXT FIELD type
              END IF 
              IF g_type = '2' THEN
                 CALL cl_set_comp_visible("nag05,nag06,nme05",FALSE)
              ELSE
                 CALL cl_set_comp_visible("nag05,nag06,nme05",TRUE)
              END IF 
        END INPUT

        CONSTRUCT BY NAME g_wc ON nme01,nmu01
           BEFORE CONSTRUCT
             CALL cl_qbe_init()
        END CONSTRUCT

        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(nme01)    #銀行編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = 'q_nma1'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nme01
                  NEXT FIELD nme01
             OTHERWISE EXIT CASE
           END CASE
          
        ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
          EXIT DIALOG

        ON ACTION CONTROLR
          CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DIALOG

        ON ACTION about
           CALL cl_about()

        ON ACTION help
           CALL cl_show_help()

        ON ACTION exit
           LET INT_FLAG = 1
           EXIT DIALOG
        
        ON ACTION accept
           EXIT DIALOG

        ON ACTION cancel
           LET INT_FLAG=1
           EXIT DIALOG 
      END DIALOG
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF 

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW p101_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
    
      IF g_wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF 

     LET g_success='Y'
     BEGIN WORK 
     CALL p101_b_fill()
     IF g_success = 'N' THEN
        CONTINUE WHILE 
     END IF
     CALL  p101_sure()         #勾選對帳碼
     IF INT_FLAG THEN 
        LET INT_FLAG = 0 
        CONTINUE WHILE 
     END IF 
 
     IF cl_sure(0,0) THEN      #確定運行本作業
        CALL s_showmsg_init() 
        CALL p101_ins()        ###逻辑处理:INSERT nag_file,nah_file;UPDATE對帳碼
        CALL s_showmsg()
        IF g_success='Y' THEN
           COMMIT WORK
           CALL cl_end2(1) RETURNING l_flag    #批次作業正確結束
        ELSE
           ROLLBACK WORK
           CALL cl_end2(2) RETURNING l_flag    #批次作業失敗
        END IF
        IF l_flag THEN
           CONTINUE WHILE
        ELSE
           EXIT WHILE
        END IF
     END IF
 
   END WHILE
 
   ERROR ""
 
END FUNCTION
 
FUNCTION p101_b_fill()
DEFINE l_sql   LIKE type_file.chr1000
DEFINE l_cnt   LIKE type_file.num5 
DEFINE l_ze01  LIKE ze_file.ze01
DEFINE l_ze03  LIKE ze_file.ze03

  IF g_type = '1' THEN    #企業帳
     LET g_wc = cl_replace_str(g_wc,"nmu01","nme16")
     LET l_sql =
           "SELECT 'N','2',nme27,nme01,nme12,nme21,nme05,nme16,nmc03,nme08 ",
           "  FROM nme_file LEFT OUTER JOIN nag_file ",
           "                  ON nme12=nag05 AND nme21=nag06 AND nme27=nag03 AND nag01=nme01",
           "  ,nmc_file ",
           " WHERE nme03 = nmc01 ",
           "   AND (nme20 <>'Y' OR nme20 IS NULL)",
           "   AND ",g_wc CLIPPED,
           " ORDER BY nme16 "
  ELSE
     LET g_wc = cl_replace_str(g_wc,"nme01","nmu03")
     LET l_sql =
           "SELECT 'N','2',nmu23,nmu03,'','','',nmu01,nmu09,nmu10 ",
           "  FROM nmu_file LEFT OUTER JOIN nah_file ",
           "                  ON nmu23=nah03 AND nah01=nmu03",
           " WHERE (nmu24 <>'Y' OR nmu24 IS NULL)",
           "   AND ",g_wc CLIPPED,
           " ORDER BY nmu01 "
  END IF 
  PREPARE p101_prepare FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('cannot prepare ',SQLCA.sqlcode,1) 
     LET g_success = 'N'
     RETURN
  END IF
 
  DECLARE p101_cur CURSOR FOR p101_prepare
  IF SQLCA.sqlcode THEN 
     CALL cl_err('cannot declare ',SQLCA.sqlcode,1) 
     LET g_success = 'N'
     RETURN
  END IF
 
  LET l_ac = 1
  LET g_rec_b = 0
  LET l_cnt = 0 
  FOREACH p101_cur INTO g_nag[l_ac].*
    IF SQLCA.sqlcode THEN 
       CALL cl_err('cannot foreach ',SQLCA.sqlcode,1) 
       LET g_success = 'N'
       EXIT FOREACH
    END IF
 
    IF g_type = '1' THEN
       SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'anm-349' AND ze02 = g_lang
       CALL cl_set_combo_items('dc1','1,2',l_ze03)
    ELSE
       SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'anm-350' AND ze02 = g_lang
       CALL cl_set_combo_items('dc1','1,-1',l_ze03)
    END IF
    LET l_ac = l_ac + 1
    IF l_ac > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
    END IF
  END FOREACH
  CALL g_nag.deleteElement(l_ac)
 
 
  LET g_rec_b=l_ac - 1
 
 
  DISPLAY ARRAY g_nag TO s_nag.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
    BEFORE DISPLAY
      EXIT DISPLAY 
  END DISPLAY 
 
END FUNCTION
   
FUNCTION p101_sure()
    DEFINE l_cnt,l_i        LIKE type_file.num5  
    DEFINE l_ac             LIKE type_file.num5
 
    LET l_ac = 1
    INPUT ARRAY g_nag WITHOUT DEFAULTS FROM s_nag.*
       ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
 
       AFTER FIELD chk1
          IF NOT cl_null(g_nag[l_ac].chk1) THEN
             IF g_nag[l_ac].chk1 NOT MATCHES "[YN]" THEN
                NEXT FIELD chk1
             END IF
          END IF
 
       AFTER ROW
         IF INT_FLAG THEN 
            EXIT INPUT
         END IF 
       
       ON ACTION select_all
          FOR l_i = 1 TO g_rec_b     #將所有的設為選擇
              LET g_nag[l_i].chk1="Y"
          END FOR

       ON ACTION cancel_all
          FOR l_i = 1 TO g_rec_b      #將所有的設為取消
              LET g_nag[l_i].chk1="N"
          END FOR

       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about        
          CALL cl_about()    
 
       ON ACTION help        
          CALL cl_show_help()
 
       ON ACTION controls                     
          CALL cl_set_head_visible("","AUTO")  
 
    END INPUT
 
END FUNCTION

FUNCTION p101_ins()
DEFINE l_year     LIKE type_file.chr4
DEFINE l_month    LIKE type_file.chr4
DEFINE l_day      LIKE type_file.chr4
DEFINE l_dt       LIKE type_file.chr20
DEFINE l_date1    LIKE type_file.chr20
DEFINE l_time     LIKE type_file.chr20
DEFINE l_nag01    LIKE nag_file.nag01
DEFINE l_nah01    LIKE nah_file.nah01
DEFINE i          LIKE type_file.num5
DEFINE l_nag02    LIKE nag_file.nag02
DEFINE l_nah02    LIKE nah_file.nah02

    LET l_date1 = g_today
    LET l_year = YEAR(l_date1)USING '&&&&'
    LET l_month = MONTH(l_date1) USING '&&'
    LET l_day = DAY(l_date1) USING  '&&'
    IF g_type = '1' THEN     #企業帳
       LET l_time = TIME(CURRENT)
       LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                    l_time[1,2],l_time[4,5],l_time[7,8]
       SELECT MAX(nag01)+1 INTO l_nag01 FROM nag_file WHERE nag01[1,14]=l_dt
       IF cl_null(l_nag01) THEN LET l_nag01 = l_dt,'000001' END IF 
       FOR i = 1 TO g_rec_b
           IF g_nag[i].chk1 = 'N' THEN CONTINUE FOR END IF 
           #對帳流水號
           LET l_time = TIME(CURRENT)
           LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                        l_time[1,2],l_time[4,5],l_time[7,8]
           SELECT MAX(nag02) + 1 INTO l_nag02 FROM nag_file
            WHERE nag02[1,14] = l_dt
              AND nag01 = l_nag01
           IF cl_null(l_nag02) THEN
              LET l_nag02 = l_dt,'000001'
           END IF

           INSERT INTO nag_file(nag01,nag02,nag03,nag04,nag05,nag06,naglegal)
           VALUES(l_nag01,l_nag02,g_nag[i].nag03,
                  '2',g_nag[i].nag05,g_nag[i].nag06,g_legal)
           IF SQLCA.sqlcode THEN
              CALL s_errmsg('nag01 ',l_nag01,'ins nag',SQLCA.sqlcode,1)
              LET g_success = 'N'
           END IF
           UPDATE nme_file SET nme20 = 'Y'
            WHERE nme12 = g_nag[i].nag05
              AND nme21 = g_nag[i].nag06
              AND nme27 = g_nag[i].nag03
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              LET g_showmsg = g_nag[i].nag05,"/",g_nag[i].nag06
              CALL s_errmsg('nme12,nme21 ',g_showmsg,'upd nme',SQLCA.sqlcode,1)
              LET g_success = 'N'
           END IF
       END FOR
    ELSE
       LET l_time = TIME(CURRENT)
       LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                    l_time[1,2],l_time[4,5],l_time[7,8]
       SELECT MAX(nah01)+1 INTO l_nah01 FROM nah_file WHERE nah01[1,14]=l_dt
       IF cl_null(l_nah01) THEN LET l_nah01 = l_dt,'000001' END IF
       FOR i = 1 TO g_rec_b
           IF g_nag[i].chk1 = 'N' THEN CONTINUE FOR END IF
           #對帳流水號
           LET l_time = TIME(CURRENT)
           LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                        l_time[1,2],l_time[4,5],l_time[7,8]
           SELECT MAX(nah02) + 1 INTO l_nah02 FROM nah_file
            WHERE nah02[1,14] = l_dt
              AND nah01 = l_nah01
           IF cl_null(l_nah02) THEN
              LET l_nah02 = l_dt,'000001'
           END IF
           INSERT INTO nah_file(nah01,nah02,nah03,nah04,nahlegal)
           VALUES(l_nah01,l_nah02,g_nag[i].nag03,'2',g_legal)
           IF SQLCA.sqlcode THEN
              CALL s_errmsg('nah01 ',l_nah01,'ins nah',SQLCA.sqlcode,1)
              LET g_success = 'N'
           END IF
           UPDATE nmu_file SET nmu24 = 'Y'
            WHERE nmu23 = g_nag[i].nag03
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL s_errmsg('nmu24 ',g_nag[i].nag03,'upd nmu',SQLCA.sqlcode,1)
              LET g_success = 'N'
           END IF
       END FOR
    END IF
END FUNCTION
#FUN-B50159
