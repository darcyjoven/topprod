# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi602.4gl
# Descriptions...: 資料中心拋轉設定作業
# Date & Author..: 07/12/07 By Carrier FUN-7C0010
# Modify.........: FUN-830090 08/03/21 By Carrier 資料中心修改
# Modify.........: NO.FUN-840033 08/04/08 BY yiting 單身新增時，條件皆預設"1=1"
# Modify.........: No.MOD-940377 09/04/30 By Smapmin 僅需控卡集團是否有屬於資料中心的營運中心存在
# Modify.........: No.FUN-980017 09/08/20 By destiny 集團架構功能修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/10/12 By dxfwo資料中心修改
# Modify.........: No.FUN-9A0092 09/10/28 By dxfwo資料中心修改
# Modify.........: No.TQC-9B0069 09/11/22 By dxfwo資料中心修改 不同資料類別的重複問題修改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-A80028 10/08/04 By Carrier 拿掉azy_file的检查,目前此TABLE已经无用了
# Modify.........: No.FUN-A90024 10/11/16 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.TQC-AB0108 10/12/04 By lixh1  修改"預設資料"aooi602_2的顯示
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80035 11/08/03 By Lujh 模組程序撰寫規範修正
# Modify.........: No:CHI-B60098 13/04/03 By Alberti 新增 geu00 為 KEY 值
# Modify.........: No:FUN-D40030 13/04/09 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D40135 13/04/19 By bart 基本資料只能手動拋轉

DATABASE ds
 
GLOBALS "../../config/top.global" #FUN-7C0010
 
DEFINE
    g_gew01         LIKE gew_file.gew01,   #營運中心
    g_gew01_t       LIKE gew_file.gew01,   #營運中心 (舊值)
    g_geu02         LIKE geu_file.geu02,
    g_gew02         LIKE gew_file.gew02,   #資料類型
    g_gew02_t       LIKE gew_file.gew02,   #資料類型 (舊值)
    g_gew03         LIKE gew_file.gew03,   #Carry
    g_gew03_t       LIKE gew_file.gew03,   #Carry    (舊值)
    g_gew           DYNAMIC ARRAY OF RECORD 
        gew04       LIKE gew_file.gew04,   #營運中心
        azp02       LIKE azp_file.azp02,   #營運中心名稱
        azw05       LIKE azw_file.azw05,   #No.FUN-980017
        azw06       LIKE azw_file.azw06,   #No.FUN-980017
        plant       LIKE type_file.chr1000,#No.FUN-980025
        gew05       LIKE gew_file.gew05,   #資料Carry Cond
        gew06       LIKE gew_file.gew06,   #資料Delete
        gew10       LIKE gew_file.gew10,   #No.FUN-980025
        gew07       LIKE gew_file.gew07,   #資料Update
        gew08       LIKE gew_file.gew08    #資料Notify
                    END RECORD,
    g_gew_t         RECORD                 #程式變數 (舊值)
        gew04       LIKE gew_file.gew04,   #營運中心
        azp02       LIKE azp_file.azp02,   #營運中心名稱
        azw05       LIKE azw_file.azw05,   #No.FUN-980017
        azw06       LIKE azw_file.azw06,   #No.FUN-980017
        plant       LIKE type_file.chr1000,#No.FUN-980025       
        gew05       LIKE gew_file.gew05,   #資料Carry Cond
        gew06       LIKE gew_file.gew06,   #資料Delete
        gew10       LIKE gew_file.gew10,   #No.FUN-980025
        gew07       LIKE gew_file.gew07,   #資料Update
        gew08       LIKE gew_file.gew08    #資料Notify
                    END RECORD,
    g_cond          DYNAMIC ARRAY OF RECORD 
        field_no    LIKE gaq_file.gaq01,   #
        field_name  LIKE gaq_file.gaq03,   #名稱
        condition   LIKE type_file.chr2,   #
        value       LIKE ze_file.ze03,     #
        data_type   LIKE type_file.chr50
                    END RECORD,
    g_cond_t  RECORD                       #程式變數 (舊值)
        field_no    LIKE gaq_file.gaq01,   #
        field_name  LIKE gaq_file.gaq03,   #名稱
        condition   LIKE type_file.chr2,   #
        value       LIKE ze_file.ze03,     #
        data_type   LIKE type_file.chr50
                    END RECORD,
    g_argv1         LIKE aag_file.aag01,
    g_ss            LIKE type_file.chr1,
    g_wc,g_sql      STRING,
    g_rec_b         LIKE type_file.num5,   #單身筆數
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT
DEFINE g_forupd_sql         STRING
DEFINE g_sql_tmp            STRING
DEFINE g_before_input_done  LIKE type_file.num5 
DEFINE g_cnt                LIKE type_file.num10
DEFINE g_i                  LIKE type_file.num5
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_row_count          LIKE type_file.num10
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_jump               LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_str                STRING            
DEFINE g_db_type            LIKE type_file.chr3
DEFINE g_azt01              LIKE azt_file.azt01                 #No.FUN-980017
DEFINE g_tt                 LIKE type_file.chr1                 #No.FUN-980017
#No.TQC-AB0108   ---begin---
DEFINE i                    LIKE type_file.num5
DEFINE l_rec_b              LIKE type_file.num5
DEFINE l_gez     DYNAMIC ARRAY OF RECORD
                 gez04    LIKE gaq_file.gaq01,       #
                 gaq03    LIKE gaq_file.gaq03,       #名稱
                 gez05    LIKE type_file.chr1000     #
                 END RECORD,
       l_gez_t   RECORD                              #程式變數 (舊值)
                 gez04    LIKE gaq_file.gaq01,       #
                 gaq03    LIKE gaq_file.gaq03,       #名稱
                 gez05    LIKE type_file.chr1000     #
                 END RECORD
#No.TQC-AB0108   ---end---
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AOO")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    LET g_db_type=cl_db_get_database_type()
 
    OPEN WINDOW i602_w WITH FORM "aoo/42f/aooi602"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

    IF NOT cl_null(g_argv1) THEN
       CALL i602_q()
    END IF
 
  
    CALL i602_menu()
 
    CLOSE WINDOW i602_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION i602_curs()
    CLEAR FORM                             #清除畫面
    CALL g_gew.clear()
 
    IF g_argv1 IS NOT NULL THEN
       LET g_gew01 =  g_argv1
       DISPLAY g_gew01 TO gew01
       CALL cl_set_head_visible("","YES")     
       LET g_wc = " gew01 ='",g_argv1,"'"
       IF INT_FLAG THEN RETURN END IF
    ELSE
       CALL cl_set_head_visible("","YES")      
       CONSTRUCT g_wc ON gew01,gew02,gew03,gew04,gew05,gew06,gew10,gew07,gew08
            FROM gew01,gew02,gew03,s_gew[1].gew04,s_gew[1].gew05,
                 s_gew[1].gew06,s_gew[1].gew10,s_gew[1].gew07,s_gew[1].gew08
 
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
 
            ON ACTION controlp
               CASE
                  WHEN INFIELD(gew01) #資料中心代碼
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_geu"
                     LET g_qryparam.arg1 ="1"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO gew01
                     NEXT FIELD gew01
                  WHEN INFIELD(gew04) #營運中心
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_azp"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO gew04
                     NEXT FIELD gew04
                 #WHEN INFIELD(gew08) #Person
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.state = "c"
                 #   LET g_qryparam.form ="q_gen"
                 #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                 #   DISPLAY g_qryparam.multiret TO gew08
                 #   NEXT FIELD gew08
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF INT_FLAG THEN RETURN END IF
    END IF
 
    LET g_sql= "SELECT DISTINCT gew01,gew02 FROM gew_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY gew01,gew02"
    PREPARE i602_prepare FROM g_sql      #預備一下
    DECLARE i602_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i602_prepare
 
    LET g_sql_tmp= "SELECT DISTINCT gew01,gew02 FROM gew_file ",
                   " WHERE ", g_wc CLIPPED,
                   "  INTO TEMP x"
    DROP TABLE x                                                                
    PREPARE i062_pre_x FROM g_sql_tmp
    EXECUTE i062_pre_x
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i602_precount FROM g_sql
    DECLARE i602_count CURSOR FOR i602_precount
END FUNCTION
 
FUNCTION i602_menu()
 
   WHILE TRUE
      CALL i602_bp("G")
      CASE g_action_choice
         WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i602_a()
           END IF
         WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i602_u()
           END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i602_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i602_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i602_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "gen_detail"
            IF cl_chk_act_auth() THEN
               CALL i602_g_b()
            END IF
         WHEN "set_default_value"
            IF cl_chk_act_auth() THEN
               IF l_ac > 0 THEN
                  CALL i602_set_default_value()
               END IF
            END IF
        #WHEN "output"
        #   IF cl_chk_act_auth() THEN
        #      CALL i602_out()
        #   END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_gew01 IS NOT NULL THEN
                  LET g_doc.column1 = "gew01"
                  LET g_doc.value1 = g_gew01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gew),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i602_gew04(p_cmd)
    DEFINE p_cmd    LIKE type_file.chr1
    DEFINE l_azp02  LIKE azp_file.azp02
    DEFINE l_azw05  LIKE azw_file.azw05                 #No.FUN-980017
    DEFINE l_azw06  LIKE azw_file.azw06                 #No.FUN-980017
    DEFINE l_azw01 LIKE azw_file.azw01                  #No.FUN-980025                                                                             
    DEFINE l_n     LIKE type_file.num5                  #No.FUN-980025                                                                             
    DEFINE l_str   string                               #No.FUN-980025
    LET g_errno = ' '
    SELECT azp02 INTO l_azp02 FROM azp_file
     WHERE azp01 = g_gew[l_ac].gew04
    CASE
       WHEN STATUS=100      LET g_errno = 'aap-025'
                            LET l_azp02 = NULL
       OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
    LET g_gew[l_ac].azp02 = l_azp02
    #No.FUN-980017--begin
    SELECT azw05,azw06 INTO l_azw05,l_azw06 FROM azw_file 
     WHERE azw01=g_gew[l_ac].gew04 
    LET g_gew[l_ac].azw05=l_azw05
    LET g_gew[l_ac].azw06=l_azw06
    DISPLAY BY NAME g_gew[l_ac].azw05
    DISPLAY BY NAME g_gew[l_ac].azw06
    IF cl_null(g_gew[l_ac].gew05) THEN
       LET g_gew[l_ac].gew05=" 1=1" 
    END IF 
    IF cl_null(g_gew[l_ac].gew06) THEN
       LET g_gew[l_ac].gew06='Y' 
    END IF 
    IF cl_null(g_gew[l_ac].gew07) THEN
       LET g_gew[l_ac].gew07='Y' 
    END IF         
    #No.FUN-980017--end
  ##NO.FUN-980025 GP5.2 add--begin                                                                                                                                                                       
   SELECT count(azw01) INTO l_n FROM azw_file WHERE azw06 = l_azw06                                                                                                                                                  
   IF l_n >= 1 THEN                                                                                                                  
     LET g_sql = "SELECT azw01 FROM azw_file WHERE azw06 = '",l_azw06,"' "                                                          
     PREPARE i602_pb1 FROM g_sql                                                                                                    
     DECLARE azw_curs CURSOR FOR i602_pb1                                                                                           
     LET l_str = ' '                                                                                                                
     FOREACH azw_curs INTO l_azw01                                                                                                  
       IF STATUS THEN                                                                                                               
          CALL cl_err('foreach:',STATUS,1)                                                                                          
          EXIT FOREACH                                                                                                              
       END IF                                                                                                                                                        
       IF l_azw01 is NULL THEN                                                                                                      
          CONTINUE FOREACH                                                                                                          
       END IF
       IF l_str = ' ' THEN                                                                                                          
          LET l_str = l_str,l_azw01                                                                                                 
          LET l_str = l_str.trim()                                                                                                  
       ELSE                                                                                                                         
          LET l_str = l_str,",",l_azw01                                                                                             
          LET l_str = l_str.trim()                                                                                                  
       END IF                                                                                                                       
     END FOREACH                                                                                                                    
   END IF    
   LET g_gew[l_ac].plant = l_str                                                                                                                         
   DISPLAY BY NAME g_gew[l_ac].plant       
   SELECT COUNT(*) INTO l_n FROM azw_file                                                                                           
    WHERE azw05 <> azw06                                                                                                          
   IF l_n < 1  THEN                                                                                                                 
     CALL cl_set_comp_visible("plant",FALSE)                                                                                        
   ELSE                                                                                                                             
     CALL cl_set_comp_visible("plant",TRUE)                                                                                         
   END IF    
  ##NO.FUN-980025 GP5.2 add--end   
