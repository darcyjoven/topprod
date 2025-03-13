# Prog. Version..: '5.10.03-08.09.13(00009)'     #
# Pattern name...: ghri054.4gl
# Descriptions...: 
# Date & Author..: 20130620 by zhuzw

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
     g_hrcn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sel          LIKE type_file.chr1,        
        hrcn02       LIKE hrcn_file.hrcn02,        
        hrat01       LIKE hrat_file.hrat01,        #
        hrat02       LIKE hrat_file.hrat02,        #
        hrat04_name  LIKE hrao_file.hrao02,        #
        hrat05_name  LIKE hras_file.hras02,   # 
        hrcn04       LIKE hrcn_file.hrcn04,
        hrcn05       LIKE hrcn_file.hrcn05,
        hrcn06       LIKE hrcn_file.hrcn06,
        hrcn07       LIKE hrcn_file.hrcn07,
        hrcn08       LIKE hrcn_file.hrcn08,
        hrcn09       LIKE hrcn_file.hrcn09,
        hrcn09_name  LIKE hrbm_file.hrbm04,
        hrcn10       LIKE hrcn_file.hrcn10,
        hrcn12       LIKE hrcn_file.hrcn12,
        hrcn13       LIKE hrcn_file.hrcn13,
        hrcn01       LIKE hrcn_file.hrcn01,
        hrcm03       LIKE hrcm_file.hrcm03,
        hrcma04      LIKE hrcma_file.hrcma04,
        hrcma05      LIKE hrcma_file.hrcma05,
        hrcma06      LIKE hrcma_file.hrcma06,
        hrcma07      LIKE hrcma_file.hrcma07,
        hrcnconf     LIKE hrcn_file.hrcnconf,
        hrcnacti     LIKE hrcn_file.hrcnacti,
        hrcn11       LIKE hrcn_file.hrcn11,
        hrcn14       LIKE hrcn_file.hrcn14
                    END RECORD,
    g_hrcn_t         RECORD                      #程式變數 (舊值)
        sel          LIKE type_file.chr1,        
        hrcn02       LIKE hrcn_file.hrcn02,        
        hrat01       LIKE hrat_file.hrat01,        #
        hrat02       LIKE hrat_file.hrat02,        #
        hrat04_name  LIKE hrao_file.hrao02,        #
        hrat05_name  LIKE hras_file.hras02,   # 
        hrcn04       LIKE hrcn_file.hrcn04,
        hrcn05       LIKE hrcn_file.hrcn05,
        hrcn06       LIKE hrcn_file.hrcn06,
        hrcn07       LIKE hrcn_file.hrcn07,
        hrcn08       LIKE hrcn_file.hrcn08,
        hrcn09       LIKE hrcn_file.hrcn09,
        hrcn09_name  LIKE hrbm_file.hrbm04,
        hrcn10       LIKE hrcn_file.hrcn10,
        hrcn12       LIKE hrcn_file.hrcn12,
        hrcn13       LIKE hrcn_file.hrcn13,
        hrcn01       LIKE hrcn_file.hrcn01,
        hrcm03       LIKE hrcm_file.hrcm03,
        hrcma04      LIKE hrcma_file.hrcma04,
        hrcma05      LIKE hrcma_file.hrcma05,
        hrcma06      LIKE hrcma_file.hrcma06,
        hrcma07      LIKE hrcma_file.hrcma07,
        hrcnconf     LIKE hrcn_file.hrcnconf,
        hrcnacti     LIKE hrcn_file.hrcnacti,
        hrcn11       LIKE hrcn_file.hrcn11,
        hrcn14       LIKE hrcn_file.hrcn14 
                    END RECORD,
    g_hrcn_t1     DYNAMIC ARRAY OF RECORD  
          sel1          LIKE type_file.chr1,                    
        hrcn02       LIKE hrcn_file.hrcn02,        
        hrat01       LIKE hrat_file.hrat01,        #
        hrat02       LIKE hrat_file.hrat02,        #
        hrat04_name  LIKE hrao_file.hrao02,        #
        hrat05_name  LIKE hras_file.hras02,        # 
        hrcn04       LIKE hrcn_file.hrcn04,
        hrcn05       LIKE hrcn_file.hrcn05,
        hrcn06       LIKE hrcn_file.hrcn06,
        hrcn07       LIKE hrcn_file.hrcn07,
        hrcn08       LIKE hrcn_file.hrcn08,
        hrcn09       LIKE hrcn_file.hrcn09,
        hrcn09_name  LIKE hrbm_file.hrbm04,
        hrcn10       LIKE hrcn_file.hrcn10,
        hrcn12       LIKE hrcn_file.hrcn12,
        hrcn13       LIKE hrcn_file.hrcn13,
        hrcn01       LIKE hrcn_file.hrcn01,
        hrcm03       LIKE hrcm_file.hrcm03,
        hrcma04      LIKE hrcma_file.hrcma04,
        hrcma05      LIKE hrcma_file.hrcma05,
        hrcma06      LIKE hrcma_file.hrcma06,
        hrcma07      LIKE hrcma_file.hrcma07,
        hrcnconf     LIKE hrcn_file.hrcnconf,
        hrcnacti     LIKE hrcn_file.hrcnacti,
        hrcn11       LIKE hrcn_file.hrcn11,
        hrcn14       LIKE hrcn_file.hrcn14 
                    END RECORD,                    
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,        #單身筆數
    l_ac            LIKE type_file.num5         #目前處理的ARRAY CNT

