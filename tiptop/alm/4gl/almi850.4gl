# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almi850.4gl
# Descriptions...: 商戶商品維護作業
# Date & Author..: No.FUN-960058 09/06/12 By destiny 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/25 By destiny 复制时lmv01带出的字段不会重新显示 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A90033 10/09/19 by suncx 新增 lmvacti，lmvpos欄位
# Modify.........: No:FUN-A90049 10/09/27 By shaoyong 全部抓取lmu_file 需調整改為 ima_file 且料件性質='2.商戶料號'
# Modify.........: No:FUN-A90049 10/09/28 By lixh1 1.料件開窗 q_lmu* 改抓 q_ima* ，修改為全系統料號開窗控管
#                                                  2.產品代號 (lmv02) AFTER FIELD 改為全系統AFTER FIELD 料號控管改法											
# Modify.........: No:FUN-A90040 10/12/28 By shenyang   原使用 lrb_file 判別產品是否已被使用, 現在改抓 ogb_file 依商戶判別產品是否已被使用.
# Modify.........: No.FUN-AB0031 10/11/08 By suncx POS中間庫資料下載相關程式Bug修正.
# Modify.........: No.FUN-AB0011 10/11/01 By lixh1 料件開窗及POS相關BUG修正 
# Modify.........: No.FUN-AA0057 10/11/24 By shenyang  招商整合bug修改
# Modify.........: No:FUN-B40071 11/04/28 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80060 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.FUN-B70075 11/10/26 By nanbing 更新已傳POS否的狀態
# Modify.........: No.FUN-C40109 12/05/09 By fanbj 畫面單頭欄位增加，對應代碼調整
# Modify.........: No.FUN-C50036 12/05/31 By yangxf 如果aza88=Y， 已传pos否<>'1'，更改时把key值noentry
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_lmv01          LIKE lmv_file.lmv01,
     g_lmv01_t        LIKE lmv_file.lmv01,
     #FUN-C40109--start add---------------
     g_lmv03          LIKE lmv_file.lmv03,
     g_lmv03_t        LIKE lmv_file.lmv03,   
     #FUN-C40109--end add----------------- 
     g_lmv           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables) 
         
        lmv02       LIKE lmv_file.lmv02,   
        ima02       LIKE ima_file.ima02,               #No.FUN-A90049 mod 
        ima021       LIKE ima_file.ima021,
        ima128       LIKE ima_file.ima128,
        lmvacti     LIKE lmv_file.lmvacti,   #No.FUN-A90033 add by suncx
        lmvpos      LIKE lmv_file.lmvpos     #No.FUN-A90033 add by suncx
                    END RECORD,
     g_lmv_t         RECORD                #程式變數 (舊值)  
        lmv02       LIKE lmv_file.lmv02,   
        ima02       LIKE ima_file.ima02,
        ima021       LIKE ima_file.ima021,
        ima128       LIKE ima_file.ima128,
        lmvacti     LIKE lmv_file.lmvacti,   #No.FUN-A90033 add by suncx
        lmvpos      LIKE lmv_file.lmvpos     #No.FUN-A90033 add by suncx 
                    END RECORD,        
       
    g_wc,g_sql,g_wc2  STRING,                                                   
    g_show            LIKE type_file.chr1,         
    g_rec_b           LIKE type_file.num5,    #單身筆數 
    g_flag            LIKE type_file.chr1,               
    g_ss              LIKE type_file.chr1,               
    l_ac              LIKE type_file.num5    #目前處理                                   
DEFINE   g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL                       
DEFINE   g_sql_tmp    STRING                              
DEFINE   g_before_input_done   LIKE type_file.num5     
DEFINE   g_chr                 LIKE type_file.chr1
DEFINE   g_cnt                 LIKE type_file.num10      
DEFINE   g_msg         LIKE ze_file.ze03            
DEFINE   g_jump        LIKE type_file.num10   
DEFINE   g_abso        LIKE type_file.num10   
DEFINE   g_row_count   LIKE type_file.num10       
DEFINE   g_curs_index  LIKE type_file.num10          
DEFINE   g_no_ask     LIKE type_file.num5
DEFINE   l_cmd         LIKE type_file.chr1000  
DEFINE   g_str         STRING
 
MAIN                                                                            
DEFINE l_lpj03   LIKE lpj_file.lpj03
DEFINE l_lpk     RECORD LIKE lpk_file.*

   OPTIONS                               #改變一些系統預設值                   
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理               

   IF (NOT cl_user()) THEN                                                      
      EXIT PROGRAM                                                              
   END IF                                                                       
 
   WHENEVER ERROR CALL cl_err_msg_log                                           
                                                                                
   IF (NOT cl_setup("ALM")) THEN                                                
      EXIT PROGRAM                                                              
   END IF 

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW i850_w WITH FORM "alm/42f/almi850"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   #No.FUN-A90033 add start------------------
   IF g_aza.aza88 = 'Y' THEN
      CALL cl_set_comp_visible("lmvpos",TRUE)
   ELSE
      CALL cl_set_comp_visible("lmvpos",FALSE)
   END IF
   #No.FUN-A90033 add end------------------
   CALL i850_menu()
   CLOSE WINDOW i850_w                 #結束畫面 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#FUN-C40109--start mark---------------------------------------------------
##QBE 查詢資料                                                                   
#FUNCTION i850_cs()                                                              
#DEFINE l_sql STRING  
#                                                           
#   CLEAR FORM 
#   CALL g_lmv.clear() 
#                                                                                      
#       INITIALIZE g_lmv01 TO NULL                    
#       #CONSTRUCT g_wc ON lmv01,lmv02,      #FUN-AB0031 mark
#       #     FROM lmv01,s_lmv[1].lmv02      #FUN-AB0031 mark
#       CONSTRUCT g_wc ON lmv01,lmv02,lmvpos            #FUN-AB0031 add
#            FROM lmv01,s_lmv[1].lmv02,s_lmv[1].lmvpos  #FUN-AB0031 add
#                
#       BEFORE CONSTRUCT                                                         
#          CALL cl_qbe_init()                     
# 
#       ON ACTION CONTROLP
#          CASE
#             WHEN INFIELD(lmv01)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form  ="q_lmv01"
#                LET g_qryparam.state ="c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO lmv01
#                NEXT FIELD lmv01
#             WHEN INFIELD(lmv02) 
#                CALL cl_init_qry_var()                                          
#                LET g_qryparam.form  ="q_lmv02"                                   
#                LET g_qryparam.state ="c"                                  
#                CALL cl_create_qry() RETURNING g_qryparam.multiret    
#                DISPLAY g_qryparam.multiret TO lmv02                           
#                NEXT FIELD lmv02
#          END CASE
#          
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE CONSTRUCT
#       
#       ON ACTION about        
#          CALL cl_about()      
#       
#       ON ACTION help          
#          CALL cl_show_help()  
#       
#       ON ACTION controlg      
#          CALL cl_cmdask()     
# 
#       ON ACTION qbe_select
#          CALL cl_qbe_select()
#          
#       ON ACTION qbe_save
#          CALL cl_qbe_save()
#       
#       END CONSTRUCT
#       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
# 
#       IF INT_FLAG THEN
#          RETURN
#       END IF
# 
#    IF cl_null(g_wc) THEN
#       LET g_wc="1=1"
#    END IF
#    
#    LET l_sql="SELECT UNIQUE lmv01 FROM lmv_file ",
#              " WHERE ", g_wc CLIPPED
#    LET g_sql= l_sql," ORDER BY lmv01"       
#    PREPARE i850_prepare FROM g_sql      #預備一下                              
#    DECLARE i850_bcs                     #宣告成動的                        
#      SCROLL CURSOR WITH HOLD FOR i850_prepare                                
# 
#    LET g_sql = "SELECT COUNT(UNIQUE lmv01) FROM lmv_file WHERE ",g_wc CLIPPED  
#    PREPARE i850_precount FROM g_sql    
#    DECLARE i850_count CURSOR FOR i850_precount
# 
#    CALL i850_show()
#END FUNCTION     
#FUN_C40109--end mark--------------------------------------------------------------

