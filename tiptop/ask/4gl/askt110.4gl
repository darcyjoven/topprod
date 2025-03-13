# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: askt110.4gl
# Descriptions...: 裁片移轉單維護作業 
# Date & Author..: No.FUN-830087 FUN-840178 2008/01/15 By hongmei
# Modify.........: No.FUN-850068 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-8A0151 08/11/01 by hongmei mark output
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980008 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80030 11/08/03 By minpp 模组程序撰写规范修改
# Modify.........: No.TQC-BB0183 11/11/21 By lixiang  修改無法進行錄入的BUG 
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/13 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C80041 12/12/28 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/19 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sks           RECORD LIKE sks_file.*,
    g_sks_t         RECORD LIKE sks_file.*,
    g_sks_o         RECORD LIKE sks_file.*,
    g_sks01_t       LIKE sks_file.sks01,    #簽核等級 (舊值)
    g_t1            LIKE oay_file.oayslip,  
    l_cnt           LIKE type_file.num5,    
    g_skt           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
        skt02       LIKE skt_file.skt02,    #項次
        skt03       LIKE skt_file.skt03,    #工單編號
        skt04       LIKE skt_file.skt04,    #工藝序號
        skt05       LIKE skt_file.skt05,    #版本序號
        skt06       LIKE skt_file.skt06,    #單件片數
        skt07       LIKE skt_file.skt07,    #移轉件數
        skt08       LIKE skt_file.skt08,    #總片數
        #FUN-850068 --start---
        sktud01     LIKE skt_file.sktud01,
        sktud02     LIKE skt_file.sktud02,
        sktud03     LIKE skt_file.sktud03,
        sktud04     LIKE skt_file.sktud04,
        sktud05     LIKE skt_file.sktud05,
        sktud06     LIKE skt_file.sktud06,
        sktud07     LIKE skt_file.sktud07,
        sktud08     LIKE skt_file.sktud08,
        sktud09     LIKE skt_file.sktud09,
        sktud10     LIKE skt_file.sktud10,
        sktud11     LIKE skt_file.sktud11,
        sktud12     LIKE skt_file.sktud12,
        sktud13     LIKE skt_file.sktud13,
        sktud14     LIKE skt_file.sktud14,
        sktud15     LIKE skt_file.sktud15
        #FUN-850068 --end--
                    END RECORD,
    g_skt_t         RECORD                  #程式變數 (舊值)
        skt02       LIKE skt_file.skt02,    #項次
        skt03       LIKE skt_file.skt03,    #工單編號
        skt04       LIKE skt_file.skt04,    #工藝序號
        skt05       LIKE skt_file.skt05,    #版本序號
        skt06       LIKE skt_file.skt06,    #單件片數
        skt07       LIKE skt_file.skt07,    #移轉件數
        skt08       LIKE skt_file.skt08,    #總片數
        #FUN-850068 --start---
        sktud01     LIKE skt_file.sktud01,
        sktud02     LIKE skt_file.sktud02,
        sktud03     LIKE skt_file.sktud03,
        sktud04     LIKE skt_file.sktud04,
        sktud05     LIKE skt_file.sktud05,
        sktud06     LIKE skt_file.sktud06,
        sktud07     LIKE skt_file.sktud07,
        sktud08     LIKE skt_file.sktud08,
        sktud09     LIKE skt_file.sktud09,
        sktud10     LIKE skt_file.sktud10,
        sktud11     LIKE skt_file.sktud11,
        sktud12     LIKE skt_file.sktud12,
        sktud13     LIKE skt_file.sktud13,
        sktud14     LIKE skt_file.sktud14,
        sktud15     LIKE skt_file.sktud15
        #FUN-850068 --end--
                    END RECORD,
    g_skt_o         RECORD                  #程式變數 (舊值)
        skt02       LIKE skt_file.skt02,    #項次
        skt03       LIKE skt_file.skt03,    #工單編號
        skt04       LIKE skt_file.skt04,    #工藝序號
        skt05       LIKE skt_file.skt05,    #版本序號
        skt06       LIKE skt_file.skt06,    #單件片數
        skt07       LIKE skt_file.skt07,    #移轉件數
        skt08       LIKE skt_file.skt08,    #總片數
        #FUN-850068 --start---
        sktud01     LIKE skt_file.sktud01,
        sktud02     LIKE skt_file.sktud02,
        sktud03     LIKE skt_file.sktud03,
        sktud04     LIKE skt_file.sktud04,
        sktud05     LIKE skt_file.sktud05,
        sktud06     LIKE skt_file.sktud06,
        sktud07     LIKE skt_file.sktud07,
        sktud08     LIKE skt_file.sktud08,
        sktud09     LIKE skt_file.sktud09,
        sktud10     LIKE skt_file.sktud10,
        sktud11     LIKE skt_file.sktud11,
        sktud12     LIKE skt_file.sktud12,
        sktud13     LIKE skt_file.sktud13,
        sktud14     LIKE skt_file.sktud14,
        sktud15     LIKE skt_file.sktud15
        #FUN-850068 --end--
                    END RECORD,
    g_wc,g_wc2,g_sql    string,  
    g_rec_b         LIKE type_file.num5,    #單身筆數  
    g_rec_bc        LIKE type_file.num5,    #單身筆數(分量計價)
    l_ac            LIKE type_file.num5,    #目前處理的ARRAY CNT  
    g_sta           LIKE type_file.chr20,  
    tm              RECORD
#                    wc    LIKE type_file.chr1000 
                    wc           STRING       #NO.FUN-910082 
                    END RECORD,
    g_message       LIKE type_file.chr1000       
DEFINE g_argv1      LIKE sks_file.sks01    
DEFINE g_argv2      STRING                  #指定執行的功能 
DEFINE p_row,p_col  LIKE type_file.num5    
DEFINE g_laststage  LIKE type_file.chr1     
#主程式開始
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    
DEFINE g_chr          LIKE type_file.chr1    
DEFINE g_chr2         LIKE type_file.chr1    
DEFINE g_chr3         LIKE type_file.chr1    
DEFINE g_cnt          LIKE type_file.num10  
DEFINE g_cnt1         LIKE type_file.num10  
DEFINE g_i            LIKE type_file.num5   #count/index for any purpose  
DEFINE g_msg          LIKE ze_file.ze03      
DEFINE g_row_count    LIKE type_file.num10   
DEFINE g_curs_index   LIKE type_file.num10   
DEFINE g_jump         LIKE type_file.num10  
DEFINE mi_no_ask      LIKE type_file.num5  
DEFINE g_cmd          LIKE type_file.chr1000
DEFINE g_tmp01        LIKE type_file.chr1 
DEFINE g_tmp_file     STRING
 
MAIN
 
    OPTIONS                                #改變一些系統預設值扢硉
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASK")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
   RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM sks_file WHERE sks01 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t110_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 9
 
   IF NOT s_industry('slk') THEN                                                
      CALL cl_err("","-1000",1)                                                 
      EXIT PROGRAM                                                              
   END IF   
 
   OPEN WINDOW t110_w AT p_row,p_col WITH FORM "ask/42f/askt110"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL t110_menu()
   CLOSE WINDOW t110_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出時間)
   RETURNING g_time
END MAIN
 
