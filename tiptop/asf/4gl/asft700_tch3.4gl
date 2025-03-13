# Prog. Version..: '5.30.06-13.03.12(00003)'     #
# Pattern name...: asft700_tch3.4gl
# Descriptions...: 製程移轉資料維護 (screen03)
# Date & Author..: 99/07/05 By Lilan
# Modify.........: No.FUN-B30216 11/03/30
# Modify.........: No.FUN-A70095 11/06/10 By lixh1 INSERT INTO shb_file 之前檢查shbconf是否為NOT NULL
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正

DATABASE ds

#FUN-B30216

GLOBALS "../../config/top.global"

DEFINE g_argv1               LIKE shb_file.shb05,         #工單單號
       g_argv2               LIKE shb_file.shb07,         #工作站
       g_argv3               LIKE shb_file.shb06,         #製程序
       g_argv4               LIKE shb_file.shb04,         #員工編號     
       g_shb                 RECORD LIKE shb_file.*,
       g_ecm                 RECORD LIKE ecm_file.*,
       g_wip_qty             LIKE shb_file.shb111,
       g_msg                 LIKE ze_file.ze03,           #VARCHAR(1500)
       g_min_set             LIKE sfb_file.sfb08,
       g_cnt                 LIKE type_file.num10,
       g_sw                  LIKE type_file.chr1,
       p_row,p_col           LIKE type_file.num5          #SMALLINT
DEFINE g_re_dis_vne06        LIKE type_file.num20
DEFINE g_shb021 RECORD
                shb021_h     LIKE type_file.chr2,         #時
                shb021_m     LIKE type_file.chr2          #分
            END RECORD
DEFINE g_shb031 RECORD
                shb031_h     LIKE type_file.chr2,         #時
                shb031_m     LIKE type_file.chr2          #分
            END RECORD
DEFINE g_h1,g_h2,g_m1,g_m2   LIKE type_file.num5,
       g_sum_m1,g_sum_m2     LIKE type_file.num5
DEFINE g_flag                INTEGER                      #是否第一次按數字鍵,0/1
DEFINE g_flag2               INTEGER                      #紀錄由何處呼叫chkdata
DEFINE g_fieldstr            STRING                       #記錄是哪個欄位檢核發生錯誤
DEFINE l_table_shb,
       l_table_shc, 
       l_str,
       g_sql                 STRING

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

    LET g_argv1 = ARG_VAL(1)    #工單單號
    LET g_argv2 = ARG_VAL(2)    #工作站
    LET g_argv3 = ARG_VAL(3)    #製程序
    LET g_argv4 = ARG_VAL(4)    #員工編號

   #LET g_argv1 = '511-10090001'
   #LET g_argv2 = '1961_W02'
   #LET g_argv3 = '20'
   #LET g_argv4 = 'tiptop'

   # CALL cl_used(g_prog,l_time,1) RETURNING l_time          #FUN-880086   MARK
    CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80086   ADD

    INITIALIZE g_shb.* TO NULL

    LET p_row = 1
    LET p_col = 10
    LET g_win_style = "touch-w1"   #yen

    OPEN WINDOW asft700_tch3_w AT p_row,p_col WITH FORM "asf/42f/asft700_tch3"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()
    CALL cl_set_act_visible("accept,cancel", FALSE)
    CALL t700_tch3_defdata()                        #取得欄位初始值
    CALL crt_temptable()                            #CREATE暫存報工資料的TB

    #產生combobox內容 STR ------------------------
    CALL touch_timecombo(23) RETURNING l_combo            
    CALL cl_set_combo_items("shb021_h", l_combo, l_combo)    #時
    CALL cl_set_combo_items("shb031_h", l_combo, l_combo)    #時

    CALL touch_timecombo(59) RETURNING l_combo
    CALL cl_set_combo_items("shb021_m", l_combo, l_combo)    #分
    CALL cl_set_combo_items("shb031_m", l_combo, l_combo)    #分

    CALL shb12_combo(g_shb.shb05) RETURNING l_combo                      
    CALL cl_set_combo_items("shb12", l_combo, l_combo)       #下製程(shb12)
    #產生combobox內容 END ------------------------

    CALL t700_tch3_i()                              #主要程式段
    CALL drop_temptable()                           #DROP暫存報工資料的TB         

    CLOSE WINDOW asft700_tch3_w
   # CALL cl_used(g_prog,l_time,2) RETURNING l_time          #FUN-B80086   MARK
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
END MAIN


