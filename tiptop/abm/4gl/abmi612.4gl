# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: abmi612.4gl
# Descriptions...: 分量損耗率維護作業
# Date & Author..: 08/01/10 By jan 
# Modify.........: No.FUN-810017 By jan
# Modify.........: No.FUN-830114 08/03/25 By jan  服飾作業修改
# Modify.........: No.FUN-870124 08/03/25 By jan  服飾作業修改
# Modify.........: No.FUN-8A0145 08/10/31 By arman 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A30003 10/03/02 By destiny 新增固定损耗率栏位
# Modify.........: No.FUN-A60031 10/06/12 By destiny 将固定损耗率改为固定损耗系数
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AC0104 10/12/25 By destiny 允许输入虚拟料号          
# Modify.........: No.FUN-AC0076 11/01/05 By wangxin 添加接受參數g_argv1
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.TQC-D40107 13/04/27 By dongsz 增加主件/元件規格欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_bof           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        bof01       LIKE bof_file.bof01,   #主件料號
        bof01_ima02 LIKE ima_file.ima02,   #主件名稱
        bof01_ima021 LIKE ima_file.ima021, #主件規格          #TQC-D40107 add
        bof02       LIKE bof_file.bof02,   #類型
        bof03       LIKE bof_file.bof03,   #元件料號/分群碼
        bof03_ima02 LIKE ima_file.ima02,   #元件名稱/分群碼名稱
        bof03_ima021 LIKE ima_file.ima021, #元件規格/分群碼規格  #TQC-D40107 add
        bof04       LIKE bof_file.bof04,   #生產起始量                          
        bof05       LIKE bof_file.bof05,   #生產截止量                          
        bof06       LIKE bof_file.bof06,   #No.FUN-A30003                        
        bof07       LIKE bof_file.bof07    #損耗率  #No.FUN-A60031          
                    END RECORD,
    g_bof_t         RECORD                 #程式變數 (舊值)
        bof01       LIKE bof_file.bof01,   #主件料號                            
        bof01_ima02 LIKE ima_file.ima02,   #主件名稱                            
        bof01_ima021 LIKE ima_file.ima021, #主件規格             #TQC-D40107 add
        bof02       LIKE bof_file.bof02,   #類型                                
        bof03       LIKE bof_file.bof03,   #元件料號/分群碼                     
        bof03_ima02 LIKE ima_file.ima02,   #元件名稱/分群碼名稱                 
        bof03_ima021 LIKE ima_file.ima021, #元件規格/分群碼規格  #TQC-D40107 add
        bof04       LIKE bof_file.bof04,   #生產起始量                          
        bof05       LIKE bof_file.bof05,   #生產截止量                          
        bof06       LIKE bof_file.bof06,   #No.FUN-A30003                        
        bof07       LIKE bof_file.bof07    #損耗率
                    END RECORD,
    g_wc2,g_sql,g_sql1,g_sql2,g_wc1    STRING,  
    l_za05          LIKE type_file.chr1000, 
    g_flag          LIKE type_file.chr1,    
    g_rec_b         LIKE type_file.num5,    
    p_row,p_col     LIKE type_file.num5,    
    l_ac            LIKE type_file.num5     
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL        
DEFINE   g_cnt           LIKE type_file.num10            
DEFINE   g_cnt1          LIKE type_file.num10
DEFINE   g_cnt2          LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        
DEFINE   g_before_input_done    LIKE type_file.num5     
DEFINE   g_bof_bof04     LIKE bof_file.bof04
DEFINE   g_bof_bof05     LIKE bof_file.bof05
DEFINE   g_bma_bma01     LIKE bma_file.bma01
DEFINE   g_imz_imz01     LIKE imz_file.imz01
DEFINE   g_argv1         LIKE bma_file.bma01  #FUN-AC0076 add  

MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1 = ARG_VAL(1)  #FUN-AC0076 add
   
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
        RETURNING g_time    
   LET p_row = 4 LET p_col = 3 
   OPEN WINDOW i612_w AT p_row,p_col WITH FORM "abm/42f/abmi612"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)     
   CALL cl_ui_init()
   
 
   LET g_wc2 = '1=1' 
   #FUN-AC0076 add ---------begin----------
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2 = " bof01 = '",g_argv1,"'"
    END IF
    #FUN-AC0076 add ----------end-----------
   CALL i612_b_fill(g_wc2)
   ERROR ""
   CALL i612_menu()
   CLOSE WINDOW i612_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
      RETURNING g_time    
END MAIN
 
FUNCTION i612_menu()
 
   WHILE TRUE
      CALL i612_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL i612_q() 
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN 
               CALL i612_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
