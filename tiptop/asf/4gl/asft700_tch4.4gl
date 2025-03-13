# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: asft700_tch4.4gl
# Descriptions...: 製程移轉品質回報作業 (screen04)
# Date & Author..: 99/09/15 By Lilan
# Modify.........: No.FUN-B30216 11/03/30
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正

DATABASE ds

#FUN-B30216

GLOBALS "../../config/top.global"

DEFINE g_argv1               STRING,                      #暫存資料表(table name)
       g_argv2               LIKE shb_file.shb05,         #工單單號
       g_argv3               LIKE shb_file.shb07,         #工作站
       g_argv4               LIKE shb_file.shb06,         #製程序
       g_argv5               LIKE shb_file.shb112,        #當站報廢數量
       g_shb                 RECORD LIKE shb_file.*,
       g_shc                 RECORD LIKE shc_file.*,
       g_rec_b1              LIKE type_file.num5,         #SMALLINT
       g_rec_b2              LIKE type_file.num5,         #SMALLINT
       g_rec_b3              LIKE type_file.num5,         #SMALLINT
       l_ac1,l_ac2,l_ac3     LIKE type_file.num5,         #目前處理的ARRAY CNT   #SMALLINT           LIKE type_file.num5      #目前處理的ARRAY CNT        #SMALLINT           LIKE type_file.num5      #目前處理的ARRAY CNT        #SMALLINT
       g_cnt                 LIKE type_file.num10,
       g_sql                 STRING,
       l_table_shc           STRING,
       p_row,p_col           LIKE type_file.num5          
DEFINE g_shc01               LIKE shc_file.shc01,         #移轉單號
       g_shcacti             LIKE shc_file.shcacti,
       g_shcuser             LIKE shc_file.shcuser,
       g_shcgrup             LIKE shc_file.shcgrup,
       g_shcmodu             LIKE shc_file.shcmodu,
       g_shcdate             LIKE shc_file.shcdate,
       g_sum_shc05           LIKE shc_file.shc05
DEFINE g_shc_1 DYNAMIC ARRAY OF RECORD
             shc03_1         LIKE shc_file.shc03,
             shc04_1         LIKE shc_file.shc04,
             qce03_1         LIKE qce_file.qce03,
             shc05_1         LIKE shc_file.shc05,
             shc06_1         LIKE shc_file.shc06,
             ecm04_1         LIKE ecm_file.ecm04 
       END RECORD,
       g_qce DYNAMIC ARRAY OF RECORD
             qce01           LIKE qce_file.qce01,
             qce03           LIKE qce_file.qce03
       END RECORD,
       g_ecm DYNAMIC ARRAY OF RECORD
             ecm03_2         LIKE ecm_file.ecm03,
             ecm04_2         LIKE ecm_file.ecm04,
             ecm45_2         LIKE ecm_file.ecm45
       END RECORD
DEFINE g_flag                INTEGER                      #是否第一次按數字鍵,0/1
DEFINE g_flag2               INTEGER                      #紀錄由何處呼叫chkdata


MAIN
    DEFINE l_time      LIKE type_file.chr8    #VARCHAR(8)
    DEFINE l_combo     STRING                 

    OPTIONS
       #FORM LINE     FIRST + 2,
       #MESSAGE LINE  LAST,
       #PROMPT LINE   LAST,
        INPUT NO WRAP
    DEFER INTERRUPT

    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
    END IF

    LET g_argv1 = ARG_VAL(1)   
    LET g_argv2 = ARG_VAL(2)    #工單單號
    LET g_argv3 = ARG_VAL(3)    #工作站
    LET g_argv4 = ARG_VAL(4)    #製程序
    LET g_argv5 = ARG_VAL(5)    #當站報廢數量

   #LET g_argv1 = 'shc152405'
   #LET g_argv2 = '511-10090001'
   #LET g_argv3 = '1961_W01'
   #LET g_argv4 = '1'
   #LET g_argv5 = 0 

   # CALL cl_used(g_prog,l_time,1) RETURNING l_time          #FUN-B80086   MARK
    CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80086   ADD

    INITIALIZE g_shb.* TO NULL
    INITIALIZE g_shc.* TO NULL

    LET p_row = 1
    LET p_col = 10
    LET g_win_style = "touch-w1"   #yen

    OPEN WINDOW asft700_tch4_w AT p_row,p_col WITH FORM "asf/42f/asft700_tch4"
                ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()
    CALL cl_set_act_visible("accept,cancel", FALSE)
    CALL cl_set_comp_visible("data_cancel", FALSE)
    CALL cl_set_comp_visible("gb_shc06,gb_shc05", FALSE)

    CALL t700_tch4_defdata()       #取得欄位初始值
    CALL t700_tch4_shc()           #取得暫存TB內的資料 
    CALL t700_tch4_i()             #主要執行段

    CLOSE WINDOW asft700_tch4_w
   # CALL cl_used(g_prog,l_time,2) RETURNING l_time
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
END MAIN