FUNCTION t700_tch3_i()
   DEFINE l_i             LIKE type_file.num5
   DEFINE l_j             LIKE type_file.num5
   DEFINE li_result       LIKE type_file.num5  
   DEFINE l_cnt           LIKE type_file.num10
   DEFINE l_shb111        LIKE shb_file.shb111
   DEFINE l_sgl08         LIKE sgl_file.sgl08
   DEFINE l_sgl08_min     LIKE sgl_file.sgl08
   DEFINE l_sgl09_max     LIKE sgl_file.sgl09
   DEFINE l_ima153        LIKE ima_file.ima153
   DEFINE l_sma126        LIKE sma_file.sma126
   DEFINE l_shb112        LIKE shb_file.shb112
   DEFINE l_combo         STRING
   DEFINE l_doc           STRING
   DEFINE l_cmd           STRING   

   DISPLAY BY NAME g_shb.shb05,g_shb.shb07 

   INPUT BY NAME g_shb.shb05,g_shb021.shb021_h,
                 g_shb021.shb021_m,g_shb031.shb031_h,g_shb031.shb031_m,  
                 g_shb.shb111,g_shb.shb115,g_shb.shb112,g_shb.shb113,
                 g_shb.shb12,g_shb.shb114,g_shb.shb17
                 WITHOUT DEFAULTS

        AFTER FIELD shb05    
           IF NOT cl_null(g_shb.shb05) THEN     
              CALL t700_tch3_shb05()
              IF NOT cl_null(g_errno) THEN   
                 CALL cl_err(g_shb.shb05,g_errno,0) 
                 DISPLAY BY NAME g_shb.shb05 
                 NEXT FIELD shb05    
              ELSE
                 CALL t700_tch3_shb09()
                 CALL shb12_combo(g_shb.shb05) RETURNING l_combo                      
                 CALL cl_set_combo_items("shb12", l_combo, l_combo)  

                 #若shb111沒有輸入值,則帶入預設值
                 IF g_shb.shb111 = 0 THEN
                    CALL t700_tch3_get_shb111()
                 END IF 
              END IF
           END IF

        AFTER FIELD shb021_h
           IF NOT cl_null(g_shb021.shb021_h) THEN
             IF NOT cl_null(g_shb021.shb021_m) THEN
                LET g_shb.shb021 = g_shb021.shb021_h,':',g_shb021.shb021_m
             END IF

             CALL t700_tch3_chktime()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_shb.shb021,g_errno,0)
                NEXT FIELD shb021_h
             END IF
           END IF

        AFTER FIELD shb021_m
           IF NOT cl_null(g_shb021.shb021_m) THEN
             IF NOT cl_null(g_shb021.shb021_h) THEN
                LET g_shb.shb021 = g_shb021.shb021_h,':',g_shb021.shb021_m
             END IF
             CALL t700_tch3_chktime()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_shb.shb021,g_errno,0)
                NEXT FIELD shb021_m
             END IF
           END IF

        AFTER FIELD shb031_h
           IF NOT cl_null(g_shb031.shb031_h) THEN
             IF NOT cl_null(g_shb031.shb031_m) THEN
                LET g_shb.shb031 = g_shb031.shb031_h,':',g_shb031.shb031_m
                CALL t700_tch3_shb032()
             END IF
             CALL t700_tch3_chktime()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_shb.shb031,g_errno,0)
                NEXT FIELD shb031_h
             END IF
           END IF

        AFTER FIELD shb031_m
           IF NOT cl_null(g_shb031.shb031_m) THEN
             IF NOT cl_null(g_shb031.shb031_h) THEN
                LET g_shb.shb031 = g_shb031.shb031_h,':',g_shb031.shb031_m
                CALL t700_tch3_shb032()
             END IF
             CALL t700_tch3_chktime()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_shb.shb031,g_errno,0)
                NEXT FIELD shb031_m
             END IF
           END IF

        BEFORE FIELD shb111
           CALL t700_tch3_shb09()
           CALL t700_tch3_shb032()
           LET g_flag = 1
           LET g_flag2 = 1
           CALL touch_count(g_shb.shb111) RETURNING li_result,g_shb.shb111
           IF INT_FLAG THEN EXIT INPUT END IF
           DISPLAY BY NAME g_shb.shb111

        AFTER FIELD shb111
          IF NOT cl_null(g_shb.shb111) THEN
             CALL t700_tch3_chkdata()          #報工前的資料檢查

             IF g_fieldstr = '111' THEN
                NEXT FIELD shb111
             END IF
          ELSE
             LET g_shb.shb111 = 0
             DISPLAY BY NAME g_shb.shb111
          END IF        

        BEFORE FIELD shb115
           LET g_flag = 1
           CALL touch_count(g_shb.shb115) RETURNING li_result,g_shb.shb115
           IF INT_FLAG THEN EXIT INPUT END IF
           DISPLAY BY NAME g_shb.shb115

        AFTER FIELD shb115
           IF NOT cl_null(g_shb.shb115) THEN
              IF g_shb.shb115 < 0 THEN
                 CALL cl_err('','aec-992',0)
                 NEXT FIELD shb115
              END IF
           ELSE
              LET g_shb.shb115 = 0
              DISPLAY BY NAME g_shb.shb115
           END IF                    
          
        BEFORE FIELD shb112
           LET g_flag = 1
           CALL touch_count(g_shb.shb112) RETURNING li_result,g_shb.shb112
           IF INT_FLAG THEN EXIT INPUT END IF
           DISPLAY BY NAME g_shb.shb112
          
        AFTER FIELD shb112
           IF NOT cl_null(g_shb.shb112) THEN
              IF g_shb.shb112 < 0  THEN
                 CALL cl_err('','aec-992',0)
                 NEXT FIELD shb112
              END IF
              IF t700_tch3_accept_qty('c') THEN    #檢查可報工數量 
                 NEXT FIELD shb112 
              END IF
              SELECT sma126 INTO l_sma126 FROM sma_file
              IF l_sma126 = 'Y' THEN
                 CALL t700_tch3_shb112() RETURNING l_shb112,l_sgl09_max
                 IF g_shb.shb112 > l_sgl09_max - l_shb112 THEN
                    CALL cl_err('','asf-113',0)
                    NEXT FIELD shb112
                 END IF
              END IF
           ELSE
              LET g_shb.shb112 = 0
              DISPLAY BY NAME g_shb.shb112
           END IF          

        BEFORE FIELD shb113
           CALL t700_tch3_set_entry()
           LET g_flag = 1
           CALL touch_count(g_shb.shb113) RETURNING li_result,g_shb.shb113
           IF INT_FLAG THEN EXIT INPUT END IF
           DISPLAY BY NAME g_shb.shb113

        AFTER FIELD shb113
           IF NOT cl_null(g_shb.shb113) THEN
              IF g_shb.shb113 < 0  THEN
                 CALL cl_err('','aec-992',0)
                 NEXT FIELD shb113
              END IF
              IF g_shb.shb113 = 0  THEN
                 LET g_shb.shb12 = ''
                 DISPLAY BY NAME g_shb.shb12
              END IF
              ## 檢查可報工數量
              IF t700_tch3_accept_qty('c') THEN 
                 NEXT FIELD shb113 
              END IF
           ELSE
              LET g_shb.shb113 = 0
              DISPLAY BY NAME g_shb.shb113
           END IF   
           CALL t700_tch3_set_no_entry()  
           
        AFTER FIELD shb12
           IF NOT cl_null(g_shb.shb12) THEN
              IF g_shb.shb12=g_shb.shb06 THEN
                 CALL cl_err(g_shb.shb12,'aec-086',0)
                 NEXT FIELD shb12
              END IF
              ## 檢查是否有此下製程
              SELECT count(*) INTO g_cnt 
                FROM ecm_file
               WHERE ecm01 = g_shb.shb05
                 AND ecm03 = g_shb.shb12
              IF g_cnt = 0  THEN
                 CALL cl_err(g_shb.shb12,'aec-085',0)
                 DISPLAY BY NAME g_shb.shb12
                 NEXT FIELD shb12
              END IF
           END IF                
          
        BEFORE FIELD shb114
           LET g_flag = 1
           CALL touch_count(g_shb.shb114) RETURNING li_result,g_shb.shb114
           IF INT_FLAG THEN EXIT INPUT END IF
           DISPLAY BY NAME g_shb.shb114

        AFTER FIELD shb114
           IF NOT cl_null(g_shb.shb114) THEN
              IF g_shb.shb114 < 0  THEN
                 CALL cl_err('','aec-992',0)
                 DISPLAY BY NAME g_shb.shb114
                 NEXT FIELD shb114
              END IF
              IF t700_tch3_accept_qty('c') THEN  #檢查可報工數量
                 NEXT FIELD shb114 
              END IF
           ELSE
              LET g_shb.shb114 = 0
              DISPLAY BY NAME g_shb.shb114
           END IF

        BEFORE FIELD shb17
           LET g_flag = 1
           CALL touch_count(g_shb.shb17) RETURNING li_result,g_shb.shb17
           IF INT_FLAG THEN EXIT INPUT END IF
           DISPLAY BY NAME g_shb.shb17
          
        AFTER FIELD shb17
           IF NOT cl_null(g_shb.shb17) THEN
              IF g_shb.shb17 < 0  THEN
                 CALL cl_err('','aec-992',0)
                 NEXT FIELD shb17
              END IF
              ## 檢查可報工數量
              IF t700_tch3_accept_qty('c') THEN 
                 NEXT FIELD shb17 
              END IF
           ELSE
              LET g_shb.shb17 = 0
              DISPLAY BY NAME g_shb.shb17
           END IF          

        #報工完成
        ON ACTION report_ok
           LET g_flag2 = 2    
           CALL t700_tch3_chkdata()          #報工前的資料檢查
            
           IF g_fieldstr = '111' THEN 
              NEXT FIELD shb111
           END IF
           IF g_fieldstr = '115' THEN 
              NEXT FIELD shb115
           END IF
           IF g_fieldstr = '112' THEN 
              NEXT FIELD shb112
           END IF
           IF g_fieldstr = '113' THEN
              NEXT FIELD shb113
           END IF
           IF g_fieldstr = '12' THEN 
              NEXT FIELD shb12
           END IF
           IF g_fieldstr = '114' THEN
              NEXT FIELD shb114
           END IF
           IF g_fieldstr = '17' THEN
              NEXT FIELD shb17
           END IF

           IF cl_null(g_fieldstr) THEN 
              IF g_shb.shb111=0 AND g_shb.shb115=0 AND
                 g_shb.shb112=0 AND g_shb.shb113=0 AND
                 g_shb.shb114=0 AND g_shb.shb17=0 THEN
                 CALL cl_err('','aec-899',0)
                 NEXT FIELD shb111
              ELSE
                 LET g_success = 'Y'
                 CALL t700_tch3_report_ok()
                 IF g_success = 'Y' THEN
                    MESSAGE ""
                    LET l_doc = '移轉單號:',g_shb.shb01
                    CALL cl_err(l_doc,'aec-224',1)
                    EXIT INPUT
                 END IF
              END IF 
           END IF


        #放棄(報工)
        ON ACTION report_cancel 
           IF cl_confirm('aec-223') THEN
              INITIALIZE g_shb.* TO NULL     
              EXIT INPUT
           END IF

        #品質回報
        ON ACTION report_back
           LET g_success = 'Y'           
     
           IF g_shb.shb112 <= 0 THEN      
              CALL cl_err('','asf-992',1) 
           ELSE
              LET g_success = 'Y'
              IF g_success = 'Y' THEN
                 LET l_cmd = "asft700_tch4 '",l_table_shc,"' '",g_shb.shb05,"' '",g_shb.shb07,"' '",
                              g_shb.shb06,"' '",g_shb.shb112,"'"
                 CALL cl_cmdrun(l_cmd)
              END IF
           END IF

        #製程狀況
        ON ACTION routing_status
           LET l_cmd = "asft700_tch1 '",g_shb.shb05,"' '",g_shb.shb07,"' '",g_shb.shb06,"' '",g_shb.shb04,"'"
           CALL cl_cmdrun(l_cmd)  

        #報工歷史資料
        ON ACTION report_history
           LET l_cmd = "asft7003_tch '",g_shb.shb07,"'"
           CALL cl_cmdrun(l_cmd)

        #備料狀況(工單)
        ON ACTION prepare_status
           LET l_cmd = "asft7002_tch '",g_shb.shb05,"' '",g_shb.shb10,"'"
           CALL cl_cmdrun(l_cmd)
   END INPUT

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