FUNCTION t110_cs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM                          #清除畫面
   CALL g_skt.clear()
    
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " sks01 = '",g_argv1,"'"
   ELSE   
      CALL cl_set_head_visible("","YES") 
               
   INITIALIZE g_sks.* TO NULL    
   CONSTRUCT BY NAME g_wc ON sks01,sks02,sks03,sks05,sks06, 
                             sksuser,sksgrup,sksmodu,sksdate,sksacti,
                             #FUN-850068   ---start---
                             sksud01,sksud02,sksud03,sksud04,sksud05,
                             sksud06,sksud07,sksud08,sksud09,sksud10,
                             sksud11,sksud12,sksud13,sksud14,sksud15
                             #FUN-850068    ----end----
 
      BEFORE CONSTRUCT
             CALL cl_qbe_init()
             
      ON ACTION controlp
         CASE
            WHEN INFIELD(sks01) #核價單號
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_sks01"
               LET g_qryparam.default1 = g_sks.sks01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sks01
               NEXT FIELD sks01
               
            WHEN INFIELD(sks03) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_eca1"
               LET g_qryparam.default1 = g_sks.sks03
               CALL cl_create_qry() RETURNING g_sks.sks03
               DISPLAY BY NAME g_sks.sks03
               CALL t110_sks03('d')
               NEXT FIELD sks03
               
            WHEN INFIELD(sks04) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_eca1"
               LET g_qryparam.default1 = g_sks.sks04
               CALL cl_create_qry() RETURNING g_sks.sks04
               DISPLAY BY NAME g_sks.sks04
               CALL t110_sks04('d')
               NEXT FIELD sks04   
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
 
    END CONSTRUCT
 
    IF INT_FLAG THEN
       RETURN
    END IF
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND sksuser = '",g_user,"'"
   #   END IF
   
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND sksgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN              #群組權限
   #      LET g_wc = g_wc clipped," AND sksgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sksuser', 'sksgrup')
   #End:FUN-980030
 
 
   CONSTRUCT g_wc2 ON skt02,skt03,skt04,skt05,skt06,skt07,skt08
                      #No.FUN-850068 --start--
                      ,sktud01,sktud02,sktud03,sktud04,sktud05
                      ,sktud06,sktud07,sktud08,sktud09,sktud10
                      ,sktud11,sktud12,sktud13,sktud14,sktud15
                      #No.FUN-850068 ---end---
           FROM s_skt[1].skt02,s_skt[1].skt03,s_skt[1].skt04,
                s_skt[1].skt05,s_skt[1].skt06,s_skt[1].skt07,
                s_skt[1].skt08
                #No.FUN-850068 --start--
                ,s_skt[1].sktud01,s_skt[1].sktud02,s_skt[1].sktud03
                ,s_skt[1].sktud04,s_skt[1].sktud05,s_skt[1].sktud06
                ,s_skt[1].sktud07,s_skt[1].sktud08,s_skt[1].sktud09
                ,s_skt[1].sktud10,s_skt[1].sktud11,s_skt[1].sktud12
                ,s_skt[1].sktud13,s_skt[1].sktud14,s_skt[1].sktud15
                #No.FUN-850068 ---end---
 
      BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()    
 
 
      ON ACTION controlp
           CASE
              WHEN INFIELD(skt03) #料件編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_sfb07"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO skt03
                   NEXT FIELD skt03
              OTHERWISE EXIT CASE
           END CASE
           
      ON ACTION qbe_save
		     CALL cl_qbe_save()
 
    END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
    
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  sks01 FROM sks_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY sks01"
   ELSE                                    # 若單身有輸入條件
      LET g_sql = "SELECT  sks01 ",
                  "  FROM sks_file, skt_file ",
                  " WHERE sks01 = skt01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY sks01"
   END IF
 
   PREPARE t110_prepare FROM g_sql
   DECLARE t110_cs                         #CURSOR
       SCROLL CURSOR WITH HOLD FOR t110_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM sks_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(UNIQUE sks01) FROM sks_file,skt_file WHERE ",
                "skt01=sks01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   
   PREPARE t110_precount FROM g_sql
   DECLARE t110_count CURSOR FOR t110_precount
 
END FUNCTION
 
FUNCTION t110_menu()
 
   WHILE TRUE
      CALL t110_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t110_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t110_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t110_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t110_u()
            END IF
#        WHEN "reproduce"
#           IF cl_chk_act_auth() THEN
#              CALL t110_copy()
#           END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t110_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#No.FUN-8A0151---Begin
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              CALL t110_out()
#           END IF
#No.FUN-8A0151---End
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t110_y()    
               CALL t110_field_pic()       
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t110_z()
               CALL t110_field_pic()
            END IF
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_skt),'','')
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t110_v()                     #CHI-D20010
               CALL t110_v(1)                     #CHI-D20010
               CALL t110_field_pic()
            END IF
         #CHI-C80041---end 
         #CHI-D20010---add--str
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               #CALL t110_v()                ##CHI-D20010
               CALL t110_v(2)                #CHI-D20010
               CALL t110_field_pic()
            END IF
         #CHI-D20010---add--end
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t110_a()
DEFINE li_result LIKE type_file.num5                   
 
   MESSAGE ""
   CLEAR FORM
   CALL g_skt.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_sks.* LIKE sks_file.*    #DEFAULT 設定
   LET g_sks01_t = NULL
   LET g_sks.sks02 = g_today
   #預設值及將數值類變數清成零
   LET g_sks_t.* = g_sks.*
   LET g_sks_o.* = g_sks.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_sks.sksuser=g_user
      LET g_sks.sksoriu = g_user #FUN-980030
      LET g_sks.sksorig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_sks.sksgrup=g_grup
      LET g_sks.sksdate=g_today
      LET g_sks.sksacti='Y'              #資料有效
      LET g_sks.sks06='N'                #確認碼
      LET g_sks.sksplant=g_plant #FUN-980008 add
      LET g_sks.skslegal=g_legal #FUN-980008 add
 
      CALL t110_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_sks.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_sks.sks01 IS NULL THEN        # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
      CALL s_auto_assign_no("asf",g_sks.sks01,g_sks.sks02,"R","sks_file","sks01","","","")
        RETURNING li_result,g_sks.sks01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_sks.sks01
 
      INSERT INTO sks_file VALUES (g_sks.*)
      
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","sks_file",g_sks.sks01,"",SQLCA.sqlcode,"","",1) #FUN-B80030 ADD
         ROLLBACK WORK     
      #  CALL cl_err3("ins","sks_file",g_sks.sks01,"",SQLCA.sqlcode,"","",1) #FUN-B80030 MARK
         CONTINUE WHILE
      ELSE
         COMMIT WORK        
         CALL cl_flow_notify(g_sks.sks01,'I')
      END IF
 
      SELECT sks01 INTO g_sks.sks01 FROM sks_file
       WHERE sks01 = g_sks.sks01
      LET g_sks01_t = g_sks.sks01        #保留舊值
      LET g_sks_t.* = g_sks.*
      LET g_sks_o.* = g_sks.*
      CALL g_skt.clear()
 
       LET g_rec_b=0  
      CALL t110_b()                      #輸入單身
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t110_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_sks.sks01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_sks.* FROM sks_file
    WHERE sks01=g_sks.sks01
 
   #檢查資料是否已確認
   IF g_sks.sks06='Y' THEN
      CALL cl_err(g_sks.sks06,'9003',0)
      RETURN
   END IF
   IF g_sks.sks06='X' THEN RETURN END IF  #CHI-C80041
   IF g_sks.sksacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_sks.sks01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_sks01_t = g_sks.sks01
   BEGIN WORK
 
   OPEN t110_cl USING g_sks.sks01
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t110_cl INTO g_sks.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_sks.sks01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t110_show()
 
   WHILE TRUE
      LET g_sks01_t = g_sks.sks01
      LET g_sks_o.* = g_sks.*
      LET g_sks.sksmodu=g_user
      LET g_sks.sksdate=g_today
 
      CALL t110_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_sks.*=g_sks_t.*
         CALL t110_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_sks.sks01 != g_sks01_t THEN            # 更改單號
         UPDATE skt_file SET skt01 = g_sks.sks01
          WHERE skt01 = g_sks01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","skt_file",g_sks01_t,"",SQLCA.sqlcode,"","skt",1)  
            CONTINUE WHILE
         END IF
      END IF
 
 
      UPDATE sks_file SET sks_file.* = g_sks.*
       WHERE sks01 = g_sks01_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","sks_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE t110_cl
   COMMIT WORK
   CALL cl_flow_notify(g_sks.sks01,'U')
 