FUNCTION t700_tch4_i()
   DEFINE l_i,l_j,         
          l_arrlen        LIKE type_file.num5
   DEFINE li_result       LIKE type_file.num5  
   DEFINE l_cnt           LIKE type_file.num10
   DEFINE l_tcharr        STRING               #是否為UPDATE單身資料
   DEFINE l_cmd           STRING 
   DEFINE l_qce03         LIKE qce_file.qce03,
          l_ecm04         LIKE ecm_file.ecm04

   LET g_shc.shc05 = 0
   LET l_tcharr = 'N'

   DISPLAY BY NAME g_shb.shb05,g_shb.shb07 

   DIALOG ATTRIBUTES(UNBUFFERED)
        INPUT BY NAME g_shc.shc04,g_shc.shc06,g_shc.shc05 
                      ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
        
           BEFORE FIELD shc04
              CALL t700_tch4_qce()
              CALL cl_set_comp_visible("gb_shc04", TRUE)
              CALL cl_set_comp_visible("gb_shc06,gb_shc05", FALSE)
        
           AFTER FIELD shc04
              IF NOT cl_null(g_shc.shc04) THEN
                 CALL t700_tch4_shc04()
                 IF NOT cl_null(g_errno)   THEN
                    CALL cl_err('sel qce:',g_errno,0) 
                    NEXT FIELD shc04
                 END IF
              ELSE 
                 DISPLAY NULL TO FORMONLY.qce03_2
              END IF

           BEFORE FIELD shc06
              CALL t700_tch4_ecm()
              CALL cl_set_comp_visible("gb_shc06", TRUE)
              CALL cl_set_comp_visible("gb_shc04,gb_shc05", FALSE)

           AFTER FIELD shc06 
              IF NOT cl_null(g_shc.shc06) THEN
                 CALL t700_tch4_shc06()
                 IF NOT cl_null(g_errno)   THEN
                    CALL cl_err('sel ecm:',g_errno,0)        
                    NEXT FIELD shc06
                 END IF 
              ELSE           
                 DISPLAY NULL TO FORMONLY.ecm04
              END IF  
        
           BEFORE FIELD shc05  
              CALL cl_set_comp_visible("gb_shc05", TRUE)
              CALL cl_set_comp_visible("gb_shc04,gb_shc06", FALSE)
              LET g_flag = 1    
              LET g_flag2 = 1   
              CALL touch_count(g_shc.shc05) RETURNING li_result,g_shc.shc05
              DISPLAY BY NAME g_shc.shc05
        END INPUT

        DISPLAY ARRAY g_shc_1 TO s_shc.* ATTRIBUTE(COUNT=g_rec_b1)
           BEFORE ROW
              LET l_tcharr = 'Y'               
              LET l_ac1 = ARR_CURR()
              LET g_shc.shc04 = g_shc_1[l_ac1].shc04_1
              LET l_qce03 = g_shc_1[l_ac1].qce03_1
              LET g_shc.shc06 = g_shc_1[l_ac1].shc06_1
              LET l_ecm04 = g_shc_1[l_ac1].ecm04_1
              LET g_shc.shc05 = g_shc_1[l_ac1].shc05_1              

              DISPLAY BY NAME g_shc.shc04,g_shc.shc06,g_shc.shc05
              DISPLAY l_qce03 TO FORMONLY.qce03_2
              DISPLAY l_ecm04 TO FORMONLY.ecm04
              DISPLAY g_shc_1[l_ac1].shc03_1 TO FORMONLY.shc03
        END DISPLAY

        DISPLAY ARRAY g_qce TO s_qce.* ATTRIBUTE(COUNT=g_rec_b2)
           BEFORE ROW
              LET l_ac2 = ARR_CURR()
              LET g_shc.shc04 = g_qce[l_ac2].qce01
              LET l_qce03 = g_qce[l_ac2].qce03 
              DISPLAY BY NAME g_shc.shc04
              DISPLAY l_qce03 TO FORMONLY.qce03_2
        END DISPLAY

        DISPLAY ARRAY g_ecm TO s_ecm.* ATTRIBUTE(COUNT=g_rec_b3)
           BEFORE ROW
              LET l_ac3 = ARR_CURR()
              LET g_shc.shc06 = g_ecm[l_ac3].ecm03_2
              LET l_ecm04 = g_ecm[l_ac3].ecm04_2
              DISPLAY BY NAME g_shc.shc06
              DISPLAY l_ecm04 TO FORMONLY.ecm04
        END DISPLAY

        #確定 = 新增/修改單身資料
        ON ACTION data_ok
           IF t700_tch4_chkdata() THEN
              IF l_tcharr = 'Y' THEN
                 CALL t700_tch4_updarr()
                 LET l_tcharr = 'N'
              ELSE
                 CALL g_shc_1.appendElement()
                 CALL t700_tch4_insarr()
              END IF
           ELSE
              CASE 
                WHEN g_errno = 'shc04'
                  NEXT FIELD shc04
                WHEN g_errno = 'shc06'
                  NEXT FIELD shc06
                WHEN g_errno = 'shc05'
                  NEXT FIELD shc05                
              END CASE
           END IF

        #放棄 = 刪除全部單身資料
        ON ACTION data_cancel
           IF cl_confirm('axm_106') THEN
              CALL g_shc_1.clear()
           END IF

        #刪除一筆單身
        ON ACTION data_delete
           LET l_arrlen = g_shc_1.getLength()            #記錄陣列筆數
           IF l_arrlen > 0 THEN
              IF cl_confirm('lib-001') THEN
                 CALL g_shc_1.deleteElement(l_ac1)
              
                 #刪除該筆單身資料後,若還有單身資料(>=一筆),
                 #則行序(shc03)需重新給值
                 LET l_j = g_shc_1.getLength()
                 IF l_j > 0 THEN
                   FOR l_i = 1 to l_j
                      LET g_shc_1[l_i].shc03_1 = l_i
                   END FOR
                 END IF
              END IF
              IF (l_arrlen = l_ac1) THEN                #判斷刪除的資料是不是最後一筆
                 LET l_ac1 = l_ac1 - 1
              END IF
           END IF


        #回報工 = 若單身有資料則寫入資料庫
        ON ACTION return_report
           LET l_j = g_shc_1.getLength()
           IF t700_tch4_insdata() AND l_j > 0 THEN
              IF NOT g_sum_shc05 = g_shb.shb112 THEN
                 CALL cl_err('','asf-710',1)
              END IF
           END IF
           EXIT DIALOG

        ON ACTION close
           EXIT DIALOG
   END DIALOG
