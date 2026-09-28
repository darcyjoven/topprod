# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: afap020.4gl
# Descriptions...: 固定資產族群資料開帳維護作業
# Date & Author..: 100/07/13 FUN-B70046 By Sakura 


DATABASE ds

GLOBALS "../../config/top.global"

DEFINE  g_wc      string,
        g_faj     DYNAMIC ARRAY OF RECORD
            faj01b   LIKE faj_file.faj01,    #序號
            faj02b   LIKE faj_file.faj02,    #資產編號
            faj022b  LIKE faj_file.faj022,   #附號                    
            faj06    LIKE faj_file.faj06,    #名稱
            faj93    LIKE faj_file.faj93     #族群編號
        END RECORD,
        g_rec_b      LIKE type_file.num5,
        g_cnt       LIKE type_file.num10,
        g_flag      LIKE type_file.chr1


MAIN
   DEFINE p_row,p_col	LIKE type_file.num5

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF

   LET p_row = 2 LET p_col = 19

   OPEN WINDOW p020_w AT p_row,p_col WITH FORM "afa/42f/afap020" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()

   CALL cl_opmsg('z')

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

    CALL p020_tm()
    ERROR ""

   CLOSE WINDOW p020_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN

FUNCTION p020_tm()
DEFINE l_no    LIKE type_file.num5
   WHILE TRUE
      LET g_action_choice = ""
      CLEAR FORM                #清空單頭畫面
      CALL g_faj.clear()        #清空單身畫面及資料
      ERROR ""
      
         CALL cl_set_head_visible("","YES")     #單頭區塊隱藏功能，配合畫面檔設定，
                                                #這裡預設單頭區塊開啟
         CONSTRUCT BY NAME g_wc ON faj01,faj02,faj022
            
            ON ACTION locale
               LET g_action_choice = 'locale'
               EXIT CONSTRUCT

            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
      
            ON ACTION about
               CALL cl_about()
           
            ON ACTION help
               CALL cl_show_help()
           
            ON ACTION controlg
               CALL cl_cmdask()

            ON ACTION exit
               LET INT_FLAG = 1
               EXIT CONSTRUCT

            ON ACTION CONTROLP
                CASE
                    WHEN INFIELD(faj02) #資產編號
                        CALL cl_init_qry_var()
                            LET g_qryparam.state = 'c'
                            LET g_qryparam.form = "q_faj"
                            LET g_qryparam.where = "faj93 IS NULL"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO faj02
                        NEXT FIELD faj02
                OTHERWISE EXIT CASE
            END CASE
         END CONSTRUCT
   
   IF g_action_choice = "locale" THEN  #genero
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE 
   END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      EXIT WHILE 
   END IF
   
   LET g_success = 'Y'
   CALL p020_b_fill()
   IF g_success = 'N' THEN 
      CONTINUE WHILE 
   END IF 
   
   CALL p020_sure()         #確定否
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CONTINUE WHILE 
   END IF 

   IF cl_sure(0,0) THEN 
      CALL cl_wait()
      
      LET g_success = 'Y'
      BEGIN WORK
      
      CALL s_showmsg_init()     #開始收集訊息初始值
      FOR l_no = 1 TO g_rec_b
          IF g_success='N' THEN
             LET g_totsuccess='N'
             LET g_success='Y'
          END IF

          IF NOT cl_null(g_faj[l_no].faj93) THEN
             UPDATE faj_file SET faj93 = g_faj[l_no].faj93
                WHERE faj01 = g_faj[l_no].faj01b 
                  AND faj02 = g_faj[l_no].faj02b
                  AND faj022 = g_faj[l_no].faj022b
        
             IF SQLCA.sqlcode THEN 
                LET g_success = 'N'
                CALL s_errmsg('faj02,faj022',g_faj[l_no].faj93,'update faj fail',SQLCA.sqlcode,1)
             END IF
          END IF
      END FOR

      IF g_totsuccess='N' THEN
         LET g_success='N'
      END IF
      CALL s_showmsg()
      IF g_success = 'Y' THEN 
         COMMIT WORK
         CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
      ELSE
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
      END IF

      IF g_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
   END IF
 END WHILE

END FUNCTION 

FUNCTION p020_b_fill()
    DEFINE l_sql 	LIKE type_file.chr1000

    LET l_sql = " SELECT faj01,faj02,faj022,faj06,faj93",
                "  FROM faj_file ",
                "  WHERE faj93 IS NULL ",
                "    AND ",g_wc CLIPPED

  PREPARE p020_prepare FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('cannot prepare ',SQLCA.sqlcode,1) 
     LET g_success = 'N'
     RETURN
  END IF
  DECLARE p020_cur CURSOR FOR p020_prepare
  IF SQLCA.sqlcode THEN 
     CALL cl_err('cannot declare ',SQLCA.sqlcode,1) 
     LET g_success = 'N'
     RETURN
  END IF
  
  LET g_cnt = 1
  LET g_rec_b = 0

  FOREACH p020_cur INTO g_faj[g_cnt].*
     IF SQLCA.sqlcode THEN 
        CALL cl_err('cannot foreach ',SQLCA.sqlcode,1) 
        LET g_success = 'N'
        EXIT FOREACH
     END IF
     
     LET g_cnt = g_cnt + 1
     IF g_cnt > g_max_rec THEN  #最大單身筆數限制
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
  END FOREACH
  
  CALL g_faj.deleteElement(g_cnt)

  LET g_rec_b=g_cnt - 1
  DISPLAY g_rec_b TO FORMONLY.cn2
  
  IF g_rec_b = 0 THEN     #單身無資料
     CALL cl_err('','aic-044',1)
     LET g_success = 'N'
     RETURN
  END IF

  DISPLAY ARRAY g_faj TO s_faj.* ATTRIBUTE(COUNT=g_rec_b)
     BEFORE DISPLAY
        EXIT DISPLAY
  END DISPLAY

END FUNCTION
   
FUNCTION p020_sure()
    DEFINE l_ac  LIKE type_file.num5,
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5


    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE 

    LET l_ac = 1
    INPUT ARRAY g_faj WITHOUT DEFAULTS FROM s_faj.*
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF

       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       AFTER ROW
         IF INT_FLAG THEN 
            EXIT INPUT
         END IF
   
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
#Patch....NO.FUN-B70046