FUNCTION touch_timecombo(p_i)
   DEFINE p_i        LIKE type_file.num5
   DEFINE l_combo    STRING
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_s        STRING

   FOR l_i = 1 TO p_i
      LET l_s = l_i
      IF l_i < 10 THEN
         LET l_s = "0",l_s
      END IF
      LET l_combo = l_combo,",",l_s
   END FOR

   LET l_combo = "00",l_combo

   RETURN l_combo
END FUNCTION

FUNCTION shb12_combo(p_shb05)
   DEFINE p_shb05    LIKE shb_file.shb05
   DEFINE l_combo    STRING
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_s        STRING
   DEFINE l_ecm03    LIKE ecm_file.ecm03


   DECLARE shb12_cur CURSOR FOR
     SELECT ecm03 FROM ecm_file WHERE ecm01 = p_shb05
   FOREACH shb12_cur INTO l_ecm03
      LET l_s = l_ecm03
      LET l_combo = l_combo,",",l_s
   END FOREACH
 
   RETURN l_combo
END FUNCTION


#取得欄位初始值
FUNCTION t700_tch3_defdata()
  DEFINE l_shb021   LIKE shb_file.shb021    #VARCHAR(8) 

    LET g_shb.shb01 = ' '               #移轉單號預設值 
    LET g_shb.shb05 = g_argv1
    LET g_shb.shb07 = g_argv2
    LET g_shb.shb06 = g_argv3
    LET g_shb.shb04 = g_argv4
    LET g_shb.shb08 = 'WK-1'            #QQWW     

    LET g_shb.shb02   = g_today
    LET g_shb.shb03   = g_today
    LET g_shb.shb113  = 0
    LET g_shb.shb115  = 0
    LET g_shb.shb112  = 0
    LET g_shb.shb114  = 0
    LET g_shb.shb17   = 0
    LET g_shb.shbinp  = g_today
    LET g_shb.shbacti = "Y"
    LET g_shb.shbuser = g_user
    LET g_shb.shbgrup = g_grup
    LET g_shb.shbmodu = ''
    LET g_shb.shbdate = ''

    LET l_shb021 = TIME
    LET g_shb031.shb031_h = l_shb021[1,2]
    LET g_shb031.shb031_m = l_shb021[4,5]

   #實體暫存資料庫名稱
    LET l_table_shb = 'shb',l_shb021[1,2],l_shb021[4,5],l_shb021[7,8]
    LET l_table_shc = 'shc',l_shb021[1,2],l_shb021[4,5],l_shb021[7,8]

    CALL t700_tch3_shb05()
    CALL t700_tch3_shb09()
    CALL t700_tch3_shb04()
    CALL t700_tch3_shb07()
    CALL t700_tch3_get_shb111()
END FUNCTION


#取得與shb05有相關的欄位值
FUNCTION t700_tch3_shb09()
   DEFINE l_ecm04    LIKE ecm_file.ecm04
   DEFINE l_ecm45    LIKE ecm_file.ecm45
   DEFINE l_ecg02    LIKE ecg_file.ecg02
   DEFINE l_shb06    STRING

    IF NOT cl_null(g_shb.shb05) AND NOT cl_null(g_shb.shb06) THEN
       SELECT ecm05 INTO g_shb.shb09
         FROM ecm_file
        WHERE ecm01 = g_shb.shb05
          AND ecm03 = g_shb.shb06

	SELECT ecm04,ecm45 INTO l_ecm04,l_ecm45
          FROM ecm_file 
         WHERE ecm01 = g_shb.shb05 
           AND ecm03 = g_shb.shb06

        SELECT ecg02 INTO l_ecg02
          FROM ecg_file
         WHERE ecg01 = g_shb.shb08

        LET g_shb.shb081 = l_ecm04
        LET g_shb.shb082 = l_ecm45 
        LET l_shb06 = g_shb.shb06          #轉型態(畫面顯示靠左)

       #DISPLAY l_ecm04,l_ecm45 TO FORMONLY.shb081,FORMONLY.shb082
        DISPLAY l_ecm45 TO FORMONLY.shb081
        DISPLAY l_shb06 TO FORMONLY.shb06
        DISPLAY l_ecg02 TO FORMONLY.ecg02
    END IF
END FUNCTION


#計算良品轉出量
FUNCTION t700_tch3_get_shb111()
    DEFINE l_wip_qty   LIKE shb_file.shb111         #在製量/良品轉出

    LET g_shb.shb111 = 0 

    SELECT * INTO g_ecm.* 
      FROM ecm_file
     WHERE ecm01 = g_shb.shb05
       AND ecm03 = g_shb.shb06
    IF g_ecm.ecm54 = 'Y' THEN   #check in 否
       LET l_wip_qty =  g_ecm.ecm291                #check in
                      - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
                      - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
                      - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
                      - g_ecm.ecm314*g_ecm.ecm59    #當站下線
                      - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
    ELSE
       LET l_wip_qty =  g_ecm.ecm301                #良品轉入量
                      + g_ecm.ecm302                #重工轉入量
                      + g_ecm.ecm303                #工單轉入
                      - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
                      - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
                      - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
                      - g_ecm.ecm314*g_ecm.ecm59    #當站下線
                      - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
    END IF
   
    IF cl_null(l_wip_qty) THEN LET l_wip_qty = 0 END IF
    LET g_shb.shb111 = l_wip_qty
    DISPLAY BY NAME g_shb.shb111
END FUNCTION

FUNCTION t700_tch3_shb032()
    IF NOT cl_null(g_shb.shb021) AND NOT cl_null(g_shb.shb031) THEN
       LET g_h1 = g_shb.shb021[1,2]   
       LET g_m1 = g_shb.shb021[4,5]   
       LET g_h2 = g_shb.shb031[1,2]  
       LET g_m2 = g_shb.shb031[4,5] 
       LET g_sum_m1 = g_h1*60 + g_m1
       LET g_sum_m2 = g_h2*60 + g_m2
       LET g_shb.shb032 = (g_shb.shb03-g_shb.shb02)*24*60+(g_sum_m2-g_sum_m1)
       LET g_shb.shb033 = g_shb.shb032
    END IF