DEFINE g_forupd_sql STRING     #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change,g_rec_b1  LIKE type_file.num5    
DEFINE g_row_count  LIKE type_file.num5   
DEFINE g_curs_index LIKE type_file.num5  
DEFINE g_str        STRING              
DEFINE g_flag       LIKE type_file.chr1
MAIN
    DEFINE p_row,p_col   LIKE type_file.num5

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
         RETURNING g_time

    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i054_w AT p_row,p_col WITH FORM "ghr/42f/ghri054"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_set_comp_visible('sel,sel1',FALSE)
    LET g_flag = 1
    CALL cl_ui_init()
    CALL i054_menu()
    CLOSE WINDOW i054_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
         RETURNING g_time
END MAIN

FUNCTION i054_menu()
DEFINE l_msg STRING
   WHILE TRUE
      IF g_flag = 1 THEN 
         CALL i054_bp("G")
      ELSE 
    	   CALL i054_bp1("G")
    	END IF    
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i054_q()
            END IF
         WHEN "plan" 
            IF cl_chk_act_auth() THEN
               CALL i054_1()
               CALL cl_err('','ghr-033',1)
            END IF            
         WHEN "bwork" 
            IF cl_chk_act_auth() THEN
               CALL i054_2('bwork')
               CALL cl_err('','ghr-033',1)
            END IF 
         WHEN "ework" 
            IF cl_chk_act_auth() THEN
               CALL i054_2('ework')
               CALL cl_err('','ghr-033',1)
            END IF             
         WHEN "page1" 
            IF cl_chk_act_auth() THEN
               LET g_flag = 1
               CALL i054_b_fill(g_wc2)
            END IF
         WHEN "page2" 
            IF cl_chk_act_auth() THEN
               LET g_flag = 2
               CALL i054_b_fill1(g_wc2)
            END IF            
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i054_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "confirm"
           IF cl_chk_act_auth() THEN  
               CALL i054_b_fill(g_wc2)
               CALL i054_y()
            END IF   
         WHEN "unconfirm"
           IF cl_chk_act_auth() THEN  
               CALL i054_b_fill1(g_wc2)                     
               CALL i054_z()
            END IF              
         WHEN "help"
            CALL cl_show_help()
         #add by zhuzw 20140926 start   
         WHEN "cjplan"
            IF cl_chk_act_auth() THEN
               LET l_msg="ghri054_bj 0000 Y "
               CALL cl_cmdrun_wait(l_msg)
               CALL cl_err('','ghr-033',1)
            END IF            
         #add by zhuzw 20140926 end    
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_hrcn[l_ac].hrcn01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrcn01"
                  LET g_doc.value1 = g_hrcn[l_ac].hrcn01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcn),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i054_q()
   CALL i054_b_askkey()
END FUNCTION

FUNCTION i054_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,                 #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否
    p_cmd           LIKE type_file.chr1,                 #處理狀態 
    l_allow_insert  LIKE type_file.chr1,                 #可新增否
    l_allow_delete  LIKE type_file.chr1,                 #可刪除否
    v,l_str         string,
    l_hrcn02         LIKE hrcn_file.hrcn02,
    l_hratid        LIKE hrat_file.hratid