#         WHEN "output" 
#            IF cl_chk_act_auth() THEN 
#               CALL i612_out()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"     
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bof),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i612_q()
   CALL i612_b_askkey()
END FUNCTION
 
FUNCTION i612_b()
DEFINE
    l_bof01         LIKE  bof_file.bof01,
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT        
    l_n             LIKE type_file.num5,          #檢查重複用       
    l_n1            LIKE type_file.num5,          #檢查重復用
    l_n2            LIKE type_file.num5,
    l_n3            LIKE type_file.num5,
    l_n4            LIKE type_file.num5,
    l_bof04         LIKE bof_file.bof04,
    l_bof05         LIKE bof_file.bof05,
    l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        
    p_cmd           LIKE type_file.chr1,          #處理狀態 
    l_allow_insert  LIKE type_file.chr1,          #可新增否
    l_allow_delete  LIKE type_file.chr1,          #可刪除否
    l_n5            LIKE type_file.num5,          #FUN-AC0104
    l_bmqacti       LIKE bmq_file.bmqacti         #FUN-AC0104
    
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT bof01,ima02,ima021,bof02,bof03,' ',' ',bof04,bof05,bof06,bof07 FROM bof_file,ima_file WHERE bof01=? AND bof02=? AND bof03=? AND bof04=? AND bof05=? AND ima01 = bof01 FOR UPDATE"  #No.FUN-A30003     #TQC-D40107 add ima021,' '
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i612_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_bof WITHOUT DEFAULTS FROM s_bof.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_bof_t.* = g_bof[l_ac].*         #新輸入資料
               LET g_before_input_done = FALSE                                                                                      
               CALL i612_set_entry(p_cmd)                                                                                           
               CALL i612_set_no_entry(p_cmd)                                                                                        
               LET g_before_input_done = TRUE                                                                                       
               BEGIN WORK
               OPEN i612_bcl USING g_bof_t.bof01,g_bof_t.bof02,g_bof_t.bof03,g_bof_t.bof04,g_bof_t.bof05
               IF STATUS THEN
                  CALL cl_err("OPEN i612_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i612_bcl INTO g_bof[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(" ",STATUS,1) 
                     LET l_lock_sw = "Y"
                  END IF
                  IF g_bof[l_ac].bof02 = "1" THEN                                                                                             
                   SELECT ima02 INTO g_bof[l_ac].bof03_ima02 FROM ima_file WHERE ima01 = g_bof[l_ac].bof03                                                               
                   SELECT ima021 INTO g_bof[l_ac].bof03_ima021 FROM ima_file WHERE ima01 = g_bof[l_ac].bof03    #TQC-D40107 add
                  ELSE                                                                                                                        
                   SELECT imz02 INTO g_bof[l_ac].bof03_ima02 FROM imz_file WHERE imz01 = g_bof[l_ac].bof03                     
 
                   LET g_bof[l_ac].bof03_ima021 = ''          #TQC-D40107 add                                          
                  END IF
               END IF
               CALL cl_show_fld_cont()     
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE                                                                                      
            CALL i612_set_entry(p_cmd)                                                                                           
            CALL i612_set_no_entry(p_cmd)                                                                                        
            LET g_before_input_done = TRUE                                                                                       
            INITIALIZE g_bof[l_ac].* TO NULL             
            LET g_bof_t.* = g_bof[l_ac].*         #新輸入資料
            LET g_bof[l_ac].bof07=0
            CALL cl_show_fld_cont()     
            NEXT FIELD bof01
 
      AFTER INSERT
         IF INT_FLAG THEN                 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO bof_file(bof01,bof02,bof03,bof04,bof05,bof06,bof07)    #No.FUN-A30003
          VALUES (g_bof[l_ac].bof01,g_bof[l_ac].bof02,
                  g_bof[l_ac].bof03,g_bof[l_ac].bof04,
                  g_bof[l_ac].bof05,g_bof[l_ac].bof06,g_bof[l_ac].bof07)     #No.FUN-A30003       
           IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","bof_file",g_bof[l_ac].bof01,g_bof[l_ac].bof02,SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2 
               COMMIT WORK
           END IF
 
        AFTER FIELD bof01                                                       
          IF NOT cl_null(g_bof[l_ac].bof01) THEN                              
            #FUN-AA0059 ---------------------------add start--------------------------
             SELECT bmqacti INTO l_bmqacti FROM bmq_file WHERE bmq01=g_bof[l_ac].bof01  #FUN-AC0104
             IF STATUS=100 THEN                                                         #FUN-AC0104 
                IF NOT s_chk_item_no(g_bof[l_ac].bof01,'') THEN
                   CALL cl_err('',g_errno,1)
                   LET g_bof[l_ac].bof01 = g_bof_t.bof01
                   DISPLAY BY NAME g_bof[l_ac].bof01
                   NEXT FIELD bof01
                END IF
             #FUN-AC0104--begin    
             ELSE  
             	  IF l_bmqacti !='Y' THEN 
             	     CALL cl_err('','9028',1)
             	     NEXT FIELD bof01
             	  END IF 
             END IF 
             #FUN-AC0104--end 
            #FUN-AA0059 ----------------------------add end---------------------------
             IF g_bof_t.bof01 IS NULL OR
                (g_bof[l_ac].bof01 != g_bof_t.bof01) THEN
                CALL i612_bof01('a')                     
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_bof[l_ac].bof01,g_errno,0)
                   LET g_bof[l_ac].bof01 = g_bof_t.bof01
                   DISPLAY BY NAME g_bof[l_ac].bof01
                   NEXT FIELD bof01
                END IF
              SELECT count(*) INTO l_n2 FROM bma_file,ima_file
              WHERE ima01 = g_bof[l_ac].bof01
                AND bma01 = ima01