END FUNCTION

#[工單編號]的檢核      
FUNCTION t700_tch3_shb05()
   DEFINE l_sfb93     LIKE sfb_file.sfb93
   DEFINE l_ima02     LIKE ima_file.ima02
   DEFINE l_ima021    LIKE ima_file.ima021
   DEFINE l_cnt       LIKE type_file.num10
                  
    LET g_errno = ' ' 
                     
    SELECT sfb93 INTO l_sfb93
      FROM sfb_file
     WHERE sfb01 = g_shb.shb05
       AND ((sfb04 IN ('4','5','6','7','8') AND sfb39='1') OR
            (sfb04 IN ('2','3','4','5','6','7','8') AND sfb39='2'))
       AND (sfb28 < '2' OR sfb28 IS NULL)
       AND sfb87!='X'
    IF STATUS THEN                                 #資料不存在
       LET g_errno = 'asf-018'
    ELSE
       IF l_sfb93 <> 'Y' THEN
          LET g_errno = 'asf-088'                  #此張工單不做製程管理!
       ELSE
          SELECT COUNT(*) INTO l_cnt FROM sfb_file
           WHERE sfb01 = g_shb.shb05
             AND sfb02='7'
             AND sfb87!='X'
          IF l_cnt > 0 THEN
             LET g_errno = 'asf-817'                     #此張工單為委外工單!
          ELSE
             SELECT COUNT(*) INTO l_cnt FROM shm_file    #此工單走run card
              WHERE shm012 = g_shb.shb05
             IF l_cnt > 0 THEN
                LET g_errno = 'asf-927'                  #此工單有RUN CARD 資料,不可在此報工 !!
             END IF
          END IF
       END IF
    END IF

    IF cl_null(g_errno) THEN
       SELECT sfb05 INTO g_shb.shb10
         FROM sfb_file 
        WHERE sfb01 = g_shb.shb05

       SELECT ima02,ima021 INTO l_ima02,l_ima021
         FROM ima_file
        WHERE ima01 = g_shb.shb10

       DISPLAY g_shb.shb10 TO FORMONLY.shb10
       DISPLAY l_ima02 TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
    ELSE
       LET g_shb.shb10 = ''
       DISPLAY NULL TO FORMONLY.shb10
       DISPLAY NULL TO FORMONLY.ima02
       DISPLAY NULL TO FORMONLY.ima021
    END IF
END FUNCTION

#[工作站]的檢核  
FUNCTION t700_tch3_shb07()
    DEFINE l_cnt       LIKE type_file.num10
    DEFINE l_ecm52     LIKE ecm_file.ecm52 
    DEFINE l_eca02     LIKE eca_file.eca02        
      
    LET g_errno = ' '
            
    IF cl_null(g_errno) THEN
       SELECT eca02 INTO l_eca02
         FROM eca_file
        WHERE eca01 = g_shb.shb07
       DISPLAY l_eca02 TO FORMONLY.eca02
    END IF
END FUNCTION

#人員               
FUNCTION t700_tch3_shb04()
   DEFINE l_gen02     LIKE gen_file.gen02, 
          l_genacti   LIKE gen_file.genacti
            
    LET g_errno = ' '
               
    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file
     WHERE gen01 = g_shb.shb04
            
    CASE 
      WHEN SQLCA.SQLCODE = 100  
         LET g_errno = 'mfg1312'
         LET l_gen02 = NULL
      WHEN l_genacti='N'
         LET g_errno = '9028'
      OTHERWISE          
         LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

    IF cl_null(g_errno) THEN
      #DISPLAY l_gen02 TO FORMONLY.gen02
       DISPLAY l_gen02 TO FORMONLY.shb04
    END IF
END FUNCTION