END FUNCTION
 
FUNCTION i602_gew01(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1
    DEFINE l_geu00   LIKE geu_file.geu00   
    DEFINE l_geu02   LIKE geu_file.geu02   
    DEFINE l_geuacti LIKE geu_file.geuacti
 
    LET g_errno = ' '
    SELECT geu00,geu02,geuacti INTO l_geu00,l_geu02,l_geuacti
     #FROM geu_file WHERE geu01=g_gew01                          #CHI-B60098 mark
      FROM geu_file WHERE geu01=g_gew01 AND geu00='1'            #CHI-B60098 add
    CASE
        WHEN l_geuacti = 'N' LET g_errno = '9028'
        WHEN l_geu00 <> '1'  LET g_errno = 'aoo-030'
        WHEN STATUS=100      LET g_errno = 100
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
    IF NOT cl_null(g_errno) THEN 
       LET l_geu02 = NULL
       LET g_geu02 = NULL
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_geu02 = l_geu02
    END IF
    DISPLAY g_geu02 TO geu02
END FUNCTION
 
#Query 查詢
FUNCTION i602_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gew01 TO NULL
    INITIALIZE g_geu02 TO NULL 
    INITIALIZE g_gew02 TO NULL
    INITIALIZE g_gew03 TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_gew.clear()
    CALL i602_curs()                          #取得查詢條件
    IF INT_FLAG THEN                          #使用者不玩了
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i602_b_curs                          #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                     #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_gew01 TO NULL
    ELSE
       CALL i602_fetch('F')
       OPEN i602_count
       FETCH i602_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i602_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i602_b_curs INTO g_gew01,g_gew02
        WHEN 'P' FETCH PREVIOUS i602_b_curs INTO g_gew01,g_gew02
        WHEN 'F' FETCH FIRST    i602_b_curs INTO g_gew01,g_gew02
        WHEN 'L' FETCH LAST     i602_b_curs INTO g_gew01,g_gew02
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i602_b_curs INTO g_gew01,g_gew02
            LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN        
        CALL cl_err(g_gew01,SQLCA.sqlcode,0)
        INITIALIZE g_gew01 TO NULL
    ELSE
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
        END CASE
        SELECT DISTINCT gew03 INTO g_gew03 FROM gew_file
         WHERE gew01 = g_gew01
           AND gew02 = g_gew02
        IF SQLCA.sqlcode THEN
           IF SQLCA.sqlcode = -284 THEN
              LET g_gew03 = 'N'
           ELSE
              CALL cl_err3("sel","gew_file",g_gew01,g_gew02,SQLCA.sqlcode,"","",1)
              INITIALIZE g_gew01 TO NULL
              INITIALIZE g_gew02 TO NULL
              INITIALIZE g_gew03 TO NULL
              INITIALIZE g_geu02 TO NULL
              RETURN
           END IF
        END IF
 
        CALL cl_navigator_setting( g_curs_index, g_row_count )
        CALL i602_show()
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i602_show()
DEFINE l_azw01  LIKE azw_file.azw01                  #No.FUN-980025  
DEFINE l_azw06  LIKE azw_file.azw06                  #No.FUN-980025                                                                           
DEFINE l_n      LIKE type_file.num5                  #No.FUN-980025                                                                             

    DISPLAY g_gew01 TO gew01   
    DISPLAY g_gew02 TO gew02   
    DISPLAY g_gew03 TO gew03
  ##NO.FUN-980025 GP5.2 add--begin
   SELECT COUNT(*) INTO l_n FROM azw_file                                                                                           
    WHERE azw05 <> azw06                                                                                                           
   IF l_n < 1  THEN                                                                                                                 
     CALL cl_set_comp_visible("plant",FALSE)                                                                                        
   ELSE                                                                                                                             
     CALL cl_set_comp_visible("plant",TRUE)                                                                                         
   END IF  
  ##NO.FUN-980025 GP5.2 add--end        
    CALL i602_gew01('d')
    CALL i602_b_fill(g_wc)  
    CALL cl_show_fld_cont()    
END FUNCTION
 
FUNCTION i602_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_gew.clear()
    INITIALIZE g_gew01 LIKE gew_file.gew01
    INITIALIZE g_gew03 LIKE gew_file.gew03
    LET g_gew01_t = NULL  
    LET g_gew02_t = NULL
    LET g_gew03_t = NULL
    LET g_gew03 = 'N'
    LET g_tt='N'                                      #No.FUN-980017
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i602_i("a")  
        IF INT_FLAG THEN    
            LET g_gew02=NULL
            LET g_gew01=NULL
            LET g_gew03=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        #No.FUN-980017--begin
        IF g_tt='Y'THEN 
           CALL i602_sel()
        END IF 
        #No.FUN-980017--end 
        LET g_rec_b = 0 
        IF g_ss='N' THEN
           CALL g_gew.clear()
        ELSE
           CALL i602_b_fill('1=1')
        END IF
        #No.FUN-980017--begin
        IF g_tt='Y' AND NOT cl_null(g_azt01) THEN
           CALL i602_b_fill('1=1')
        END IF 
        #No.FUN-980017--end 
        CALL i602_b()          
        LET g_gew02_t = g_gew02
        LET g_gew03_t = g_gew03
        LET g_gew01_t = g_gew01
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i602_u()
  DEFINE  l_buf      LIKE type_file.chr50
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_gew01) OR cl_null(g_gew02) THEN 
        CALL cl_err('',-400,0)
        RETURN
    END IF
#   IF g_gew02 = '0' THEN RETURN END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_gew01_t = g_gew01
    LET g_gew02_t = g_gew02
    LET g_gew03_t = g_gew03
    BEGIN WORK
    WHILE TRUE
        CALL i602_i("u") 
        IF INT_FLAG THEN
            LET g_gew01=g_gew01_t
            LET g_gew02=g_gew02_t  
            LET g_gew03=g_gew03_t  
            DISPLAY g_gew01 TO gew01               #單頭
            DISPLAY g_gew02 TO gew02
            DISPLAY g_gew03 TO gew03
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_gew01 != g_gew01_t OR g_gew03 != g_gew03_t 
        OR g_gew02 != g_gew02_t THEN
           UPDATE gew_file SET gew01 = g_gew01,
                               gew02 = g_gew02,
                               gew03 = g_gew03
            WHERE gew01 = g_gew01_t
              AND gew02 = g_gew02_t
            IF SQLCA.sqlcode THEN
                LET l_buf = g_gew01 CLIPPED,'+',g_gew02 CLIPPED
                CALL cl_err3("upd","gew_file",g_gew01_t,g_gew02_t,SQLCA.sqlcode,"","",1) 
                ROLLBACK WORK
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
FUNCTION i602_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,  
    l_buf           LIKE type_file.chr1000, 
    l_n             LIKE type_file.num5,       
    l_cnt           LIKE type_file.num5,   #MOD-940377      
    l_count         LIKE type_file.num5    #No.FUN-980017 
 
    LET g_ss = 'Y'
    CALL cl_set_head_visible("","YES")     
 
    DISPLAY g_gew01 TO gew01
    DISPLAY g_gew02 TO gew02
    DISPLAY g_gew03 TO gew03
 
    CALL i602_set_entry(p_cmd)
    INPUT g_gew01,g_gew02,g_gew03  WITHOUT DEFAULTS 
          FROM gew01,gew02,gew03 
 
       BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i602_set_entry(p_cmd)
          CALL i602_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
       BEFORE FIELD gew01
          IF NOT cl_null(g_argv1) THEN
             LET g_gew01 = g_argv1
             DISPLAY g_gew01 TO gew01
             NEXT FIELD gew02
          END IF
 
       AFTER FIELD gew01
          IF NOT cl_null(g_gew01) THEN
             CALL i602_gew01('a')
             IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gew01,g_errno,0)
               LET g_gew01 = g_gew01_t
               DISPLAY g_gew01 TO gew01
               NEXT FIELD gew01
             END IF
          ELSE
             DISPLAY '' TO geu02
          END IF
 
       BEFORE FIELD gew02
          IF cl_null(g_gew01) THEN NEXT FIELD gew01 END IF
       
       AFTER FIELD gew02
          IF NOT cl_null(g_gew02) THEN
             IF g_gew01 != g_gew01_t OR g_gew01_t IS NULL OR
                g_gew02 != g_gew02_t OR g_gew02_t IS NULL THEN 
                SELECT UNIQUE gew01,gew02 FROM gew_file
                 WHERE gew01=g_gew01 AND gew02=g_gew02
                IF SQLCA.sqlcode THEN          
                   IF p_cmd='a' THEN
                      LET g_ss='N'
                   END IF
                ELSE
                   IF p_cmd='u' THEN
                      LET l_buf = g_gew01 CLIPPED,'+',g_gew02 CLIPPED
                      CALL cl_err(l_buf,-239,0)
                      LET g_gew01=g_gew01_t
                      LET g_gew02=g_gew02_t
                      NEXT FIELD gew01 
                   END IF
                END IF
             END IF
             #No.FUN-830090  --Begin
             IF NOT cl_null(g_gew01) THEN
                LET l_cnt = 0   #MOD-940377
                #SELECT * FROM gev_file WHERE gev01 = g_gew02   #MOD-940377
                SELECT COUNT(*) INTO l_cnt FROM gev_file    #MOD-940377
                  WHERE gev01 = g_gew02   #MOD-940377
                    AND gev03 = 'Y'
                    AND gev04 = g_gew01
                #IF SQLCA.sqlcode THEN   #MOD-940377
                IF l_cnt = 0  THEN   #MOD-940377
                   CALL cl_err(g_gew01,'aoo-094',0)
                   NEXT FIELD gew01
                END IF
             END IF
             #No.FUN-830090  --End  
             #No.FUN-980017--begin
             SELECT COUNT(*) INTO l_count FROM gew_file 
              WHERE gew01=g_gew01 AND gew02=g_gew02
             IF l_count=0 AND p_cmd='a' THEN 
                LET g_tt='Y'
             END IF 
             #No.FUN-980017--end
             #MOD-D40135---begin
             IF g_gew02 = '0' AND g_gew03 <> '3' THEN
                IF g_gew03 = '1' OR g_gew03 = '2' THEN 
                   CALL cl_err('','aoo-180',0)
                END IF 
                LET g_gew03 = '3'
                DISPLAY g_gew03 TO gew03
             END IF 
             #MOD-D40135---end
          END IF

       #MOD-D40135---begin
       AFTER FIELD gew03
          IF g_gew02 = '0' AND g_gew03 <> '3' THEN
             CALL cl_err('','aoo-180',0)
             LET g_gew03 = '3'
             DISPLAY g_gew03 TO gew03
             NEXT FIELD gew03
          END IF 
       #MOD-D40135---end
 
       ON ACTION CONTROLF               
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(gew01) #資料中心代碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_geu"
                  LET g_qryparam.arg1     = "1"
                  LET g_qryparam.default1 = g_gew01
                  CALL cl_create_qry() RETURNING g_gew01
                  DISPLAY g_gew01 TO gew01
                  NEXT FIELD gew01
          END CASE
    END INPUT
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i602_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_gew01 IS NULL OR g_gew02 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "gew01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_gew01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM gew_file WHERE gew01 = g_gew01 AND gew02 = g_gew02
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","gew_file",g_gew01,g_gew02,SQLCA.sqlcode,"","del gew",1)
          ROLLBACK WORK
          RETURN
       ELSE
          LET g_cnt=SQLCA.SQLERRD[3]
          DELETE FROM gez_file WHERE gez01 = g_gew01 AND gez02 = g_gew02
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","gez_file",g_gew01,g_gew02,SQLCA.sqlcode,"","del gez",1)
             ROLLBACK WORK
             RETURN
          END IF
          CLEAR FORM
          CALL g_gew.clear()
          MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
          DROP TABLE x
          PREPARE i602_pre_x2 FROM g_sql_tmp
          EXECUTE i602_pre_x2
          OPEN i602_count
          #FUN-B50063-add-start--
          IF STATUS THEN
             CLOSE i602_b_curs
             CLOSE i602_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50063-add-end-- 
          FETCH i602_count INTO g_row_count
          #FUN-B50063-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i602_b_curs
             CLOSE i602_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50063-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i602_b_curs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i602_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET g_no_ask = TRUE
             CALL i602_fetch('/')
          END IF
       END IF
    END IF
    COMMIT WORK