#               AND ima151 != 'Y'   #No.FUN-870124
                AND imaacti ='Y'
              #FUN-AC0104--begin  
              SELECT COUNT(*) INTO l_n5 FROM bmo_file,bmq_file
               WHERE bmq01 = g_bof[l_ac].bof01
                 AND bmo01 = ima01
                 AND bmqacti ='Y'  
              IF l_n5=0 THEN 
              #FUN-AC0104--end
              IF l_n2 = 0 THEN
                 CALL cl_err('','mfg3006',0)                                                                                       
                 NEXT FIELD bof01
              END IF
              END IF 
           END IF
          END IF
        AFTER FIELD bof03                                                       
            IF NOT cl_null(g_bof[l_ac].bof03) THEN                               
              #FUN-AA0059 --------------------------add start---------------------------
               SELECT bmqacti INTO l_bmqacti FROM bmq_file WHERE bmq01=g_bof[l_ac].bof01  #FUN-AC0104
               IF STATUS=100 THEN                                                         #FUN-AC0104 
                  IF NOT s_chk_item_no(g_bof[l_ac].bof03,'') THEN
                     CALL cl_err('',g_errno,1)
                     LET g_bof[l_ac].bof03 = g_bof_t.bof03
                     DISPLAY BY NAME g_bof[l_ac].bof03
                     NEXT FIELD bof03
                  END IF 
               #FUN-AC0104--begin    
               ELSE  
               	  IF l_bmqacti !='Y' THEN 
               	     CALL cl_err('','9028',1)
               	     NEXT FIELD bof01
               	  END IF 
               END IF 
               #FUN-AC0104--end                
              #FUN-AA0059 ------------------------add end------------------------------   
               IF g_bof_t.bof03 IS NULL OR
                  (g_bof[l_ac].bof03 != g_bof_t.bof03) THEN
                  CALL i612_bof03('a')                                            
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_bof[l_ac].bof03,g_errno,0)
                    LET g_bof[l_ac].bof03 = g_bof_t.bof03
                    DISPLAY BY NAME g_bof[l_ac].bof03
                    NEXT FIELD bof03
                 END IF
               END IF                       
             IF g_bof[l_ac].bof02 = '1' THEN             
               IF g_bof[l_ac].bof03 = g_bof[l_ac].bof01 THEN
                  CALL cl_err('','msg003',0)
                  NEXT FIELD bof03
               END IF 
               #080926 carrier  --begin
              # SELECT count(*) INTO l_n3 FROM bma_file,ima_file                                                                      
              #WHERE ima01 = g_bof[l_ac].bof03                                                                                       
              #  AND bma01 = ima01                                                                                                   
              #  AND ima151 != 'Y'                                                                                                   
              #  AND imaacti ='Y'                                                                                                    
              # SELECT COUNT(*) INTO l_n3            #FUN-AC0104--mark
#No.FUN-870124--EBGIN
                 #FROM ima_file                      #FUN-AC0104--mark
#                FROM bma_file,bmb_file,ima_file
#                WHERE bmb01 = bma01 AND bmb29 = bma06
#                  AND bmb01 = g_bof[l_ac].bof01
#                  AND bmb03 = g_bof[l_ac].bof03
#                  AND ima01 = bmb03
#                  AND ima151 != 'Y'                   #No.FUN-870124                                                                                
                #WHERE  imaacti ='Y'                  #FUN-AC0104--mark
                #  AND  ima01 = g_bof[l_ac].bof03     #FUN-AC0104--mark 