END FUNCTION

#取得欄位初始值
FUNCTION t700_tch4_defdata()
    LET g_shb.shb05 = g_argv2
    LET g_shb.shb07 = g_argv3
    LET g_shb.shb06 = g_argv4
    LET g_shb.shb112= g_argv5
    LET g_shb.shb08 = 'WK-1'           #QQWW

    LET g_shc01 = ' '              #移轉單號               
    LET g_shcacti = "Y"
    LET g_shcuser = g_user
    LET g_shcgrup = g_grup
    LET g_shcmodu = ''
    LET g_shcdate = ''

    LET l_table_shc = g_argv1
END FUNCTION

#檢查單頭欄位資料
FUNCTION t700_tch4_chkdata()
    LET g_errno = ' ' 

    IF cl_null(g_shc.shc04) THEN
       LET g_errno = 'shc04'
       CALL cl_err('','aap-099',1)
       RETURN FALSE
    END IF

    IF cl_null(g_shc.shc06) THEN
       LET g_errno = 'shc06'
       CALL cl_err('','aap-099',1)
       RETURN FALSE
    END IF
 
    IF cl_null(g_shc.shc05) THEN
       LET g_errno = 'shc05'
       CALL cl_err('','aap-022',1)
       RETURN FALSE
    END IF

    RETURN TRUE
END FUNCTION