#FUN-C40109--start add-------------------------------------------------------------
FUNCTION i850_cs()
   DEFINE l_sql STRING

   CLEAR FORM
   CALL g_lmv.clear()

   INITIALIZE g_lmv01 TO NULL
   INITIALIZE g_lmv03 TO NULL
   CONSTRUCT g_wc ON lmv01,lmv03,lmv02,lmvacti,lmvpos
        FROM lmv01,lmv03,s_lmv[1].lmv02,s_lmv[1].lmvacti,s_lmv[1].lmvpos

   BEFORE CONSTRUCT
      CALL cl_qbe_init()

   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(lmv01)
            CALL cl_init_qry_var()
            LET g_qryparam.form  ="q_lmv01"
            LET g_qryparam.state ="c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO lmv01
            NEXT FIELD lmv01
         WHEN INFIELD(lmv02)
            CALL cl_init_qry_var()
            LET g_qryparam.form  ="q_lmv02"
            LET g_qryparam.state ="c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO lmv02
            NEXT FIELD lmv02
         WHEN INFIELD(lmv03)
            CALL cl_init_qry_var()
            LET g_qryparam.form  ="q_lmv03"
            LET g_qryparam.state ="c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO lmv03
            NEXT FIELD lmv03
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) 

   IF INT_FLAG THEN
      RETURN
   END IF

   IF cl_null(g_wc) THEN
      LET g_wc=" 1=1"
   END IF

   LET l_sql="SELECT UNIQUE lmv01,lmv03 FROM lmv_file ",
             " WHERE ", g_wc CLIPPED
   LET g_sql= l_sql," ORDER BY lmv01,lmv03"
   PREPARE i850_prepare FROM g_sql      #預備一下
   DECLARE i850_bcs                     #宣告成動的
     SCROLL CURSOR WITH HOLD FOR i850_prepare

   DROP TABLE lmv_temp 
   LET g_sql = " SELECT DISTINCT lmv01,lmv03 ",
               "  FROM lmv_file",
               " WHERE ",g_wc CLIPPED,
               " GROUP BY lmv01,lmv03 ",
               "  INTO TEMP lmv_temp"
   PREPARE i850_precount_x FROM g_sql
   EXECUTE i850_precount_x 
   LET g_sql = " SELECT COUNT(*) FROM lmv_temp "
   
   PREPARE i850_precount FROM g_sql
   DECLARE i850_count CURSOR FOR i850_precount

   CALL i850_show()
END FUNCTION
#FUN-C40109--end add---------------------------------------------------------------
 
FUNCTION i850_menu()
 
   WHILE TRUE
      CALL i850_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i850_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i850_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i850_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i850_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i850_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_lmv),'','')
            END IF
         WHEN "related_document"           
            IF cl_chk_act_auth() THEN
               IF g_lmv01 IS NOT NULL THEN
                  LET g_doc.column1 = "lmv01"
                  LET g_doc.value1 = g_lmv01
                  CALL cl_doc()
               END IF 
            END IF
      END CASE
   END WHILE
END FUNCTION     
 
FUNCTION i850_a()                                                               
   MESSAGE ""                                                                   
   CLEAR FORM                                                                   
   CALL g_lmv.clear()
 
   IF s_shut(0) THEN RETURN END IF                #浪 d v  
 
   LET g_lmv01 = NULL                                                           
   LET g_lmv01_t = NULL
   #FUN-C40109--start add-----
   LET g_lmv03 = null
   LET g_lmv03_t = null       
   #FUN-C40109--end add-------     
   
   CALL cl_opmsg('a')                                                           
                                                                                
    WHILE TRUE                                                            
       CALL i850_i("a")                   #塊 J蟲 Y                             
       IF INT_FLAG THEN                   #ㄏв  ゅ   F                         
          LET INT_FLAG = 0                                                      
          CALL cl_err('',9001,0)   
          CLEAR FORM                                              
          EXIT WHILE                                                            
       END IF                                                                   
       IF cl_null(g_lmv01) THEN                                                 
          CONTINUE WHILE                                                        
       END IF                
       IF SQLCA.sqlcode THEN                                                    
       #   ROLLBACK WORK        # FUN-B80060---回滾放在報錯後---                                                 
          CALL cl_err(g_lmv01,SQLCA.sqlcode,1)                  
          ROLLBACK WORK         # FUN-B80060--add--                
          CONTINUE WHILE                                                        
       ELSE                                                                     
          COMMIT WORK                                                           
       END IF
 
       CALL g_lmv.clear()                                                       
       LET g_rec_b = 0                                                          
       DISPLAY g_rec_b TO FORMONLY.cn2                                          
                                                                                
       CALL i850_b()                      #塊 J蟲                               
       LET g_lmv01_t = g_lmv01            # O d侶                               
       LET g_lmv03_t = g_lmv03            #FUN-C40109 add
       EXIT WHILE                                                               
    END WHILE                                                                   
    LET g_wc=' ' 
                                                    
END FUNCTION                 
 
FUNCTION i850_i(p_cmd)                                                          
DEFINE                                                                          
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改   
    l_cnt           LIKE type_file.num10,      
    l_n             LIKE type_file.num5,                                                                               
    l_n1            LIKE type_file.num5,
    l_lne36         LIKE lne_file.lne36
                                                                                
                                                             
                         
    #INPUT g_lmv01 WITHOUT DEFAULTS FROM lmv01                #FUN-C40109 mark
    INPUT g_lmv01,g_lmv03 WITHOUT DEFAULTS FROM lmv01,lmv03   #FUN-C40109 add                                    

       #FUN-C40109--start mark-----------------------------  
       #AFTER FIELD lmv01 
       #   IF NOT cl_null(g_lmv01) THEN 
       #      IF g_lmv01 != g_lmv01_t OR
       #         g_lmv01_t IS NULL THEN
       #         CALL i850_lmv01(p_cmd,g_lmv01)
       #         SELECT count(*) INTO l_n FROM lmv_file
       #          WHERE lmv01 = g_lmv01
       #         IF cl_null(g_errno) AND l_n> 0 THEN
       #            LET g_errno ='alm-054'
       #         END IF 
       #         IF NOT cl_null(g_errno) THEN                 
       #            CALL cl_err(g_lmv01,g_errno,1)  
       #            LET g_lmv01=g_lmv01_t
       #            NEXT FIELD lmv01
       #         END IF
       #      END IF
       #   END IF   
      #FUN-C40109--end mark------------------------------

      #FUN-C40109--start add----------------------------
      AFTER FIELD lmv01
         IF NOT cl_null(g_lmv01) THEN
            IF g_lmv01 <> g_lmv01_t OR cl_null(g_lmv01_t) THEN
               CALL i850_lmv01(p_cmd,g_lmv01)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lmv01 = g_lmv01_t
                  DISPLAY g_lmv01 TO lmv01
                  NEXT FIELD lmv01
               END IF 
               IF NOT cl_null(g_lmv03) THEN
                  CALL i850_lmv_chk(g_lmv01,g_lmv03)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lmv01 = g_lmv01_t
                     DISPLAY g_lmv01 TO lmv01
                     NEXT FIELD lmv01
                  END IF 
               END IF 
            END IF   
         END IF 

      AFTER FIELD lmv03
         IF NOT cl_null(g_lmv03) THEN
            CALL i850_lmv03(p_cmd,g_lmv03)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lmv03 = g_lmv03_t
               DISPLAY g_lmv03 TO lmv03
               NEXT FIELD lmv03
            END IF 
            IF NOT cl_null(g_lmv01) THEN    
               CALL i850_lmv_chk(g_lmv01,g_lmv03)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lmv03 = g_lmv03_t
                  DISPLAY g_lmv03 TO lmv03
                  NEXT FIELD lmv03
               END IF
            END IF 
         END IF    
      #FUN-C40109--end add------------------------------ 
                                                                
       AFTER INPUT          
          IF INT_FLAG THEN
             EXIT INPUT
          END IF                                                    
          IF g_lmv01 IS NULL THEN               
             NEXT FIELD lmv01                  
          END IF 
 
         ON ACTION CONTROLP                                                       
            CASE                                                                  
               WHEN INFIELD(lmv01)                                                
                  CALL cl_init_qry_var()                                          
                  LET g_qryparam.form  ="q_lne_1"                                   
                  LET g_qryparam.default1 = g_lmv01              
                  CALL cl_create_qry() RETURNING g_lmv01               
                  DISPLAY g_lmv01 TO lmv01                               
                  NEXT FIELD lmv01 
              #FUN-C40109--start add-------------------
               WHEN INFIELD(lmv03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  ="q_lja06i"
                  LET g_qryparam.default1 = g_lmv03
                  CALL cl_create_qry() RETURNING g_lmv03
                  DISPLAY g_lmv03 TO lmv03
                  NEXT FIELD lmv03 
               #FUN-C40109--end add---------------------
              OTHERWISE EXIT CASE
            END CASE        
 
         ON ACTION CONTROLG                                                     
           CALL cl_cmdask()                                                     
                                                                                
         ON IDLE g_idle_seconds                                                 
           CALL cl_on_idle()                                                    
           CONTINUE INPUT                                                       
                                                                                
         ON ACTION about                                       
            CALL cl_about()                                     
                                                                                
         ON ACTION help                                        
            CALL cl_show_help()                                
                                                                                
         ON ACTION CONTROLF                  #欄位說明                            
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)                          
    END INPUT          