#No.FUN-870124--END--
               #080926 carrier  --end   
              #FUN-AC0104--begin--mark 
              #IF l_n3 = 0 THEN                                                                                                      
#             #   CALL cl_err('','mfg3006',0)   #No.FUN-830114                                                                                      
              #   CALL cl_err('','mfg3021',0)   #No.FUN-830114                                                                                       
              #   NEXT FIELD bof03                                                                                                   
              #END IF
              #FUN-AC0104--end--mark
             END IF
             IF g_bof[l_ac].bof02 ='2' THEN         
              SELECT count(*) INTO l_n4 FROM imz_file
              WHERE imz01 = g_bof[l_ac].bof03
                AND imzacti = 'Y'
              IF l_n4 = 0 THEN
#                CALL cl_err('','mfg3006',0)  #No.FUN-830114                                                                                    
                 CALL cl_err('','mfg3022',0)  #No.FUN-830114                                                                                    
                 NEXT FIELD bof03
              END IF                                             
             END IF
            END IF
        AFTER FIELD bof04
           IF NOT cl_null(g_bof[l_ac].bof04)  THEN
            IF g_bof[l_ac].bof04 <0 THEN
               CALL cl_err('','mfg4012',0)
               NEXT FIELD bof04
            END IF
            IF g_bof[l_ac].bof04 != g_bof_t.bof04
              OR g_bof_t.bof04 IS NULL THEN  
              SELECT count(*)                                                                                                         
                INTO l_n1                                                                                                             
                FROM bof_file                                                                                                         
              WHERE bof01 = g_bof[l_ac].bof01                                                                                         
                AND bof02 = g_bof[l_ac].bof02                                                                                         
                AND bof03 = g_bof[l_ac].bof03                                                                                         
              IF l_n1 > 0 THEN
               IF g_bof_t.bof04 IS NULL THEN
                  LET g_sql1 = " SELECT bof04,bof05", 
                               "  FROM bof_file",
                               " WHERE bof01 = '",g_bof[l_ac].bof01,"'",                                                                                       
                               "   AND bof02 = '",g_bof[l_ac].bof02,"'",                                                                                       
                               "   AND bof03 = '",g_bof[l_ac].bof03,"'"
               END IF
               IF g_bof_t.bof04 != g_bof[l_ac].bof04 THEN
                  LET g_sql1 = " SELECT bof04,bof05",                                
                               "  FROM bof_file",                                    
                               " WHERE bof01 = '",g_bof[l_ac].bof01,"'",                                                                
                               "   AND bof02 = '",g_bof[l_ac].bof02,"'",                                                                
                               "   AND bof03 = '",g_bof[l_ac].bof03,"'",
                               "   AND bof04 != '",g_bof_t.bof04,"'",
                               "   AND bof05 != '",g_bof_t.bof05,"'"
               END IF
               PREPARE i612_prepare FROM g_sql1
               DECLARE bof1_curs CURSOR FOR i612_prepare
               LET g_cnt1 = 1
               LET g_success = 'Y'
               FOREACH bof1_curs INTO g_bof_bof04,g_bof_bof05
                 IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
                 IF g_bof[l_ac].bof04 >= g_bof_bof04 AND g_bof[l_ac].bof04 <= g_bof_bof05 THEN
                   CALL cl_err('','msg002',0)
                   LET g_success = 'N'
                   EXIT FOREACH
                 END IF
                 LET g_cnt1 = g_cnt1 + 1                                                                                                       
                 IF g_cnt1 > g_max_rec THEN                                                                                                   
                   CALL cl_err( '', 9035, 0 )                                                                                               
                   EXIT FOREACH                                                                                                             
                 END IF
               END FOREACH
               LET g_cnt1 = 0
               IF g_success = 'N' THEN
                 NEXT FIELD bof04
               ELSE
                 NEXT FIELD bof05
               END IF
              END IF
            END IF
           END IF
 
        BEFORE FIELD bof05
         IF cl_null(g_bof[l_ac].bof04) THEN                                   
              NEXT FIELD bof04                                                  
         END IF
 
        AFTER FIELD bof05
           IF NOT cl_null(g_bof[l_ac].bof05)  THEN
              IF g_bof[l_ac].bof05 <0 THEN                                                                                          
                 CALL cl_err('','mfg4012',0)                                                                                        
                 NEXT FIELD bof05                                                                                                   
              END IF
