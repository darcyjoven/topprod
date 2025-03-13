# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: aemi001.4gl
# Descriptions...: 設備類型維護作業
# Date & Author..: 12/08/23  by suncx
# Modify.........: No:CHI-C80061 12/08/23 BY suncx 新增
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_trw           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
        trw01       LIKE trw_file.trw01,
        trw02       LIKE trw_file.trw02,
        trwacti     LIKE trw_file.trwacti
                    END RECORD,
    g_trw_t         RECORD                  #程式變數 (舊值)
        trw01       LIKE trw_file.trw01,
        trw02       LIKE trw_file.trw02,
        trwacti     LIKE trw_file.trwacti
                    END RECORD,
    g_wc2,g_sql     STRING,   
    g_rec_b         LIKE type_file.num5,    #單身筆數
    l_ac            LIKE type_file.num5,    #目前處理的ARRAY CNT
    p_row,p_col     LIKE type_file.num5     #SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5     #SMALLINT

DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt      LIKE type_file.num10    #INTEGER    
DEFINE   g_i        LIKE type_file.num5     #SMALLINT  #count/index for any purpose
MAIN

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AEM")) THEN
      EXIT PROGRAM
   END IF


      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
         RETURNING g_time    
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW i001_w AT p_row,p_col WITH FORM "aem/42f/aemi001"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()

    LET g_wc2 = '1=1' CALL i001_b_fill(g_wc2)
    CALL i001_menu()
    CLOSE WINDOW i001_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)      #計算使用時間 (退出使間) 
         RETURNING g_time    
END MAIN


FUNCTION i001_menu()
DEFINE l_cmd  LIKE type_file.chr1000             
   WHILE TRUE
      CALL i001_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i001_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_rec_b= 0 THEN
                  CALL g_trw.deleteElement(1)
               END IF
               CALL i001_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i001_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION i001_q()
   CALL i001_b_askkey()
END FUNCTION

FUNCTION i001_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,    #檢查重複用
    l_ltrw_sw       LIKE type_file.chr1,    #單身鎖住否
    p_cmd           LIKE type_file.chr1,    #處理狀態
    l_allow_insert  LIKE type_file.num5,    #可新增否
    l_allow_delete  LIKE type_file.num5     #可刪除否

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT trw01,trw02,trwacti FROM trw_file WHERE trw01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")

        INPUT ARRAY g_trw WITHOUT DEFAULTS FROM s_trw.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_ltrw_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()

            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_trw_t.* = g_trw[l_ac].*  #BACKUP
               LET  g_before_input_done = FALSE
               CALL i001_set_entry(p_cmd)
               CALL i001_set_no_entry(p_cmd)
               LET  g_before_input_done = TRUE

               BEGIN WORK

               OPEN i001_bcl USING g_trw_t.trw01
               IF STATUS THEN
                  CALL cl_err("OPEN i001_bcl:", STATUS, 1)
                  LET l_ltrw_sw = "Y"
               ELSE
                  FETCH i001_bcl INTO g_trw[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_trw_t.trw01,SQLCA.sqlcode,1)
                     LET l_ltrw_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()    
            END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET  g_before_input_done = FALSE
            CALL i001_set_entry(p_cmd)
            CALL i001_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            INITIALIZE g_trw[l_ac].* TO NULL      #900423
            LET g_trw_t.* = g_trw[l_ac].*         #新輸入資料
            LET g_trw[l_ac].trwacti='Y'
            CALL cl_show_fld_cont()     
            NEXT FIELD trw01


        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO trw_file(trw01,trw02,trwacti)
                          VALUES(g_trw[l_ac].trw01,g_trw[l_ac].trw02,
                                 g_trw[l_ac].trwacti)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","trw_file",g_trw[l_ac].trw01,"",
                             SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 


        AFTER FIELD trw01                        #check 編號是否重複
            IF NOT cl_null(g_trw[l_ac].trw01) THEN
               IF g_trw[l_ac].trw01 != g_trw_t.trw01 OR
                  g_trw_t.trw01 IS NULL THEN

                   SELECT count(*) INTO l_n FROM trw_file
                       WHERE trw01 = g_trw[l_ac].trw01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_trw[l_ac].trw01 = g_trw_t.trw01
                       NEXT FIELD trw01
                   END IF
               END IF
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_trw_t.trw01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
 
                IF l_ltrw_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM trw_file
                      WHERE trw01 = g_trw_t.trw01
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","trw_file",g_trw_t.trw01,"",
                                 SQLCA.sqlcode,"","",1)  
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_trw[l_ac].* = g_trw_t.*
               CLOSE i001_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_ltrw_sw = 'Y' THEN
               CALL cl_err(g_trw[l_ac].trw01,-263,1)
               LET g_trw[l_ac].* = g_trw_t.*
            ELSE
               UPDATE trw_file SET
                      trw01  = g_trw[l_ac].trw01,
                      trw02  = g_trw[l_ac].trw02,
                      trwacti  = g_trw[l_ac].trwacti
                WHERE trw01 = g_trw_t.trw01
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","trw_file",g_trw[l_ac].trw01,"",
                                 SQLCA.sqlcode,"","",1) 
                   LET g_trw[l_ac].* = g_trw_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_trw[l_ac].* = g_trw_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_trw.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i001_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i001_bcl
            COMMIT WORK

        ON ACTION CONTROLN
            CALL i001_b_askkey()
            EXIT INPUT

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(trw01) AND l_ac > 1 THEN
                LET g_trw[l_ac].* = g_trw[l_ac-1].*
                NEXT FIELD trw01
            END IF

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF
            CASE
                WHEN INFIELD(trw01) CALL cl_fldhlp('trw01')
                WHEN INFIELD(trw02) CALL cl_fldhlp('trw02')
                WHEN INFIELD(trwacti) CALL cl_fldhlp('trwacti')
                OTHERWISE          CALL cl_fldhlp('    ')
            END CASE
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()   
 
      ON ACTION help         
         CALL cl_show_help() 
 
 
        END INPUT

    CLOSE i001_bcl
    COMMIT WORK
    OPTIONS
        INSERT KEY F1,
        DELETE KEY F2
END FUNCTION

FUNCTION i001_b_askkey()
    CLEAR FORM
    CALL g_trw.clear()
    CONSTRUCT g_wc2 ON trw01,trw02,trwacti
            FROM s_trw[1].trw01,s_trw[1].trw02,s_trw[1].trwacti
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about() 
 
      ON ACTION help         
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask() 
 
 
    END CONSTRUCT

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF

    CALL i001_b_fill(g_wc2)
END FUNCTION

FUNCTION i001_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           STRING  

    LET g_sql =
        "SELECT trw01,trw02,trwacti",
        " FROM trw_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY trw01"
    PREPARE i001_pb FROM g_sql
    DECLARE trw_curs CURSOR FOR i001_pb

    CALL g_trw.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH trw_curs INTO g_trw[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_trw.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION

FUNCTION i001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_trw TO s_trw.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()        

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
         CALL cl_show_fld_cont() 

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION CANCEL
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()   
 
      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i001_out()
   DEFINE l_cmd  LIKE type_file.chr1000                                                                          
                                                                                                                                    
    IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF                                                                    
    LET l_cmd = 'p_query "aemi001" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN      

END FUNCTION
 
FUNCTION i001_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1     
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("trw01",TRUE)
   END IF
END FUNCTION
 
 
FUNCTION i001_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("trw01",FALSE)
   END IF
END FUNCTION
 
#CHI-C80061 新增