END FUNCTION
 
FUNCTION i850_q()                                                               
   LET g_lmv01 = ''                                                                                                                                                                                   
   LET g_lmv03 = ''           #FUN-C40109 add 
   LET g_row_count = 0                                                          
   LET g_curs_index = 0                                                         
   CALL cl_navigator_setting( g_curs_index, g_row_count )                       
   INITIALIZE g_lmv01 TO NULL                            
   MESSAGE ""                                                                   
   CALL cl_opmsg('q')                                                           
   CLEAR FORM                                                                   
   CALL g_lmv.clear()                                                           
   DISPLAY '' TO FORMONLY.cnt                                                   
                                                                                
   CALL i850_cs()                      #取得查詢條件                            
                                                                                
   IF INT_FLAG THEN                    #使用者不玩了                            
      LET INT_FLAG = 0         
      INITIALIZE g_lmv01 TO NULL                                        
      INITIALIZE g_lmv03 TO NULL       #FUN-C40109 add
      CALL g_lmv.clear()               #FUN-C40109 add
      RETURN                                                                    
   END IF                                                                       
                                                                                
   OPEN i850_bcs                       #從DB產生合乎條件TEMP(0-30秒)            
   IF SQLCA.sqlcode THEN               #有問題                                  
      CALL cl_err('',SQLCA.sqlcode,0)                                           
      INITIALIZE g_lmv01 TO NULL                                        
      INITIALIZE g_lmv03 TO NULL       #FUN-C40109 add
   ELSE                                                                         
      OPEN i850_count                                                           
      FETCH i850_count INTO g_row_count   
      DISPLAY g_row_count TO FORMONLY.cnt                                       
      CALL i850_fetch('F')            #讀出TEMP第一筆并顯示                     
   END IF                                                                       
                                                                                
END FUNCTION     
 
#處理資料的讀取                                                                 
FUNCTION i850_fetch(p_flag)                                                     
DEFINE                                                                          
   p_flag          LIKE type_file.chr1    #處理方式       
                                                                                
   MESSAGE ""                                                                   
   CASE p_flag                                                                  
   #FUN-C40109--start mark--------------------------- 
       #WHEN 'N' FETCH NEXT     i850_bcs INTO g_lmv01                   
       #WHEN 'P' FETCH PREVIOUS i850_bcs INTO g_lmv01             
       #WHEN 'F' FETCH FIRST    i850_bcs INTO g_lmv01       
       #WHEN 'L' FETCH LAST     i850_bcs INTO g_lmv01
   #FUN-C40109--end mark----------------------------- 
   #FUN-C40109--start add----------------------------
       WHEN 'N' FETCH NEXT     i850_bcs INTO g_lmv01,g_lmv03
       WHEN 'P' FETCH PREVIOUS i850_bcs INTO g_lmv01,g_lmv03
       WHEN 'F' FETCH FIRST    i850_bcs INTO g_lmv01,g_lmv03
       WHEN 'L' FETCH LAST     i850_bcs INTO g_lmv01,g_lmv03
   #FUN-C40109--end add------------------------------
       WHEN '/'  
         IF (NOT g_no_ask) THEN                                                              
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg                      
            LET INT_FLAG = 0                            
            PROMPT g_msg CLIPPED,': ' FOR g_abso  
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
              
               ON ACTION about    
                  CALL cl_about()   
              
               ON ACTION help          
                  CALL cl_show_help() 
              
               ON ACTION controlg      
                  CALL cl_cmdask()     
              
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF 
            FETCH ABSOLUTE g_abso i850_bcs 
                  #INTO g_lmv01              #FUN-C40109 mark
                  INTO g_lmv01,g_lmv03       #FUN-C40109 add  
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                     #有麻煩
      CALL cl_err(g_lmv01,SQLCA.sqlcode,0)
      INITIALIZE g_lmv01 TO NULL  
      INITIALIZE g_lmv03 TO NULL             #FUN-C40109 add  
   ELSE
      CALL i850_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.indx    #FUN-C40109 add     
   END IF
 
END FUNCTION
 
                                                             
FUNCTION i850_show()                                                            
   #FUN-C40109--start add---------
   LET g_lmv01_t = g_lmv01
   LET g_lmv03_t = g_lmv03
   DISPLAY g_lmv03 TO lmv03 
   #FUN-C40109--end add-----------
   DISPLAY g_lmv01 TO lmv01
 
   CALL i850_lmv01('d',g_lmv01)                                                                             
   CALL i850_lmv03('d',g_lmv03)                        #FUN-C40109 add
   CALL i850_b_fill(g_wc)                      #單身                            
   CALL cl_show_fld_cont()                             
END FUNCTION
 