#             IF g_bof[l_ac].bof05 <= g_bof[l_ac].bof04 THEN   #No.FUN-830114                                                                      
              IF g_bof[l_ac].bof05 < g_bof[l_ac].bof04 THEN    #No.FUN-830114                                                                    
                  CALL cl_err('','msg001',1)                                                                                        
                  NEXT FIELD bof05
              END IF
            IF g_bof[l_ac].bof05 != g_bof_t.bof05
              OR g_bof_t.bof05 IS NULL THEN
              SELECT count(*)                                                                                                       
                INTO l_n1                                                                                                             
                FROM bof_file                                                                                                         
              WHERE bof01 = g_bof[l_ac].bof01                                                                                         
                AND bof02 = g_bof[l_ac].bof02                                                                                         
                AND bof03 = g_bof[l_ac].bof03                                                                                         
             IF l_n1 > 0 THEN
              IF g_bof_t.bof05 IS NULL THEN
                 LET g_sql2 = " SELECT bof04,bof05",                                
                              "  FROM bof_file",                                    
                              " WHERE bof01 = '",g_bof[l_ac].bof01,"'",                                                                
                              "   AND bof02 = '",g_bof[l_ac].bof02,"'",                                                                
                              "   AND bof03 = '",g_bof[l_ac].bof03,"'"
              END IF
              IF g_bof_t.bof05 != g_bof[l_ac].bof05 THEN
                 LET g_sql2 = " SELECT bof04,bof05",                                
                              "  FROM bof_file",                                    
                              " WHERE bof01 = '",g_bof[l_ac].bof01,"'",                                                                
                              "   AND bof02 = '",g_bof[l_ac].bof02,"'",                                                                
                              "   AND bof03 = '",g_bof[l_ac].bof03,"'",
                              "   AND bof04 != '",g_bof_t.bof04,"'",
                              "   AND bof05 != '",g_bof_t.bof05,"'"
              END IF
              PREPARE i612_ac FROM g_sql2                                        
              DECLARE bof2_curs CURSOR FOR i612_ac 
              LET g_cnt2 = 1  
              LET g_success = 'Y'
              FOREACH bof2_curs INTO g_bof_bof04,g_bof_bof05                
                IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
                IF (g_bof[l_ac].bof04 < g_bof_bof04 AND g_bof[l_ac].bof05 < g_bof_bof04) OR                                                   
                   (g_bof[l_ac].bof04 > g_bof_bof05 AND g_bof[l_ac].bof05 > g_bof_bof05) THEN                                                 
                    LET g_success = 'Y'
                ELSE                                                                                                                  
                    LET g_success = 'N'
                    CALL cl_err('','msg002',0)     
                    EXIT FOREACH
                END IF
                LET g_cnt2 = g_cnt2 + 1                                                                                             
                IF g_cnt2 > g_max_rec THEN                                                                                          
                CALL cl_err( '', 9035, 0 )                                                                                          
                EXIT FOREACH                                                                                                        
                END IF                                                                                                              
              END FOREACH
                LET g_cnt1 = 0
                IF g_success = 'N' THEN
                   NEXT FIELD bof05
                ELSE
                   NEXT FIELD bof06
                END IF
              END IF
            END IF
           END IF
 
        #No.FUN-A30003--begin
        AFTER FIELD bof07
           IF NOT cl_null(g_bof[l_ac].bof07) THEN
              IF g_bof[l_ac].bof07 <0 THEN
                 CALL cl_err('','mfg4012',0)
                 NEXT FIELD bof07 
              END IF
           END IF
        #No.FUN-A30003--end
 
        AFTER FIELD bof06
           IF NOT cl_null(g_bof[l_ac].bof06) THEN
              IF g_bof[l_ac].bof06 <0 THEN
                 CALL cl_err('','mfg4012',0)
                 NEXT FIELD bof06 
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
             IF g_bof_t.bof01 IS NOT NULL AND
                g_bof_t.bof02 IS NOT NULL AND
                g_bof_t.bof03 IS NOT NULL AND
                g_bof_t.bof04 IS NOT NULL AND
                g_bof_t.bof05 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
            DELETE FROM bof_file
                WHERE bof01 = g_bof_t.bof01
                  AND bof02 = g_bof_t.bof02
                  AND bof03 = g_bof_t.bof03
                  AND bof04 = g_bof_t.bof04
                  AND bof05 = g_bof_t.bof05 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bof_file",g_bof[l_ac].bof01,g_bof[l_ac].bof02,SQLCA.sqlcode,"","",1) 
                ROLLBACK WORK
                CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2 
            MESSAGE "Delete OK" 
            CLOSE i612_bcl     
            COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_bof[l_ac].* = g_bof_t.*
              CLOSE i612_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(" ",-263,1)
              LET g_bof[l_ac].* = g_bof_t.*
           ELSE
              UPDATE bof_file SET bof01=g_bof[l_ac].bof01,
                                  bof02=g_bof[l_ac].bof02,
                                  bof03=g_bof[l_ac].bof03,
                                  bof04=g_bof[l_ac].bof04,
                                  bof05=g_bof[l_ac].bof05,
                                  bof06=g_bof[l_ac].bof06,                     
                                  bof07=g_bof[l_ac].bof07             #No.FUN-A30003                      
                WHERE bof01 = g_bof_t.bof01                                     
                  AND bof02 = g_bof_t.bof02                                     
                  AND bof03 = g_bof_t.bof03                                     
                  AND bof04 = g_bof_t.bof04                                     
                  AND bof05 = g_bof_t.bof05
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","bof_file",g_bof[l_ac].bof01,g_bof[l_ac].bof02,SQLCA.sqlcode,"","update bof error",1) 
                   LET g_bof[l_ac].* = g_bof_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                                             
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd='u' THEN
                  LET g_bof[l_ac].* = g_bof_t.*                                    
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bof.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i612_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i612_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i612_b_askkey()
            EXIT INPUT
 