END FUNCTION
 
FUNCTION t110_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,    
   li_result LIKE type_file.num5,    
   p_cmd     LIKE type_file.chr1     #a:輸入 u:更改  
 
   DISPLAY BY NAME g_sks.sksuser,g_sks.sksmodu,
                   g_sks.sksgrup,g_sks.sksdate,g_sks.sksacti,
                   g_sks.sksoriu,g_sks.sksorig #TQC-BB0183   add
 
   CALL cl_set_head_visible("","YES")           
   INPUT BY NAME g_sks.sks01,g_sks.sks02,g_sks.sks05, # g_sks.sksoriu,g_sks.sksorig, #TQC-BB0183 mark    
                 g_sks.sks03,g_sks.sks04,g_sks.sks06,
                 #FUN-850068     ---start---
                 g_sks.sksud01,g_sks.sksud02,g_sks.sksud03,g_sks.sksud04,
                 g_sks.sksud05,g_sks.sksud06,g_sks.sksud07,g_sks.sksud08,
                 g_sks.sksud09,g_sks.sksud10,g_sks.sksud11,g_sks.sksud12,
                 g_sks.sksud13,g_sks.sksud14,g_sks.sksud15 
                 #FUN-850068     ----end----
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t110_set_entry(p_cmd)
         CALL t110_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("sks01")        
 
      AFTER FIELD sks01
         IF NOT cl_null(g_sks.sks01) THEN
             CALL s_check_no("asf",g_sks.sks01,g_sks_t.sks01,"R","sks_file","sks01","")
               RETURNING li_result,g_sks.sks01
             DISPLAY BY NAME g_sks.sks01
             IF (NOT li_result) THEN
                 LET g_sks.sks01=g_sks_o.sks01
    	           NEXT FIELD sks01
             END IF
            SELECT smyapr INTO g_smy.smyapr FROM smy_file
             WHERE smyslip = g_t1
         END IF
 
      AFTER FIELD sks03                       #廠商編號
         IF g_sks.sks03 IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM eca_file
                 WHERE eca_file.eca01=g_sks.sks03
                   AND eca_file.ecaacti='Y'
            IF l_n=0 THEN
                  CALL cl_err(g_sks.sks03,'ask-008',0)
                  NEXT FIELD sks03
            END IF
            CALL t110_sks03('d')     
         END IF         
 
      AFTER FIELD sks04                       #廠商編號
         IF g_sks.sks04 IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM eca_file
                 WHERE eca_file.eca01=g_sks.sks03
                   AND eca_file.ecaacti='Y'
            IF l_n=0 THEN
                  CALL cl_err(g_sks.sks03,'ask-008',0)
                  NEXT FIELD sks04
            END IF
            CALL t110_sks04('d')     
         END IF       
 
      #FUN-850068     ---start---
      AFTER FIELD sksud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sksud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sksud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sksud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sksud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sksud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sksud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sksud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sksud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sksud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sksud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sksud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sksud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sksud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sksud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-850068     ----end----
         
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(sks01) #單據編號
               LET g_t1=s_get_doc_no(g_sks.sks01)     
               CALL q_smy(FALSE,FALSE,g_t1,'ASF','R') RETURNING g_t1 
               LET g_sks.sks01=g_t1                   
               DISPLAY BY NAME g_sks.sks01
               CALL t110_sks01('d')
               NEXT FIELD sks01
 
            WHEN INFIELD(sks03) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_eca1"
               LET g_qryparam.default1 = g_sks.sks03
               CALL cl_create_qry() RETURNING g_sks.sks03
               DISPLAY BY NAME g_sks.sks03
               CALL t110_sks03('d')
               NEXT FIELD sks03
            
            WHEN INFIELD(sks04) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_eca1"
               LET g_qryparam.default1 = g_sks.sks04
               CALL cl_create_qry() RETURNING g_sks.sks04
               DISPLAY BY NAME g_sks.sks04
               CALL t110_sks04('d')
               NEXT FIELD sks04
 
            OTHERWISE EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
   END INPUT
 
END FUNCTION
 
FUNCTION t110_sks01(p_cmd)  #移轉單號
    DEFINE 
           l_smyacti LIKE smy_file.smyacti,
           l_t1      LIKE smy_file.smyslip, 
           p_cmd     LIKE type_file.chr1    
 
   LET g_chr = ' '
   LET l_t1 = s_get_doc_no(g_sks.sks01)   
   IF g_sks.sks01 IS NULL THEN
      LET g_chr = 'E'
   ELSE
      SELECT smyacti
        INTO l_smyacti
        FROM smy_file WHERE smyslip = l_t1
      IF SQLCA.sqlcode THEN
         LET g_chr = 'E'
      ELSE
         IF l_smyacti matches'[nN]' THEN
            LET g_chr = 'E'
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t110_sks03(p_cmd)  #移出部門
    DEFINE l_sks03_eca02   LIKE sks_file.sks03,
           l_ecaacti       LIKE eca_file.ecaacti,
           p_cmd           LIKE type_file.chr1   
 
   LET g_errno = " "
   SELECT eca02 INTO l_sks03_eca02 FROM eca_file WHERE eca01 = g_sks.sks03
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
                                  LET l_sks03_eca02 = NULL
        WHEN l_ecaacti='N' LET g_errno = '9028'
        WHEN l_ecaacti MATCHES '[PH]'  LET g_errno = '9038'   
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_sks03_eca02 TO FORMONLY.sks03_eca02
   END IF
 
END FUNCTION
 
FUNCTION t110_sks04(p_cmd)  #移入部門 
    DEFINE l_sks04_eca02  LIKE sks_file.sks04,
           l_ecaacti      LIKE eca_file.ecaacti,
           p_cmd          LIKE type_file.chr1   
 
   LET g_errno = " "
   SELECT eca02 INTO l_sks04_eca02 FROM eca_file WHERE eca01 = g_sks.sks04
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
                                  LET l_sks04_eca02 = NULL
        WHEN l_ecaacti='N' LET g_errno = '9028'
        WHEN l_ecaacti MATCHES '[PH]'  LET g_errno = '9038'   
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_sks04_eca02 TO FORMONLY.sks04_eca02
   END IF
 
END FUNCTION
 