#將單頭資料寫入單身ARRAY
FUNCTION t700_tch4_insarr()
    DEFINE l_i      LIKE type_file.num5
    DEFINE l_qce03  LIKE qce_file.qce03
    DEFINE l_ecm04  LIKE ecm_file.ecm04

    SELECT qce03 INTO l_qce03
      FROM qce_file
     WHERE qce01 = g_shc.shc04
    
    SELECT ecm04 INTO l_ecm04
      FROM ecm_file
     WHERE ecm01 = g_shb.shb05
       AND ecm03 = g_shc.shc06

    LET l_i = g_shc_1.getLength()
    LET g_shc_1[l_i].shc03_1 = l_i
    LET g_shc_1[l_i].shc04_1 = g_shc.shc04
    LET g_shc_1[l_i].qce03_1 = l_qce03
    LET g_shc_1[l_i].shc05_1 = g_shc.shc05
    LET g_shc_1[l_i].shc06_1 = g_shc.shc06
    LET g_shc_1[l_i].ecm04_1 = l_ecm04
END FUNCTION

#將單頭資料更新單身ARRAY
FUNCTION t700_tch4_updarr()
    DEFINE l_qce03  LIKE qce_file.qce03
    DEFINE l_ecm04  LIKE ecm_file.ecm04

    SELECT qce03 INTO l_qce03
      FROM qce_file
     WHERE qce01 = g_shc.shc04

    SELECT ecm04 INTO l_ecm04
      FROM ecm_file
     WHERE ecm01 = g_shb.shb05
       AND ecm03 = g_shc.shc06

    LET g_shc_1[l_ac1].shc04_1 = g_shc.shc04
    LET g_shc_1[l_ac1].qce03_1 = l_qce03
    LET g_shc_1[l_ac1].shc05_1 = g_shc.shc05
    LET g_shc_1[l_ac1].shc06_1 = g_shc.shc06
    LET g_shc_1[l_ac1].ecm04_1 = l_ecm04
    DISPLAY NULL TO FORMONLY.shc03
END FUNCTION


#將單身資料寫入到暫存資料庫
FUNCTION t700_tch4_insdata()
    DEFINE l_i,l_j      LIKE type_file.num5

    LET l_j = g_shc_1.getLength()
    LET g_success = 'Y'
    LET g_sum_shc05 = 0

    BEGIN WORK

    #先刪除暫存資料表內所有單身 
    LET g_sql = "DELETE FROM ",l_table_shc CLIPPED
    PREPARE del_pre FROM g_sql
    EXECUTE del_pre
    
    #2.再將陣列(g_shc_1s)內的資料寫入
    LET g_sql = "INSERT INTO ",l_table_shc,"(shc01,shc03,shc04,shc05,shc06,",
                "            shcacti,shcuser,shcgrup,shcmodu,shcdate)",
                "            VALUES(?,?,?,?,?,?,?,?,?,?)"
    PREPARE ins_pre FROM g_sql
    DECLARE inc_csr CURSOR FOR ins_pre
    OPEN inc_csr
    FOR l_i = 1 to l_j
        LET g_sum_shc05 = g_sum_shc05 + g_shc_1[l_i].shc05_1
        PUT inc_csr FROM g_shc01,g_shc_1[l_i].shc03_1,g_shc_1[l_i].shc04_1,
                         g_shc_1[l_i].shc05_1,g_shc_1[l_i].shc06_1,
                         g_shcacti,g_shcuser,g_shcgrup,g_shcmodu,g_shcdate
    END FOR

    FLUSH inc_csr
    IF SQLCA.sqlcode THEN
       CALL cl_err('t700_tch4_insdata:',SQLCA.sqlcode,0)
       LET g_success = 'N'
    END IF
    CLOSE inc_csr

    IF g_success = 'Y' THEN
       COMMIT WORK
       RETURN TRUE
    ELSE
       ROLLBACK WORK
       RETURN FALSE
    END IF
END FUNCTION

FUNCTION t700_tch4_shc04()
   DEFINE l_qce03    LIKE qce_file.qce03,
          l_qceacti  LIKE qce_file.qceacti

   LET g_errno = ' '
   SELECT qce03,qceacti INTO l_qce03,l_qceacti
     FROM qce_file
    WHERE qce01 = g_shc.shc04
   CASE 
        WHEN SQLCA.SQLCODE = 100  
            LET g_errno = 'aqc-023'
        WHEN l_qceacti='N' 
            LET g_errno = '9028'
        OTHERWISE          
            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
  
   IF cl_null(g_errno) THEN
      DISPLAY l_qce03 TO FORMONLY.qce03_2
   ELSE
      DISPLAY NULL TO FORMONLY.qce03_2
   END IF      
END FUNCTION