#FUN-C40109--start mark-----------------------------------------------                                                                     
#FUNCTION i850_b()                                                               
#DEFINE                                                                          
#   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT 
#   l_n             LIKE type_file.num5,          #檢查重復用        
#   l_n1            LIKE type_file.num5,          #檢查重復用        
#   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        
#   p_cmd           LIKE type_file.chr1,          #處理狀態         
#   l_allow_insert  LIKE type_file.num5,          #可新增否         
#   l_allow_delete  LIKE type_file.num5,          #可刪除否         
#   l_cnt           LIKE type_file.num10,     
#   l_imaacti       LIKE ima_file.imaacti,
#   l_ima02         LIKE ima_file.ima02
#DEFINE  l_lmvpos   LIKE lmv_file.lmvpos          #FUN-B70075                                                                                  
#   LET g_action_choice = ""
#                                                                               
#   IF cl_null(g_lmv01) THEN   
#      CALL cl_err('',-400,1)                                                    
#      RETURN                                        
#   END IF                                                                       
#                                                                                
#   IF s_shut(0) THEN                                                            
#      RETURN                                                                    
#   END IF           
#  
#           
#   CALL cl_opmsg('b')
# 
#  #FUN-B70075 Begin --------
#  # LET g_forupd_sql = "SELECT lmv02,'' ",
#   LET g_forupd_sql = "SELECT lmv02,'','','',lmvacti,lmvpos ",
#  #FUN-B70075 End --------
#                      " FROM lmv_file",
#                      " WHERE lmv01 = ? AND lmv02 = ?  FOR UPDATE "
#                      
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE i850_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
# 
#   LET l_ac_t = 0
#   LET l_allow_insert = cl_detail_input_auth("insert")
#   LET l_allow_delete = cl_detail_input_auth("delete")
# 
#   #IF g_rec_b=0 THEN CALL g_lmv.clear() END IF
# 
#   INPUT ARRAY g_lmv WITHOUT DEFAULTS FROM s_lmv.*
#              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
# 
#      BEFORE INPUT
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(l_ac)
#         END IF
# 
#      BEFORE ROW
#         LET p_cmd = ''
#         LET l_ac = ARR_CURR()
#         LET l_lock_sw = 'N'            #DEFAULT
#         LET l_n  = ARR_COUNT()
#         IF g_rec_b >= l_ac THEN
#           #FUN-B70075 Begin---
#            IF g_aza.aza88 = 'Y' THEN
#               UPDATE lmv_file SET lmvpos = '4'
#                WHERE lmv01 = g_lmv01 AND lmv02 = g_lmv[l_ac].lmv02
#               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                  CALL cl_err3("upd","lmv_file",g_lmv01,"",SQLCA.sqlcode,"","",1)
#                  LET l_lock_sw = "Y"
#               END IF
#               LET l_lmvpos = g_lmv[l_ac].lmvpos
#               LET g_lmv[l_ac].lmvpos = '4'
#               DISPLAY BY NAME g_lmv[l_ac].lmvpos
#            END IF
#           #FUN-B70075 End-----         
#            BEGIN WORK
#            LET p_cmd='u'
#            LET g_lmv01_t = g_lmv01
#            LET g_lmv_t.* = g_lmv[l_ac].*  #BACKUP
#            OPEN i850_bcl USING g_lmv01,g_lmv[l_ac].lmv02
#            IF STATUS THEN
#               CALL cl_err("OPEN i850_bcl:", STATUS, 1)
#               LET l_lock_sw = "Y"
#            ELSE
#               FETCH i850_bcl INTO g_lmv[l_ac].*
#               ###########FUN-B70075 Mark Begin---
#               #SELECT ima02 INTO l_ima02 FROM ima_file                    
#               # WHERE ima01 = g_lmv[l_ac].lmv02   
#               # LET g_lmv[l_ac].ima02 = l_ima02 
#               # DISPLAY BY NAME g_lmv[l_ac].ima02
#               ##############FUN-B70075 Mark End---
#               IF STATUS THEN
#                  CALL cl_err("OPEN i850_bcl:", STATUS, 1)
#                  LET l_lock_sw = "Y"  
#               #FUN-B70075 Begin ----
#               ELSE
#                  CALL i850_lmv02()
#               #FUN-B70075 End ----   
#               END IF 
#            END IF
#            CALL cl_show_fld_cont()     
#         END IF
#  
#      BEFORE INSERT                                                             
#         LET l_n = ARR_COUNT()                                                  
#         LET p_cmd='a'                                                          
#         LET g_before_input_done = FALSE
#         INITIALIZE g_lmv[l_ac].* TO NULL                   
#         LET g_before_input_done = TRUE
#         LET g_lmv_t.* = g_lmv[l_ac].*               #新輸入資料                
#         LET g_lmv[l_ac].lmvacti = 'Y'      #FUN-A90049
#         #No.FUN-A90033 add start------------------         
#            LET g_lmv[l_ac].lmvpos = '1' #NO.FUN-B40071
#         #No.FUN-A90033 add end  ------------------
#         CALL cl_show_fld_cont()                                                
#         NEXT FIELD lmv02 
# 
#      AFTER INSERT
#         IF INT_FLAG THEN
#            CALL cl_err('',9001,0)
#            LET INT_FLAG = 0
#            CANCEL INSERT
#         END IF
#         INSERT INTO lmv_file(lmv01,lmv02,lmvacti,lmvpos)
#               VALUES(g_lmv01,g_lmv[l_ac].lmv02,g_lmv[l_ac].lmvacti,g_lmv[l_ac].lmvpos)
#         IF SQLCA.sqlcode THEN
#            CALL cl_err3("ins","lmv_file",g_lmv[l_ac].lmv02,SQLCA.sqlcode,"","","",1)  
#            CANCEL INSERT
#         ELSE
#            MESSAGE 'INSERT O.K'
#            COMMIT WORK
#            LET g_rec_b=g_rec_b+1
#            DISPLAY g_rec_b TO FORMONLY.cnt2
#         END IF
#    
#      AFTER FIELD lmv02                         # check data  是否重復
#          IF NOT cl_null(g_lmv[l_ac].lmv02) THEN 
##FUN-A90049 --Begin--
#             IF NOT  s_chk_item_no(g_lmv[l_ac].lmv02,"") THEN						
#                CALL cl_err('',g_errno,1)								
#                LET g_lmv[l_ac].lmv02 = g_lmv_t.lmv02								
#                NEXT FIELD lmv02								
#             END IF 
##FUN-A90049 --End--             
#             IF g_lmv[l_ac].lmv02 != g_lmv_t.lmv02 OR
#                g_lmv_t.lmv02 IS NULL THEN
#                CALL i850_lmv02()
#                SELECT COUNT(*) INTO l_n FROM lmv_file 
#                 WHERE lmv01=g_lmv01 
#                   AND lmv02=g_lmv[l_ac].lmv02 
#                IF cl_null(g_errno) AND l_n> 0 THEN
#                   LET g_errno ='atm-310'
#                END IF 
#                IF NOT cl_null(g_errno) THEN                 
#                   CALL cl_err(g_lmv[l_ac].lmv02,g_errno,1)  
#                   LET g_lmv[l_ac].lmv02=g_lmv_t.lmv02
#                   NEXT FIELD lmv02
#                END IF                 
#              END IF
#           ELSE 
#              LET g_lmv[l_ac].ima02=NULL                           
#              DISPLAY BY NAME g_lmv[l_ac].ima02
#              LET g_lmv[l_ac].ima021=NULL                           
#              DISPLAY BY NAME g_lmv[l_ac].ima021
#              LET g_lmv[l_ac].ima128=NULL                           
#              DISPLAY BY NAME g_lmv[l_ac].ima128
#           END IF 
#        #  IF NOT cl_null(g_lmv[l_ac].lmv02) THEN   #FUN-AA0057
#              IF p_cmd='u' AND g_lmv[l_ac].lmv02 != g_lmv_t.lmv02 THEN 
#           #      SELECT COUNT(*) INTO l_n1 FROM lrb_file   #NO.FUN-A90040   -- mark
#            #      WHERE lrb02=g_lmv[l_ac].lmv02            #NO.FUN-A90040   -- mark 
#               SELECT COUNT(*) INTO l_n FROM ogb_file       #NO.FUN-A90040 
#               WHERE ogb04 =g_lmv_t.lmv02 AND ogb49 =g_lmv01  #NO.FUN-A90040 
#            
#                 IF l_n>0 THEN       #FUN-AA0057 
#                    CALL cl_err(g_lmv[l_ac].lmv02,'alm-249',1)
#                    LET g_lmv[l_ac].lmv02=g_lmv_t.lmv02
#                    NEXT FIELD lmv02   
#                 END IF
#              END IF  
#       #  ELSE                 #FUN-AA0057
#          IF  cl_null(g_lmv[l_ac].lmv02) THEN        #FUN-AA0057    
#              LET g_lmv[l_ac].ima02=NULL                           
#              DISPLAY BY NAME g_lmv[l_ac].ima02
#              LET g_lmv[l_ac].ima021=NULL                           
#              DISPLAY BY NAME g_lmv[l_ac].ima021
#              LET g_lmv[l_ac].ima128=NULL                           
#              DISPLAY BY NAME g_lmv[l_ac].ima128  
#          END IF               
# 
#      BEFORE DELETE                            # 是否取消單身 
#         IF NOT cl_null(g_lmv_t.lmv02)  THEN
#            IF NOT cl_delb(0,0) THEN
#               CANCEL DELETE
#            END IF
#            IF l_lock_sw = "Y" THEN
#               CALL cl_err("", -263, 1)
#               CANCEL DELETE
#            END IF
#         #   SELECT COUNT(*) INTO l_n FROM lrb_file       #NO.FUN-A90040   -- mark
#         #      WHERE lrb02=g_lmv[l_ac].lmv02             #NO.FUN-A90040   -- mark 
#             SELECT COUNT(*) INTO l_n FROM ogb_file       #NO.FUN-A90040 
#            WHERE ogb04 =g_lmv_t.lmv02 AND ogb49 =g_lmv01  #NO.FUN-A90040 
#            
#
#               
#              IF l_n>0 THEN       #FUN-AA0057 
#                 CALL cl_err(g_lmv[l_ac].lmv02,'alm-249',1)
#                 CANCEL DELETE
#            END IF
#            #No.FUN-A90033 add start------------------
#            IF g_aza.aza88 = 'Y' THEN
#               #IF (g_lmv[1].lmvacti = 'N' OR g_lmv[1].lmvacti = 'Y') AND g_lmv[1].lmvpos = 'N' THEN  #FUN-AB0031 mark
#              #FUN-B40071 --START--
#               #IF (g_lmv[l_ac].lmvacti = 'N' OR g_lmv[l_ac].lmvacti = 'Y') AND g_lmv[l_ac].lmvpos = 'N' THEN  #FUN-AB0031
#               #   CALL cl_err("",'art-648',0)
#               #   CANCEL DELETE
#               #   RETURN
#               #END IF               
#               #IF g_lmv[l_ac].lmvacti = 'Y' AND g_lmv[l_ac].lmvpos = 'Y' THEN
#               #   CALL cl_err("",'art-648',0)
#               #   CANCEL DELETE
#               #   RETURN
#               #END IF
#              #FUN-B70075 Begin -----               
#               #IF NOT ((g_lmv[l_ac].lmvpos='3' AND g_lmv[l_ac].lmvacti='N') 
#               #        OR (g_lmv[l_ac].lmvpos='1'))  THEN    
#               IF NOT ((l_lmvpos ='3' AND g_lmv_t.lmvacti='N')
#                       OR (l_lmvpos ='1')) THEN
#               #FUN-B70075 End ------          
#                  CALL cl_err('','apc-139',0)
#                  CANCEL DELETE            
#                  RETURN
#               END IF
#              #FUN-B40071 --END--
#            END IF               
#           #IF NOT cl_delete() THEN
#           #     CANCEL DELETE
#           #END IF    
#            #No.FUN-A90033 add end------------------           
#            DELETE FROM lmv_file WHERE lmv01 = g_lmv01
#                                   AND lmv02 = g_lmv_t.lmv02
#            IF SQLCA.sqlcode THEN
#               CALL cl_err3("del","lmv_file",g_lmv[l_ac].lmv02,SQLCA.sqlcode,"","","",1)  
#               ROLLBACK WORK
#               CANCEL DELETE
#            END IF
#            LET g_rec_b = g_rec_b-1
#            DISPLAY g_rec_b TO FORMONLY.cnt2
#         END IF
#         COMMIT WORK   
# 
#      ON ROW CHANGE
#         IF INT_FLAG THEN
#            CALL cl_err('',9001,0)
#            LET INT_FLAG = 0
#            LET g_lmv[l_ac].* = g_lmv_t.*
#            CLOSE i850_bcl
#            ROLLBACK WORK
#            EXIT INPUT
#         END IF
#         #No.FUN-A90033 add start------------------
#         IF g_aza.aza88 = 'Y' THEN            
#           #FUN-B40071 --START--
#            #LET g_lmv[l_ac].lmvpos = 'N'
#           #FUN-B70075 Begin --------
#           # IF g_lmv[l_ac].lmvpos <> '1' THEN  
#            IF l_lmvpos <> '1'  THEN
#               LET g_lmv[l_ac].lmvpos = '2'
#            ELSE
#               LET g_lmv[l_ac].lmvpos = '1'
#            END IF  
#           #FUN-B70075 End --------            
#           #FUN-B40071 --END--
#         END IF
#         #No.FUN-A90033 add end  ------------------
#         IF l_lock_sw = 'Y' THEN
#            CALL cl_err(g_lmv[l_ac].lmv02,-263,1)
#            LET g_lmv[l_ac].* = g_lmv_t.*
#         ELSE
#            UPDATE lmv_file SET lmv02 = g_lmv[l_ac].lmv02 , lmvacti = g_lmv[l_ac].lmvacti ,lmvpos = g_lmv[l_ac].lmvpos
#                                 WHERE lmv01 = g_lmv01
#                                   AND lmv02 = g_lmv_t.lmv02
#            IF SQLCA.sqlcode THEN
#               CALL cl_err3("upd","lmv_file",g_lmv[l_ac].lmv02,SQLCA.sqlcode,"","","",1)  #No.FUN-660138
#               LET g_lmv[l_ac].* = g_lmv_t.*
#            ELSE
#               MESSAGE 'UPDATE O.K'
#               COMMIT WORK
#            END IF
#         END IF          
# 
#      AFTER ROW
#         LET l_ac = ARR_CURR()
#         LET l_ac_t = l_ac
#         IF INT_FLAG THEN
#            CALL cl_err('',9001,0)
#            LET INT_FLAG = 0
#            IF p_cmd = 'u' THEN
#               LET g_lmv[l_ac].* = g_lmv_t.*
#            END IF
#            CLOSE i850_bcl
#            ROLLBACK WORK
#            
#           #FUN-B70075 Begin---
#            IF p_cmd='u' THEN
#               IF g_aza.aza88 = 'Y' THEN
#                  UPDATE lmv_file SET lmvpos = l_lmvpos
#                   WHERE lmv01 = g_lmv01 AND lmv02 = g_lmv[l_ac].lmv02
#                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                     CALL cl_err3("upd","lmv_file",g_lmv01,"",SQLCA.sqlcode,"","",1)
#                     LET l_lock_sw = "Y"
#                  END IF
#                  LET g_lmv[l_ac].lmvpos = l_lmvpos
#                  DISPLAY BY NAME g_lmv[l_ac].lmvpos
#               END IF
#            END IF
#           #FUN-B70075 End-----            
#            EXIT INPUT
#         END IF
#         CLOSE i850_bcl
#         COMMIT WORK
# 
#       ON ACTION CONTROLP                                                       
#          CASE                                                                  
#             WHEN INFIELD(lmv02)                                                
#               # CALL cl_init_qry_var()                                          
#               # LET g_qryparam.form ="q_lmu_1"                    #FUN-A90049   
#               # LET g_qryparam.arg1 =g_lmv01                      #FUN-A90049
#               # LET g_qryparam.default1 = g_lmv[l_ac].lmv02       #FUN-A90049                      
#               # CALL cl_create_qry() RETURNING g_lmv[l_ac].lmv02  #FUN-A90049
#	            CALL q_sel_ima(FALSE, "q_ima", "", g_lmv[l_ac].lmv02 , g_lmv01 , "", "", "" ,"" ,'')  #FUN-A90049  #FUN-A90040
#                    RETURNING g_lmv[l_ac].lmv02	                                                       #FUN-AB0011
#                DISPLAY BY NAME g_lmv[l_ac].lmv02
#                NEXT FIELD lmv02                                                
#            OTHERWISE EXIT CASE                                             
#          END CASE             
# 
#      ON ACTION CONTROLO                      
#         IF INFIELD(lmv01) AND l_ac > 1 THEN
#            LET g_lmv[l_ac].* = g_lmv[l_ac-1].*
#            LET g_lmv[l_ac].lmv02=null
#            NEXT FIELD lmv02
#         END IF
# 
#      ON ACTION CONTROLR
#         CALL cl_show_req_fields()
# 
#      ON ACTION CONTROLG
#         CALL cl_cmdask()
# 
#      ON ACTION CONTROLF
#         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about     
#         CALL cl_about()      
# 
#      ON ACTION help          
#         CALL cl_show_help()  
#                              
#      ON ACTION controls                                        
#         CALL cl_set_head_visible("","AUTO")                    
# 
# 
#   END INPUT
# 
#   CLOSE i850_bcl
#   COMMIT WORK
# 
#END FUNCTION            
#FUN-C40109--end mark----------------------------------------------