## 檢查可報工數量
FUNCTION t700_tch3_accept_qty(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,    
       l_wip_qty  LIKE shb_file.shb111,
       l_pqc_qty  LIKE qcm_file.qcm091,   #良品數
       l_sum_qty  LIKE qcm_file.qcm091

      #WIP量 = 總投入量(a+b)-總轉出量(f+g)-報廢量(d)-入庫量(e)
      #       -委外加工量(h)+委外完工量(i)
      #WIP量指目前在該站的在製量，
      #若系統參數定義要做Check-In時，WIP量尚可區
      #分為等待上線數量與上線處理數量。
      #上線處理數量 = Check-In量(c)-總轉出量(f+g)-報廢量(d)-入庫量(e)
      #              -委外加工量(h)+委外完工量(i)
      #等待上線數量=線投入量(a+b)-Check-In量(c)

      #若該站允許做製程委外，則
      #可委外加工量 = WIP量-委外加工量(h)
      #委外在外量   = 委外加工量(h)-委外完工量(i)

      #某站若要報工則其可報工數 = WIP量(a+b-f-g-d-e-h+i)，
      #若要做Check-In則可報工數 = c-f-g-d-e-h+i。

       SELECT * INTO g_ecm.* FROM ecm_file
        WHERE ecm01 = g_shb.shb05 
          AND ecm03 = g_shb.shb06
       IF STATUS THEN                       
          CALL cl_err('sel ecm_file',STATUS,0)  #資料不存在
          RETURN -1
       END IF
      
       LET g_shb.shb14 = ''                     #暫不做委外
       LET g_shb.shb15 = ''                     #暫不做委外

       IF cl_null(g_shb.shb14) AND cl_null(g_shb.shb15) THEN
          IF g_ecm.ecm54 = 'Y' THEN                       #check in 否?
             LET l_wip_qty =  g_ecm.ecm291                #check in
                            - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
                            - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
                            - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
                            - g_ecm.ecm314*g_ecm.ecm59    #當站下線
                            - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
                            - g_ecm.ecm321                #委外加工量
                            + g_ecm.ecm322                #委外完工量
          ELSE
             LET l_wip_qty =  g_ecm.ecm301                #良品轉入量
                            + g_ecm.ecm302                #重工轉入量
                            + g_ecm.ecm303                #工單轉入
                            - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
                            - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
                            - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
                            - g_ecm.ecm314*g_ecm.ecm59    #當站下線
                            - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
                            - g_ecm.ecm321                #委外加工量
                            + g_ecm.ecm322                #委外完工量
          END IF
       ELSE
          LET l_wip_qty = g_ecm.ecm321 - g_ecm.ecm322   
       END IF
 
       IF cl_null(l_wip_qty) THEN 
          LET l_wip_qty = 0 
       END IF

       LET l_sum_qty = (g_shb.shb111+g_shb.shb113+g_shb.shb112+g_shb.shb114+g_shb.shb17)
                       *g_ecm.ecm59

       IF l_sum_qty>l_wip_qty AND p_cmd<>'d' AND p_cmd<>'s' THEN 
          LET g_msg="WIP:",l_wip_qty USING "<<<<.<<" CLIPPED
          CALL cl_err(g_msg,'asf-801',0)
          RETURN -1
       END IF

      #若該站製程追蹤檔中定義本站需要做PQC檢查，
      #則可報工數量尚需滿足以下條件:
      #    可報工數量<=SUM(PQC Accept數量)-當站下線量(e)-良品轉出量(f)
       IF g_ecm.ecm53 = 'Y' THEN              #PQC
          SELECT SUM(qcm091) INTO l_pqc_qty 
            FROM qcm_file
           WHERE qcm02 = g_shb.shb05          #工單編號
             AND qcm05 = g_shb.shb06          #製程序號
             AND qcm14 = 'Y'                  #確認
             AND (qcm09='1' OR qcm09='3')     #判定結果(1.Accept 3.特採) 
 
          IF cl_null(l_pqc_qty) THEN LET l_pqc_qty=0 END IF
          IF cl_null(g_ecm.ecm311) THEN LET g_ecm.ecm311=0 END IF
          IF cl_null(g_ecm.ecm312) THEN LET g_ecm.ecm312=0 END IF
          IF cl_null(g_ecm.ecm313) THEN LET g_ecm.ecm313=0 END IF
          IF cl_null(g_ecm.ecm314) THEN LET g_ecm.ecm314=0 END IF
          IF cl_null(g_ecm.ecm302) THEN LET g_ecm.ecm302=0 END IF
          IF cl_null(g_ecm.ecm303) THEN LET g_ecm.ecm303=0 END IF
          IF cl_null(g_ecm.ecm316) THEN LET g_ecm.ecm316=0 END IF

          LET l_pqc_qty = l_pqc_qty - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
                                    - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
                                    - g_ecm.ecm314*g_ecm.ecm59    #當站下線
                                    - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
                                    + g_ecm.ecm302

          IF l_sum_qty-g_shb.shb112>l_pqc_qty AND p_cmd<>'d' THEN
             LET g_msg = "WIP:",l_wip_qty USING "<<<<.<<" CLIPPED,
                         "  PQC:",l_pqc_qty USING "<<<<.<<" CLIPPED
             CALL cl_err(g_msg,'asf-802',0)
             RETURN -1
          END IF
       END IF

       LET g_wip_qty = l_wip_qty    

       RETURN 0
END FUNCTION

FUNCTION t700_tch3_shb111()
   DEFINE l_sma126              LIKE sma_file.sma126
   DEFINE l_shb111              LIKE shb_file.shb111
   DEFINE l_sgl08               LIKE sgl_file.sgl08
   DEFINE l_sgl08_min           LIKE sgl_file.sgl08
   DEFINE l_sgd                 RECORD LIKE sgd_file.*
        
     DECLARE sgd_cs CURSOR FOR 
      SELECT * FROM sgd_file
       WHERE sgd00 = g_shb.shb05
         AND sgd03 = g_shb.shb06
         AND sgd14 = 'Y'      

     LET l_sgl08_min = 0

     #抓取飛票報工資料單頭，單身檔，抓出各單元的報工合計量，並得到所有單元中的最小報工量
     FOREACH sgd_cs INTO l_sgd.*
         SELECT SUM(sgl08) INTO l_sgl08
           FROM sgl_file,sgk_file
          WHERE sgl01 = sgk01
            AND sgl04 = l_sgd.sgd00
            AND sgl06 = l_sgd.sgd03
            AND sgl07 = l_sgd.sgd05
            AND sgk07 = 'Y'
            AND sgkacti = 'Y'
         IF l_sgl08 IS NULL THEN  
            LET l_sgl08 = 0 
         END IF
         IF l_sgl08 = 0 THEN
            LET l_sgl08_min = 0
            EXIT FOREACH
         ELSE
            IF l_sgl08_min = 0 THEN
               LET l_sgl08_min = l_sgl08
            ELSE
               IF l_sgl08 < l_sgl08_min THEN
                  LET l_sgl08_min = l_sgl08
               END IF
            END IF
          END IF
     END FOREACH

     #再抓取本工單，工序在生產日報中已經報工的數量
     SELECT SUM(shb111) INTO l_shb111 FROM shb_file
      WHERE shb05 = g_shb.shb05
        AND shb06 = g_shb.shb06
     IF cl_null(l_shb111) THEN
        LET l_shb111 = 0
     END IF

     RETURN l_shb111,l_sgl08_min
END FUNCTION

FUNCTION t700_tch3_shb112()
  DEFINE l_sma126           LIKE sma_file.sma126
  DEFINE l_shb112           LIKE shb_file.shb112
  DEFINE l_sgl09            LIKE sgl_file.sgl09
  DEFINE l_sgl09_max        LIKE sgl_file.sgl09
  DEFINE l_sgd              RECORD LIKE sgd_file.*

     DECLARE sgd_cs1 CURSOR FOR
      SELECT * FROM sgd_file
       WHERE sgd00 = g_shb.shb05
         AND sgd03 = g_shb.shb06
         AND sgd14 = 'Y'         

     LET l_sgl09_max = 0

     #抓取飛票報工資料單頭，單身檔，抓出各單元的報工合計量，並得到所有單元中的最小報工量
     FOREACH sgd_cs1 INTO l_sgd.*
         SELECT SUM(sgl09) INTO l_sgl09
           FROM sgl_file,sgk_file
          WHERE sgl01 = sgk01
            AND sgl04 = l_sgd.sgd00
            AND sgl06 = l_sgd.sgd03
            AND sgl07 = l_sgd.sgd05
            AND sgk07 = 'Y'
            AND sgkacti = 'Y'
         IF l_sgl09 IS NULL THEN  LET l_sgl09 = 0 END IF
         IF l_sgl09 = 0 THEN
            LET l_sgl09_max = 0
            EXIT FOREACH
         ELSE
            IF l_sgl09_max = 0 THEN
               LET l_sgl09_max = l_sgl09
            ELSE
               IF l_sgl09 > l_sgl09_max THEN
                  LET l_sgl09_max = l_sgl09
               END IF
            END IF
          END IF
     END FOREACH

     #再抓取本工單，工序在生產日報中已經報工的數量
     SELECT SUM(shb112) INTO l_shb112 
       FROM shb_file
      WHERE shb05 = g_shb.shb05
        AND shb06 = g_shb.shb06
     IF cl_null(l_shb112) THEN 
        LET l_shb112 = 0 
     END IF

     RETURN l_shb112,l_sgl09_max
END FUNCTION

FUNCTION t700_tch3_set_entry()
     CALL cl_set_comp_entry("shb12",TRUE)
END FUNCTION

FUNCTION t700_tch3_set_no_entry()
     IF g_shb.shb113 = 0 THEN
        CALL cl_set_comp_entry("shb12",FALSE)
     END IF
        
     IF g_shb.shb113 > 0 THEN
        CALL cl_set_comp_entry("shb12",TRUE)
        CALL cl_set_comp_required("shb12",TRUE)
     ELSE
        CALL cl_set_comp_required("shb12",FALSE)
     END IF
END FUNCTION

FUNCTION t700_tch3_report_ok()
   DEFINE li_result    LIKE type_file.num5  
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_ima55      LIKE ima_file.ima55
   DEFINE l_ecm58      LIKE ecm_file.ecm58
   DEFINE l_factor     LIKE ecm_file.ecm59 

     BEGIN WORK    
 
     CALL t700_tch3_getshb01()              #取得"移轉單號"

     IF g_success = 'Y' THEN
       IF cl_null(g_shb.shbconf) THEN  LET g_shb.shbconf = 'N' END IF    #FUN-A70095  
       INSERT INTO shb_file VALUES (g_shb.*)
       IF STATUS THEN
         LET g_success = 'N'
         CALL cl_err(g_shb.shb01,STATUS,1)
       ELSE
         CALL t700_tch3_upd_ecm('a')    #Update製程追蹤檔
         IF g_success = 'Y' THEN
            IF g_shb.shb112 > 0 THEN    #表示有報廢數量
              #update 工單單頭報廢量
               SELECT ima55 INTO l_ima55 FROM ima_file
                WHERE ima01= g_shb.shb10

               SELECT ecm58 INTO l_ecm58 FROM ecm_file
                WHERE ecm01=g_shb.shb05
                  AND ecm03=g_shb.shb06

               CALL s_umfchk(g_shb.shb10,l_ecm58,l_ima55)
                    RETURNING l_i,l_factor

               IF l_i = '1' THEN
                  LET l_factor = 1
               END IF

               UPDATE sfb_file 
                  SET sfb12 = sfb12 + (g_shb.shb112 * l_factor)
                WHERE sfb01 = g_shb.shb05
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err(g_shb.shb05,'asf-861',1)
                  LET g_success = 'N'
               END IF
            END IF            
         END IF
       END IF
     END IF    

     IF g_success = 'Y' THEN
        #將單號寫入temp table
        LET g_sql = "UPDATE ",l_table_shc CLIPPED," SET shc01 = '",g_shb.shb01,"'"
        PREPARE updshc01_pre FROM g_sql
        EXECUTE updshc01_pre
        IF SQLCA.sqlcode THEN
           CALL cl_err('update temptable:',SQLCA.sqlcode,0)
           LET g_success = 'N'
        ELSE
           #將品質回報資料從暫存檔寫入shc_file
           LET g_sql = "INSERT INTO shc_file(shc01,shc03,shc04,shc05,shc06,",
                       "shcacti,shcuser,shcgrup,shcmodu,shcdate) ",
                       "SELECT shc01,shc03,shc04,shc05,shc06,shcacti,shcuser,",
                       "shcgrup,shcmodu,shcdate FROM ",l_table_shc CLIPPED
           PREPARE inssub_pre FROM g_sql
           EXECUTE inssub_pre
           IF SQLCA.sqlcode THEN     
              CALL cl_err('insert shc_file:',SQLCA.sqlcode,0)
              LET g_success = 'N'
           END IF
        END IF
     END IF

     IF g_success = 'N' THEN
        ROLLBACK WORK
     ELSE
        COMMIT WORK

        SELECT COUNT(*) INTO l_i
          FROM shc_file
         WHERE shc01 = g_shb.shb01
        IF l_i = 0 THEN 
          CALL cl_err('','asf-993',1)
        END IF
     END IF
END FUNCTION

#Update 製程追蹤檔
FUNCTION t700_tch3_upd_ecm(p_cmd)
DEFINE l_vne03  LIKE vne_file.vne03     
DEFINE l_vne06  LIKE vne_file.vne06    
DEFINE p_cmd    LIKE type_file.chr1,    
       l_shi    RECORD LIKE shi_file.*,
       l_ecm03  LIKE ecm_file.ecm03,
       l_ecm03n LIKE ecm_file.ecm03,
       l_ecm322 LIKE ecm_file.ecm322,
       l_final  LIKE type_file.chr1     #VARCHAR(1)   #終站否
DEFINE l_sum    LIKE qcm_file.qcm091,   #DEC(12,3),
       l_factor LIKE ecm_file.ecm59,    #DEC(16,8),
       l_cnt    LIKE type_file.num5,    #SMALLINT
       l_ecm57a LIKE ecm_file.ecm57,    #當站在制單位  
       l_ecm57  LIKE ecm_file.ecm57,
       l_ecm58  LIKE ecm_file.ecm58,
       l_ecm51  LIKE ecm_file.ecm51

    # 抓下製程
    LET l_ecm03 = ''
    LET l_final = 'N'

    SELECT MIN(ecm03) INTO l_ecm03 
      FROM ecm_file
     WHERE ecm01 = g_shb.shb05   #工單單號
       AND ecm03 > g_shb.shb06
    IF cl_null(l_ecm03) THEN
       LET l_final='Y'
    END IF

    IF NOT cl_null(g_shb.shb14) THEN   #委外入庫單 !=space
       LET l_ecm322 = g_shb.shb111
    ELSE
       LET l_ecm322 = 0
    END IF

    MESSAGE "asft700.update ecm_file ............."

    CASE p_cmd
         WHEN 'a'
              #..........檢查轉出量.......................
              SELECT (ecm311+ecm312+ecm313+ecm314+ecm316),ecm51
                INTO l_sum,l_ecm51
                FROM ecm_file
               WHERE ecm01 = g_shb.shb05
                 AND ecm03 = g_shb.shb06
              IF l_sum = 0 OR cl_null(l_sum) THEN   #表第一站
                 UPDATE ecm_file 
                    SET ecm311=ecm311+g_shb.shb111, #良品轉出
                        ecm312=ecm312+g_shb.shb113, #重工轉出
                        ecm313=ecm313+g_shb.shb112, #當站報廢
                        ecm314=ecm314+g_shb.shb114, #當站下線
                        ecm315=ecm315+g_shb.shb115, #Bonus
                        ecm316=ecm316+g_shb.shb17,
                        ecm322=ecm322+l_ecm322,     #委外完工量
                        ecm50 = g_shb.shb02,        #開工日期
                        ecm51 = g_shb.shb03,        #完工日
                        ecm25 = g_shb.shb021,       #開工時間
                        ecm26 = g_shb.shb031        #完工時間
                  WHERE ecm01 = g_shb.shb05         #工單單號
                    AND ecm03 = g_shb.shb06         #本製程序
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                    CALL cl_err('Update ecm_file:#1',STATUS,1)
                    LET g_success='N'
                 END IF
                 IF g_sma.sma901 = 'Y' THEN    #有串APS
                    IF g_ecm.ecm61 = 'Y' THEN  #有平行加工
                       UPDATE vne_file 
                          SET vne311=vne311+g_shb.shb111, #良品轉出
                              vne312=vne312+g_shb.shb113, #重工轉出
                              vne313=vne313+g_shb.shb112, #當董虃o
                              vne314=vne314+g_shb.shb114, #當站下線
                              vne315=vne315+g_shb.shb115, #Bonus
                              vne316=vne316+g_shb.shb17,  #工單轉出
                              vne50 = g_shb.shb02,        #開工日期
                              vne51 = g_shb.shb03,        #完工日期
                              vne25 = g_shb.shb021,       #開工時間
                              vne26 = g_shb.shb031        #完工時間
                           WHERE vne01=g_shb.shb05 
                             AND vne02=g_shb.shb05
                             AND vne03=g_shb.shb06
                             AND vne05=g_shb.shb09

                       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                          CALL cl_err('Update vlj_file:#1',STATUS,1)
                          LET g_success='N'
                       END IF
                    END IF

                    #==>更新vne_file的未完成量
                    LET l_vne03 = g_shb.shb06
                    SELECT vne06 INTO l_vne06
                      FROM vne_file
                     WHERE vne01 = g_shb.shb05    #製令編號
                       AND vne02 = g_shb.shb05    #途程編號
                       AND vne03 = l_vne03        #加工序號
                       AND vne04 = g_ecm.ecm04    #作業編號
                       AND vne05 = g_shb.shb09    #資源編號
                    IF NOT cl_null(l_vne06) THEN
                       LET l_vne06 = l_vne06 - 
                                    (g_shb.shb111 + g_shb.shb113 + g_shb.shb112 +
                                     g_shb.shb114 + g_shb.shb115 + g_shb.shb17)
                       IF l_vne06 < 0 THEN
                          LET g_re_dis_vne06 = l_vne06 *(-1) 
                          LET l_vne06 = 0 
                       END IF
                       UPDATE vne_file
                          SET vne06 = l_vne06
                        WHERE vne01 = g_shb.shb05 #製令編號
                          AND vne02 = g_shb.shb05 #途程編號
                          AND vne03 = l_vne03     #加工序號
                          AND vne04 = g_ecm.ecm04 #作業編號
                          AND vne05 = g_shb.shb09 #資源編號
                       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                          CALL cl_err('Update vne_file:#1',STATUS,1)
                          LET g_success='N'
                       END IF
                    END IF
                 END IF
              ELSE
                 UPDATE ecm_file 
                    SET ecm311=ecm311+g_shb.shb111, #良品轉出
                        ecm312=ecm312+g_shb.shb113, #重工轉出
                        ecm313=ecm313+g_shb.shb112, #當站報廢
                        ecm314=ecm314+g_shb.shb114, #當站下線
                        ecm315=ecm315+g_shb.shb115, #Bonus
                        ecm316=ecm316+g_shb.shb17,
                        ecm322=ecm322+l_ecm322,     #委外完工量
                        ecm50 = g_shb.shb02,        #開工日期
                        ecm51 = g_shb.shb03,        #完工日
                        ecm25 = g_shb.shb021,       #開工時間
                        ecm26 = g_shb.shb031        #完工時間
                  WHERE ecm01=g_shb.shb05           #工單單號
                    AND ecm03=g_shb.shb06           #本製程序
                 IF STATUS OR SQLCA.SQLERRD[3]=0
                    THEN
                    CALL cl_err('Update ecm_file:#1',STATUS,1)
                    LET g_success='N'
                 END IF

                 IF g_sma.sma901 = 'Y' THEN    #有串APS
                     IF g_ecm.ecm61 = 'Y' THEN #有平行加工
                        UPDATE vne_file 
                           SET vne311=vne311+g_shb.shb111, #良品轉出
                               vne312=vne312+g_shb.shb113, #重工轉出
                               vne313=vne313+g_shb.shb112, #當站報廢
                               vne314=vne314+g_shb.shb114, #當站下線
                               vne315=vne315+g_shb.shb115, #Bonus
                               vne316=vne316+g_shb.shb17,  #工單轉出
                               vne50 = g_shb.shb02,        #開工日期
                               vne51 = g_shb.shb03,        #完工日期
                               vne25 = g_shb.shb021,       #開工時間
                               vne26 = g_shb.shb031        #完工時間
                         WHERE vne01=g_shb.shb05 
                           AND vne02=g_shb.shb05
                           AND vne03=g_shb.shb06
                           AND vne05=g_shb.shb09 
                        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                           CALL cl_err('Update vlj_file:#2',STATUS,1)
                           LET g_success='N'
                        END IF
                     END IF

                     #==>更新vne_file的未完成量
                     LET l_vne03 = g_shb.shb06
                     SELECT vne06 INTO l_vne06
                       FROM vne_file
                      WHERE vne01 = g_shb.shb05 #製令編號
                        AND vne02 = g_shb.shb05 #途程編號
                        AND vne03 = l_vne03     #加工序號
                        AND vne04 = g_ecm.ecm04 #作業編號
                        AND vne05 = g_shb.shb09 #資源編號
                     IF NOT cl_null(l_vne06) THEN
                        LET l_vne06 = l_vne06 - 
                                     (g_shb.shb111 + g_shb.shb113 + g_shb.shb112 + 
                                      g_shb.shb114 + g_shb.shb115 + g_shb.shb17)
                        IF l_vne06 < 0 THEN
                           LET g_re_dis_vne06 = l_vne06 *(-1) 
                           LET l_vne06 = 0 
                        END IF
                        UPDATE vne_file
                           SET vne06 = l_vne06
                         WHERE vne01 = g_shb.shb05 #製令編號
                           AND vne02 = g_shb.shb05 #途程編號
                           AND vne03 = l_vne03     #加工序號
                           AND vne04 = g_ecm.ecm04 #作業編號
                           AND vne05 = g_shb.shb09 #資源編號
                        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                           CALL cl_err('Update vne_file:#2',STATUS,1)
                           LET g_success='N'
                        END IF
                     END IF
                 END IF
              END IF

              IF l_final='N' THEN #非終站
                 SELECT ecm58 INTO l_ecm57a 
                   FROM ecm_file
                  WHERE ecm01=g_shb.shb05
                    AND ecm03=g_shb.shb06

                 SELECT ecm57 INTO l_ecm57 FROM ecm_file
                  WHERE ecm01=g_shb.shb05
                    AND ecm03=l_ecm03
                 CALL s_umfchk(g_shb.shb10,l_ecm57a,l_ecm57)                                                   
                      RETURNING g_sw,l_factor
                 IF g_sw = '1' THEN                                                                                             
                    CALL cl_err('upd_ecm301','mfg1206',0)                                                                  
                    LET g_success='N'
                 ELSE
                    UPDATE ecm_file 
                       SET ecm301 = ecm301+(g_shb.shb111+g_shb.shb115)*l_factor
                     WHERE ecm01 = g_shb.shb05   #工單單號
                       AND ecm03 = l_ecm03       #下製程序
                    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                       CALL cl_err('Update ecm_file:#2',STATUS,1)
                       LET g_success='N'
                    END IF
                 END IF           
              END IF
              IF g_shb.shb113>0 THEN        #重工轉出
                 SELECT ecm58 INTO l_ecm58  #轉出單位
                   FROM ecm_file           
                  WHERE ecm01=g_shb.shb05   #工單單號
                    AND ecm03=g_shb.shb06   #當站製程序

                 SELECT ecm57 INTO l_ecm57 
                   FROM ecm_file
                  WHERE ecm01=g_shb.shb05   #工單單號
                    AND ecm03=g_shb.shb12   #重工下製程序

                 #計算重工單位轉換率
                 CALL s_umfchk(g_shb.shb10,l_ecm58,l_ecm57) RETURNING g_sw,l_factor
                 IF g_sw = '1' THEN
                    CALL cl_err('upd_ecm_shb113','mfg1206',1)
                    LET g_success='N'
                 END IF
                 UPDATE ecm_file 
                    SET ecm302 = ecm302+g_shb.shb113*l_factor
                  WHERE ecm01 = g_shb.shb05   #工單單號
                    AND ecm03 = g_shb.shb12   #重工下製程序
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                    CALL cl_err('Update ecm_file:#3',STATUS,1)
                    LET g_success='N'
                 END IF
              END IF
              IF g_shb.shb17>0 THEN  #工單轉出
                 DECLARE shi_cur CURSOR FOR
                    SELECT * FROM shi_file 
                     WHERE shi01 = g_shb.shb01
                 FOREACH shi_cur INTO l_shi.*
                    UPDATE ecm_file 
                       SET ecm303 = ecm303+l_shi.shi05
                     WHERE ecm01 = l_shi.shi02            #工單單號
                       AND ecm03 = l_shi.shi04            #製程序
                    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                       CALL cl_err('Update ecm_file:#31',STATUS,1)
                       LET g_success='N' 
                       EXIT FOREACH
                    END IF
                 END FOREACH
              END IF
    END CASE
END FUNCTION

#檢查報工時間不可小於開始時間
FUNCTION t700_tch3_chktime()
   DEFINE l_shb021_h      LIKE type_file.num5,
          l_shb021_m      LIKE type_file.num5,
          l_shb031_h      LIKE type_file.num5,
          l_shb031_m      LIKE type_file.num5
   DEFINE l_chk_time1     LIKE type_file.num10    #開始時間(單位:分鐘)  #INTEGER
   DEFINE l_chk_time2     LIKE type_file.num10    #報工時間(單位:分鐘)  #INTEGER
 
  
      LET g_errno = ''
      
      IF NOT cl_null(g_shb021.shb021_h) AND NOT cl_null(g_shb021.shb021_m) AND
         NOT cl_null(g_shb031.shb031_h) AND NOT cl_null(g_shb031.shb031_m) THEN
       
         LET l_shb021_h = g_shb021.shb021_h
         LET l_shb021_m = g_shb021.shb021_m
         LET l_shb031_h = g_shb031.shb031_h
         LET l_shb031_m = g_shb031.shb031_m
         LET l_chk_time1 = l_shb021_h*60 + l_shb021_m
         LET l_chk_time2 = l_shb031_h*60 + l_shb031_m

         IF l_chk_time1 > l_chk_time2 THEN
            LET g_errno = 'asf-917'
         END IF
      END IF
END FUNCTION


FUNCTION t700_tch3_chkdata()
   DEFINE l_shb111        LIKE shb_file.shb111
   DEFINE l_sgl08         LIKE sgl_file.sgl08
   DEFINE l_sgl08_min     LIKE sgl_file.sgl08
   DEFINE l_sgl09_max     LIKE sgl_file.sgl09
   DEFINE l_ima153        LIKE ima_file.ima153
   DEFINE l_sma126        LIKE sma_file.sma126
   DEFINE l_shb112        LIKE shb_file.shb112


     LET g_fieldstr = ''

     IF g_shb.shb111 < 0  THEN
        CALL cl_err('','aec-992',0)
        LET g_fieldstr = '111'
        RETURN
     END IF

     #檢查可報工數量
     IF t700_tch3_accept_qty('c') THEN
        LET g_fieldstr = '111'
        RETURN
     END IF

     IF g_shb.shb111*g_ecm.ecm59 > g_wip_qty THEN
        IF cl_confirm('asf-047') THEN
           LET g_shb.shb115 = g_shb.shb115 + (g_shb.shb111 - g_shb.shb115)
           LET g_shb.shb111 = g_wip_qty
        ELSE
           LET g_shb.shb111 = g_wip_qty
        END IF

        DISPLAY BY NAME g_shb.shb111
    
        IF t700_tch3_accept_qty('c') THEN 
           LET g_fieldstr = '111'
           RETURN
        END IF
     END IF

     SELECT COUNT(*) INTO g_cnt 
       FROM sfa_file
      WHERE sfa01 = g_shb.shb05
        AND sfa08 = g_shb.shb081
     IF g_cnt > 0 THEN
        CALL s_get_ima153(g_shb.shb10) RETURNING l_ima153
       #CALL s_minp(g_shb.shb05,g_sma.sma73,l_ima153,g_shb.shb081)
        CALL s_minp_routing(g_shb.shb05,g_sma.sma73,l_ima153,g_shb.shb081,g_shb.shb012,g_shb.shb06) 
            RETURNING g_cnt,g_min_set

        IF g_cnt !=0  THEN
           CALL cl_err(g_shb.shb05,'asf-549',0)
           LET g_fieldstr = '111'
           RETURN
        END IF
        IF g_shb.shb111 > g_min_set THEN
           CALL cl_err(g_shb.shb05,'asf-670',0)
           LET g_fieldstr = '111'
           RETURN
        END IF
     END IF
    
     SELECT sma126 INTO l_sma126 FROM sma_file
     IF l_sma126 = 'Y' THEN
        CALL t700_tch3_shb111() RETURNING l_shb111,l_sgl08_min
        IF g_shb.shb111 > l_sgl08_min - l_shb111 THEN
           CALL cl_err('','asf-111',0)
           LET g_fieldstr = '111'
           RETURN
        END IF
     END IF

    #若由AFTER FIELD shb111呼叫,則不繼續往下執行(檢核)
     IF g_flag = 1 THEN RETURN END IF    

     IF g_shb.shb115 < 0 THEN
        CALL cl_err('','aec-992',0)
        LET g_fieldstr = '115'
        RETURN
     END IF

     IF g_shb.shb112 < 0  THEN
        CALL cl_err('','aec-992',0)
        LET g_fieldstr = '112'
        RETURN
     ELSE
        IF t700_tch3_accept_qty('c') THEN    #檢查可報工數量
           LET g_fieldstr = '112'
           RETURN
        END IF
     END IF

     SELECT sma126 INTO l_sma126 FROM sma_file
     IF l_sma126 = 'Y' THEN
        CALL t700_tch3_shb112() RETURNING l_shb112,l_sgl09_max
        IF g_shb.shb112 > l_sgl09_max - l_shb112 THEN
           CALL cl_err('','asf-113',0)
           LET g_fieldstr = '112'
           RETURN
        END IF
     END IF

     IF g_shb.shb113 < 0  THEN
        CALL cl_err('','aec-992',0)
        LET g_fieldstr = '113'
        RETURN
     ELSE
        IF g_shb.shb113 = 0  THEN
           LET g_shb.shb12 = ''
           DISPLAY BY NAME g_shb.shb12
        END IF

        ## 檢查可報工數量
        IF t700_tch3_accept_qty('c') THEN
           LET g_fieldstr = '113'
           RETURN
        END IF
     END IF

     CALL t700_tch3_set_no_entry()

     IF g_shb.shb12 = g_shb.shb06 THEN
        CALL cl_err(g_shb.shb12,'aec-086',0)
        LET g_fieldstr = '12'
        RETURN
     ELSE
        IF g_shb.shb113 > 0 THEN
           IF cl_null(g_shb.shb12) THEN
              CALL cl_err('','aec-019',0)
              LET g_fieldstr = '12'
              RETURN
           END IF  

           ## 檢查是否有此下製程
           SELECT count(*) INTO g_cnt
             FROM ecm_file
            WHERE ecm01 = g_shb.shb05
              AND ecm03 = g_shb.shb12
           IF g_cnt = 0  THEN
              CALL cl_err(g_shb.shb12,'aec-085',0)
              DISPLAY BY NAME g_shb.shb12
              LET g_fieldstr = '12'
              RETURN
           END IF
        END IF
     END IF

     IF g_shb.shb114 < 0  THEN
        CALL cl_err('','aec-992',0)
        DISPLAY BY NAME g_shb.shb114
        LET g_fieldstr = '114'
        RETURN
     ELSE
       #檢查可報工數量
        IF t700_tch3_accept_qty('c') THEN  
           LET g_fieldstr = '114'
           RETURN
        END IF
     END IF

     IF g_shb.shb17 < 0  THEN
        CALL cl_err('','aec-992',0)
        LET g_fieldstr = '17'
        RETURN
     ELSE 
        ## 檢查可報工數量
        IF t700_tch3_accept_qty('c') THEN
           LET g_fieldstr = '17'
           RETURN
        END IF
     END IF 
END FUNCTION

#產生移轉單號
FUNCTION t700_tch3_getshb01()
   DEFINE li_result       LIKE type_file.num5

     IF cl_null(g_shb.shb01) THEN
        CALL s_check_no("asf","561","","9","shb_file","shb01","") 
             RETURNING li_result,g_shb.shb01

        CALL s_auto_assign_no("asf","561",g_shb.shb03,"9","shb_file","shb01","","","")
             RETURNING li_result,g_shb.shb01
        IF (NOT li_result) THEN
          LET g_success = 'N'
          CALL cl_err('取得單號失敗',STATUS,1)
        END IF
     END IF
END FUNCTION

FUNCTION crt_temptable()
    LET g_sql = "CREATE TABLE ",l_table_shc CLIPPED,
                "      (shc01  VARCHAR2(16),",	
                "       shc03  SMALLINT,",
                "       shc04  VARCHAR2(6),",
                "       shc05  DEC(15,3),", 
                "       shc06  SMALLINT,",		 			 
                "       shcacti VARCHAR2(1),",			 
                "       shcuser VARCHAR2(10),", 
                "       shcgrup VARCHAR2(10),",
                "       shcmodu VARCHAR2(10),", 
                "       shcdate DATE)"
    PREPARE crttmp_pre FROM g_sql
    EXECUTE crttmp_pre
END FUNCTION

FUNCTION drop_temptable()
    LET g_sql = "DROP TABLE ",l_table_shc CLIPPED
    PREPARE droptmp_pre FROM g_sql
    EXECUTE droptmp_pre
END FUNCTION