FUNCTION t700_tch4_shc06()
   DEFINE l_ecm04    LIKE ecm_file.ecm04
  
   LET g_errno = ' '
   SELECT ecm04 INTO l_ecm04 
     FROM ecm_file
    WHERE ecm01 = g_shb.shb05 
      AND ecm03 = g_shc.shc06
   IF STATUS THEN
      LET g_errno = STATUS
      CALL cl_err('sel ecm',STATUS,0)
   END IF
   IF cl_null(g_errno) THEN
      DISPLAY l_ecm04 TO FORMONLY.ecm04
   ELSE
      DISPLAY NULL TO FORMONLY.ecm04
   END IF
END FUNCTION


FUNCTION t700_tch4_shc()
   LET g_sql = "SELECT shc03,shc04,qce03,shc05,shc06,ecm04 ",
               "  FROM ",l_table_shc,",qce_file,ecm_file",
               " WHERE shc04 = qce01",
               "   AND ecm01 = '",g_shb.shb05,"'",
               "   AND shc06 = ecm03",
               " ORDER BY shc03"
   PREPARE q700_g_shc_1_pre FROM g_sql
   DECLARE q700_g_shc_1_cs SCROLL CURSOR FOR q700_g_shc_1_pre           #SCROLL CURSOR

   CALL g_shc_1.clear()
   LET g_rec_b1 = 0
   LET g_cnt = 1

   FOREACH q700_g_shc_1_cs INTO g_shc_1[g_cnt].shc03_1,g_shc_1[g_cnt].shc04_1,
                                g_shc_1[g_cnt].qce03_1,g_shc_1[g_cnt].shc05_1,
                                g_shc_1[g_cnt].shc06_1,g_shc_1[g_cnt].ecm04_1
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_shc_1.deleteElement(g_cnt)   #刪去最後一行空白
END FUNCTION

FUNCTION t700_tch4_qce()
   LET g_sql = "SELECT qce01,qce03 ",
               "  FROM qce_file ",
               " WHERE qceacti = 'Y' "
   PREPARE q700_qce_pre FROM g_sql
   DECLARE q700_qce_cs SCROLL CURSOR FOR q700_qce_pre           #SCROLL CURSOR

   CALL g_qce.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1

   FOREACH q700_qce_cs INTO g_qce[g_cnt].qce01,g_qce[g_cnt].qce03
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_qce.deleteElement(g_cnt)   #刪去最後一行空白
END FUNCTION


FUNCTION t700_tch4_ecm()

   LET g_sql = "SELECT ecm03,ecm04,ecm45",
               "  FROM ecm_file ",
               " WHERE ecm01 = '",g_shb.shb05,"'"
   PREPARE q700_ecm_pre FROM g_sql
   DECLARE q700_ecm_cs SCROLL CURSOR FOR q700_ecm_pre           #SCROLL CURSOR

   CALL g_ecm.clear()
   LET g_rec_b3 = 0
   LET g_cnt = 1

   FOREACH q700_ecm_cs INTO g_ecm[g_cnt].ecm03_2,g_ecm[g_cnt].ecm04_2,g_ecm[g_cnt].ecm45_2
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_ecm.deleteElement(g_cnt)   #刪去最後一行空白
END FUNCTION