#FUN-C40109--start add---------------------------------------------
FUNCTION i850_b()
   DEFINE l_ac_t          LIKE type_file.num5
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_n1            LIKE type_file.num5
   DEFINE l_lock_sw       LIKE type_file.chr1
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE l_allow_insert  LIKE type_file.num5
   DEFINE l_allow_delete  LIKE type_file.num5 
   DEFINE l_cnt           LIKE type_file.num10
   DEFINE l_imaacti       LIKE ima_file.imaacti
   DEFINE l_ima02         LIKE ima_file.ima02
   DEFINE l_lmvpos        LIKE lmv_file.lmvpos
   DEFINE l_flag          LIKE type_file.chr1          #FUN-C50036 add

   LET g_action_choice = ""

   IF cl_null(g_lmv01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF

   IF s_shut(0) THEN
      RETURN
   END IF


   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT lmv02,'','','',lmvacti,lmvpos ",
                      " FROM lmv_file",
                      " WHERE lmv01 = ? AND lmv02 = ? AND lmv03 = ? FOR UPDATE "

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i850_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_lmv WITHOUT DEFAULTS FROM s_lmv.*
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
         LET l_flag = 'N'               #FUN-C50036 add  
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_lmv01_t = g_lmv01
            LET g_lmv03_t = g_lmv03
            LET g_lmv_t.* = g_lmv[l_ac].*  #BACKUP 
            IF g_aza.aza88 = 'Y' THEN
#FUN-C50036 add begin ---
               IF g_lmv[l_ac].lmvpos <> '1' THEN
                  CALL cl_set_comp_entry("lmv02",FALSE)
               ELSE
                  CALL cl_set_comp_entry("lmv02",TRUE)
               END IF
#FUN-C50036 add end ----
               BEGIN WORK
               OPEN i850_bcl USING g_lmv01,g_lmv[l_ac].lmv02,g_lmv03
               IF STATUS THEN
               ELSE
                  FETCH i850_bcl INTO g_lmv[l_ac].*
                  IF SQLCA.sqlcode THEN
                  ELSE
                     #FUN-C50036--start add-----------------------------------
                      SELECT lmvpos INTO l_lmvpos
                        FROM lmv_file
                       WHERE lmv01 = g_lmv01
                         AND lmv02 = g_lmv[l_ac].lmv02
                         AND lmv03 = g_lmv03
                     #FUN-C50036--end add-------------------------------------
    
                     UPDATE lmv_file
                        SET lmvpos = '4'
                      WHERE lmv01 = g_lmv01
                        AND lmv02 = g_lmv[l_ac].lmv02
                        AND lmv03 = g_lmv03
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL cl_err3("upd","lmv_file",g_lmv01,"",SQLCA.sqlcode,"","",1)
                        LET l_lock_sw = "Y"
                     END IF
                     LET l_lmvpos = g_lmv[l_ac].lmvpos
                     LET g_lmv[l_ac].lmvpos = '4'
                     DISPLAY BY NAME g_lmv[l_ac].lmvpos 
                  END IF
               END IF
               CLOSE i850_bcl
               COMMIT WORK
            END IF

            BEGIN WORK
            OPEN i850_bcl USING g_lmv01,g_lmv[l_ac].lmv02,g_lmv03
            IF STATUS THEN
               CALL cl_err("OPEN i850_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i850_bcl INTO g_lmv[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i850_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i850_lmv02()
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         CALL cl_set_comp_entry("lmv02",TRUE)    #FUN-C50036 add 
         LET g_before_input_done = FALSE
         INITIALIZE g_lmv[l_ac].* TO NULL
         LET g_before_input_done = TRUE
         LET g_lmv_t.* = g_lmv[l_ac].*               #新輸入資料
         LET g_lmv[l_ac].lmvacti = 'Y'
         IF g_aza.aza88 = 'Y' THEN
            LET g_lmv[l_ac].lmvpos = '1'
            LET l_lmvpos = '1'
         END IF 
         DISPLAY BY NAME g_lmv[l_ac].lmvpos  
         CALL cl_set_comp_entry("lmvpos",FALSE) 
         CALL cl_show_fld_cont()
         NEXT FIELD lmv02

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO lmv_file(lmv01,lmv02,lmv03,lmvacti,lmvpos)
               VALUES(g_lmv01,g_lmv[l_ac].lmv02,g_lmv03,g_lmv[l_ac].lmvacti,g_lmv[l_ac].lmvpos)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lmv_file",g_lmv[l_ac].lmv02,SQLCA.sqlcode,"","","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      AFTER FIELD lmv02                         # check data  是否重復
          IF NOT cl_null(g_lmv[l_ac].lmv02) THEN
             IF NOT  s_chk_item_no(g_lmv[l_ac].lmv02,"") THEN
                CALL cl_err('',g_errno,1)
                LET g_lmv[l_ac].lmv02 = g_lmv_t.lmv02
                NEXT FIELD lmv02
             END IF
             IF g_lmv[l_ac].lmv02 != g_lmv_t.lmv02 OR
                g_lmv_t.lmv02 IS NULL THEN
                CALL i850_lmv02()
                SELECT COUNT(*) INTO l_n FROM lmv_file
                 WHERE lmv01=g_lmv01
                   AND lmv02=g_lmv[l_ac].lmv02
                   AND lmv03 = g_lmv03
                IF cl_null(g_errno) AND l_n> 0 THEN
                   LET g_errno ='atm-310'
                END IF
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_lmv[l_ac].lmv02,g_errno,1)
                   LET g_lmv[l_ac].lmv02=g_lmv_t.lmv02
                   NEXT FIELD lmv02
                END IF
              END IF
           ELSE
              LET g_lmv[l_ac].ima02=NULL
              DISPLAY BY NAME g_lmv[l_ac].ima02
              LET g_lmv[l_ac].ima021=NULL
              DISPLAY BY NAME g_lmv[l_ac].ima021
              LET g_lmv[l_ac].ima128=NULL
              DISPLAY BY NAME g_lmv[l_ac].ima128
           END IF
              IF p_cmd='u' AND g_lmv[l_ac].lmv02 != g_lmv_t.lmv02 THEN
               SELECT COUNT(*) INTO l_n 
                 FROM ogb_file 
               WHERE ogb04 = g_lmv_t.lmv02 
                 AND ogb49 = g_lmv01 
                 AND ogb48 = g_lmv03
                 IF l_n>0 THEN
                    CALL cl_err(g_lmv[l_ac].lmv02,'alm-249',1)
                    LET g_lmv[l_ac].lmv02=g_lmv_t.lmv02
                    NEXT FIELD lmv02
                 END IF
              END IF
           IF cl_null(g_lmv[l_ac].lmv02) THEN 
              LET g_lmv[l_ac].ima02=NULL
              DISPLAY BY NAME g_lmv[l_ac].ima02
              LET g_lmv[l_ac].ima021=NULL
              DISPLAY BY NAME g_lmv[l_ac].ima021
              LET g_lmv[l_ac].ima128=NULL
              DISPLAY BY NAME g_lmv[l_ac].ima128
          END IF

      AFTER FIELD lmvpos
         IF NOT cl_null(g_lmv[l_ac].lmvpos) THEN
            IF g_lmv[l_ac].lmvpos NOT MATCHES '[123]' THEN
               NEXT FIELD lmvpos
            END IF
         END IF

      BEFORE DELETE                            # 是否取消單身
         IF NOT cl_null(g_lmv_t.lmv02)  THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
             SELECT COUNT(*) INTO l_n 
               FROM ogb_file
              WHERE ogb04 = g_lmv_t.lmv02 
                AND ogb49 = g_lmv01
                AND ogb48 = g_lmv03

              IF l_n>0 THEN 
                 CALL cl_err(g_lmv[l_ac].lmv02,'alm-249',1)
                 CANCEL DELETE
            END IF
            IF g_aza.aza88 = 'Y' THEN
               IF NOT ((l_lmvpos ='3' AND g_lmv_t.lmvacti='N')
                       OR (l_lmvpos ='1')) THEN
                  CALL cl_err('','apc-139',0)
                  CANCEL DELETE
                  RETURN
               END IF
            END IF
            DELETE FROM lmv_file 
             WHERE lmv01 = g_lmv01
               AND lmv02 = g_lmv_t.lmv02
               AND lmv03 = g_lmv03  
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","lmv_file",g_lmv[l_ac].lmv02,SQLCA.sqlcode,"","","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_lmv[l_ac].* = g_lmv_t.*
            CLOSE i850_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF

         LET l_flag = 'Y'                     #FUN-C50036 add
         IF g_aza.aza88 = 'Y' THEN
            IF l_lmvpos <> '1'  THEN
               LET g_lmv[l_ac].lmvpos = '2'
            ELSE
               LET g_lmv[l_ac].lmvpos = '1'
            END IF
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_lmv[l_ac].lmv02,-263,1)
            LET g_lmv[l_ac].* = g_lmv_t.*
         ELSE
            UPDATE lmv_file 
               SET lmv02 = g_lmv[l_ac].lmv02,
                   lmvacti = g_lmv[l_ac].lmvacti,
                   lmvpos = g_lmv[l_ac].lmvpos
             WHERE lmv01 = g_lmv01
               AND lmv02 = g_lmv_t.lmv02
               AND lmv03 = g_lmv03

            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","lmv_file",g_lmv[l_ac].lmv02,SQLCA.sqlcode,"","","",1)  #No.FUN-660138
               LET g_lmv[l_ac].* = g_lmv_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D30033 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #IF p_cmd = 'u' THEN
            #   LET g_lmv[l_ac].* = g_lmv_t.*
            #END IF
            CLOSE i850_bcl
            ROLLBACK WORK

            IF p_cmd='u' THEN
               IF g_aza.aza88 = 'Y' AND l_lock_sw <> 'Y' THEN
                  UPDATE lmv_file 
                     SET lmvpos = l_lmvpos
                   WHERE lmv01 = g_lmv01 
                     AND lmv02 = g_lmv[l_ac].lmv02
                     AND lmv03 = g_lmv03
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","lmv_file",g_lmv01,"",SQLCA.sqlcode,"","",1)
                     LET l_lock_sw = "Y"
                  END IF
                  LET g_lmv[l_ac].lmvpos = l_lmvpos
                  DISPLAY BY NAME g_lmv[l_ac].lmvpos
               END IF
               LET g_lmv[l_ac].* = g_lmv_t.*
            ELSE
               CALL g_lmv.deleteElement(l_ac)  
               #FUN-D30033--add--str--
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
               #FUN-D30033--add--end--
            END IF
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30033 Add
         #FUN-C50036--start add-----------------------
         IF l_flag <> 'Y' AND NOT INT_FLAG THEN
            IF l_lmvpos <> '1' THEN
               LET g_lmv[l_ac].lmvpos = '2'
            ELSE
               LET g_lmv[l_ac].lmvpos = '1'  
            END IF 
            
            UPDATE lmv_file
               SET lmvpos = g_lmv[l_ac].lmvpos
             WHERE lmv01 = g_lmv01
               AND lmv02 = g_lmv[l_ac].lmv02
               AND lmv03 = g_lmv03
          
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","lmv_file",g_lmv01,"",SQLCA.sqlcode,"","",1)
               LET l_lock_sw = "Y"
            END IF  
            DISPLAY BY NAME g_lmv[l_ac].lmvpos
         END IF  
         #FUN-C50036--end add-------------------------
    
         CLOSE i850_bcl
         COMMIT WORK

       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(lmv02)
                    CALL q_sel_ima(FALSE, "q_ima", "", g_lmv[l_ac].lmv02 , g_lmv01 , "", "", "" ,"" ,'')
                    RETURNING g_lmv[l_ac].lmv02 
                DISPLAY BY NAME g_lmv[l_ac].lmv02
                NEXT FIELD lmv02
            OTHERWISE EXIT CASE
          END CASE

      ON ACTION CONTROLO
         IF INFIELD(lmv01) AND l_ac > 1 THEN
            LET g_lmv[l_ac].* = g_lmv[l_ac-1].*
            LET g_lmv[l_ac].lmv02=null
            NEXT FIELD lmv02
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

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

   CLOSE i850_bcl
   COMMIT WORK