END FUNCTION
 
FUNCTION i602_g_b()
  
 
END FUNCTION
 
#單身
FUNCTION i602_b()
DEFINE
    l_ac_t          LIKE type_file.num5,           #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,           #檢查重複用 
    l_n1            LIKE type_file.num5,           #No.FUN-980025       
    l_lock_sw       LIKE type_file.chr1,           #單身鎖住否       
    p_cmd           LIKE type_file.chr1,           #處理狀態         
    l_allow_insert  LIKE type_file.num5,           #可新增否         
    l_allow_delete  LIKE type_file.num5,           #可刪除否    
    l_str           LIKE type_file.chr1000,
    l_azw06         LIKE azw_file.azw06,           #No.FUN-980025
    l_gew09         LIKE gew_file.gew09    

 
    LET g_action_choice = ""
    IF g_gew01 IS NULL OR g_gew02 IS NULL THEN
       RETURN
    END IF
    CALL cl_opmsg('b')
 
#    LET g_forupd_sql = "SELECT gew04,'',gew05,gew06,gew07,gew08,gew09 FROM gew_file ",             #No.FUN-980017
#    LET g_forupd_sql = "SELECT gew04,'','','',gew05,gew06,gew07,gew08,gew09 FROM gew_file ",       #No.FUN-980017 #No.FUN-980025 mark
     LET g_forupd_sql = "SELECT gew04,'','','','',gew05,gew06,gew10,gew07,gew08,gew09 FROM gew_file ", #No.FUN-980017 #No.FUN-980025
                       " WHERE gew01= ? AND gew02 = ? AND gew04 = ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i602_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_gew WITHOUT DEFAULTS FROM s_gew.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_before_input_done = FALSE
            CALL i602_set_entry_b(p_cmd)
            CALL i602_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'   
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_gew_t.* = g_gew[l_ac].*  #BACKUP
               OPEN i602_bcl USING g_gew01,g_gew02,g_gew_t.gew04
               IF STATUS THEN
                  CALL cl_err("OPEN i602_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i602_bcl INTO g_gew[l_ac].*,l_gew09
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_gew_t.gew06,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL i602_gew04('d')
  ##NO.FUN-980025 GP5.2 add--begin
               IF g_gew[l_ac].azw05 <> g_gew[l_ac].azw06 THEN                                                                      
#                  LET g_gew[l_ac].gew10 = 'N'                                                                                      
                  CALL cl_set_comp_entry("gew10",FALSE)                                                                            
               ELSE                                                                                                                
#                  LET g_gew[l_ac].gew10 = 'Y'                                                                                      
                  CALL cl_set_comp_entry("gew10",TRUE)                                                                             
               END IF 
  ##NO.FUN-980025 GP5.2 add--end
               END IF
               CALL cl_show_fld_cont()
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_gew[l_ac].* TO NULL      #900423
            LET g_gew[l_ac].gew06 = 'Y'
            LET g_gew[l_ac].gew07 = 'Y'
            LET g_gew[l_ac].gew10 = 'Y'         #No.FUN-9A0092
            #IF g_gew02 = '0' THEN              #no.FUN-840033 mark
               LET g_gew[l_ac].gew05 = " 1=1"
            #END IF                             #no.FUN-840033 mark
            LET l_gew09 = NULL
            LET g_gew_t.* = g_gew[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()
            NEXT FIELD gew04
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF cl_null(g_gew[l_ac].gew05) THEN
               LET g_gew[l_ac].gew05 = " 1=1"
            END IF
#           INSERT INTO gew_file(gew01,gew02,gew03,gew04,gew05,gew06,gew07,gew08,gew09)      #No.FUN-980025 mark
            INSERT INTO gew_file(gew01,gew02,gew03,gew04,gew05,gew06,gew07,gew08,gew09,gew10)#No.FUN-980025 
                   VALUES(g_gew01,g_gew02,g_gew03,g_gew[l_ac].gew04,g_gew[l_ac].gew05,
                          g_gew[l_ac].gew06,g_gew[l_ac].gew07,g_gew[l_ac].gew08,l_gew09,g_gew[l_ac].gew10)  #No.FUN-980025
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","gew_file",g_gew01,g_gew[l_ac].gew04,SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
 
        AFTER FIELD gew05
             IF cl_null(g_gew[l_ac].gew04) THEN
                NEXT FIELD gew04
             END IF
 
        AFTER FIELD gew04
             IF NOT cl_null(g_gew[l_ac].gew04) THEN
                CALL i602_gew04('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_gew[l_ac].gew04,g_errno,1)
                   LET g_gew[l_ac].gew04 = g_gew_t.gew04
                   NEXT FIELD gew04
                END IF
                
                IF NOT cl_null(g_gew[l_ac].gew04) THEN
                   IF g_gew[l_ac].gew04 != g_gew_t.gew04 OR
                      g_gew_t.gew04 IS NULL THEN
                      SELECT COUNT(*) INTO l_n FROM gew_file
                       WHERE gew01 = g_gew01
                         AND gew02 = g_gew02
                         AND gew04 = g_gew[l_ac].gew04
                      IF l_n > 0 THEN
                          CALL cl_err('',-239,0)
                          LET g_gew[l_ac].gew04 = g_gew_t.gew04
                          NEXT FIELD gew04
                      END IF
                      SELECT COUNT(*) INTO l_n1 FROM gew_file,azw_file 
                       WHERE  azw06 = g_gew[l_ac].azw06
                         AND  gew04 = azw01
                         AND  gew02 = g_gew02           #No.TQC-9B0069  
                       IF l_n1  >= 1 THEN 
                        CALL cl_err_msg(NULL,"aoo-118",g_gew[l_ac].azw06,0)
                        NEXT FIELD gew04 
                       END IF 
                   END IF
                END IF
  ##NO.FUN-980025 GP5.2 add--begin
                IF g_gew[l_ac].azw05 <> g_gew[l_ac].azw06 THEN 
#                  LET g_gew[l_ac].gew10 = 'N'                   #No.FUN-9A0092  
                   CALL cl_set_comp_entry("gew10",FALSE) 
                ELSE 
#                  LET g_gew[l_ac].gew10 = 'Y'                   #No.FUN-9A0092                                                                         
                   CALL cl_set_comp_entry("gew10",TRUE)
                END IF
  ##NO.FUN-9A0092  add--begin
                #No.MOD-A80028  --Begin
                #CALL i602_check(p_cmd,g_gew[l_ac].azw06) 
                #IF NOT cl_null(g_errno) THEN
       	        #   LET g_gew[l_ac].gew04 = g_gew_t.gew04
                #   CALL cl_err_msg(NULL,g_errno,g_str,1)
                #   NEXT FIELD gew04
                #END IF                 
                #No.MOD-A80028  --End  
  ##NO.FUN-9A0092  add--end
#                 IF g_gew02  MATCHES '[1234567]'  THEN 
#                  IF g_gew[l_ac].azw05 <> g_gew[l_ac].azw06 THEN 
#                    SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw05<>azw06 AND azw01 = g_gew[l_ac].gew04
#                    SELECT  COUNT(*) INTO l_n1 FROM azy_file WHERE azy01 = l_azw06
#                      IF l_n1 < 1 THEN 
#                       CALL cl_err('','aoo-119',1)
#                       NEXT FIELD gew04 
#                      END IF 
#                   END IF 
#                 END IF  
  ##NO.FUN-980025 GP5.2 add--end
             END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_gew_t.gew04 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM gew_file
                WHERE gew01 = g_gew01 
                  AND gew02 = g_gew02
                  AND gew04 = g_gew_t.gew04
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","gew_file",g_gew01,g_gew_t.gew04,SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  CANCEL DELETE
               ELSE
                  DELETE FROM gez_file 
                   WHERE gez01 = g_gew01 
                     AND gez02 = g_gew02
                     AND gez03 = g_gew_t.gew04
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","gez_file",g_gew01,g_gew_t.gew04,SQLCA.sqlcode,"","del gez",1)
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF
               END IF
               LET g_rec_b = g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_gew[l_ac].* = g_gew_t.*
               CLOSE i602_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_gew[l_ac].gew04,-263,1)
               LET g_gew[l_ac].* = g_gew_t.*
            ELSE
               IF cl_null(g_gew[l_ac].gew05) THEN
                  LET g_gew[l_ac].gew05 = " 1=1"
               END IF
               UPDATE gew_file SET gew04 = g_gew[l_ac].gew04,
                                   gew05 = g_gew[l_ac].gew05,
                                   gew06 = g_gew[l_ac].gew06,
                                   gew07 = g_gew[l_ac].gew07,
                                   gew08 = g_gew[l_ac].gew08,
                                   gew10 = g_gew[l_ac].gew10,
                                   gew09 = l_gew09
                WHERE gew01 = g_gew01 
                  AND gew02 = g_gew02
                  AND gew04 = g_gew_t.gew04
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","gew_file",g_gew01,g_gew_t.gew04,SQLCA.sqlcode,"","",1)
                  LET g_gew[l_ac].* = g_gew_t.*
                  ROLLBACK WORK
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
               IF p_cmd='u' THEN
                  LET g_gew[l_ac].* = g_gew_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_gew.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--

               END IF
               CLOSE i602_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i602_bcl
            COMMIT WORK
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(gew04)        #azp_file
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azp"
                  LET g_qryparam.default1 = g_gew[l_ac].gew04
                  CALL cl_create_qry() RETURNING g_gew[l_ac].gew04
                  DISPLAY BY NAME g_gew[l_ac].gew04
                  NEXT FIELD gew04
             WHEN INFIELD(gew05)        #carry condition
                  CALL i602_input_condition(l_gew09) RETURNING g_gew[l_ac].gew05,l_gew09
                  DISPLAY BY NAME g_gew[l_ac].gew05
                  NEXT FIELD gew05
             WHEN INFIELD(gew08)
                  CALL s_dc_usermail(TRUE,TRUE,'',g_gew[l_ac].gew08,TRUE)  #No.FUN-830090
                       RETURNING l_str,g_gew[l_ac].gew08
                  DISPLAY BY NAME g_gew[l_ac].gew08
                  NEXT FIELD gew08
          END CASE
 
        ON ACTION CONTROLR
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
                       
        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT
    CLOSE i602_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i602_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc     STRING
DEFINE l_azw01  LIKE azw_file.azw01                  #No.FUN-980025  
DEFINE l_azw06  LIKE azw_file.azw06                  #No.FUN-980025                                                                           
DEFINE l_n      LIKE type_file.num5                  #No.FUN-980025 
DEFINE l_str    string                               #No.FUN-980025 
#    LET g_sql ="SELECT gew04,'',gew05,gew06,gew07,gew08 FROM gew_file ",              #No.FUN-980017
     LET g_sql ="SELECT gew04,'','','','',gew05,gew06,gew10,gew07,gew08 FROM gew_file ",  #No.FUN-980017  #No.FUN-980025
               " WHERE gew01 = '",g_gew01,"'",
               "   AND gew02 = '",g_gew02,"'",
               "   AND ",p_wc CLIPPED,
               " ORDER BY gew04"
    PREPARE i602_p2 FROM g_sql      #預備一下
    DECLARE gew_curs CURSOR FOR i602_p2
 
    CALL g_gew.clear()
 
    LET g_cnt = 1
    FOREACH gew_curs INTO g_gew[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT azp02 INTO g_gew[g_cnt].azp02
          FROM azp_file
         WHERE azp01=g_gew[g_cnt].gew04
        #No.FUN-980017--begin 
        SELECT azw05,azw06 INTO g_gew[g_cnt].azw05,g_gew[g_cnt].azw06
          FROM azw_file 
         WHERE azw01=g_gew[g_cnt].gew04
        #No.FUN-980017--end  
  ##NO.FUN-980025 GP5.2 add--begin    
#   SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw01 = g_gew01                                                                      
   SELECT count(azw01) INTO l_n FROM azw_file WHERE azw06 = g_gew[g_cnt].azw06                                                                                                                                                  
   LET g_sql = "SELECT azw01 FROM azw_file WHERE azw06 = '",g_gew[g_cnt].azw06,"' "                                                          
   PREPARE i602_pb2 FROM g_sql                                                                                                    
   DECLARE azw_curs1 CURSOR FOR i602_pb2
   IF l_n >= 1 THEN 
     LET l_str = ' '                                                                                                                
     FOREACH azw_curs1 INTO l_azw01                                                                                                  
       IF STATUS THEN                                                                                                               
          CALL cl_err('foreach:',STATUS,1)                                                                                          
          EXIT FOREACH                                                                                                              
       END IF                                                                                                                                                        
       IF l_azw01 is NULL THEN                                                                                                      
          CONTINUE FOREACH                                                                                                          
       END IF
       IF l_str = ' ' THEN                                                                                                          
          LET l_str = l_str,l_azw01                                                                                                 
          LET g_gew[g_cnt].plant = l_str.trim()                                                                                                  
       ELSE                                                                                                                         
          LET l_str = l_str,",",l_azw01                                                                                             
          LET g_gew[g_cnt].plant = l_str.trim()                                                                                                  
       END IF                                                                                                                       
     END FOREACH                                                                                                                    
   END IF                                                                                                                            
 
  ##NO.FUN-980025 GP5.2 add--end         
        LET g_cnt = g_cnt + 1 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gew.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i602_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gew TO s_gew.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
         
      ON ACTION first
         CALL i602_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i602_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i602_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION next
         CALL i602_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION last
         CALL i602_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
         
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION set_default_value
         LET g_action_choice="set_default_value"
         EXIT DISPLAY
 
     #ON ACTION output
     #   LET g_action_choice="output"
     #   EXIT DISPLAY
         
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
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i602_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    CALL cl_set_comp_entry("gew01,gew02,gew03",TRUE)
 
END FUNCTION
 
FUNCTION i602_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' THEN
       CALL cl_set_comp_entry("gew01,gew02",FALSE)
    END IF
    
    IF p_cmd = 'u' AND g_gew02 = '0' THEN
       CALL cl_set_comp_entry("gew03",FALSE)
    END IF
   #IF INFIELD(gew01) AND g_gew02 = '0' THEN
   #   CALL cl_set_comp_entry("gew03",FALSE)
   #END IF
 
END FUNCTION
 
FUNCTION i602_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF NOT g_before_input_done THEN
       CALL cl_set_comp_entry("gew05,gew06",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i602_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF NOT g_before_input_done THEN
       IF g_gew02 = '0' THEN
          CALL cl_set_comp_entry("gew05,gew06",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i602_input_condition(p_gew09)
   DEFINE p_gew09   LIKE gew_file.gew09
   DEFINE l_gew05   LIKE gew_file.gew05
   DEFINE l_gew09   LIKE gew_file.gew09
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE i         LIKE type_file.num5
   DEFINE l_tab     LIKE type_file.chr50
   DEFINE li_return LIKE type_file.num5
 
   IF cl_null(g_gew[l_ac].gew04) THEN
      RETURN
   END IF
 
   OPEN WINDOW i602_1_w AT 6,26 WITH FORM "aoo/42f/aooi602_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("aooi602_1")
 
   DISPLAY g_gew[l_ac].gew04 TO gew04
   DISPLAY g_gew[l_ac].azp02 TO azp02
 
   CASE g_gew02
        WHEN '1' LET l_tab = 'ima_file'
        WHEN '2' LET l_tab = 'bma_file'
        WHEN '3' LET l_tab = 'bmx_file'
        WHEN '4' LET l_tab = 'occ_file'
        WHEN '5' LET l_tab = 'pmc_file'
        WHEN '6' LET l_tab = 'aag_file'
        WHEN '7' LET l_tab = 'tqm_file'
   END CASE
        
 
#  CALL s_set_combo_all(g_gew02,"field_no")
 
   CALL g_cond.clear()
   
   IF NOT cl_null(p_gew09) AND g_gew[l_ac].gew05 <> " 1=1" THEN
      CALL i602_cond_dispatch(p_gew09)
           RETURNING l_cnt
   END IF
 
   CALL g_cond.deleteElement(l_cnt+1)
 
   DISPLAY ARRAY g_cond TO s_cond.* ATTRIBUTE(COUNT=l_cnt,UNBUFFERED)
       BEFORE ROW
          EXIT DISPLAY
   END DISPLAY
 
   INPUT ARRAY g_cond WITHOUT DEFAULTS FROM s_cond.*
         ATTRIBUTE (COUNT=l_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
 
        BEFORE INPUT
           IF l_cnt != 0 THEN
              CALL fgl_set_arr_curr(i)
           END IF
 
        BEFORE ROW
           LET i = ARR_CURR()             # 現在游標是在陣列的第幾筆
           LET g_cond_t.* = g_cond[i].*
 
        BEFORE FIELD field_no
           CALL cl_set_comp_required("condition,value,data_type",FALSE) 
             
        AFTER FIELD field_no
           IF NOT cl_null(g_cond[i].field_no) THEN
              IF cl_null(g_cond_t.field_no) OR g_cond_t.field_no <> g_cond[i].field_no THEN
                 CALL i602_check_field(g_cond[i].field_no,l_tab)
                      RETURNING li_return,g_cond[i].data_type
                 IF li_return = 0 THEN
                    NEXT FIELD field_no
                 END IF
              END IF
              SELECT gaq03 INTO g_cond[i].field_name
                FROM gaq_file
               WHERE gaq01 = g_cond[i].field_no
                 AND gaq02 = g_lang
              CALL cl_set_comp_required("condition,value,data_type",TRUE) 
           END IF
    
        AFTER FIELD value
           IF NOT cl_null(g_cond[i].value) THEN 
              CALL s_value_chk(g_cond[i].value)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_cond[i].value,g_errno,1)
                 LET g_cond[i].value = g_cond_t.value
                 NEXT FIELD value
              END IF
           END IF
 
        AFTER ROW
           LET i = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_cond[i].* = g_cond_t.*
              EXIT INPUT
           END IF
 
        ON ACTION CONTROLP                                                        
#          CALL cl_set_act_visible("accept,cancel", TRUE)                         
           CASE                                                                   
               WHEN INFIELD(field_no)                                             
                 CALL q_gaq1(FALSE,TRUE,g_cond[i].field_no,l_tab)
                      RETURNING g_cond[i].field_no
                 DISPLAY BY NAME g_cond[i].field_no
           END CASE                                                               
#          CALL cl_set_act_visible("accept,cancel", FALSE)
  
        ON ACTION CONTROLR
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
 
    IF g_cond.getLength() > 0 THEN
       CALL s_cond_combine(g_cond) RETURNING l_gew05,l_gew09
    END IF
    IF cl_null(l_gew05) THEN LET l_gew05 = " 1=1" END IF
    
    LET g_sql = "SELECT COUNT(*) FROM ",l_tab CLIPPED," WHERE",l_gew05
    PREPARE check_sql FROM g_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare sql',SQLCA.sqlcode,1)
    END IF
    EXECUTE check_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('execute sql','aoo-047',1)
    END IF
 
    CLOSE WINDOW i602_1_w
 
    RETURN l_gew05,l_gew09
 
END FUNCTION
 
FUNCTION i602_set_default_value()
#TQC-AB0108 --------------------Begin----------------------------------
#   DEFINE l_gez     DYNAMIC ARRAY OF RECORD 
#                    gez04    LIKE gaq_file.gaq01,       #
#                    gaq03    LIKE gaq_file.gaq03,       #名稱
#                    gez05    LIKE type_file.chr1000     #
#                    END RECORD,
#          l_gez_t   RECORD                              #程式變數 (舊值)
#                    gez04    LIKE gaq_file.gaq01,       #
#                    gaq03    LIKE gaq_file.gaq03,       #名稱
#                    gez05    LIKE type_file.chr1000     #
#                    END RECORD
#   DEFINE l_rec_b   LIKE type_file.num5,
#          l_cnt     LIKE type_file.num5,
#          i         LIKE type_file.num5,
   DEFINE l_cnt     LIKE type_file.num5, 
          i_t       LIKE type_file.num5,
          l_n       LIKE type_file.num5,
          l_lock_sw LIKE type_file.chr1,
          p_cmd     LIKE type_file.chr1
 
   IF cl_null(g_gew[l_ac].gew04) THEN
      RETURN
   END IF
   IF g_gew02 = '0' THEN
      RETURN
   END IF
 
   OPEN WINDOW i602_2_w AT 6,26 WITH FORM "aoo/42f/aooi602_2"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("aooi602_2")
 
   DISPLAY g_gew[l_ac].gew04 TO gew04
   DISPLAY g_gew[l_ac].azp02 TO azp02
 
   CALL s_set_combo_all(g_gew02,"gez04")
 
   CALL l_gez.clear()
 
   LET g_sql = "SELECT gez04,'',gez05 ",
               "  FROM gez_file ",
               " WHERE gez01 = '",g_gew01,"'",
               "   AND gez02 = '",g_gew02,"'",
               "   AND gez03 = '",g_gew[l_ac].gew04,"'",
               " ORDER BY gez04 "
 
   PREPARE s_aooi602_1_pre1 FROM g_sql
   DECLARE s_aooi602_1_c1 CURSOR FOR s_aooi602_1_pre1
 
   LET l_cnt = 1
   FOREACH s_aooi602_1_c1 INTO l_gez[l_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach gev',STATUS,0)
         EXIT FOREACH
      END IF
      SELECT gaq03 INTO l_gez[l_cnt].gaq03 FROM gaq_file
       WHERE gaq01 = l_gez[l_cnt].gez04
         AND gaq02 = g_lang
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_gez.deleteElement(l_cnt)
   LET l_rec_b = l_cnt - 1
   LET i = 1
 
#TQC-AB0108 ----------Begin-------------
#   DISPLAY ARRAY l_gez TO s_gez.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
#       BEFORE ROW
#          EXIT DISPLAY
#   END DISPLAY
 
#   LET g_forupd_sql = "SELECT gez04,'',gez05 FROM gez_file ",
#                      " WHERE gez01 = ? AND gez02 = ? AND gez03 = ? AND gez04 = ? FOR UPDATE"
 
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE i602_2_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   WHILE TRUE
      CALL i602_2_bp("G")
      CASE g_action_choice

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i602_2_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "exit"
            EXIT WHILE
      END CASE
   END WHILE
   CLOSE WINDOW i602_2_w
END FUNCTION
#TQC-AB0108 -------------------------End-------------------------------
 
#TQC-AB0108 -------------------------Begin-----------------------------
FUNCTION i602_2_b()
   DEFINE l_cnt     LIKE type_file.num5,
          i_t       LIKE type_file.num5,
          l_n       LIKE type_file.num5,
          l_lock_sw LIKE type_file.chr1,
          p_cmd     LIKE type_file.chr1

   LET g_action_choice = ""

      IF g_gew[l_ac].gew04 IS NULL  THEN
         RETURN
      END IF
   CALL cl_opmsg('b')
   LET g_forupd_sql = "SELECT gez04,'',gez05 FROM gez_file ",
                      " WHERE gez01 = ? AND gez02 = ? AND gez03 = ? AND gez04 = ? FOR UPDATE"

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i602_2_bcl CURSOR FROM g_forupd_sql
#TQC-AB0108 -------------------------End-------------------------------
   INPUT ARRAY l_gez WITHOUT DEFAULTS FROM s_gez.*
         ATTRIBUTE (COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
 
       BEFORE INPUT
          IF l_rec_b != 0 THEN
             CALL fgl_set_arr_curr(i)
          END IF
 
       BEFORE ROW
           LET p_cmd=''
           LET i = ARR_CURR()             # 現在游標是在陣列的第幾筆
           LET l_lock_sw = 'N'            # DEFAULT
           LET l_n  = ARR_COUNT()         # 陣列總數有幾筆
           IF l_rec_b >= i THEN
               BEGIN WORK
               LET p_cmd='u'
               LET l_gez_t.* = l_gez[i].*  #BACKUP
               OPEN i602_2_bcl USING g_gew01,g_gew02,g_gew[l_ac].gew04,l_gez_t.gez04
               IF STATUS THEN
                  CALL cl_err("OPEN i602_2_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i602_2_bcl INTO l_gez[i].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(l_gez[i].gez04,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT gaq03 INTO l_gez[i].gaq03 FROM gaq_file
                   WHERE gaq01 = l_gez[i].gez04
                     AND gaq02 = g_lang
               END IF
               CALL cl_show_fld_cont()
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE l_gez[i].* TO NULL
            LET l_gez_t.* = l_gez[i].*         #新輸入資料
            CALL cl_show_fld_cont()
            NEXT FIELD gez04
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i602_2_bcl
              CANCEL INSERT
           END IF
           INSERT INTO gez_file(gez01,gez02,gez03,gez04,gez05)
           VALUES(g_gew01,g_gew02,g_gew[l_ac].gew04,l_gez[i].gez04,l_gez[i].gez05)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","gez_file",g_gew01,l_gez[i].gez04,SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET l_rec_b = l_rec_b + 1
           END IF
 
        BEFORE FIELD gez04
           CALL cl_set_comp_required("gez05",FALSE) 
 
        AFTER FIELD gez04
           IF NOT cl_null(l_gez[i].gez04) THEN
              SELECT gaq03 INTO l_gez[i].gaq03
                FROM gaq_file
               WHERE gaq01 = l_gez[i].gez04
                 AND gaq02 = g_lang 
              IF l_gez[i].gez04 != l_gez_t.gez04 OR l_gez_t.gez04 IS NULL THEN
                 SELECT COUNT(*) INTO g_cnt FROM gez_file
                  WHERE gez01 = g_gew01
                    AND gez02 = g_gew02
                    AND gez03 = g_gew[l_ac].gew04
                    AND gez04 = l_gez[i].gez04
                 IF g_cnt > 0 THEN
                    CALL cl_err('',-239,0)
                    LET l_gez[i].gez04 = l_gez_t.gez04
                    NEXT FIELD gez04
                 END IF
              END IF
              CALL cl_set_comp_required("gez05",TRUE) 
           END IF
    
        BEFORE FIELD gez05
           IF cl_null(l_gez[i].gez04) THEN NEXT FIELD gez04 END IF
 
        BEFORE DELETE                            #是否取消單身
            IF l_rec_b>=i THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM gez_file WHERE gez01 = g_gew01
                                      AND gez02 = g_gew02
                                      AND gez03 = g_gew[l_ac].gew04
                                      AND gez04 = l_gez_t.gez04
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","gez_file",g_gew01,l_gez_t.gez04,SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  EXIT INPUT
               ELSE  
                  LET l_rec_b = l_rec_b - 1
                  COMMIT WORK
               END IF
             END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET l_gez[i].* = l_gez_t.*
              CLOSE i602_2_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(l_gez[i].gez04,-263,0)
              LET l_gez[i].* = l_gez_t.*
           ELSE
              UPDATE gez_file SET gez04=l_gez[i].gez04,gez05=l_gez[i].gez05
               WHERE gez01 = g_gew01
                 AND gez02 = g_gew02
                 AND gez03 = g_gew[l_ac].gew04
                 AND gez04 = l_gez_t.gez04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","gez_file",g_gew01,l_gez_t.gez04,SQLCA.sqlcode,"","",1)
                 LET l_gez[i].* = l_gez_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
 
        AFTER ROW
           LET i = ARR_CURR()
           #LET i_t = i  #FUN-D40030     
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET l_gez[i].* = l_gez_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL l_gez.deleteElement(i)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET i = i_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i602_2_bcl 
              ROLLBACK WORK   
              EXIT INPUT
           END IF
           LET i_t = i  #FUN-D40030     
           CLOSE i602_2_bcl  
           COMMIT WORK
 
        ON ACTION CONTROLR
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
 
    CLOSE i602_2_bcl
    COMMIT WORK
  # CLOSE WINDOW i602_2_w      #TQC-AB0108
END FUNCTION
 
#TQC-AB0108 ----------------------Begin-------------------------
FUNCTION i602_2_bp(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1

   IF p_cmd <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY l_gez TO s_gez.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         LET INT_FLAG = 1
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET i = ARR_CURR()
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET i = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY

        ON ACTION about
           CALL cl_about()

        ON ACTION help
           CALL cl_show_help()

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#TQC-AB0108 ----------------------End---------------------------
FUNCTION i602_cond_dispatch(p_cond)
  DEFINE p_cond              LIKE type_file.chr1000
  DEFINE l_i                 LIKE type_file.num5
  DEFINE conditions_total    base.StringTokenizer
  DEFINE sub_conditions      STRING
  DEFINE l_p1                LIKE type_file.num5
  DEFINE l_p2                LIKE type_file.num5
  DEFINE l_p3                LIKE type_file.num5
  
    IF p_cond IS NULL  THEN RETURN END IF
    IF p_cond = " 1=1" THEN RETURN END IF
    
    #p_cond   ima01+1+a;b;c)ima06+3+01
    CALL g_cond.clear()
    LET l_i = 1
 
    LET conditions_total = base.StringTokenizer.create(p_cond, ")")             
    WHILE conditions_total.hasMoreTokens()                                               
       #sub conditions = ima01+1+3+a;b;c
       LET sub_conditions = conditions_total.nextToken()   
       LET l_p1=sub_conditions.getIndexOf("+",1)
       LET l_p2=sub_conditions.getIndexOf("+",l_p1+1)
       LET l_p3=sub_conditions.getIndexOf("+",l_p2+1)
       LET g_cond[l_i].field_no = sub_conditions.subString(1,l_p1-1)
       SELECT gaq03 INTO g_cond[l_i].field_name
         FROM gaq_file
        WHERE gaq01 = g_cond[l_i].field_no
          AND gaq02 = g_lang
       LET g_cond[l_i].condition= sub_conditions.subString(l_p1+1,l_p2-1)
       LET g_cond[l_i].data_type= sub_conditions.subString(l_p2+1,l_p3-1)
       LET g_cond[l_i].value    = sub_conditions.subString(l_p3+1,sub_conditions.getLength())
       LET l_i = l_i + 1
    END WHILE
    LET l_i = l_i - 1
    RETURN l_i
END FUNCTION
 
FUNCTION i602_check_field(p_field,p_table)
DEFINE p_field       STRING
DEFINE p_table       STRING
DEFINE l_str         STRING
DEFINE ls_sql        STRING
DEFINE l_status      LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_tok         base.StringTokenizer
DEFINE l_type1       LIKE type_file.chr50
DEFINE l_type        STRING
DEFINE l_data_type   LIKE type_file.chr50
DEFINE l_data_length LIKE type_file.chr8         #FUN-A90024
DEFINE l_sch01       LIKE sch_file.sch01         #FUN-A90024
DEFINE l_sch02       LIKE sch_file.sch01         #FUN-A90024
 
   LET l_type = NULL
   LET l_type1= NULL

   #---FUN-A90024---start-----
   #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
   #目前統一用sch_file紀錄TIPTOP資料結構  
   #CASE g_db_type  
   #    WHEN "IFX" 
   #         LET ls_sql =
   #             "SELECT coltype",
   #             " FROM syscolumns c,systables t",
   #             " WHERE c.tabid=t.tabid AND t.tabname='",p_table,"'",
   #             "   AND c.colname='",p_field,"'"
   #    WHEN "ORA"   
   #         LET ls_sql =
   #             "SELECT DATA_TYPE FROM user_tab_columns",
   #             " WHERE lower(table_name)='",p_table,"'",
   #             "   AND lower(column_name)='",p_field,"'"
   ##     WHEN "MSV"
   ##          LET ls_sql =
   ##              "SELECT COUNT(*) FROM sys.objects a,sys.columns b",
   ##             " WHERE a.object_id = b.object_id ",
   ##              "   AND a.name='",p_table CLIPPED,"'",
   ##             "   AND b.name='",p_field,"'"
   #END CASE                                                   #FUN-750084
   #PREPARE i602_pre1 FROM ls_sql
   #DECLARE i602_sys1 CURSOR FOR i602_pre1
   #OPEN i602_sys1
   #FETCH i602_sys1 INTO l_type1
   LET l_sch01 = p_table
   LET l_sch02 = p_field
   SELECT COUNT(*) INTO l_cnt FROM sch_file 
     WHERE sch01 = l_sch01 AND sch02 = l_sch02
   IF l_cnt = 0 THEN
      LET l_type = ''
   ELSE
      CALL cl_get_column_info('ds', p_table, p_field) 
          RETURNING l_type1, l_data_length
   END IF
   #---FUN-A90024---end-------  
   LET l_type = l_type1 CLIPPED
   LET l_type = l_type.trim()
   IF cl_null(l_type) THEN
      LET l_str= p_table,"+",p_field
      CALL cl_err(l_str,NOTFOUND,0)
      RETURN 0,NULL
   ELSE
      #---FUN-A90024---start-----
      #CASE g_db_type  
      #    WHEN "IFX" 
      #         CASE l_type
      #              WHEN '0'         LET l_data_type = '1'
      #              WHEN '13'        LET l_data_type = '1'
      #              WHEN '7'         LET l_data_type = '3'
      #              OTHERWISE        LET l_data_type = '2'
      #         END CASE
      #    WHEN "ORA" 
      #         CASE l_type
      #              WHEN 'VARCHAR2'              LET l_data_type = '1'
      #              WHEN 'VARCHAR'               LET l_data_type = '1'
      #              WHEN 'DATE'                  LET l_data_type = '3'
      #              OTHERWISE                    LET l_data_type = '2'
      #         END CASE
      #END CASE 
      CASE l_type
           WHEN 'char'                  LET l_data_type = '1'
           WHEN 'varchar2'              LET l_data_type = '1'
           WHEN 'varchar'               LET l_data_type = '1'
           WHEN 'nvarchar'              LET l_data_type = '1'
           WHEN 'nvarchar2'             LET l_data_type = '1'
           WHEN 'date'                  LET l_data_type = '3'
           OTHERWISE                    LET l_data_type = '2'
      END CASE
      #---FUN-A90024---end-------  
   END IF
   RETURN 1,l_data_type
END FUNCTION
#No.FUN-980017--begin
FUNCTION i602_sel()
    DEFINE p_row,p_col   LIKE type_file.num5,
           p_cmd         LIKE type_file.chr1,
           tm            RECORD        
             sel         LIKE type_file.chr1,
             azt01       LIKE azt_file.azt01
           END RECORD,
           l_sql         STRING,
           l_n           LIKE type_file.num5,
           l_n1          LIKE type_file.num5,   #No.FUN-980025
           l_azw06       LIKE azw_file.azw06,   #No.FUN-980025
           l_gew04       LIKE gew_file.gew04,   #No.FUN-980025
           l_azw01       LIKE azw_file.azw01

           
   LET p_row = 2   LET p_col = 30
 
    CREATE TEMP TABLE temp_out(
     temp_azw01  LIKE azw_file.azw01,
     temp_azw06  LIKE azw_file.azw06) 

   OPEN WINDOW i602_3_w AT p_row,p_col WITH FORM "aoo/42f/aooi602_3"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("aooi602_3")
 
   LET tm.sel ='N'
   DISPLAY BY NAME tm.sel 
   CALL cl_set_comp_entry("azt01",FALSE)
   INPUT BY NAME tm.sel,tm.azt01 WITHOUT DEFAULTS
   
         ON CHANGE sel
            CALL cl_set_comp_entry("azt01",TRUE)
            IF tm.sel='N' THEN 
                CALL cl_set_comp_entry("azt01",FALSE)
            END IF 
            
         AFTER FIELD sel
            IF cl_null(tm.sel) THEN
               NEXT FIELD sel
            ELSE
            	 IF tm.sel='Y' THEN 
            	    CALL cl_set_comp_entry("azt01",TRUE)
            	 END IF 
            END IF
 
         AFTER FIELD azt01 
            IF NOT cl_null(tm.azt01) THEN 
               SELECT COUNT(*) INTO l_n FROM azt_file
                WHERE azt01=tm.azt01
               IF l_n=0 THEN 
                  CALL cl_err('','aoo-416',1)
                  NEXT FIELD azt01 
               END IF  
            END IF 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about        
             CALL cl_about()     
  
          ON ACTION controlg    
             CALL cl_cmdask()   
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
         ON ACTION controlp 
            CASE
               WHEN INFIELD(azt01)        
                    CALL cl_init_qry_var()
                    LET g_qryparam.form  = "q_azt01"
                    LET g_qryparam.default1 =tm.azt01 
                    CALL cl_create_qry() RETURNING tm.azt01
                    DISPLAY BY NAME tm.azt01
                    NEXT FIELD azt01
            END CASE 
      END INPUT   
      IF INT_FLAG THEN
         LET INT_FLAG = 0
      END IF
      LET g_azt01=tm.azt01 
      IF NOT cl_null(tm.azt01) THEN 
         LET l_sql=" SELECT azw01 FROM azw_file WHERE azw02='",tm.azt01,"' "
        PREPARE i602_prepare1 FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('prepare:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM
        END IF
        DECLARE i602_cs1 CURSOR FOR i602_prepare1
        FOREACH i602_cs1 INTO l_azw01
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
  ##NO.FUN-980025 GP5.2 add--begin	
            SELECT azw06 INTO l_azw06  FROM azw_file 
             WHERE  azw02 = tm.azt01
               AND  azw01 = l_azw01    

        INSERT INTO temp_out (temp_azw01,temp_azw06)  VALUES (l_azw01,l_azw06) 
     
        SELECT COUNT(*) INTO l_n  FROM temp_out  WHERE temp_azw06 = l_azw06 
          IF  l_n > 1 THEN 
            CONTINUE FOREACH 
          END IF     
  ##NO.FUN-980025 GP5.2 add--end
  ##NO.FUN-9A0092  add--begin 
        SELECT azw06 INTO l_azw06 FROM azw_file 
         WHERE azw01 = l_azw01
        #No.MOD-A80028  --Begin
        #  CALL i602_check(p_cmd,l_azw06)  
        #  IF NOT cl_null(g_errno) THEN
#       #       CALL cl_err_msg(NULL,g_errno,g_str,1)
        #     CONTINUE FOREACH
        #  END IF
        #No.MOD-A80028  --End  
  ##NO.FUN-9A0092  add--end
#       INSERT INTO gew_file(gew01,gew02,gew03,gew04) VALUES(g_gew01,g_gew02,g_gew03,l_azw01)
        INSERT INTO gew_file(gew01,gew02,gew03,gew04,gew05,gew06,gew07) 
                     VALUES(g_gew01,g_gew02,g_gew03,l_azw01,'1=1','Y','Y')
        IF SQLCA.sqlcode THEN                   
            CALL cl_err3("ins","gew_file",l_azw01,"",SQLCA.sqlcode,"","",1)    #FUN-B80035  ADD
            ROLLBACK WORK
         #  CALL cl_err3("ins","gew_file",l_azw01,"",SQLCA.sqlcode,"","",1)    #FUN-B80035  MARK
           EXIT FOREACH
        END IF
        END FOREACH
        DROP TABLE temp_out 
      END IF 
      
#    DROP TABLE tepm_out
     CLOSE WINDOW i602_3_w
END FUNCTION 
#No.FUN-980017--end  
             
#No.MOD-A80028  --Begin
# ##NO.FUN-9A0092  add--begin                 
#FUNCTION i602_check(p_cmd,p_azw06)
# DEFINE p_cmd   LIKE type_file.chr1
# DEFINE l_n     LIKE type_file.num5
# DEFINE p_azw06 LIKE azw_file.azw06            #No.FUN-9A0092 
#   LET g_errno = ''
#  select count( *) INTO l_n FROM azw_file 
#   WHERE azw05 = azw06 
#     AND azw06 = p_azw06
#   IF l_n = 0 THEN 
#         CASE 
#           WHEN g_gew02 = '1' 
#              select count( *) INTO l_n FROM  azy_file 
#               WHERE azy01 = p_azw06
#                 AND azy02 IN ('ima_file','smd_file','imc_file','imaicd_file','gca_file','gcb_file','imab_file')
#               IF  l_n >= 0 AND l_n < 7 THEN
#                 CALL i602_check1(p_cmd,p_azw06)
#                 LET g_errno = 'aoo-119'
#               END IF 
#           WHEN g_gew02 = '2' 
#              select count( *) INTO l_n FROM  azy_file 
#               WHERE azy01 = p_azw06
#                 AND azy02 IN ('bma_file','bmc_file','bmb_file','bmd_file','bmt_file','bml_file','boa_file','bob_file')
#               IF l_n >=0 AND l_n < 8 THEN
#                 CALL i602_check2(p_cmd,p_azw06)
#                 LET g_errno = 'aoo-119'
#               END IF 
##          WHEN g_gew02 = '3' 
##             select count( *) INTO l_n FROM  azy_file 
##              WHERE azy01 = p_azw06 
##                AND azy02 IN ('bmx_file','bmz_file','bmy_file','bmg_file','bmw_file','bmf_file')
##              IF l_n>=0 AND l_n < 6 THEN
##                CALL i602_check3(p_cmd,p_azw06)
##                LET g_errno = 'aoo-119'
##              END IF  
#           WHEN g_gew02 = '4' 
#              select count( *) INTO l_n FROM  azy_file 
#               WHERE azy01 = p_azw06 
#               AND azy02 IN ('occ_file','occg_file','ocd_file','oce_file','oci_file','ocj_file','tql_file','tqk_file','pov_file','tqo_file','tqm_file','tqn_file')
#               IF l_n >= 0 AND l_n < 12 THEN
#                 CALL i602_check4(p_cmd,p_azw06)
#                 LET g_errno = 'aoo-119'               
#               END IF       
#           WHEN g_gew02 = '5' 
#              select count( *) INTO l_n FROM  azy_file 
#               WHERE azy01 = p_azw06
#                 AND azy02 IN ('pmc_file','pnp_file','pmf_file','pov_file','pmg_file','pmd_file')
#               IF l_n>=0 AND l_n < 6 THEN
#                 CALL i602_check5(p_cmd,p_azw06)
#                 LET g_errno = 'aoo-119'
#               END IF      
#           WHEN g_gew02 = '6' 
#              select count( *) INTO l_n FROM  azy_file 
#               WHERE azy01 = p_azw06 
#                 AND azy02 IN ('giu_file')
#               IF l_n >= 0 AND l_n < 1 THEN
#                 CALL i602_check6(p_cmd,p_azw06)
#                 LET g_errno = 'aoo-119'
#               END IF                                                                                       
#           WHEN g_gew02 = '7' 
#              select count( *) INTO l_n FROM  azy_file 
#               WHERE azy01 = p_azw06 
#                 AND azy02 IN ('tqm_file','tqn_file')
#               CALL i602_check7(p_cmd,p_azw06)  
#               IF l_n >= 0 AND l_n < 2 THEN
#                 CALL i602_check7(p_cmd,p_azw06)
#                 LET g_errno = 'aoo-119'
#               END IF
#         END CASE       
#   END IF        
#END FUNCTION  
#
#FUNCTION i602_check1(p_cmd,p_azw06)
# DEFINE p_cmd   LIKE type_file.chr1
# DEFINE p_azw06 LIKE azw_file.azw06            #No.FUN-9A0092 
# DEFINE l_azy02 LIKE azy_file.azy02
# DEFINE l_str   string
# DEFINE l_str1  string 
# DEFINE l_str2  string
# DEFINE l_str3  string
# DEFINE l_str4  string
# DEFINE l_str5  string
# DEFINE l_str6  string
# DEFINE l_str7  string
# DEFINE l_str8  string   
# DEFINE l_str9  LIKE type_file.chr1000
# 
#  LET g_sql = "SELECT azy02 ",
#              " FROM  azy_file ", 
#              " WHERE azy01 = '",p_azw06, "'",
#              "   AND azy02 IN ('ima_file','smd_file','imc_file','imaicd_file','gca_file','gcb_file','imab_file') "
#    
#    PREPARE i602_p1 FROM g_sql 
#    DECLARE i602_co CURSOR FOR i602_p1         
#    LET l_str  = ' '  
#    LET l_str1 = 'ima_file' 
#    LET l_str2 = 'smd_file'  
#    LET l_str3 = 'imc_file'  
#    LET l_str4 = 'imaicd_file'  
#    LET l_str5 = 'gca_file'  
#    LET l_str6 = 'gcb_file'  
#    LET l_str7 = 'imab_file' 
#    FOREACH i602_co INTO  l_azy02
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#
#      IF l_azy02 = 'ima_file' THEN   
#        LET l_str1 = ''
#      END IF 
#      IF l_azy02 = 'smd_file' THEN   
#        LET l_str2 = ''
#      END IF 
#      IF l_azy02 = 'imc_file' THEN   
#        LET l_str3 = ''
#      END IF 
#      IF l_azy02 = 'imaicd_file' THEN   
#        LET l_str4 = ''
#      END IF
#      IF l_azy02 = 'gca_file' THEN   
#        LET l_str5 = ''
#      END IF
#      IF l_azy02 = 'gcb_file' THEN   
#        LET l_str6 = ''
#      END IF
#      IF l_azy02 = 'imab_file' THEN   
#        LET l_str7 = ''
#      END IF                
#    END FOREACH
#    IF l_str1 IS NOT NULL THEN LET l_str = l_str,",",l_str1 END IF 
#    IF l_str2 IS NOT NULL THEN LET l_str = l_str,",",l_str2 END IF 
#    IF l_str3 IS NOT NULL THEN LET l_str = l_str,",",l_str3 END IF 
#    IF l_str4 IS NOT NULL THEN LET l_str = l_str,",",l_str4 END IF 
#    IF l_str5 IS NOT NULL THEN LET l_str = l_str,",",l_str5 END IF  
#    IF l_str6 IS NOT NULL THEN LET l_str = l_str,",",l_str6 END IF 
#    IF l_str7 IS NOT NULL THEN LET l_str = l_str,",",l_str7 END IF
#    LET l_str9 = l_str.trim() 
#    LET g_str = l_str9[2,Length(l_str9)]
#END FUNCTION 
#
#FUNCTION i602_check2(p_cmd,p_azw06)
# DEFINE p_cmd   LIKE type_file.chr1
# DEFINE p_azw06 LIKE azw_file.azw06            #No.FUN-9A0092 
# DEFINE l_azy02 LIKE azy_file.azy02
# DEFINE l_str   string
# DEFINE l_str1  string 
# DEFINE l_str2  string
# DEFINE l_str3  string
# DEFINE l_str4  string
# DEFINE l_str5  string
# DEFINE l_str6  string
# DEFINE l_str7  string
# DEFINE l_str8  string   
# DEFINE l_str9  LIKE type_file.chr1000
# 
#  LET g_sql = "SELECT azy02 ",
#              " FROM  azy_file ", 
#              " WHERE azy01 = '",p_azw06, "'",
#              "   AND azy02 IN ('bma_file','bmc_file','bmb_file','bmd_file','bmt_file','bml_file','boa_file','bob_file') "
#    
#    PREPARE i602_q2 FROM g_sql 
#    DECLARE i602_co1 CURSOR FOR i602_q2         
#    LET l_str  = ' '  
#    LET l_str1 = 'bma_file' 
#    LET l_str2 = 'bmc_file'  
#    LET l_str3 = 'bmb_file'  
#    LET l_str4 = 'bmd_file'  
#    LET l_str5 = 'bmt_file'  
#    LET l_str6 = 'bml_file'  
#    LET l_str7 = 'boa_file'
#    LET l_str8 = 'bob_file' 
#    FOREACH i602_co INTO  l_azy02
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#
#      IF l_azy02 = 'bma_file' THEN   
#        LET l_str1 = ''
#      END IF 
#      IF l_azy02 = 'bmc_file' THEN   
#        LET l_str2 = ''
#      END IF 
#      IF l_azy02 = 'bmb_file' THEN   
#        LET l_str3 = ''
#      END IF 
#      IF l_azy02 = 'bmd_file' THEN   
#        LET l_str4 = ''
#      END IF
#      IF l_azy02 = 'bmt_file' THEN   
#        LET l_str5 = ''
#      END IF
#      IF l_azy02 = 'bml_file' THEN   
#        LET l_str6 = ''
#      END IF
#      IF l_azy02 = 'boa_file' THEN   
#        LET l_str7 = ''
#      END IF
#      IF l_azy02 = 'bob_file' THEN   
#        LET l_str8 = ''
#      END IF                      
#    END FOREACH
#    IF l_str1 IS NOT NULL THEN LET l_str = l_str,",",l_str1 END IF 
#    IF l_str2 IS NOT NULL THEN LET l_str = l_str,",",l_str2 END IF 
#    IF l_str3 IS NOT NULL THEN LET l_str = l_str,",",l_str3 END IF 
#    IF l_str4 IS NOT NULL THEN LET l_str = l_str,",",l_str4 END IF 
#    IF l_str5 IS NOT NULL THEN LET l_str = l_str,",",l_str5 END IF  
#    IF l_str6 IS NOT NULL THEN LET l_str = l_str,",",l_str6 END IF 
#    IF l_str7 IS NOT NULL THEN LET l_str = l_str,",",l_str7 END IF
#    IF l_str8 IS NOT NULL THEN LET l_str = l_str,",",l_str8 END IF      
#    LET l_str9 = l_str.trim() 
#    LET g_str = l_str9[2,Length(l_str9)]
#END FUNCTION 
#
#FUNCTION i602_check3(p_cmd,p_azw06)
# DEFINE p_cmd   LIKE type_file.chr1
# DEFINE p_azw06 LIKE azw_file.azw06            #No.FUN-9A0092 
# DEFINE l_azy02 LIKE azy_file.azy02
# DEFINE l_str   string
# DEFINE l_str1  string 
# DEFINE l_str2  string
# DEFINE l_str3  string
# DEFINE l_str4  string
# DEFINE l_str5  string
# DEFINE l_str6  string
# DEFINE l_str7  string
# DEFINE l_str8  string   
# DEFINE l_str9  LIKE type_file.chr1000
# 
#  LET g_sql = "SELECT azy02 ",
#              " FROM  azy_file ", 
#              " WHERE azy01 = '",p_azw06, "'",
#              "   AND azy02 IN ('bmx_file','bmz_file','bmy_file','bmg_file','bmw_file','bmf_file') "
#    
#    PREPARE i602_p3 FROM g_sql 
#    DECLARE i602_co2 CURSOR FOR i602_p3         
#    LET l_str  = ' '  
#    LET l_str1 = 'bmx_file' 
#    LET l_str2 = 'bmz_file'  
#    LET l_str3 = 'bmy_file'  
#    LET l_str4 = 'bmg_file'  
#    LET l_str5 = 'bmw_file'  
#    LET l_str6 = 'bmf_file'
#    FOREACH i602_co INTO  l_azy02
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#
#      IF l_azy02 = 'bmx_file' THEN   
#        LET l_str1 = ''
#      END IF 
#      IF l_azy02 = 'bmz_file' THEN   
#        LET l_str2 = ''
#      END IF 
#      IF l_azy02 = 'bmy_file' THEN   
#        LET l_str3 = ''
#      END IF 
#      IF l_azy02 = 'bmg_file' THEN   
#        LET l_str4 = ''
#      END IF
#      IF l_azy02 = 'bmw_file' THEN   
#        LET l_str5 = ''
#      END IF
#      IF l_azy02 = 'bmf_file' THEN   
#        LET l_str6 = ''
#      END IF                     
#    END FOREACH
#    IF l_str1 IS NOT NULL THEN LET l_str = l_str,",",l_str1 END IF 
#    IF l_str2 IS NOT NULL THEN LET l_str = l_str,",",l_str2 END IF 
#    IF l_str3 IS NOT NULL THEN LET l_str = l_str,",",l_str3 END IF 
#    IF l_str4 IS NOT NULL THEN LET l_str = l_str,",",l_str4 END IF 
#    IF l_str5 IS NOT NULL THEN LET l_str = l_str,",",l_str5 END IF  
#    IF l_str6 IS NOT NULL THEN LET l_str = l_str,",",l_str6 END IF     
#    LET l_str9 = l_str.trim() 
#    LET g_str = l_str9[2,Length(l_str9)]
#END FUNCTION 
#
#FUNCTION i602_check4(p_cmd,p_azw06)
# DEFINE p_cmd   LIKE type_file.chr1
# DEFINE p_azw06 LIKE azw_file.azw06            #No.FUN-9A0092 
# DEFINE l_azy02 LIKE azy_file.azy02
# DEFINE l_str   string
# DEFINE l_str1  string 
# DEFINE l_str2  string
# DEFINE l_str3  string
# DEFINE l_str4  string
# DEFINE l_str5  string
# DEFINE l_str6  string
# DEFINE l_str7  string
# DEFINE l_str8  string 
# DEFINE l_str9  string 
# DEFINE l_str10 string
# DEFINE l_str11 string
# DEFINE l_str12 string   
# DEFINE l_str13 LIKE type_file.chr1000
# 
#  LET g_sql = "SELECT azy02 ",
#              " FROM  azy_file ", 
#              " WHERE azy01 = '",p_azw06, "'",
#              "   AND azy02 IN ('occ_file','occg_file','ocd_file','oce_file','oci_file','ocj_file','tql_file','tqk_file','pov_file','tqo_file','tqm_file','tqn_file') "
#    
#    PREPARE i602_p4 FROM g_sql 
#    DECLARE i602_co3 CURSOR FOR i602_p4         
#    LET l_str  = ' '  
#    LET l_str1 = 'occ_file' 
#    LET l_str2 = 'occg_file'  
#    LET l_str3 = 'ocd_file'  
#    LET l_str4 = 'oce_file'  
#    LET l_str5 = 'oci_file'  
#    LET l_str6 = 'ocj_file'
#    LET l_str7 = 'tql_file'
#    LET l_str8 = 'tqk_file'
#    LET l_str9 = 'pov_file'
#    LET l_str10 = 'tqo_file'
#    LET l_str11 = 'tqm_file'
#    LET l_str12 = 'tqn_file'
#    FOREACH i602_co INTO  l_azy02
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#
#      IF l_azy02 = 'occ_file' THEN   
#        LET l_str1 = ''
#      END IF 
#      IF l_azy02 = 'occg_file' THEN   
#        LET l_str2 = ''
#      END IF 
#      IF l_azy02 = 'ocd_file' THEN   
#        LET l_str3 = ''
#      END IF 
#      IF l_azy02 = 'oce_file' THEN   
#        LET l_str4 = ''
#      END IF
#      IF l_azy02 = 'oci_file' THEN   
#        LET l_str5 = ''
#      END IF
#      IF l_azy02 = 'ocj_file' THEN   
#        LET l_str6 = ''
#      END IF
#      IF l_azy02 = 'tql_file' THEN   
#        LET l_str7 = ''
#      END IF
#      IF l_azy02 = 'tqk_file' THEN   
#        LET l_str8 = ''
#      END IF  
#      IF l_azy02 = 'pov_file' THEN   
#        LET l_str9 = ''
#      END IF
#      IF l_azy02 = 'tqo_file' THEN   
#        LET l_str10 = ''
#      END IF
#      IF l_azy02 = 'tqm_file' THEN   
#        LET l_str11 = ''
#      END IF
#      IF l_azy02 = 'tqn_file' THEN   
#        LET l_str12 = ''
#      END IF                         
#    END FOREACH
#    IF l_str1 IS NOT NULL THEN LET l_str = l_str,",",l_str1 END IF 
#    IF l_str2 IS NOT NULL THEN LET l_str = l_str,",",l_str2 END IF 
#    IF l_str3 IS NOT NULL THEN LET l_str = l_str,",",l_str3 END IF 
#    IF l_str4 IS NOT NULL THEN LET l_str = l_str,",",l_str4 END IF 
#    IF l_str5 IS NOT NULL THEN LET l_str = l_str,",",l_str5 END IF  
#    IF l_str6 IS NOT NULL THEN LET l_str = l_str,",",l_str6 END IF
#    IF l_str7 IS NOT NULL THEN LET l_str = l_str,",",l_str7 END IF 
#    IF l_str8 IS NOT NULL THEN LET l_str = l_str,",",l_str8 END IF
#    IF l_str9 IS NOT NULL THEN LET l_str = l_str,",",l_str9 END IF 
#    IF l_str10 IS NOT NULL THEN LET l_str = l_str,",",l_str10 END IF 
#    IF l_str11 IS NOT NULL THEN LET l_str = l_str,",",l_str11 END IF
#    IF l_str12 IS NOT NULL THEN LET l_str = l_str,",",l_str12 END IF            
#    LET l_str13 = l_str.trim() 
#    LET g_str = l_str13[2,Length(l_str13)]
#END FUNCTION 
#
#FUNCTION i602_check5(p_cmd,p_azw06)
# DEFINE p_cmd   LIKE type_file.chr1
# DEFINE p_azw06 LIKE azw_file.azw06            #No.FUN-9A0092 
# DEFINE l_azy02 LIKE azy_file.azy02
# DEFINE l_str   string
# DEFINE l_str1  string 
# DEFINE l_str2  string
# DEFINE l_str3  string
# DEFINE l_str4  string
# DEFINE l_str5  string
# DEFINE l_str6  string
# DEFINE l_str7  LIKE type_file.chr1000
# 
#  LET g_sql = "SELECT azy02 ",
#              " FROM  azy_file ", 
#              " WHERE azy01 = '",p_azw06, "'",
#              "   AND azy02 IN ('pmc_file','pnp_file','pmf_file','pov_file','pmg_file','pmd_file') "
#    
#    PREPARE i602_p5 FROM g_sql 
#    DECLARE i602_co4 CURSOR FOR i602_p5         
#    LET l_str  = ' '  
#    LET l_str1 = 'pmc_file' 
#    LET l_str2 = 'pnp_file'  
#    LET l_str3 = 'pmf_file'  
#    LET l_str4 = 'pov_file'  
#    LET l_str5 = 'pmg_file'  
#    LET l_str6 = 'pmd_file'
#    FOREACH i602_co INTO  l_azy02
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#
#      IF l_azy02 = 'pmc_file' THEN   
#        LET l_str1 = ''
#      END IF 
#      IF l_azy02 = 'pmp_file' THEN   
#        LET l_str2 = ''
#      END IF 
#      IF l_azy02 = 'pmf_file' THEN   
#        LET l_str3 = ''
#      END IF 
#      IF l_azy02 = 'pov_file' THEN   
#        LET l_str4 = ''
#      END IF
#      IF l_azy02 = 'pmg_file' THEN   
#        LET l_str5 = ''
#      END IF
#      IF l_azy02 = 'pmd_file' THEN   
#        LET l_str6 = ''
#      END IF              
#    END FOREACH
#    IF l_str1 IS NOT NULL THEN LET l_str = l_str,",",l_str1 END IF 
#    IF l_str2 IS NOT NULL THEN LET l_str = l_str,",",l_str2 END IF 
#    IF l_str3 IS NOT NULL THEN LET l_str = l_str,",",l_str3 END IF 
#    IF l_str4 IS NOT NULL THEN LET l_str = l_str,",",l_str4 END IF 
#    IF l_str5 IS NOT NULL THEN LET l_str = l_str,",",l_str5 END IF  
#    IF l_str6 IS NOT NULL THEN LET l_str = l_str,",",l_str6 END IF          
#    LET l_str7 = l_str.trim() 
#    LET g_str = l_str7[2,Length(l_str7)]
#END FUNCTION 
#
#
#FUNCTION i602_check6(p_cmd,p_azw06)
# DEFINE p_cmd   LIKE type_file.chr1
# DEFINE p_azw06 LIKE azw_file.azw06            #No.FUN-9A0092 
# DEFINE l_azy02 LIKE azy_file.azy02
# DEFINE l_str   string
# DEFINE l_str1  string 
# DEFINE l_str2  LIKE type_file.chr1000
# 
#  LET g_sql = "SELECT azy02 ",
#              " FROM  azy_file ", 
#              " WHERE azy01 = '",p_azw06, "'",
#              "   AND azy02 IN ('giu_file') "
#    
#    PREPARE i602_p6 FROM g_sql 
#    DECLARE i602_co5 CURSOR FOR i602_p6         
#    LET l_str  = ' '  
#    LET l_str1 = 'giu_file'
#    FOREACH i602_co INTO  l_azy02
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#
#      IF l_azy02 = 'giu_file' THEN   
#        LET l_str1 = ''
#      END IF  
#    END FOREACH
#    IF l_str1 IS NOT NULL THEN LET l_str = l_str,",",l_str1 END IF         
#    LET l_str2 = l_str.trim() 
#    LET g_str = l_str2[2,Length(l_str2)]
#END FUNCTION
#
#FUNCTION i602_check7(p_cmd,p_azw06)
# DEFINE p_cmd   LIKE type_file.chr1
# DEFINE p_azw06 LIKE azw_file.azw06            #No.FUN-9A0092 
# DEFINE l_azy02 LIKE azy_file.azy02
# DEFINE l_str   string
# DEFINE l_str1  string
# DEFINE l_str2  string 
# DEFINE l_str3  LIKE type_file.chr1000
# 
#  LET g_sql = "SELECT azy02 ",
#              " FROM  azy_file ", 
#              " WHERE azy01 = '",p_azw06, "'",
#              "   AND azy02 IN ('tqm_file','tqn_file') "
#    
#    PREPARE i602_p7 FROM g_sql 
#    DECLARE i602_co6 CURSOR FOR i602_p7         
#    LET l_str  = ' '  
#    LET l_str1 = 'giu_file'
#    FOREACH i602_co INTO  l_azy02
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#
#      IF l_azy02 = 'tqm_file' THEN   
#        LET l_str1 = ''
#      END IF 
#      IF l_azy02 = 'tqn_file' THEN   
#        LET l_str1 = ''
#      END IF         
#    END FOREACH
#    IF l_str1 IS NOT NULL THEN LET l_str = l_str,",",l_str1 END IF
#    IF l_str2 IS NOT NULL THEN LET l_str = l_str,",",l_str2 END IF             
#    LET l_str3 = l_str.trim() 
#    LET g_str = l_str3[2,Length(l_str3)]
#END FUNCTION
#  ##NO.FUN-9A0092  add--end     
#No.MOD-A80028  --End  