FUNCTION t110_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sks.* TO NULL
 
   CALL cl_msg("")                             
 
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_skt.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL t110_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_sks.* TO NULL
      RETURN
   END IF
 
   OPEN t110_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_sks.* TO NULL
   ELSE
      OPEN t110_count
      FETCH t110_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t110_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t110_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1      #處理方式
 
   CASE p_flag
       WHEN 'N' FETCH NEXT     t110_cs INTO g_sks.sks01
       WHEN 'P' FETCH PREVIOUS t110_cs INTO g_sks.sks01
       WHEN 'F' FETCH FIRST    t110_cs INTO g_sks.sks01
       WHEN 'L' FETCH LAST     t110_cs INTO g_sks.sks01
       WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help() 
 
      ON ACTION controlg     
         CALL cl_cmdask()    
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t110_cs INTO g_sks.sks01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_sks.sks01,SQLCA.sqlcode,0)
      INITIALIZE g_sks.* TO NULL  
     
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_sks.* FROM sks_file WHERE sks01 = g_sks.sks01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","sks_file","","",SQLCA.sqlcode,"","",1) 
      INITIALIZE g_sks.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_sks.sksuser     
   LET g_data_group = g_sks.sksgrup    
   LET g_data_plant = g_sks.sksplant #FUN-980030
 
   CALL t110_show()
 
END FUNCTION
 
FUNCTION t110_show()
 
   LET g_sks_t.* = g_sks.*                #保存單頭舊值
   LET g_sks_o.* = g_sks.*                #保存單頭舊值
   DISPLAY BY NAME g_sks.sks01,g_sks.sks02,g_sks.sks03,g_sks.sks04,g_sks.sks05,# g_sks.sksoriu,g_sks.sksorig, #TQC-BB0183 mark
                   g_sks.sks06,g_sks.sksuser,g_sks.sksgrup,g_sks.sksmodu,
                   g_sks.sksdate,g_sks.sksacti,g_sks.sksoriu,g_sks.sksorig, #TQC-BB0183 add
                   #FUN-850068     ---start---
                   g_sks.sksud01,g_sks.sksud02,g_sks.sksud03,g_sks.sksud04,
                   g_sks.sksud05,g_sks.sksud06,g_sks.sksud07,g_sks.sksud08,
                   g_sks.sksud09,g_sks.sksud10,g_sks.sksud11,g_sks.sksud12,
                   g_sks.sksud13,g_sks.sksud14,g_sks.sksud15 
                   #FUN-850068     ----end----
 
   CALL cl_set_field_pic(g_sks.sks06,g_chr2,"","",g_chr,"")
   CALL t110_sks01('d')
   CALL t110_sks03('s') 
   CALL t110_sks04('s')
   CALL t110_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t110_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_sks.sks01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_sks.* FROM sks_file
    WHERE sks01=g_sks.sks01
 
   #檢查資料是否已確認
   IF g_sks.sks06='Y' THEN
      CALL cl_err(g_sks.sks06,'9003',0)
      RETURN
   END IF
   IF g_sks.sks06='X' THEN RETURN END IF  #CHI-C80041
   IF g_sks.sksacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_sks.sks01,'mfg1000',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t110_cl USING g_sks.sks01
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t110_cl INTO g_sks.*                         # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_sks.sks01,SQLCA.sqlcode,0)        #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t110_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM sks_file WHERE sks01 = g_sks.sks01
      DELETE FROM skt_file WHERE skt01 = g_sks.sks01
      CLEAR FORM
      CALL g_skt.clear()
      OPEN t110_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t110_cs
         CLOSE t110_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      FETCH t110_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t110_cs
         CLOSE t110_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t110_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t110_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t110_fetch('/')
      END IF
   END IF
 
   CLOSE t110_cl
   COMMIT WORK
   CALL cl_flow_notify(g_sks.sks01,'D')
 
END FUNCTION
 