END FUNCTION
#FUN-C40109--end add-----------------------------------------------
 
FUNCTION i850_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
 
   LET g_sql = "SELECT lmv02,'','','',lmvacti,lmvpos ",
               " FROM lmv_file ",
               " WHERE lmv01 = '",g_lmv01,"'",
               "   AND lmv03 = '",g_lmv03,"'",   #FUN-C40109 add 
               "  AND ",p_wc CLIPPED ,
               " ORDER BY lmv02"
   PREPARE i850_prepare2 FROM g_sql       #預備一下 
   DECLARE lmv_cs CURSOR FOR i850_prepare2
 
   CALL g_lmv.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH lmv_cs INTO g_lmv[g_cnt].*     #單身ARRAY填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT ima02,ima021,ima128 
        INTO g_lmv[g_cnt].ima02,g_lmv[g_cnt].ima021,g_lmv[g_cnt].ima128 
        FROM ima_file WHERE ima01 = g_lmv[g_cnt].lmv02
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_lmv.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   #DISPLAY g_rec_b TO FORMONLY.cnt2     #FUN-C40109 mark
   DISPLAY g_rec_b TO FORMONLY.cn2       #FUN-C40109 add
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i850_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lmv TO s_lmv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION first
         CALL i850_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         #IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         #END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL i850_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         #IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         #END IF
	 ACCEPT DISPLAY              
 
      ON ACTION jump
         CALL i850_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         #IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         #END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION next
         CALL i850_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         CALL fgl_set_arr_curr(1)  
 
	 ACCEPT DISPLAY               
 
      ON ACTION last
         CALL i850_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(1)  
	 ACCEPT DISPLAY                   
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                  
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION   