#No.FUN-830114--BEGIN--
        ON ACTION CONTROLO                        #沿用所有欄位                                                                     
            IF INFIELD(bof01) AND l_ac > 1 THEN                                                                                     
                LET g_bof[l_ac].* = g_bof[l_ac-1].*                                                                                 
                NEXT FIELD bof01                                                                                                    
            END IF 
 
#No.FUN-830114--END--
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE 
              WHEN INFIELD(bof01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_bof01"
                 LET g_qryparam.default1 = g_bof[l_ac].bof01
                 CALL cl_create_qry() RETURNING g_bof[l_ac].bof01
                 CALL FGL_DIALOG_SETBUFFER( g_bof[l_ac].bof01 )
                 DISPLAY BY NAME g_bof[l_ac].bof01
                 NEXT FIELD bof01
              WHEN INFIELD(bof03)
                 IF g_bof[l_ac].bof02 = "1" THEN
#FUN-AA0059 --Begin--
                 #  CALL cl_init_qry_var()                                         
                 #  LET g_qryparam.form ="q_bof3"              
#                #  LET g_qryparam.arg1 = g_bof[l_ac].bof01   #No.FUN-870124                   
                 #  LET g_qryparam.default1 = g_bof[l_ac].bof03                    
                 #  CALL cl_create_qry() RETURNING g_bof[l_ac].bof03                
                   CALL q_sel_ima(FALSE, "q_bof3", "", g_bof[l_ac].bof03, g_bof[l_ac].bof01, "", "", "" ,"",'' )  RETURNING g_bof[l_ac].bof03 
#FUN-AA0059 --End--
                   CALL FGL_DIALOG_SETBUFFER( g_bof[l_ac].bof03 )                  
                   DISPLAY BY NAME g_bof[l_ac].bof03                              
                   NEXT FIELD bof03
                 END IF
                 IF g_bof[l_ac].bof02 = "2" THEN
                   CALL cl_init_qry_var()                                         
                   LET g_qryparam.form ="q_imz"                                 
                   LET g_qryparam.default1 = g_bof[l_ac].bof03                    
                   CALL cl_create_qry() RETURNING g_bof[l_ac].bof03                
                   CALL FGL_DIALOG_SETBUFFER( g_bof[l_ac].bof03 )                  
                   DISPLAY BY NAME g_bof[l_ac].bof03                              
                   NEXT FIELD bof03
                 END IF
               OTHERWISE EXIT CASE
           END CASE
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
        
        END INPUT
 
    CLOSE i612_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i612_b_askkey()
    CLEAR FORM
    CALL g_bof.clear()
    CONSTRUCT g_wc2 ON bof01, bof01_ima02, bof01_ima021, bof02, bof03, bof03_ima02, bof03_ima021,  #TQC-D40107 add bof01_ima021,bof03_ima021
                       bof04,bof05,bof07,bof06                           #No.FUN-A30003 add bof07
            FROM s_bof[1].bof01,s_bof[1].bof01_ima02,s_bof[1].bof01_ima021,s_bof[1].bof02,         #TQC-D40107 s_bof[1].bof01_ima021
                 s_bof[1].bof03,s_bof[1].bof03_ima02,s_bof[1].bof03_ima021,s_bof[1].bof04,         #TQC-D40107 s_bof[1].bof03_ima021
                 s_bof[1].bof05,s_bof[1].bof07,s_bof[1].bof06            #No.FUN-A30003  add bof07
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      
       ON ACTION CONTROLP                                                                                                          
            CASE                                                                                                                    
               WHEN INFIELD(bof01)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form = "q_bof01"                                                                                     
                  LET g_qryparam.state = 'c'                                                                                        
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO bof01                                                                              
                  NEXT FIELD bof01                                                                                                  
               WHEN INFIELD(bof03)                                                                                                   
                   CALL cl_init_qry_var()                                                                                           
                   LET g_qryparam.form ="q_bof03"                                                                                   
                   LET g_qryparam.state = 'c'                                                                                        
                   CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                   DISPLAY g_qryparam.multiret TO bof03                                                                              
                   NEXT FIELD bof03
              
               OTHERWISE EXIT CASE                                                                                                  
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
    CALL i612_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i612_b_fill(p_wc2)              
DEFINE
#    p_wc2       LIKE type_file.chr1000   
    p_wc2        STRING              #NO.FUN-910082 
 
    LET g_sql =
        " SELECT bof01,ima02,ima021,bof02,bof03,' ',' ',bof04,",     #TQC-D40107 add ima021,' '                       
        " bof05,bof06,bof07",           #No.FUN-A30003
        " FROM   bof_file,ima_file " ,
        " WHERE  ", p_wc2 CLIPPED,"AND ima01=bof01"
    PREPARE i612_pb FROM g_sql
    DECLARE bof_curs CURSOR FOR i612_pb
 
    CALL g_bof.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH bof_curs INTO g_bof[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        IF g_bof[g_cnt].bof02 = "1" THEN
          SELECT ima02 INTO g_bof[g_cnt].bof03_ima02 FROM ima_file WHERE ima01 = g_bof[g_cnt].bof03
          SELECT ima021 INTO g_bof[g_cnt].bof03_ima021 FROM ima_file WHERE ima01 = g_bof[g_cnt].bof03    #TQC-D40107 add
        ELSE
          SELECT imz02 INTO g_bof[g_cnt].bof03_ima02 FROM imz_file WHERE imz01 = g_bof[g_cnt].bof03
          LET g_bof[g_cnt].bof03_ima021 = ''          #TQC-D40107 add
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bof.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i612_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bof TO s_bof.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i612_bof01(p_cmd)                                            
    DEFINE l_ima02    LIKE ima_file.ima02,                                      
           l_ima021   LIKE ima_file.ima021,     #TQC-D40107 add
           l_imaacti  LIKE ima_file.imaacti,                                    
           p_cmd      LIKE type_file.chr1,      #No.FUN-8A0145                                                
           l_n        LIKE type_file.num5          #FUN-AC0104                                                                      
     LET g_errno = ' '   
     #FUN-AC0104--begin
     SELECT COUNT(*) INTO l_n FROM bmq_file 
      WHERE bmq01= g_bof[l_ac].bof03 AND bmqacti='Y'                  
     IF l_n=0 THEN                              
     #FUN-AC0104--end                                                       
        SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti      #TQC-D40107 add ima021,l_ima021                             
          FROM ima_file WHERE ima01 = g_bof[l_ac].bof01                            
                                                                                   
        CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3015'                     
                                LET l_ima02 = NULL                                 
                                LET l_ima021 = NULL                         #TQC-D40107 add
             WHEN l_imaacti='N' LET g_errno = '9028'                               
             OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'        
        END CASE                                                                   
     END IF                                                                            
      IF cl_null(g_errno) OR p_cmd = 'd' THEN                              
         LET g_bof[l_ac].bof01_ima02 = l_ima02                                        
         LET g_bof[l_ac].bof01_ima021 = l_ima021            #TQC-D40107 add
      END IF
                                                                               
END FUNCTION
 
FUNCTION i612_bof03(p_cmd)                                                      
    DEFINE l_ima02    LIKE ima_file.ima02,                                      
           l_ima021   LIKE ima_file.ima021,        #TQC-D40107 add
           l_imaacti  LIKE ima_file.imaacti,    
           l_imz02    LIKE imz_file.imz02,
           l_imzacti  LIKE imz_file.imzacti,                                
           p_cmd      LIKE type_file.chr1,         #No.FUN-8A0145  
           l_n        LIKE type_file.num5          #FUN-AC0104  
    IF g_bof[l_ac].bof02 = "1" THEN                                            
     LET g_errno = ' '           
     #FUN-AC0104--begin
     SELECT COUNT(*) INTO l_n FROM bmq_file 
      WHERE bmq01= g_bof[l_ac].bof03 AND bmqacti='Y'                  
     IF l_n=0 THEN                              
     #FUN-AC0104--end
        SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti      #TQC-D40107 add ima021,l_ima021                              
          FROM ima_file WHERE ima01 = g_bof[l_ac].bof03                            
                                                                                   
        CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3021'                     
                                LET l_ima02 = NULL                                 
                                LET l_ima021 = NULL                         #TQC-D40107 add
             WHEN l_imaacti='N' LET g_errno = '9028'                               
             OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'        
        END CASE                                                                   
     END IF                                                                            
      IF cl_null(g_errno) OR p_cmd = 'd' THEN                                       
         LET g_bof[l_ac].bof03_ima02 = l_ima02                                             
         LET g_bof[l_ac].bof03_ima021 = l_ima021           #TQC-D40107 add                                                                     
      END IF
     END IF
     
     IF g_bof[l_ac].bof02 = "2" THEN                                             
      LET g_errno = ' '                                                          
      SELECT imz02,imzacti INTO l_imz02,l_imzacti                                
        FROM imz_file WHERE imz01 = g_bof[l_ac].bof03                            
                                                                                
#     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'   #No.FUN-830114                    
      CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3022'   #No.FUN-830114                  
                             LET l_imz02 = NULL                                 
          WHEN l_imzacti='N' LET g_errno = '9028'                               
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'        
      END CASE                                                                   
                                                                                
      IF cl_null(g_errno) OR p_cmd = 'd' THEN                                         
         LET g_bof[l_ac].bof03_ima02 = l_imz02                            
         LET g_bof[l_ac].bof03_ima021 = ''          #TQC-D40107 add                                                    
      END IF                                                                    
     END IF                                                                    
                                                                                
END FUNCTION
#No.FUN-8A0145  --begin
#FUNCTION i010_out()
#    DEFINE
#        l_i             LIKE type_file.num5,     #No.FUN-680073 
#        l_name          LIKE type_file.chr20,    # No.FUN-680073  # External(Disk) file name
#        l_za05          LIKE type_file.chr1000,  # No.FUN-680073 
#        l_chr           LIKE type_file.chr1,          #No.FUN-680073 
#        l_sga   RECORD  LIKE  sga_file.*,
#    sr              RECORD
#        sga01       LIKE sga_file.sga01,   #單元工時代號
#        sga02       LIKE sga_file.sga02,   #單元名稱
#        sga03       LIKE sga_file.sga03,   #單元規格
#        sga04       LIKE sga_file.sga04,   #單元工時
#        sga06       LIKE sga_file.sga06,   #單元機時
#        sga05       LIKE sga_file.sga05,   #備註
#        sgaacti     LIKE sga_file.sgaacti #資料有效  
#                    END RECORD
##No.TQC-710076 -- begin --
#   IF cl_null(g_wc2) THEN
#      CALL cl_err("","9057",0)
#      RETURN
#   END IF
##No.TQC-710076 -- end --
#
#    CALL cl_wait()
#    CALL cl_outnam('aeci010') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql=
#        " SELECT sga01,sga02,sga03,sga04,sga06,sga05,sgaacti,''",  
#        " FROM   sga_file ",
#        " ORDER BY sga01, sga02"
#    PREPARE i010_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i010_co                         # SCROLL CURSOR
#        CURSOR FOR i010_p1
#
#    START REPORT i010_rep TO l_name
#
#    FOREACH i010_co INTO sr.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i010_rep(sr.*)
#    END FOREACH
#    FINISH REPORT i010_rep
#    CLOSE i010_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT i010_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680073 
#        l_chr           LIKE type_file.chr1,          #No.FUN-680073 
#    sr              RECORD
#        sga01       LIKE sga_file.sga01,   #單元工時代號
#        sga02       LIKE sga_file.sga02,   #單元名稱
#        sga03       LIKE sga_file.sga03,   #單元規格
#        sga04       LIKE sga_file.sga04,   #單元工時
#        sga06       LIKE sga_file.sga06,   #單元機時
#        sga05       LIKE sga_file.sga05,   #備註
#        sgaacti     LIKE sga_file.sgaacti #資料有效  
#                    END RECORD
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.sga01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#        ON EVERY ROW
#            PRINT COLUMN g_c[31], sr.sga01,
#                  COLUMN g_c[32], sr.sga02 CLIPPED, 
#                  COLUMN g_c[33], sr.sga03 CLIPPED, 
##No.TQC-6C0190 --begin
##                 COLUMN g_c[34], sr.sga04,
##                 COLUMN g_c[35], sr.sga06,
#                  COLUMN g_c[34], cl_numfor(sr.sga04,34,2),
#                  COLUMN g_c[35], cl_numfor(sr.sga06,35,2),
##No.TQC-6C0190 --end
#                  COLUMN g_c[36], sr.sga05 CLIPPED,
#                  COLUMN g_c[37], sr.sgaacti 
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT 
#No.FUN-8A0145 ---end
FUNCTION i612_set_entry(p_cmd)                                                                                                      
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                     
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("bof01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
FUNCTION i612_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1             
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("bof01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-810017