FUNCTION t110_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,    #檢查重複用  
    l_m             LIKE type_file.num5,
    l_x             LIKE type_file.num5,
    l_a             LIKE type_file.num5,
    l_b             LIKE type_file.num5,
    l_p             LIKE type_file.num5,
    l_c             LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,    #檢查重複用  
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  
    p_cmd           LIKE type_file.chr1,    #處理狀態  
    l_cmd           LIKE type_file.chr1000, 
    l_allow_insert  LIKE type_file.num5,    #可新增否  
    l_allow_delete  LIKE type_file.num5,    #可刪除否 
    l_skt07         LIKE skt_file.skt07
 
    LET g_action_choice = ""
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_sks.sks01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_sks.* FROM sks_file
     WHERE sks01=g_sks.sks01
 
   #檢查資料是否已確認
   IF g_sks.sks06='Y' THEN
      CALL cl_err(g_sks.sks06,'9003',0)
      RETURN
   END IF
   IF g_sks.sks06='X' THEN RETURN END IF  #CHI-C80041
   IF g_sks.sksacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_sks.sks01,'mfg1000',0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT skt02,skt03,skt04,skt05,skt06,skt07,skt08,",  
                       #No.FUN-850068 --start--
                       "       sktud01,sktud02,sktud03,sktud04,sktud05,",
                       "       sktud06,sktud07,sktud08,sktud09,sktud10,",
                       "       sktud11,sktud12,sktud13,sktud14,sktud15 ", 
                       #No.FUN-850068 ---end---
                       "  FROM skt_file",
                       " WHERE skt01=? AND skt02=?  FOR UPDATE"  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_skt WITHOUT DEFAULTS FROM s_skt.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           
           CALL cl_set_comp_entry("skt04",TRUE) 
 
           BEGIN WORK
           OPEN t110_cl USING g_sks.sks01
           IF STATUS THEN
              CALL cl_err("OPEN t110_cl:", STATUS, 1)
              CLOSE t110_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t110_cl INTO g_sks.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_sks.sks01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t110_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_skt_t.* = g_skt[l_ac].*  #BACKUP
              LET g_skt_o.* = g_skt[l_ac].*  #BACKUP
              OPEN t110_bcl USING g_sks.sks01,g_skt_t.skt02
              IF STATUS THEN
                 CALL cl_err("OPEN t110_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t110_bcl INTO g_skt[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_skt_t.skt02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()    
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_skt[l_ac].* TO NULL      
           LET g_skt_t.* = g_skt[l_ac].*         #新輸入資料
           LET g_skt_o.* = g_skt[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()    
           NEXT FIELD skt02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO skt_file(skt01,skt02,skt03,skt04,skt05,skt06,skt07,skt08,  
                                #FUN-850068 --start--
                                sktud01,sktud02,sktud03,sktud04,sktud05,sktud06,
                                sktud07,sktud08,sktud09,sktud10,sktud11,sktud12,
                                sktud13,sktud14,sktud15,sktplant,sktlegal) #FUN-980008 add sktplant,sktlegal
                                #FUN-850068 --end--
                VALUES(g_sks.sks01,g_skt[l_ac].skt02,
                       g_skt[l_ac].skt03,g_skt[l_ac].skt04,
                       g_skt[l_ac].skt05,g_skt[l_ac].skt06,
                       g_skt[l_ac].skt07,g_skt[l_ac].skt08,  
                       #FUN-850068 --start--
                       g_skt[l_ac].sktud01,g_skt[l_ac].sktud02,
                       g_skt[l_ac].sktud03,g_skt[l_ac].sktud04,
                       g_skt[l_ac].sktud05,g_skt[l_ac].sktud06,
                       g_skt[l_ac].sktud07,g_skt[l_ac].sktud08,
                       g_skt[l_ac].sktud09,g_skt[l_ac].sktud10,
                       g_skt[l_ac].sktud11,g_skt[l_ac].sktud12,
                       g_skt[l_ac].sktud13,g_skt[l_ac].sktud14,
                       g_skt[l_ac].sktud15,g_plant,g_legal) #FUN-980008 add g_plant,g_legal
                       #FUN-850068 --end--
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("ins","skt_file",g_sks.sks01,g_skt[l_ac].skt02,SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD skt02                        #default 序號
           IF g_skt[l_ac].skt02 IS NULL OR g_skt[l_ac].skt02 = 0 THEN
              SELECT max(skt02)+1 INTO g_skt[l_ac].skt02 FROM skt_file
               WHERE skt01 = g_sks.sks01
              IF g_skt[l_ac].skt02 IS NULL THEN
                 LET g_skt[l_ac].skt02 = 1
              END IF
           END IF
 
        AFTER FIELD skt02       #check 序號是否重複
           IF NOT cl_null(g_skt[l_ac].skt02) THEN
              IF g_skt[l_ac].skt02 != g_skt_t.skt02 OR g_skt_t.skt02 IS NULL THEN
                 SELECT COUNT(*) INTO l_cnt FROM skt_file
                  WHERE skt01 = g_sks.sks01
                    AND skt02 = g_skt[l_ac].skt02
                 IF l_cnt > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_skt[l_ac].skt02 = g_skt_t.skt02
                    NEXT FIELD skt02
                 END IF
              END IF
           END IF
           
        AFTER FIELD skt03                        
         IF g_skt[l_ac].skt03 IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM sfb_file 
              WHERE sfb_file.sfb01=g_skt[l_ac].skt03
                AND sfb_file.sfb04!='8' 
                AND sfb_file.sfbacti='Y'
            IF l_n=0 THEN
                  CALL cl_err(g_skt[l_ac].skt03,'ask-037',0)
                  NEXT FIELD skt03
            END IF
            SELECT COUNT(*) INTO l_m FROM skq_file 
              WHERE skq_file.skq01=g_skt[l_ac].skt03 
                AND skq_file.skqacti='Y' 
                AND skq_file.skq08='Y'
            IF l_m=0 THEN
                  CALL cl_err(g_skt[l_ac].skt03,'ask-038',0)
                  NEXT FIELD skt03
            END IF
            SELECT COUNT(*) INTO l_p FROM ecm_file 
             WHERE ecm_file.ecmslk01='Y'
               AND ecm_file.ecm01 =g_skt[l_ac].skt03
            IF l_p=0 THEN
              CALL cl_set_comp_entry("skt04",FALSE)
              NEXT FIELD skt05
            END IF  
         END IF 
         
        AFTER FIELD skt04
         IF g_skt[l_ac].skt04 IS NOT NULL THEN
            SELECT COUNT(*) INTO l_x FROM skr_file
              WHERE skr_file.skr01=g_skt[l_ac].skt03 
                AND skr_file.skr02=g_skt[l_ac].skt04
            IF l_x=0 THEN
                 CALL cl_err(g_sks.sks03,'ask-008',0)
                 NEXT FIELD skt04
            END IF               
         END IF
         
        AFTER FIELD skt05
        IF NOT cl_null(g_skt[l_ac].skt05) THEN  
          IF g_skt[l_ac].skt04 IS NULL THEN
            SELECT COUNT(*) INTO l_c FROM skr_file
             WHERE skr_file.skr01=g_skt[l_ac].skt03  
               AND skr_file.skr03=g_skt[l_ac].skt05 
            IF l_c=0 THEN
               CALL cl_err(g_skt[l_ac].skt05,'ask-008',0)
               NEXT FIELD skt05
            END IF
          END IF  
          IF g_skt[l_ac].skt04 IS NOT NULL THEN
            SELECT COUNT(*) INTO l_a FROM skr_file
              WHERE skr_file.skr01=g_skt[l_ac].skt03
                AND skr_file.skr02=g_skt[l_ac].skt04
                AND skr_file.skr03=g_skt[l_ac].skt05
            IF l_a=0 THEN
               CALL cl_err(g_skt[l_ac].skt05,'ask-008',0)
               NEXT FIELD skt05
            END IF 
            CALL t110_skt07(g_skt[l_ac].skt03,g_skt[l_ac].skt04,g_skt[l_ac].skt05) 
                 RETURNING l_skt07,g_skt[l_ac].skt06
            LET g_skt[l_ac].skt08 = g_skt[l_ac].skt06 * l_skt07
            LET g_skt[l_ac].skt07 = l_skt07 
          END IF
        ELSE
        	NEXT FIELD skt05
        END IF 	   
        
           
        AFTER FIELD skt07 
         IF g_skt[l_ac].skt07 > l_skt07 THEN
            CALL cl_err(g_skt[l_ac].skt07,'ask-008',0)
            NEXT FIELD skt07
         ELSE 
         	  LET g_skt[l_ac].skt08 = g_skt[l_ac].skt06 * g_skt[l_ac].skt07   
         END IF   
         
        #No.FUN-850068 --start--
        AFTER FIELD sktud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sktud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sktud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sktud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sktud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sktud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sktud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sktud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sktud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sktud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sktud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sktud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sktud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sktud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sktud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-850068 ---end---
         
        BEFORE DELETE                            #是否取消單身
           IF g_skt_t.skt02 > 0 AND g_skt_t.skt02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM skt_file
               WHERE skt01 = g_sks.sks01
                 AND skt02 = g_skt_t.skt02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","skt_file",g_sks.sks01,g_skt_t.skt02,SQLCA.sqlcode,"","",1) 
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
              LET g_skt[l_ac].* = g_skt_t.*
              CLOSE t110_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_skt[l_ac].skt02,-263,1)
              LET g_skt[l_ac].* = g_skt_t.*
           ELSE
              UPDATE skt_file SET skt02 = g_skt[l_ac].skt02,
                                  skt03 = g_skt[l_ac].skt03,
                                  skt04 = g_skt[l_ac].skt04,
                                  skt05 = g_skt[l_ac].skt05,
                                  skt06 = g_skt[l_ac].skt06,
                                  skt07 = g_skt[l_ac].skt07,
                                  skt08 = g_skt[l_ac].skt08,
                                  #FUN-850068 --start--
                                  sktud01 = g_skt[l_ac].sktud01,
                                  sktud02 = g_skt[l_ac].sktud02,
                                  sktud03 = g_skt[l_ac].sktud03,
                                  sktud04 = g_skt[l_ac].sktud04,
                                  sktud05 = g_skt[l_ac].sktud05,
                                  sktud06 = g_skt[l_ac].sktud06,
                                  sktud07 = g_skt[l_ac].sktud07,
                                  sktud08 = g_skt[l_ac].sktud08,
                                  sktud09 = g_skt[l_ac].sktud09,
                                  sktud10 = g_skt[l_ac].sktud10,
                                  sktud11 = g_skt[l_ac].sktud11,
                                  sktud12 = g_skt[l_ac].sktud12,
                                  sktud13 = g_skt[l_ac].sktud13,
                                  sktud14 = g_skt[l_ac].sktud14,
                                  sktud15 = g_skt[l_ac].sktud15
                                  #FUN-850068 --end-- 
               WHERE skt01=g_sks.sks01 AND skt02=g_skt_t.skt02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err3("upd","skt_file",g_sks.sks01,g_skt_t.skt02,SQLCA.sqlcode,"","",1)  
                 LET g_skt[l_ac].* = g_skt_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac          #FUN-D40030 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_skt[l_ac].* = g_skt_t.*
              #FUN-D40030---add---str---
              ELSE
                 CALL g_skt.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030---add---end---
              END IF
              CLOSE t110_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac         #FUN-D40030 add
           CLOSE t110_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(skt02) AND l_ac > 1 THEN
              LET g_skt[l_ac].* = g_skt[l_ac-1].*
              NEXT FIELD skt02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(skt03) #工單單號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_sfb07"
                   LET g_qryparam.default1 = g_skt[l_ac].skt03
                   CALL cl_create_qry() RETURNING g_skt[l_ac].skt03
                   DISPLAY BY NAME g_skt[l_ac].skt03           
                   NEXT FIELD skt03
                 OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
 
    LET g_sks.sksmodu = g_user
    LET g_sks.sksdate = g_today
    UPDATE sks_file SET sksmodu = g_sks.sksmodu,sksdate = g_sks.sksdate
     WHERE sks01 = g_sks.sks01
    DISPLAY BY NAME g_sks.sksmodu,g_sks.sksdate
 
    CLOSE t110_bcl
    COMMIT WORK
#   CALL t110_delall()  #CHI-C30002 mark
    CALL t110_delHeader()     #CHI-C30002 add
    
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t110_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_sks.sks01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM sks_file ",
                  "  WHERE sks01 LIKE '",l_slip,"%' ",
                  "    AND sks01 > '",g_sks.sks01,"'"
      PREPARE t110_pb1 FROM l_sql 
      EXECUTE t110_pb1 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         #CALL t110_v()            #CHI-D20010
         CALL t110_v(1)            #CHI-D20010
         CALL t110_field_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM sks_file WHERE sks01 = g_sks.sks01
         INITIALIZE g_sks.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t110_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM skt_file
#   WHERE skt01 = g_sks.sks01
#
#  IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM sks_file WHERE sks01 = g_sks.sks01
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t110_b_askkey()
DEFINE
    #l_wc2           LIKE type_file.chr1000 
    l_wc2           STRING       #NO.FUN-910082 
 
    CONSTRUCT l_wc2 ON skt02,skt03,skt04,skt05,skt06,skt07,skt08
                       #No.FUN-850068 --start--
                       ,sktud01,sktud02,sktud03,sktud04,sktud05
                       ,sktud06,sktud07,sktud08,sktud09,sktud10
                       ,sktud11,sktud12,sktud13,sktud14,sktud15
                       #No.FUN-850068 ---end---
            FROM s_skt[1].skt02,s_skt[1].skt03,s_skt[1].skt04,
                 s_skt[1].skt05,s_skt[1].skt06,s_skt[1].skt07,
                 s_skt[1].skt08
                 #No.FUN-850068 --start--
                 ,s_skt[1].sktud01,s_skt[1].sktud02,s_skt[1].sktud03
                 ,s_skt[1].sktud04,s_skt[1].sktud05,s_skt[1].sktud06
                 ,s_skt[1].sktud07,s_skt[1].sktud08,s_skt[1].sktud09
                 ,s_skt[1].sktud10,s_skt[1].sktud11,s_skt[1].sktud12
                 ,s_skt[1].sktud13,s_skt[1].sktud14,s_skt[1].sktud15
                 #No.FUN-850068 ---end---
 
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL t110_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t110_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   # p_wc2           LIKE type_file.chr1000 
    p_wc2           STRING       #NO.FUN-910082 
 
    IF cl_null(p_wc2) THEN
       LET p_wc2='1=1 '
    END IF
 
    LET g_sql = "SELECT skt02,skt03,skt04,skt05,skt06,skt07,skt08,",
                #No.FUN-850068 --start--
                "       sktud01,sktud02,sktud03,sktud04,sktud05,",
                "       sktud06,sktud07,sktud08,sktud09,sktud10,",
                "       sktud11,sktud12,sktud13,sktud14,sktud15 ", 
                #No.FUN-850068 ---end---
                " FROM skt_file", 
                " WHERE skt01 ='",g_sks.sks01,"' AND ",  #單頭
                p_wc2 CLIPPED,                           #單身
                " ORDER BY 1"
    PREPARE t110_pb FROM g_sql
    DECLARE skt_cs                       #CURSOR
        CURSOR FOR t110_pb
 
    CALL g_skt.clear()
    LET g_cnt = 1
    FOREACH skt_cs INTO g_skt[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_skt.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_skt TO s_skt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t110_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL t110_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY                  
 
      ON ACTION jump
         CALL t110_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION next
         CALL t110_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                  
 
      ON ACTION last
         CALL t110_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                  
 
#     ON ACTION reproduce
#        LET g_action_choice="reproduce"
#        EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end

      #CHI-D20010--add--str
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010--add---end

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
 
      ON ACTION controls                                     
         CALL cl_set_head_visible("","AUTO")       
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE) 
END FUNCTION
 
#FUNCTION t110_copy()
#DEFINE
#    l_newno         LIKE sks_file.sks01,
#    l_newdate       LIKE sks_file.sks02,
#    l_sks03         LIKE sks_file.sks03, 
#    l_oldno         LIKE sks_file.sks01,
#    li_result       LIKE type_file.num5  
#
#    IF s_shut(0) THEN RETURN END IF
#    IF g_sks.sks01 IS NULL THEN
#       CALL cl_err('',-400,0)
#       RETURN
#    END IF
#     LET l_newno   = NULL              
#     LET l_newdate = NULL              
#     LET l_sks03   = NULL             
#     LET g_before_input_done = FALSE   
#     CALL t110_set_entry('a')
#     LET g_before_input_done = TRUE   
#
#     CALL cl_set_head_visible("","YES")           
#     INPUT l_newno,l_newdate,l_sks03 FROM sks01,sks02,sks03 
# 
#        BEFORE INPUT
#            CALL cl_set_docno_format("sks01")     
#
#        AFTER FIELD sks01
#                CALL s_check_no("asf",l_newno,"","R","sks_file","sks01","")
#                   RETURNING li_result,l_newno
#                DISPLAY l_newno to sks01
#                IF (NOT li_result) THEN
#                    NEXT FIELD sks01
#                END IF
#         
#        AFTER FIELD sks03                       #廠商編號
#           IF NOT cl_null(l_sks03) THEN
#               LET g_chr=NULL
#               LET g_sks.sks03=l_sks03
#               CALL t110_sks03('a')
#               LET g_sks.sks03=NULL
#               IF NOT cl_null(g_errno) THEN
#                  CALL cl_err(l_sks03,g_errno,0)
#                  NEXT FIELD sks03
#               END IF
#           END IF
#        
#
#        ON ACTION controlp
#            CASE
#               WHEN INFIELD(sks01) #移轉單號
#                    LET g_t1=s_get_doc_no(l_newno)     
#                    CALL q_smy(FALSE,FALSE,g_t1,'APM','5') RETURNING g_t1 
#                    LET l_newno=g_t1                   
#                    DISPLAY l_newno TO sks01
#                    CALL t110_sks01('d')
#                    NEXT FIELD sks01
#        
#               WHEN INFIELD(sks03) #移出部門
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_eca1"
#                  LET g_qryparam.default1 = g_sks.sks03
#                  CALL cl_create_qry() RETURNING g_sks.sks03
#                  DISPLAY BY NAME g_sks.sks03
#                  NEXT FIELD sks03
#                  
#               WHEN INFIELD(sks04) #移入部門
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_eca1"
#                  LET g_qryparam.default1 = g_sks.sks04
#                  CALL cl_create_qry() RETURNING g_sks.sks04
#                  DISPLAY BY NAME g_sks.sks04
#                  NEXT FIELD sks04
#     
#               OTHERWISE EXIT CASE
#            END CASE
# 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
# 
#      ON ACTION about         
#         CALL cl_about()      
# 
#      ON ACTION help          
#         CALL cl_show_help()  
# 
#      ON ACTION controlg     
#         CALL cl_cmdask()   
# 
# 
#    END INPUT
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0
#       ROLLBACK WORK         
#       DISPLAY BY NAME g_sks.sks01
#       RETURN
#    END IF
#
#    #單頭
#    DROP TABLE y
#    SELECT * FROM sks_file
#        WHERE sks01=g_sks.sks01
#        INTO TEMP y
#
#    #單身
#    DROP TABLE x
#    SELECT * FROM skt_file
#     WHERE skt01=g_sks.sks01
#      INTO TEMP x
#
#    BEGIN WORK
#    LET g_success = 'Y'
#
#    #==>單頭複製
#    UPDATE y SET sks01=l_newno,    #新的鍵值
#                 sks02=l_newdate,  #新的鍵值
#                 sks03=l_sks03,    
#                 sksuser=g_user,   #資料所有者
#                 sksgrup=g_grup,   #資料所有者所屬群
#                 sksmodu=NULL,     #資料修改日期
#                 sksdate=g_today,  #資料建立日期
#                 sksacti='Y',      #有效資料
#                 sks06='N'         #確認
#
#    INSERT INTO sks_file SELECT * FROM y
#
#    IF SQLCA.sqlcode THEN
#        CALL cl_err3("ins","sks_file","","",SQLCA.sqlcode,"","",1)  
#        LET g_success = 'N'
#        ROLLBACK WORK
#        RETURN
#     ELSE
#        COMMIT WORK
#     END IF
#
#
#    IF g_success = 'Y' THEN
#        #==>單身複製
#        UPDATE x SET skt01=l_newno
#        INSERT INTO skt_file SELECT * FROM x
#        IF SQLCA.sqlcode THEN
#            CALL cl_err3("ins","skt_file","","",SQLCA.sqlcode,"","INSERT INTO skt_file",1)
#            LET g_success = 'N'
#        ELSE
#            LET g_cnt=SQLCA.SQLERRD[3]
#            MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
#        END IF
#    END IF
#
#    IF g_success = 'Y' THEN
#        COMMIT WORK
#        LET l_oldno = g_sks.sks01
#        SELECT * INTO g_sks.* FROM sks_file WHERE sks01 = l_newno
#        CALL t110_u()
#        CALL t110_b()
#    ELSE
#        ROLLBACK WORK
#    END IF
#
#    SELECT * INTO g_sks.* FROM sks_file WHERE sks01 = l_oldno
#
#    CALL t110_show()
#
#END FUNCTION
#
#
#FUNCTION t110_out()
#   DEFINE l_cmd        LIKE type_file.chr1000, 
#          l_wc,l_wc2   LIKE type_file.chr1000, 
#          l_prtway     LIKE type_file.chr1     
#
#   SELECT COUNT(*) INTO l_cnt
#     FROM skt_file
#    WHERE skt01=g_sks.sks01
#
#   IF l_cnt = 0 OR l_cnt IS NULL THEN
#      CALL cl_err('','arm-034',1)
#      RETURN
#   END IF
#
#   CALL cl_wait()
#
#   LET l_wc='sks01="',g_sks.sks01,'"'
#
#   SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'askt110'
#   IF SQLCA.sqlcode OR l_wc2 IS NULL THEN
#      LET l_wc2 = " '3' 'N' "
#   END IF
#
#   LET l_cmd = "askt110",
#                " '",g_today CLIPPED,"' ''",
#                " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
#                " '",l_wc CLIPPED,"' '3'"   
#
#   CALL cl_cmdrun(l_cmd)
#
#   ERROR ' '
#
#END FUNCTION
 
FUNCTION t110_z()
   DEFINE  l_skt           RECORD LIKE skt_file.*
   DEFINE  l_sfb           RECORD LIKE sfb_file.*
   DEFINE  l_a             LIKE type_file.num5 
   
   IF g_sks.sks01 IS NULL THEN RETURN END IF
    SELECT * INTO g_sks.* FROM sks_file
     WHERE sks01=g_sks.sks01
   IF g_sks.sks06='N' THEN RETURN END IF
   IF g_sks.sks06='X' THEN RETURN END IF  #CHI-C80041
   DECLARE t110_chk_skt CURSOR FOR
       SELECT skt03 FROM skt_file
        WHERE skt01 = g_sks.sks01
 
   INITIALIZE l_skt.* TO NULL
 
   FOREACH t110_chk_skt INTO l_skt.skt03
      SELECT skt01 INTO l_skt.skt01 FROM sks_file,skt_file
       WHERE sks03=g_sks.sks03
         AND sks06='N'
         AND sks01!=g_sks.sks01
         AND skt01=sks01
         AND skt03 = l_skt.skt03
      IF NOT cl_null(l_skt.skt01) THEN
         LET g_message = NULL
         LET g_message = 'NO:',l_skt.skt01,'==>',l_skt.skt03 CLIPPED
         LET g_message = g_message CLIPPED
         CALL cl_err(g_message,'apm-262',0)
         RETURN
      END IF
      SELECT skt03 INTO l_skt.skt03 FROM sfb_file,skt_file
       WHERE sfb_file.sfb01 = g_skt[l_ac].skt03
         IF NOT cl_null(l_skt.skt03) THEN
            SELECT sfb08 INTO l_sfb.sfb08 FROM sfb_file
              IF l_sfb.sfb08 = '8' THEN
               CALL cl_err('','ask1007',1)
              ELSE
              	UPDATE skq_file SET skq_file.skq05 = NULL
              	                WHERE skq01 =g_skt[l_ac].skt03
              END IF 	                
              	SELECT * INTO l_a FROM skr_file WHERE skr_file.skr08>0
              	  IF cl_null(l_a) THEN
              	     UPDATE skq_file SET skq_file.skq04 = NULL
              	                WHERE skq01 =g_skt[l_ac].skt03               
              	  END IF 
         END IF     	  
      INITIALIZE l_skt.* TO NULL
   END FOREACH
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
   OPEN t110_cl USING g_sks.sks01
   #--Add exception check during OPEN CURSOR
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t110_cl INTO g_sks.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_sks.sks01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
    UPDATE sks_file SET sks06='N' 
                WHERE sks01=g_sks.sks01
 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","sks_file",g_sks.sks01,"","apm-266","","upd sks_file",1)
      LET g_success='N'
   END IF 
 
   IF g_success = 'Y' THEN
      LET g_sks.sks06='N'
      COMMIT WORK
      DISPLAY BY NAME g_sks.sks06
   ELSE
      LET g_sks.sks06='Y'
      DISPLAY BY NAME g_sks.sks06
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t110_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sks01",TRUE)
    END IF
END FUNCTION
 
FUNCTION t110_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
  DEFINE l_n     LIKE type_file.num5   
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sks01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t110_y()
DEFINE
    l_n             LIKE type_file.num5,    #檢查重複用  
    l_b             LIKE type_file.num5,
    l_skt           RECORD LIKE skt_file.*,
    l_skt07         LIKE skt_file.skt07,
    l_skr08         LIKE skr_file.skr08,
    l_skq04         LIKE skq_file.skq04
    
   IF g_sks.sks01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_sks.sks06 !='N' THEN
      CALL cl_err('','9023',0)      
      RETURN
   END IF
   IF g_sks.sksacti = 'N' THEN
      CALL cl_err('','9028',0)      
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 --------------------- add ----------------------- begin
   SELECT * INTO g_sks.* FROM sks_file WHERE sks01 = g_sks.sks01
   IF g_sks.sks01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_sks.sks06 !='N' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF g_sks.sksacti = 'N' THEN
      CALL cl_err('','9028',0)
      RETURN
   END IF
#CHI-C30107 --------------------- add ----------------------- end
   BEGIN WORK
   
   OPEN t110_cl USING g_sks.sks01
   IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_sks.*               #對DB鎖定
    
   DECLARE t110_y CURSOR FOR SELECT * FROM skt_file WHERE skt01=g_sks.sks01 
    FOREACH t110_y INTO l_skt.*
       IF STATUS THEN EXIT FOREACH END IF
          CALL t110_skt07(l_skt.skt03,l_skt.skt04,l_skt.skt05) 
               RETURNING l_skt07,l_skt.skt06   
          IF l_skt.skt07 > = l_skt07 THEN
            IF NOT cl_null(l_skt.skt04) THEN
             SELECT skr08 INTO l_skr08 FROM skr_file
                 WHERE skr_file.skr01=l_skt.skt03 
                   AND skr_file.skr03=l_skt.skt05
                   AND skr_file.skr02=l_skt.skt04   
             UPDATE skr_file SET skr_file.skr08=l_skr08+l_skt.skt07 
              WHERE skr_file.skr01=l_skt.skt03 
                AND skr_file.skr03=l_skt.skt05
                AND skr_file.skr02=l_skt.skt04
            ELSE 
             SELECT skr08 INTO l_skr08 FROM skr_file
                 WHERE skr_file.skr01=l_skt.skt03 
                   AND skr_file.skr03=l_skt.skt05
             UPDATE skr_file SET skr_file.skr08=l_skr08+l_skt.skt07 
              WHERE skr_file.skr01=l_skt.skt03 
                AND skr_file.skr03=l_skt.skt05 
            END IF
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err('',SQLCA.sqlcode,0) 
               ROLLBACK WORK
            END IF           
          ELSE
             CALL cl_err_msg('','ask-041',l_skt.skt02 CLIPPED||'|'||l_skt.skt07 CLIPPED,0)
             ROLLBACK WORK 
             RETURN
          END IF
    UPDATE sks_file SET sks06 = g_sks.sks06
                  WHERE sks01 = g_sks.sks01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
       CALL cl_err3("upd","sks_file",g_sks.sks01,"",SQLCA.sqlcode,"","",0)
       ROLLBACK WORK
       RETURN
    END IF 
       
       IF NOT cl_null(l_skt.skt04) THEN  
         SELECT skq04 INTO l_skq04 FROM skq_file 
          WHERE skq01=l_skt.skt03 
            AND skq03=l_skt.skt04 
       ELSE
       	 SELECT skq04 INTO l_skq04 FROM skq_file 
          WHERE skq01=l_skt.skt03        
       END IF 
       IF cl_null(l_skq04) THEN
          UPDATE skq_file SET skq_file.skq04=g_sks.sks02,
                              skq_file.skq05=g_sks.sks02
       END IF 
        IF SQLCA.sqlcode  THEN
          CALL cl_err('',SQLCA.sqlcode,0)
          ROLLBACK WORK                      
        END IF 
    END FOREACH 
    LET g_sks.sks06 = 'Y'
    UPDATE sks_file SET sks_file.sks06 = g_sks.sks06
     WHERE sks01=g_sks.sks01 
     IF SQLCA.sqlcode  THEN
        CALL cl_err3("upd","sks_file",g_sks.sks01,"","apm-266","","upd sks_file",1)
        ROLLBACK WORK                      
     END IF   
    CLOSE t110_cl
    COMMIT WORK
    DISPLAY BY NAME g_sks.sks06
END FUNCTION 
 
FUNCTION t110_field_pic()
   DEFINE l_flag   LIKE type_file.chr1
 
   CASE
     #無效
     WHEN g_sks.sksacti = 'N' 
        CALL cl_set_field_pic("","","","","","N")
     #審核
     WHEN g_sks.sks06 = 'Y' 
        CALL cl_set_field_pic("Y","","","","","")
     WHEN g_sks.sks06 = 'X'  # CHI-C80041
        CALL cl_set_field_pic("","","","","Y","")  #CHI-C80041
     OTHERWISE
        CALL cl_set_field_pic("","","","","","")
   END CASE
END FUNCTION
 
FUNCTION t110_skt07(p_skt03,p_skt04,p_skt05)
DEFINE l_n  LIKE type_file.num5,
       l_n1,l_n2 LIKE type_file.num5,
       p_skt03   LIKE skt_file.skt03,
       p_skt04   LIKE skt_file.skt04,
       p_skt05   LIKE skt_file.skt05
 
     SELECT skr07-skr08 INTO l_n FROM skr_file
        WHERE skr01 = p_skt03
          AND skr02 = p_skt04
          AND skr03 = p_skt05
     IF cl_null(l_n) THEN
        LET l_n = 0
     END IF         
     SELECT skr06 INTO l_n2 FROM skr_file
        WHERE skr01 = p_skt03
          AND skr02 = p_skt04
          AND skr03 = p_skt05 
     IF cl_null(l_n2) THEN
        LET l_n2 = 0
     END IF         
     SELECT SUM(skt07) INTO l_n1 FROM skt_file,sks_file
       WHERE skt01 = p_skt03
         AND skt02 = p_skt04
         AND skt03 = p_skt05
         AND sks01 = skt01
         AND sks06 = 'N' 
         AND sksacti = 'Y' 
      IF cl_null(l_n1) THEN
        LET l_n1 = 0
     END IF   
      LET l_n = l_n - l_n1
      RETURN l_n,l_n2
END FUNCTION            
#No.FUN-830087 FUN-840178         
#CHI-C80041---begin
#FUNCTION t110_v()        #CHI-D20010
FUNCTION t110_v(p_type)        #CHI-D20010
   DEFINE l_chr LIKE type_file.chr1
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_sks.sks01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_sks.sks06='X' THEN RETURN END IF
   ELSE
      IF g_sks.sks06<>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t110_cl USING g_sks.sks01
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t110_cl INTO g_sks.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_sks.sks01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t110_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_sks.sks06 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
  #IF cl_void(0,0,g_sks.sks06)   THEN                 #CHI-D20010
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #CHI-D20010
   IF cl_void(0,0,l_flag) THEN                                         #CHI-D20010  
        LET l_chr=g_sks.sks06
       #IF g_sks.sks06='N' THEN                                        #CHI-D20010
        IF p_type = 1 THEN                                             #CHI-D20010
            LET g_sks.sks06='X' 
        ELSE
            LET g_sks.sks06='N'
        END IF
        UPDATE sks_file
            SET sks06=g_sks.sks06,  
                sksmodu=g_user,
                sksdate=g_today
            WHERE sks01=g_sks.sks01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","sks_file",g_sks.sks01,"",SQLCA.sqlcode,"","",1)  
            LET g_sks.sks06=l_chr 
        END IF
        DISPLAY BY NAME g_sks.sks06
   END IF
 
   CLOSE t110_cl
   COMMIT WORK
   CALL cl_flow_notify(g_sks.sks01,'V')
 
END FUNCTION
#CHI-C80041---end