FUNCTION i850_r()
DEFINE l_lmvpos  LIKE lmv_file.lmvpos,     #FUN-AB0031 add
       l_lmvacti LIKE lmv_file.lmvacti,    #FUN-AB0031 add
       l_sql     STRING                    #FUN-AB0031 add
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_lmv01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
   #No.FUN-A90033 add by suncx begin-----------
   IF g_aza.aza88 = 'Y' THEN
      #FUN-AB0031 add begin-------------------------
      #LET l_sql = "SELECT lmvacti,lmvpos FROM lmv_file WHERE lmv01 = '",g_lmv01,"'"       #FUN-C40109 mark
      #FUN-C40109--start add-------------------------
      LET l_sql = "SELECT lmvacti,lmvpos",
                  "  FROM lmv_file ",
                  " WHERE lmv01 = '",g_lmv01,"'",
                  "   AND lmv03 = '",g_lmv03,"'"
      #FUN-C40109--end add---------------------------
      PREPARE i850_prepare3 FROM l_sql       #預備一下
      DECLARE lmv_pos CURSOR FOR i850_prepare3
      INITIALIZE l_lmvpos TO NULL
      INITIALIZE l_lmvacti TO NULL
      #FUN-AB0031 add end---------------------------
      FOREACH lmv_pos INTO l_lmvacti,l_lmvpos
        #FUN-B40071 --START--
         #IF (l_lmvacti = 'N' OR l_lmvacti = 'Y') AND l_lmvpos = 'N' THEN
         #   CALL cl_err("",'art-648',0)
         #   RETURN
         #END IF
         #IF l_lmvacti = 'Y' AND l_lmvpos = 'Y' THEN
         #   CALL cl_err("",'art-648',0)
         #   RETURN
         #END IF         
         IF NOT ((l_lmvpos='3' AND l_lmvacti='N') 
                    OR (l_lmvpos='1'))  THEN                  
            CALL cl_err('','apc-139',0)                      
            RETURN
         END IF
        #FUN-B40071 --END--
      END FOREACH
   END IF
   #No.FUN-A90033 add by suncx end-----------
   IF cl_delh(0,0) THEN             #確認一下      
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "lmv01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_lmv01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()          #No.FUN-9B0098 10/02/24
      #DELETE FROM lmv_file WHERE lmv01 = g_lmv01                      #FUN-C40109 mark
      DELETE FROM lmv_file WHERE lmv01 = g_lmv01 AND lmv03 = g_lmv03   #FUN-C40109 add
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","lmv_file",g_lmv01,"",SQLCA.sqlcode,"","BODY DELETE",0) 
      ELSE
         DELETE FROM lmv_temp where lmv01 = g_lmv01 AND lmv03 = g_lmv03
         COMMIT WORK                  #FUN-C40109 add
         CLEAR FORM
         CALL g_lmv.clear()
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN i850_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i850_bcs
            CLOSE i850_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i850_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i850_bcs
            CLOSE i850_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i850_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET  g_abso= g_row_count
            CALL i850_fetch('L')
         ELSE
            LET g_abso = g_curs_index
            LET g_no_ask = TRUE
            CALL i850_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION

#FUN-C40109--start add-----------------------------------------
FUNCTION i850_copy()
   DEFINE l_n      LIKE type_file.num10
   DEFINE l_cnt    LIKE type_file.num10
   DEFINE l_oldno1 LIKE lmv_file.lmv01
   DEFINE l_oldno2 LIKE lmv_file.lmv03
   DEFINE l_newno1 LIKE lmv_file.lmv01
   DEFINE l_newno2 LIKE lmv_file.lmv03
   DEFINE l_lne36  LIKE lne_file.lne36

   IF s_shut(0) THEN
      RETURN
   END IF

   IF cl_null(g_lmv01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF

   CALL i850_set_entry('a')
   CALL cl_set_head_visible("","YES")

   INPUT l_newno1,l_newno2 FROM lmv01,lmv03

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      AFTER FIELD lmv01
         IF NOT cl_null(l_newno1) THEN
            CALL i850_lmv01('c',l_newno1) 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lmv01 = g_lmv01_t
               DISPLAY g_lmv01 TO lmv01
               NEXT FIELD lmv01 
            END IF 
            IF NOT cl_null(l_newno2) THEN
               CALL i850_lmv_chk(l_newno1,l_newno2)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lmv01 = g_lmv01_t
                  DISPLAY g_lmv01 TO lmv01
                  NEXT FIELD lmv01
               END IF 
            END IF 
         END IF

     AFTER FIELD lmv03
        IF NOT cl_null(l_newno2) THEN
           CALL i850_lmv03('c',l_newno2)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              LET g_lmv03 = g_lmv03_t
              DISPLAY g_lmv03 TO lmv03
              NEXT FIELD lmv03 
           END IF   
           IF NOT cl_null(l_newno1) THEN
              CALL i850_lmv_chk(l_newno1,l_newno2)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_lmv03 = g_lmv03_t
                 DISPLAY g_lmv03 TO lmv03
                 NEXT FIELD lmv03
              END IF 
           END IF 
        END IF 

     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(lmv01)
              CALL cl_init_qry_var()
              LET g_qryparam.form  ="q_lne_3"
              LET g_qryparam.default1 = g_lmv01
              CALL cl_create_qry() RETURNING l_newno1
              DISPLAY l_newno1 TO lmv01
              NEXT FIELD lmv01
                 
           WHEN INFIELD(lmv03)
              CALL cl_init_qry_var()
              LET g_qryparam.form  ="q_lja06i"
              LET g_qryparam.default1 = g_lmv03
              CALL cl_create_qry() RETURNING l_newno2 
              DISPLAY l_newno2 TO lmv03
              NEXT FIELD lmv03      
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

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_lmv01,g_lmv03 TO lmv01,lmv03
      RETURN
   END IF

   DROP TABLE x

   SELECT * FROM lmv_file
    WHERE lmv01 = g_lmv01
      And lmv03 = g_lmv03
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_lmv01,'',SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   UPDATE x 
      SET lmv01 = l_newno1,
          lmv03 = l_newno2
        
   INSERT INTO lmv_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","lmv_file",l_newno1,'l_newno2',SQLCA.sqlcode,"",g_msg,1)
      RETURN
   ELSE
      MESSAGE 'COPY O.K'
      LET l_oldno1 = g_lmv01
      LET l_oldno2 = g_lmv03
      LET g_lmv01 = l_newno1
      LET g_lmv03 = l_newno2  
      CALL i850_b()
      #LET g_lmv01 = l_oldno1  #FUN-C30027
      #LET g_lmv03 = l_oldno2  #FUN-C30027
      CALL i850_show()
   END IF
END FUNCTION
#FUN-C40109--end add-------------------------------------------

#FUN-C40109--start mark---------------------------------------- 
#FUNCTION i850_copy()
#DEFINE
#   l_n             LIKE type_file.num5,   
#   l_cnt           LIKE type_file.num10,  
#   l_oldno1        LIKE lmv_file.lmv01,
#   l_newno        LIKE lmv_file.lmv01,
#   l_lne36         LIKE lne_file.lne36
#   
#   IF s_shut(0) THEN
#      RETURN
#   END IF
# 
#   IF cl_null(g_lmv01) THEN
#      CALL cl_err('',-400,1)
#      RETURN  
#   END IF
#   
#   CALL i850_set_entry('a')
#   CALL cl_set_head_visible("","YES")     
# 
#   INPUT l_newno FROM lmv01         
# 
#      AFTER INPUT
#         IF INT_FLAG THEN
#            EXIT INPUT
#         END IF
#         
#      AFTER FIELD lmv01 
#         IF NOT cl_null(l_newno) THEN
#            SELECT COUNT(*) INTO l_n FROM lmv_file
#             WHERE lmv01 = l_newno
#            IF l_n > 0 THEN
#               CALL cl_err('',-239,0)
#               NEXT FIELD lmv01
#            END IF
#            SELECT count(*) INTO l_n FROM lne_file
#             WHERE lne01 = l_newno
#             
#             SELECT lne36 INTO l_lne36 FROM lne_file                                                                             
#              WHERE lne01 = l_newno       
#             IF l_n = 0 THEN
#                 CALL cl_err('lmv01','alm-009',0)
#                 LET g_lmv01 = g_lmv01_t
#                 NEXT FIELD lmv01
#             ELSE
#               IF l_lne36='N' THEN 
#                  CALL cl_err('lmv01','alm-004',0)
#                  LET g_lmv01 = g_lmv01_t
#                  NEXT FIELD lmv01
#               END IF
#             END IF
#             CALL i850_lmv01('d',l_newno)
#         END IF
# 
#     ON ACTION CONTROLP                                                     
#        CASE                                                                
#          WHEN INFIELD(lmv01)                                               
#            CALL cl_init_qry_var()                                          
#            LET g_qryparam.form  ="q_lne_3"                                   
#            LET g_qryparam.default1 = g_lmv01                             
#            CALL cl_create_qry() RETURNING l_newno                          
#            DISPLAY l_newno TO lmv01                                        
#            NEXT FIELD lmv01                                                
#            OTHERWISE EXIT CASE                                               
#          END CASE     
#   
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
# 
#     ON ACTION about        
#        CALL cl_about()    
# 
#     ON ACTION help          
#        CALL cl_show_help()
# 
#     ON ACTION controlg      
#        CALL cl_cmdask()     
# 
#  END INPUT
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      DISPLAY g_lmv01 TO lmv01
#      RETURN
#   END IF
# 
#   DROP TABLE x
# 
#   SELECT * FROM lmv_file             
#    WHERE lmv01 = g_lmv01
#     INTO TEMP x
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","x",g_lmv01,'',SQLCA.sqlcode,"","",1)  
#      RETURN
#   END IF
# 
#   UPDATE x SET lmv01  = l_newno  
#   
#   INSERT INTO lmv_file SELECT * FROM x
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","lmv_file",l_newno,'',SQLCA.sqlcode,"",g_msg,1)  
#      RETURN
#   ELSE 
#      MESSAGE 'COPY O.K'
#      LET l_oldno1 = g_lmv01
#      LET g_lmv01=l_newno
#      CALL i850_b()
#    # LET g_lmv01 = l_oldno1    #No.FUN-9B0136
#      CALL i850_show()
#      CALL i850_lmv01('d',l_newno)
#   END IF
#END FUNCTION
#FUN-C40109--end mark----------------------------------------------------- 

 
FUNCTION i850_lmv01(p_cmd,p_lmv01)   
DEFINE
   p_cmd           LIKE type_file.chr1,
   l_desc          LIKE type_file.chr4,
   l_lne05         LIKE lne_file.lne05,
   l_lne14         LIKE lne_file.lne14,
   l_lne15         LIKE lne_file.lne15,
   l_lne10         LIKE lne_file.lne10,
   l_lne20         LIKE lne_file.lne20,
   l_lne21         LIKE lne_file.lne21,                                         
   l_lne36         LIKE lne_file.lne36,         
   p_lmv01         LIKE lmv_file.lmv01

   LET g_errno = ' '
   SELECT lne05,lne14,lne15,lne10,lne20,lne21,lne36 
     INTO l_lne05,l_lne14,l_lne15,l_lne10,l_lne20,l_lne21,l_lne36
     FROM lne_file WHERE lne01 = p_lmv01
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm-009'
                                 LET l_lne05 = NULL
                                 LET l_lne14 = NULL
                                 LET l_lne15 = NULL
                                 LET l_lne10 = NULL
                                 LET l_lne20 = NULL
                                 LET l_lne21 = NULL
                                 LET l_lne36 = NULL
        WHEN l_lne36 = 'N'       LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_lne05  TO FORMONLY.lne05
      DISPLAY l_lne14  TO FORMONLY.lne14
      DISPLAY l_lne15  TO FORMONLY.lne15
      DISPLAY l_lne10  TO FORMONLY.lne10
      DISPLAY l_lne20  TO FORMONLY.lne20
      DISPLAY l_lne21  TO FORMONLY.lne21
   END IF
 
END FUNCTION
 
FUNCTION i850_lmv02()                                          
DEFINE   l_ima02         LIKE ima_file.ima02
DEFINE   l_imaacti         LIKE ima_file.imaacti
DEFINE   l_ima021         LIKE ima_file.ima021
DEFINE   l_ima128         LIKE ima_file.ima128
DEFINE   p_cmd           LIKE type_file.chr1
 
   LET g_errno =''                                                      
   SELECT ima02,imaacti,ima021,ima128 
     INTO l_ima02,l_imaacti,l_ima021,l_ima128 FROM ima_file                    
    WHERE ima01 = g_lmv[l_ac].lmv02    
                                                         
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm-009'
                                 LET l_ima02 = NULL
                                 LET l_imaacti = NULL
                                 LET l_ima021 = NULL
                                 LET l_ima128 = NULL
        WHEN l_imaacti = 'N'       LET g_errno = 'alm-004'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE              
   
      LET g_lmv[l_ac].ima02=l_ima02                           
      DISPLAY BY NAME g_lmv[l_ac].ima02
      LET g_lmv[l_ac].ima021=l_ima021                           
      DISPLAY BY NAME g_lmv[l_ac].ima021
      LET g_lmv[l_ac].ima128=l_ima128                           
      DISPLAY BY NAME g_lmv[l_ac].ima128
                               
END FUNCTION 

#FUN-C40109--start add-------------------------------------
FUNCTION i850_lmv03(p_cmd,p_lmv03)
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE l_lmf06         LIKE lmf_file.lmf06
   DEFINE l_lmf13         LIKE lmf_file.lmf13
   DEFINE p_lmv03         LIKE lmv_file.lmv03

   LET g_errno = ''
   SELECT lmf06,lmf13 INTO l_lmf06,l_lmf13
     FROM lmf_file
    WHERE lmf01 = p_lmv03

   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'alm-042'
      WHEN l_lmf06 = 'N' 
         LET g_errno = 'alm1063'
      WHEN l_lmf06 = 'X'
         LET g_errno = 'alm1620' 
   END CASE

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_lmf13 TO FORMONLY.lmf13
   END IF  
END FUNCTION
 
FUNCTION i850_lmv_chk(p_lmv01,p_lmv03)
   DEFINE l_n          LIKE type_file.num10
   DEFINE p_lmv01      LIKE lmv_file.lmv01
   DEFINE p_lmv03      LIKE lmv_file.lmv03
  
   LET g_errno = ''
   SELECT count(*) INTO l_n 
     FROM lmv_file
    WHERE lmv01 = p_lmv01
      AND lmv03 = p_lmv03
   
   IF l_n > 0 THEN
      LET g_errno = 'alm1621'
   END IF  
END FUNCTION
#FUN-C40109--end add---------------------------------------
 
FUNCTION i850_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         #CALL cl_set_comp_entry("lmv01",TRUE)     #FUN-C40109 mark
        CALL cl_set_comp_entry("lmv01,lmv03",TRUE) 
     END IF
END FUNCTION
 