DEFINE  g_h,g_m   LIKE  type_file.num5     
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    CALL cl_set_comp_entry("hrcn01,hrcn02,hrcn03,hrcn04,hrcn05,hrcn06,hrcn07,hrcn08,hrcn09,hrcn10,hrcn11,hrcn12,hrcn13,hrcnacti,hrat01,hrat02,hrcn02,hrcn10,hrat04_name,hrat05_name,hrcm03,hrcma04,hrcma05,hrcma06,hrcma07,hrcnconf",TRUE )                                      

    LET g_forupd_sql = "SELECT '',hrcn02,'','','','',hrcn04,hrcn05,hrcn06,hrcn07,hrcn08,hrcn09,'',hrcn10,hrcn12,hrcn13,hrcn01,'','','','','',hrcnconf,hrcnacti,hrcn11,hrcn14 ",
                       "  FROM hrcn_file WHERE hrcn02=? FOR UPDATE NOWAIT"
    DECLARE i054_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_hrcn WITHOUT DEFAULTS FROM s_hrcn.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 

    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
       CALL cl_set_comp_entry("hrat01,hrcn04,hrcn05,hrcn06,hrcn07,hrcn08,hrcn09,hrcn11,hrcn12,hrcn13",TRUE) 
       CALL i054_set_no_entry(p_cmd)  

    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
        LET g_on_change = TRUE 

        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_before_input_done = FALSE                                      
           LET g_before_input_done = TRUE                                       
           LET g_hrcn_t.* = g_hrcn[l_ac].*  #BACKUP
           IF g_hrcn[l_ac].hrcn10 = 'N' THEN 
              CALL cl_set_comp_entry("hrat01,hrcn04,hrcn05,hrcn06,hrcn07,hrcn08,hrcn09,hrcn11,hrcn12,hrcn13",FALSE)
           #130813jiangxt-start
           ELSE
              CALL cl_set_comp_entry("hrat01,hrcn04,hrcn05,hrcn06,hrcn07,hrcn08,hrcn09,hrcn11,hrcn12,hrcn13",TRUE)           
           END IF 
           IF g_hrcn[l_ac].hrcnconf = 'Y' THEN 
              CALL cl_set_comp_entry("hrat01,hrcn04,hrcn05,hrcn06,hrcn07,hrcn08,hrcn09,hrcn11,hrcn12,hrcn13",FALSE)
           END IF  
           #130813jiangxt-end
           OPEN i054_bcl USING g_hrcn_t.hrcn02
           IF STATUS THEN
              CALL cl_err("OPEN i054_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i054_bcl INTO g_hrcn[l_ac].*
              SELECT hrat01 INTO g_hrcn[l_ac].hrat01 FROM hrat_file,hrcn_file
               WHERE hratid = hrcn03
                 AND hrcn02 = g_hrcn[l_ac].hrcn02
              SELECT hrao02,hrat02 INTO g_hrcn[l_ac].hrat04_name,g_hrcn[l_ac].hrat02  FROM hrao_file,hrat_file
               WHERE hrat01= g_hrcn[l_ac].hrat01 
                 AND hrat04 = hrao01
              SELECT hras02 INTO g_hrcn[l_ac].hrat05_name FROM hras_file,hrat_file
               WHERE hrat01= g_hrcn[l_ac].hrat01 
                 AND hrat05 = hras01  
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrcn_t.hrcn02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()
        END IF

     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                        
         CALL i054_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
         INITIALIZE g_hrcn[l_ac].* TO NULL
         LET g_hrcn[l_ac].hrcnacti = 'Y'       #Body default
         LET g_hrcn_t.* = g_hrcn[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM hrcn_file 
         IF l_n >0 THEN 
            SELECT MAX(hrcn02) + 1 INTO g_hrcn[l_ac].hrcn02 FROM hrcn_file
         ELSE 
         	  LET g_hrcn[l_ac].hrcn02 = 1
         END IF  
         CALL cl_set_comp_entry("hrat01,hrcn04,hrcn05,hrcn06,hrcn07,hrcn08,hrcn09,hrcn11,hrcn12,hrcn13",TRUE)   
         DISPLAY BY NAME g_hrcn[l_ac].hrcn02
         NEXT FIELD hrat01

     AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i054_bcl
           CANCEL INSERT
        END IF

        BEGIN WORK 
        SELECT hratid INTO l_hratid FROM hrat_file
         WHERE hrat01 = g_hrcn[l_ac].hrat01
        INSERT INTO hrcn_file(hrcn01,hrcn02,hrcn03,hrcn04,hrcn05,
                              hrcn06,hrcn07,hrcn08,hrcn09,hrcn10,
                              hrcn11,hrcn12,hrcn13,hrcn14,hrcnconf,hrcnacti)
               VALUES(g_hrcn[l_ac].hrcn01,g_hrcn[l_ac].hrcn02,
                      l_hratid,g_hrcn[l_ac].hrcn04,
                      g_hrcn[l_ac].hrcn05,g_hrcn[l_ac].hrcn06,
                      g_hrcn[l_ac].hrcn07,g_hrcn[l_ac].hrcn08,
                      g_hrcn[l_ac].hrcn09,g_hrcn[l_ac].hrcn10,
                      g_hrcn[l_ac].hrcn11,g_hrcn[l_ac].hrcn12,
                      g_hrcn[l_ac].hrcn13,g_hrcn[l_ac].hrcn14,
                      g_hrcn[l_ac].hrcnconf,g_hrcn[l_ac].hrcnacti)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrcn_file",g_hrcn[l_ac].hrcn02,"",SQLCA.sqlcode,"","",1)
           ROLLBACK WORK         
           CANCEL INSERT
        ELSE
           COMMIT WORK 
        END IF

     AFTER FIELD hrat01                       
        IF NOT cl_null(g_hrcn[l_ac].hrat01) THEN
           LET l_n = 0
           SELECT count(*) INTO l_n FROM hrat_file
            WHERE hrat01 = g_hrcn[l_ac].hrat01
             AND hratconf = 'Y'
           IF l_n = 0 THEN
               CALL cl_err(g_hrcn[l_ac].hrat01,'ghr-081',0)
               NEXT FIELD hrat01
           END IF
           SELECT hrao02,hrat02 INTO g_hrcn[l_ac].hrat04_name,g_hrcn[l_ac].hrat02  FROM hrao_file,hrat_file
            WHERE hrat01= g_hrcn[l_ac].hrat01 
             AND hrat04 = hrao01
           SELECT hras02 INTO g_hrcn[l_ac].hrat05_name FROM hras_file,hrat_file
            WHERE hrat01= g_hrcn[l_ac].hrat01 
             AND hrat05 = hras01 
           LET g_hrcn[l_ac].hrcn04 = g_today
           LET g_hrcn[l_ac].hrcn05 = '00:00'
           LET g_hrcn[l_ac].hrcn06 = ''
           LET g_hrcn[l_ac].hrcn07 = '00:00'
           LET g_hrcn[l_ac].hrcn08 = 0
           LET g_hrcn[l_ac].hrcn10 = 'Y'
           LET g_hrcn[l_ac].hrcn12 = 0
           LET g_hrcn[l_ac].hrcn13 = 0
           LET g_hrcn[l_ac].hrcnconf = 'N'
           LET g_hrcn[l_ac].hrcnacti = 'Y'
           
        END IF

     AFTER FIELD hrcn04
       IF NOT cl_null(g_hrcn[l_ac].hrcn04) AND NOT cl_null(g_hrcn[l_ac].hrcn06) THEN
          IF g_hrcn[l_ac].hrcn04 > g_hrcn[l_ac].hrcn06 THEN 
             CALL cl_err('','alm1038',0)
             NEXT FIELD hrcn04
          END IF
       END IF 
     AFTER FIELD hrcn06
       IF NOT cl_null(g_hrcn[l_ac].hrcn04) AND NOT cl_null(g_hrcn[l_ac].hrcn06) THEN
          IF g_hrcn[l_ac].hrcn04 > g_hrcn[l_ac].hrcn06 THEN 
             CALL cl_err('','alm1038',0)
             NEXT FIELD hrcn04
          END IF
       END IF
       IF  cl_null(g_hrcn[l_ac].hrcn04) THEN
             NEXT FIELD hrcn04
       END IF       
       IF  cl_null(g_hrcn[l_ac].hrcn06) THEN
             NEXT FIELD hrcn06
       END IF 
     AFTER FIELD hrcn05
         IF NOT cl_null(g_hrcn[l_ac].hrcn05) THEN
            LET g_h=''
            LET g_m=''
            LET g_h=g_hrcn[l_ac].hrcn05[1,2]
            LET g_m=g_hrcn[l_ac].hrcn05[4,5]
            IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
               CALL cl_err('时间录入错误','!',0)
               NEXT FIELD hrcn05
            END IF
           IF g_hrcn[l_ac].hrcn05[1] =' ' OR g_hrcn[l_ac].hrcn05[2] =' '  OR      
              g_hrcn[l_ac].hrcn05[4] =' ' OR g_hrcn[l_ac].hrcn05[5] =' ' THEN 
               CALL cl_err('时间录入错误','!',0)
               NEXT FIELD hrcn05
            END IF
         END IF 
     AFTER FIELD hrcn07
         IF NOT cl_null(g_hrcn[l_ac].hrcn07) THEN
            LET g_h=''
            LET g_m=''
            LET g_h=g_hrcn[l_ac].hrcn07[1,2]
            LET g_m=g_hrcn[l_ac].hrcn07[4,5]
            IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
               CALL cl_err('时间录入错误','!',0)
               NEXT FIELD hrcn05
            END IF
           IF g_hrcn[l_ac].hrcn07[1] =' ' OR g_hrcn[l_ac].hrcn07[2] =' '  OR      
              g_hrcn[l_ac].hrcn07[4] =' ' OR g_hrcn[l_ac].hrcn07[5] =' ' THEN 
               CALL cl_err('时间录入错误','!',0)
               NEXT FIELD hrcn07
            END IF
         END IF 
     AFTER FIELD hrcn08
       IF NOT cl_null(g_hrcn[l_ac].hrcn08) THEN
          IF g_hrcn[l_ac].hrcn08 < 0  THEN 
             CALL cl_err(g_hrcn[l_ac].hrcn08,'aim-223',0)
             NEXT FIELD hrcn04
          END IF
       END IF   
     AFTER FIELD hrcn09
       IF NOT cl_null(g_hrcn[l_ac].hrcn09) THEN
          LET l_n = 0 
          SELECT COUNT(*) INTO l_n FROM hrbm_file 
           WHERE hrbm07 ='Y' AND hrbm02  ='008'  AND hrbm03 = g_hrcn[l_ac].hrcn09
           IF l_n <=0 THEN  
              CALL cl_err('','mfg1306',0)            
              NEXT FIELD hrcn09 
           ELSE 
              SELECT hrbm04 INTO g_hrcn[l_ac].hrcn09_name FROM hrbm_file 
               WHERE hrbm07 ='Y' AND hrbm02  ='008'  AND hrbm03 = g_hrcn[l_ac].hrcn09 
              DISPLAY BY NAME g_hrcn[l_ac].hrcn09_name           	     
           END IF 
       END IF  
      AFTER FIELD hrcn14 
         IF  cl_null(g_hrcn[l_ac].hrcn14) THEN  
             MESSAGE "该栏位不可为空!"
             NEXT FIELD hrcn14
         END IF
#     AFTER FIELD hrcn01
#       IF NOT cl_null(g_hrcn[l_ac].hrcn01) THEN
#          LET l_n = 0 
#          SELECT COUNT(*) INTO l_n FROM hrcm_file 
#           WHERE hrcm02 = g_hrcn[l_ac].hrcn01 
#             AND hrcmconf = 'Y'
#           IF l_n <=0 THEN  
#              CALL cl_err('','mfg1306',0)            
#              NEXT FIELD hrcn01 
#           END IF 
#       END IF                             
     BEFORE DELETE                            #是否取消單身
         IF g_hrcn_t.hrcn02 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               ROLLBACK WORK
               CANCEL DELETE 
            END IF 
            IF (NOT cl_del_itemname("hrcn_file","hrcn02", g_hrcn_t.hrcn02)) THEN 
               ROLLBACK WORK
               RETURN
            END IF
            DELETE FROM hrcn_file WHERE hrcn02 = g_hrcn_t.hrcn02
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","hrcn_file",g_hrcn_t.hrcn02,"",SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE
                EXIT INPUT
            END IF
         END IF

     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_hrcn[l_ac].* = g_hrcn_t.*
          CLOSE i054_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_hrcn[l_ac].hrcn02,-263,0)
           LET g_hrcn[l_ac].* = g_hrcn_t.*
        ELSE
          SELECT hratid INTO l_hratid FROM hrat_file 
           WHERE hrat01 = g_hrcn[l_ac].hrat01
            AND hratconf = 'Y'
           UPDATE hrcn_file SET hrcn01=g_hrcn[l_ac].hrcn01,
                                hrcn02=g_hrcn[l_ac].hrcn02,
                                hrcn03=l_hratid,
                                hrcn04=g_hrcn[l_ac].hrcn04,
                                hrcn05=g_hrcn[l_ac].hrcn05,
                                hrcn06=g_hrcn[l_ac].hrcn06,
                                hrcn07=g_hrcn[l_ac].hrcn07,
                                hrcn08=g_hrcn[l_ac].hrcn08,
                                hrcn09=g_hrcn[l_ac].hrcn09,
                                hrcn10=g_hrcn[l_ac].hrcn10,
                                hrcn11=g_hrcn[l_ac].hrcn11,
                                hrcn12=g_hrcn[l_ac].hrcn12,
                                hrcn13=g_hrcn[l_ac].hrcn13,
                                hrcn14=g_hrcn[l_ac].hrcn14,
                                hrcnacti=g_hrcn[l_ac].hrcnacti
           WHERE hrcn02 = g_hrcn_t.hrcn02
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","hrcn_file",g_hrcn_t.hrcn02,"",SQLCA.sqlcode,"","",1) 
              ROLLBACK WORK 
              LET g_hrcn[l_ac].* = g_hrcn_t.*
           ELSE
              COMMIT WORK
           END IF
        END IF

     AFTER ROW
        LET l_ac = ARR_CURR()            # 新增
        LET l_ac_t = l_ac                # 新增

        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_hrcn[l_ac].* = g_hrcn_t.*
           END IF
           CLOSE i054_bcl                # 新增
           ROLLBACK WORK                 # 新增
           EXIT INPUT
         END IF
         CLOSE i054_bcl                  # 新增
         COMMIT WORK

     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(hrcn02) AND l_ac > 1 THEN
             LET g_hrcn[l_ac].* = g_hrcn[l_ac-1].*
             NEXT FIELD hrat01
         END IF

       ON ACTION controlp
           CASE WHEN INFIELD(hrat01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_hrat01"
                     LET g_qryparam.default1 = g_hrcn[l_ac].hrat01
                     CALL cl_create_qry() RETURNING g_hrcn[l_ac].hrat01
                     DISPLAY g_hrcn[l_ac].hrat01 TO hrat01
                WHEN INFIELD(hrcn09)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_hrbm03"
                     LET g_qryparam.arg1 = '008'
                     LET g_qryparam.default1 = g_hrcn[l_ac].hrcn09
                     CALL cl_create_qry() RETURNING g_hrcn[l_ac].hrcn09
                     DISPLAY g_hrcn[l_ac].hrcn09 TO hrcn09  
                WHEN INFIELD(hrcn01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "g_hrcm02"
                     LET g_qryparam.default1 = g_hrcn[l_ac].hrcn01
                     CALL cl_create_qry() RETURNING g_hrcn[l_ac].hrcn01
                     DISPLAY g_hrcn[l_ac].hrcn01 TO hrcn01                                          
                OTHERWISE
                     EXIT CASE
            END CASE
            

     ON ACTION CONTROLZ
        CALL cl_show_req_fields()

     ON ACTION CONTROLG
        CALL cl_cmdask()

     ON ACTION CONTROLF
        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      ON ACTION about 
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()

    END INPUT

    CLOSE i054_bcl
    COMMIT WORK
     
END FUNCTION
FUNCTION i054_b_askkey()
    CLEAR FORM
    CALL g_hrcn.clear()

    CONSTRUCT g_wc2 ON hrcn02,hrat01,hrcn04,hrcn05,hrcn06,hrcn07,hrcn08,hrcn09,hrcn10,hrcn12,hrcn13,hrcn01,hrcnconf,hrcnacti,hrcn11,hrcn14
         FROM s_hrcn[1].hrcn02,s_hrcn[1].hrat01,
              s_hrcn[1].hrcn04,s_hrcn[1].hrcn05,s_hrcn[1].hrcn06,s_hrcn[1].hrcn07,
              s_hrcn[1].hrcn08,s_hrcn[1].hrcn09,s_hrcn[1].hrcn10,
              s_hrcn[1].hrcn12,s_hrcn[1].hrcn13,s_hrcn[1].hrcn01,
              s_hrcn[1].hrcnconf,s_hrcn[1].hrcnacti,s_hrcn[1].hrcn11,s_hrcn[1].hrcn14

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE WHEN INFIELD(hrat01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_hrat01"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_hrcn[1].hrat01
              WHEN INFIELD(hrcn09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "g_hrbm03"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_hrcn[1].hrcn09
              WHEN INFIELD(hrcn01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "g_hrcm02"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_hrcn[1].hrcn01                                      
              OTHERWISE
                   EXIT CASE
         END CASE

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help() 
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrcnuser', 'hrcngrup')
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF
    CALL i054_b_fill(g_wc2)

END FUNCTION

FUNCTION i054_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_hrcn03 LIKE hrcn_file.hrcn03
    DEFINE p_wc2           STRING
    LET g_flag = 1
    IF cl_null(p_wc2) THEN 
       LET p_wc2 = '1=1'
    END IF 
    LET g_sql = "SELECT 'N',hrcn02,hrat01,hrat02,'','',hrcn04,hrcn05,hrcn06,hrcn07,hrcn08,hrcn09,'',hrcn10,hrcn12,hrcn13,hrcn01,'','','','','',hrcnconf,hrcnacti,hrcn11,hrcn14 ",
                " FROM hrcn_file,hrat_file ",
                " WHERE hrcn03 = hratid  AND hrcnconf ='N' AND ", p_wc2 CLIPPED,           #單身
                " ORDER BY hrcn02 " 

    PREPARE i054_pb FROM g_sql
    DECLARE hrcn_curs CURSOR FOR i054_pb

    CALL g_hrcn.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrcn_curs INTO g_hrcn[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT hrao02 INTO g_hrcn[g_cnt].hrat04_name FROM hrao_file,hrat_file
         WHERE hrat01= g_hrcn[g_cnt].hrat01 
           AND hrat04 = hrao01
        SELECT hras04 INTO g_hrcn[g_cnt].hrat05_name FROM hras_file,hrat_file
         WHERE hrat01= g_hrcn[g_cnt].hrat01 
           AND hrat05 = hras01
        IF NOT cl_null(g_hrcn[g_cnt].hrcn01) THEN 
           SELECT hrcn03 INTO l_hrcn03 FROM hrcn_file 
            WHERE hrcn02 = g_hrcn[g_cnt].hrcn02
           SELECT hrcm03,hrcma04,hrcma05,hrcma06,hrcma07 INTO g_hrcn[g_cnt].hrcm03,g_hrcn[g_cnt].hrcma04,g_hrcn[g_cnt].hrcma05,g_hrcn[g_cnt].hrcma06,g_hrcn[g_cnt].hrcma07 FROM hrcma_file,hrcm_file 
            WHERE hrcm02 = hrcma02
              AND hrcma03 = l_hrcn03
              AND hrcm02 = g_hrcn[g_cnt].hrcn01
        END IF               
        SELECT hrbm04 INTO g_hrcn[g_cnt].hrcn09_name FROM hrbm_file 
         WHERE hrbm07 ='Y' AND hrbm02  ='008'  AND hrbm03 = g_hrcn[g_cnt].hrcn09  
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrcn.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0

END FUNCTION
FUNCTION i054_b_fill1(p_wc2)              #BODY FILL UP
DEFINE l_hrcn03 LIKE hrcn_file.hrcn03
    DEFINE p_wc2           STRING
    LET g_flag = 2
    IF cl_null(p_wc2) THEN 
       LET p_wc2 = '1=1'
    END IF
    CALL cl_set_act_visible("accept,cancel", FALSE)
    
    LET g_sql = "SELECT 'N',hrcn02,hrat01,hrat02,'','',hrcn04,hrcn05,hrcn06,hrcn07,hrcn08,hrcn09,'',hrcn10,hrcn12,hrcn13,hrcn01,'','','','','',hrcnconf,hrcnacti,hrcn11,hrcn14 ",
                " FROM hrcn_file,hrat_file ",
                " WHERE hrcn03 = hratid AND hrcnconf = 'Y' AND ", p_wc2 CLIPPED,           #單身
                " ORDER BY hrcn02 " 

    PREPARE i054_pb1 FROM g_sql
    DECLARE hrcn_curs1 CURSOR FOR i054_pb1

    CALL g_hrcn_t1.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrcn_curs1 INTO g_hrcn_t1[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT hrao02 INTO g_hrcn_t1[g_cnt].hrat04_name FROM hrao_file,hrat_file
         WHERE hrat01= g_hrcn_t1[g_cnt].hrat01 
           AND hrat04 = hrao01
        SELECT hras04 INTO g_hrcn_t1[g_cnt].hrat05_name FROM hras_file,hrat_file
         WHERE hrat01= g_hrcn_t1[g_cnt].hrat01 
           AND hrat05 = hras01
        IF NOT cl_null(g_hrcn_t1[g_cnt].hrcn01) THEN 
           SELECT hrcn03 INTO l_hrcn03 FROM hrcn_file 
            WHERE hrcn02 = g_hrcn_t1[g_cnt].hrcn02
           SELECT hrcm03,hrcma04,hrcma05,hrcma06,hrcma07 INTO g_hrcn_t1[g_cnt].hrcm03,g_hrcn_t1[g_cnt].hrcma04,g_hrcn_t1[g_cnt].hrcma05,g_hrcn_t1[g_cnt].hrcma06,g_hrcn_t1[g_cnt].hrcma07 FROM hrcma_file,hrcm_file 
            WHERE hrcm02 = hrcma02
              AND hrcma03 = l_hrcn03
              AND hrcm02 = g_hrcn_t1[g_cnt].hrcn01
        END IF               
        SELECT hrbm04 INTO g_hrcn_t1[g_cnt].hrcn09_name FROM hrbm_file 
         WHERE hrbm07 ='Y' AND hrbm02  ='008'  AND hrbm03 = g_hrcn_t1[g_cnt].hrcn09
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrcn_t1.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
FUNCTION i054_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   LET g_row_count = 0
   LET g_curs_index = 0

   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DISPLAY ARRAY g_hrcn TO s_hrcn.* ATTRIBUTE(COUNT=g_rec_b)   
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
#      ON ACTION plan
#         LET g_action_choice="plan"
#         EXIT DISPLAY
#      ON ACTION cjplan
#         LET g_action_choice="cjplan"
#         EXIT DISPLAY
#      ON ACTION bwork
#         LET g_action_choice="bwork"
#         EXIT DISPLAY
#      ON ACTION ework
#         LET g_action_choice="ework"
#         EXIT DISPLAY         
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY 
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY                  
      ON ACTION PAGE1
         LET g_action_choice="page1"
         EXIT DISPLAY
      ON ACTION PAGE2
         LET g_action_choice="page2"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
   
       ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION i054_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   LET g_row_count = 0
   LET g_curs_index = 0

   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DISPLAY ARRAY g_hrcn_t1 TO s_hrcn1.* ATTRIBUTE(COUNT=g_rec_b1)   
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
#      ON ACTION plan
#         LET g_action_choice="plan"
#         EXIT DISPLAY
#      ON ACTION cjplan
#         LET g_action_choice="cjplan"
#         EXIT DISPLAY
#      ON ACTION bwork
#         LET g_action_choice="bwork"
#         EXIT DISPLAY
#      ON ACTION ework
#         LET g_action_choice="ework"
#         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY  
      ON ACTION PAGE1
         LET g_action_choice="page1"
         EXIT DISPLAY
      ON ACTION PAGE2
         LET g_action_choice="page2"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
   
       ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
                                                                
                                                                                
FUNCTION i054_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1
          
     CALL cl_set_comp_entry("hrcn01,hrat02,hrcn02,hrcn10,hrat04_name,hrat05_name,hrcn09_name,hrcm03,hrcma04,hrcma05,hrcma06,hrcma07,hrcnconf",FALSE)                                      
                                                                    
                                                                                
END FUNCTION      
FUNCTION i054_y()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5, 
    l_i             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1,
    l_hrat21        LIKE hrat_file.hrat21,
    l_hratid        LIKE hrat_file.hratid  
    IF g_rec_b <= 0 THEN 
       CALL cl_err('','ghr-121',1)
       RETURN 
    END IF    
 
    CALL  cl_set_comp_visible('sel',TRUE)
    CALL cl_set_comp_entry("hrcn01,hrcn02,hrcn03,hrcn04,hrcn05,hrcn06,hrcn07,hrcn08,hrcn09,hrcn10,hrcn11,hrcn12,hrcn13,hrcnacti,hrat01,hrat02,hrcn02,hrcn10,hrat04_name,hrat05_name,hrcm03,hrcma04,hrcma05,hrcma06,hrcma07,hrcnconf",FALSE)
    INPUT ARRAY g_hrcn  WITHOUT DEFAULTS FROM s_hrcn.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_rec_b,  UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
 
    BEFORE INPUT
        CALL cl_set_act_visible("accept,cancel",TRUE)		
       	
    BEFORE ROW
        LET l_ac = ARR_CURR()
        LET l_n  = ARR_COUNT()
        DISPLAY BY NAME g_hrcn[l_ac].sel
    	
      ON ACTION sel_all
         LET g_action_choice="sel_all" 
         LET l_i = 0        	
         FOR l_i = 1 TO g_rec_b
             LET g_hrcn[l_i].sel = 'Y'
             DISPLAY BY NAME g_hrcn[l_i].sel
         END FOR  
      ON ACTION sel_none
         LET g_action_choice="sel_none"   
         LET l_i = 0     	
         FOR l_i = 1 TO g_rec_b
             LET g_hrcn[l_i].sel = 'N'
            # DISPLAY BY NAME g_hrcn[l_i].sel
         END FOR
      ON ACTION accept
         LET l_i = 0
         FOR l_i = 1 TO g_rec_b
             IF  g_hrcn[l_i].sel = 'Y' THEN 
                 UPDATE hrcn_file SET hrcnconf = 'Y' WHERE hrcn02= g_hrcn[l_i].hrcn02
                 IF SQLCA.sqlcode THEN
                 ELSE 
                    CALL i054_uphrcp35(g_hrcn_t1[l_i].hrat01,g_hrcn_t1[l_i].hrcn14)
                 #add by zhuzw 20140919 start #间接员工生成调休计划
                    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcn[l_i].hrat01
                    SELECT hrat21 INTO l_hrat21 FROM hrat_file 
                     WHERE hratid = l_hratid
                    IF l_hrat21 = '002' THEN 
                       SELECT COUNT(*) INTO l_n FROM hrci_file
                        WHERE hrci01 = g_hrcn[l_i].hrcn02 AND hrci02 = l_hratid AND hrci03 = g_hrcn[l_i].hrcn14
                       IF l_n = 0 THEN  
                          CALL i054_txjh(g_hrcn[l_i].hrcn02)
                       ELSE
                          UPDATE hrci_file SET hrci05 = g_hrcn[l_i].hrcn08,hrci07 = g_hrcn[l_i].hrcn08,hrci09 = g_hrcn[l_i].hrcn08- hrci08 
                           WHERE hrci01 =  g_hrcn[l_i].hrcn02  AND hrci02 = l_hratid AND  hrci03 = g_hrcn[l_i].hrcn14
                       END IF 	 
                    END IF 
            #add by zhuzw 20140919 end #间接员工生成调休计划                     
                 END IF  
             END IF     
         END FOR 
         EXIT INPUT 
                                 
     END INPUT    
     CALL cl_set_comp_visible('sel,sel1',FALSE)  
     CALL i054_b_fill(g_wc2)
     CALL i054_b_fill1(g_wc2)     
END FUNCTION 
FUNCTION i054_z()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5, 
    l_i             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1,
    l_hrci08        LIKE hrci_file.hrci08,
    l_hratid        LIKE hrat_file.hratid  
    IF g_rec_b1 <= 0 THEN 
       CALL cl_err('','ghr-121',1)
       RETURN 
    END IF    
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    CALL  cl_set_comp_visible('sel1',TRUE)
    CALL cl_set_comp_entry("hrcn1,hrcn2,hrcn3,hrcn4,hrcn5,hrcn6,hrcn7,hrcn8,hrcn9,hrcn10_1,hrcn11_1,hrcn12_1,hrcn13_1,hrcnacti1,hrat1,hrat2,hrcn2,hrcn10_1,hrat04_name1,hrat05_name1,hrcm3,hrcma4,hrcma5,hrcma6,hrcma7,hrcnconf1",FALSE)
    INPUT ARRAY g_hrcn_t1  WITHOUT DEFAULTS FROM s_hrcn1.*
          ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=g_rec_b1,  UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
 
    BEFORE INPUT
       CALL cl_set_act_visible("accept,cancel", TRUE)		
       	
#    BEFORE ROW
#        LET p_cmd='' 
#        LET l_ac = ARR_CURR()
#        LET l_lock_sw = 'N'            #DEFAULT
#        LET l_n  = ARR_COUNT()
    	
      ON ACTION sel_all
         LET g_action_choice="sel_all" 
         LET l_i = 0        	
         FOR l_i = 1 TO g_rec_b1
             LET g_hrcn_t1[l_i].sel1 = 'Y'
             DISPLAY BY NAME g_hrcn_t1[l_i].sel1
         END FOR  
      ON ACTION sel_none
         LET g_action_choice="sel_none"   
         LET l_i = 0     	
         FOR l_i = 1 TO g_rec_b1
             LET g_hrcn_t1[l_i].sel1 = 'N'
             DISPLAY BY NAME g_hrcn_t1[l_i].sel1
         END FOR
      ON ACTION accept
         FOR l_i = 1 TO g_rec_b1
             IF  g_hrcn_t1[l_i].sel1 = 'Y' THEN 
                 #add by zhuzw 20141030 start
                 SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcn_t1[l_i].hrat01
                 SELECT hrci08 INTO  l_hrci08 FROM hrci_file
                  WHERE hrci01 = g_hrcn_t1[l_i].hrcn02 AND hrci02 = l_hratid AND hrci03 =  g_hrcn_t1[l_i].hrcn14
                 IF l_hrci08 > 0 THEN 
                    CALL cl_err(g_hrcn_t1[l_i].hrcn02,'！',0)
                 ELSE 
                    UPDATE hrcn_file SET hrcnconf = 'N' WHERE hrcn02= g_hrcn_t1[l_i].hrcn02
                    IF SQLCA.sqlcode THEN
                    ELSE 
                       CALL i054_uphrcp35(g_hrcn_t1[l_i].hrat01,g_hrcn_t1[l_i].hrcn14)
                       DELETE FROM hrci_file
                        WHERE hrci01 = g_hrcn_t1[l_i].hrcn02 AND hrci02 = l_hratid AND hrci03 =  g_hrcn_t1[l_i].hrcn14
                    END IF                  
                 END IF 
                 #add by zhuzw 20141030 end                  
   
             END IF     
         END FOR 
         EXIT INPUT 
                                 
     END INPUT    
     CALL cl_set_comp_visible('sel,sel1',FALSE)  
     CALL i054_b_fill(g_wc2)
     CALL i054_b_fill1(g_wc2)     
END FUNCTION 
FUNCTION i054_uphrcp35(p_hrat01,p_hrcn14)
DEFINE l_hratid         LIKE hrat_file.hratid
DEFINE p_hrcn14         LIKE hrcn_file.hrcn14
DEFINE p_hrat01         LIKE hrat_file.hrat01
DEFINE l_k              LIKE type_file.num5
   SELECT hratid INTO l_hratid FROM hrat_file 
    WHERE hrat01 = p_hrat01
   SELECT COUNT(*) INTO l_k FROM hrcp_file WHERE hrcp02 = l_hratid AND hrcp03 = p_hrcn14
   IF l_k > 0 THEN 
    	UPDATE hrcp_file
    	   SET hrcp35 = 'N'
       WHERE hrcp02 = l_hratid AND hrcp03 = p_hrcn14
   END IF   
END FUNCTION         
#add by zhuzw 20140919 start
FUNCTION i054_txjh(p_hrcn02)
  DEFINE p_hrcn02   LIKE hrcn_file.hrcn02 
  DEFINE l_hrcn RECORD LIKE hrcn_file.*
  DEFINE l_hrci RECORD LIKE hrci_file.*
  DEFINE l_hrbl02 LIKE hrbl_file.hrbl02
  DEFINE l_hrat03 LIKE hrat_file.hrat03
  SELECT * INTO l_hrcn.* FROM hrcn_file
   WHERE hrcn02 = p_hrcn02
  LET l_hrci.hrci01 = p_hrcn02
  LET l_hrci.hrci02 = l_hrcn.hrcn03 
  LET l_hrci.hrci03 = l_hrcn.hrcn14
  LET l_hrci.hrci04 = l_hrcn.hrcn09
  LET l_hrci.hrci05 = l_hrcn.hrcn08
  LET l_hrci.hrci06 = 0
  LET l_hrci.hrci07 = l_hrci.hrci05
  LET l_hrci.hrci08 = 0
  LET l_hrci.hrci09 = l_hrci.hrci05
  SELECT hrat03 INTO l_hrat03 FROM hrat_file 
   WHERE hratid  = l_hrcn.hrcn03
  SELECT hrbl02 INTO l_hrbl02 FROM hrbl_file
   WHERE  hrbl01 = l_hrat03 
     AND hrbl06 <= l_hrci.hrci03 AND hrbl07 >= l_hrci.hrci03
  SELECT hrbl07 INTO  l_hrci.hrci10 FROM hrbl_file 
   WHERE hrbl02 = l_hrbl02 + 1   
  LET l_hrci.hrciacti ='Y'
  LET l_hrci.hrciconf ='Y' 
  INSERT INTO hrci_file VALUES (l_hrci.*)
END FUNCTION   
#add by zhuzw 20140919 end                   