#產生畫面上的數字輸入按鈕
FUNCTION touch_count(ps_value)
   DEFINE   ps_value     STRING
   DEFINE   ps_value_o   STRING
   DEFINE   li_result    LIKE type_file.num5
   DEFINE   ls_result    STRING
   DEFINE   ls_touch     STRING
   DEFINE   lwin_curr    ui.Window
   DEFINE   lfrm_curr    ui.Form
   DEFINE   ls_ab        STRING    
   DEFINE   ls_tabname    STRING
   DEFINE   lnode_item    om.DomNode
   DEFINE   lnode_child   om.DomNode
   DEFINE   lnode_name    STRING
   DEFINE   ls_attribute  STRING   

   CALL FGL_DIALOG_GETFIELDNAME() RETURNING ls_touch
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()

   LET ls_tabname = cl_get_table_name(ls_touch CLIPPED)
   LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||ls_touch)
   LET lnode_child = lnode_item.getfirstchild()   #FormField裡面的Edit
   LET ls_attribute = lnode_child.getAttribute("style")

   CALL lfrm_curr.setFieldStyle(ls_touch,"touchfocus")
   
   LET ps_value_o = ps_value
   INPUT ps_value WITHOUT DEFAULTS FROM FORMONLY.count
      BEFORE FIELD count
         CALL FGL_DIALOG_SETCURSOR(ps_value.getLength()+1)

      AFTER INPUT
         LET ps_value = GET_FLDBUF(count)

      ON ACTION c1         
         CALL touch_count_compose(ps_value,"1") RETURNING ps_value
         DISPLAY ps_value TO FORMONLY.count
         CALL FGL_DIALOG_SETCURSOR(ps_value.getLength()+1)
      ON ACTION c2
         CALL touch_count_compose(ps_value,"2") RETURNING ps_value
         DISPLAY ps_value TO FORMONLY.count
         CALL FGL_DIALOG_SETCURSOR(ps_value.getLength()+1)
      ON ACTION c3
         CALL touch_count_compose(ps_value,"3") RETURNING ps_value
         DISPLAY ps_value TO FORMONLY.count
         CALL FGL_DIALOG_SETCURSOR(ps_value.getLength()+1)
      ON ACTION c4
         CALL touch_count_compose(ps_value,"4") RETURNING ps_value
         DISPLAY ps_value TO FORMONLY.count
         CALL FGL_DIALOG_SETCURSOR(ps_value.getLength()+1)
      ON ACTION c5
         CALL touch_count_compose(ps_value,"5") RETURNING ps_value
         DISPLAY ps_value TO FORMONLY.count
         CALL FGL_DIALOG_SETCURSOR(ps_value.getLength()+1)
      ON ACTION c6
         CALL touch_count_compose(ps_value,"6") RETURNING ps_value
         DISPLAY ps_value TO FORMONLY.count
         CALL FGL_DIALOG_SETCURSOR(ps_value.getLength()+1)
      ON ACTION c7
         CALL touch_count_compose(ps_value,"7") RETURNING ps_value
         DISPLAY ps_value TO FORMONLY.count
         CALL FGL_DIALOG_SETCURSOR(ps_value.getLength()+1)
      ON ACTION c8
         CALL touch_count_compose(ps_value,"8") RETURNING ps_value
         DISPLAY ps_value TO FORMONLY.count
         CALL FGL_DIALOG_SETCURSOR(ps_value.getLength()+1)
      ON ACTION c9
         CALL touch_count_compose(ps_value,"9") RETURNING ps_value
         DISPLAY ps_value TO FORMONLY.count
         CALL FGL_DIALOG_SETCURSOR(ps_value.getLength()+1)
      ON ACTION c0
         CALL touch_count_compose(ps_value,"0") RETURNING ps_value
         DISPLAY ps_value TO FORMONLY.count
         CALL FGL_DIALOG_SETCURSOR(ps_value.getLength()+1)
      ON ACTION cdot
         CALL touch_count_compose(ps_value,".") RETURNING ps_value
         DISPLAY ps_value TO FORMONLY.count
         CALL FGL_DIALOG_SETCURSOR(ps_value.getLength()+1)
      ON ACTION ce
         LET ps_value = ""
         DISPLAY ps_value TO FORMONLY.count
      ON ACTION enter
         LET ps_value = GET_FLDBUF(count)
         EXIT INPUT
   END INPUT
   IF INT_FLAG THEN
      LET ls_result = ps_value_o
      LET li_result = FALSE
   ELSE
      LET ls_result = ps_value
      LET li_result = TRUE
   END IF

   #CALL lfrm_curr.setFieldStyle(ls_touch,"touchnofocus")
   CALL lnode_child.setAttribute("style",ls_attribute)

   RETURN li_result,ls_result
END FUNCTION

FUNCTION touch_count_compose(ps_value,ps_add)
   DEFINE   ps_value   STRING
   DEFINE   ps_add     STRING
   DEFINE   li_cursor  LIKE type_file.num5

   IF g_flag THEN            #yen
      LET ps_value = ps_add
      LET g_flag = 0
   END IF
   IF ps_add = "." AND ps_value.getIndexOf(".",1) THEN
   ELSE
      CALL FGL_DIALOG_GETCURSOR() RETURNING li_cursor
      CASE li_cursor
         WHEN li_cursor = 0
            LET ps_value = ps_value
         WHEN li_cursor = 1
            LET ps_value = ps_add,ps_value
         WHEN li_cursor = ps_value.getLength()+1
            LET ps_value = ps_value,ps_add
         OTHERWISE
            LET ps_value = ps_value.subString(1,li_cursor-1),ps_add,ps_value.subString(li_cursor,ps_value.getLength())
      END CASE
   END IF

   RETURN ps_value
END FUNCTION


