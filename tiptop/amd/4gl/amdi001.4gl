# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: amdi001.4gl
# Descriptions...: 申報稅籍資料維護作業
# Date & Author..: 96/11/12 By Apple
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0007 04/11/01 By Yuna 加轉excel檔功能
# Modify.........: No.MOD-510007 05/01/05 By Kitty B單身會出現OPEN i001_bcl錯誤
# Modify.........: No.FUN-510019 05/02/14 By Smapmin 報表轉XML格式
# Modify         : No.MOD-530869 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: No.FUN-570108 05/07/13 By vivien KEY值更改控制   
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No.FUN-680074 06/08/23 By huchenghao 類型轉換 
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-690020 05/11/01 By Nicola 加ama13,ama14,ama15二個欄位
# Modify.........: No.MOD-6B0142 06/11/27 By Smapmin INSERT INTO ama_file有誤
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: NO.FUN-850045 08/05/09 By zhaijie 老報表修改為CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.MOD-960052 09/06/09 By baofei Mark DISPLAY l_ac TO FORMONLY.cn3
# Modify.........: No.FUN-950013 09/06/24 By hongmei增加ama16,ama17,ama18,ama19,ama20欄位 
# Modify.........: No.MOD-980072 09/08/12 By mike 當ama16='1'時,應一并清空ama20
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990047 09/09/11 By Carrier ama10 非負控管
# Modify.........: NO.FUN-980024 09/10/29 BY yiting add ama21,ama22
# Modify.........: No:FUN-990034 09/10/29 By yiting 國稅局0909新版 線上離線建檔基本資料己將身份證編號改為"非必輸" 
# Modify.........: No:FUN-990021 09/10/30 By yiting  add ama24,當ama15為總公司彙總報繳時，才能維護 ama24
# Modify.........: No:FUN-980090 09/10/30 By yiting add ama23,總機構統編
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No.FUN-B40054 11/04/25 By zhangweib 增加功能鍵"進項稅額分攤"、"國外勞務"
# Modify.........: No.FUN-BA0021 11/10/21 By Belle  將"進項稅額分攤"、"國外勞務"修改為獨立執行
# Modify.........: No.FUN-C70030 12/07/10 By pauline 新增電子發票相關欄位
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ama        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                       ama01   LIKE ama_file.ama01,   
                       ama02   LIKE ama_file.ama02,  
                       ama11   LIKE ama_file.ama11, 
                       ama03   LIKE ama_file.ama03, 
                       ama04   LIKE ama_file.ama04, 
                       ama05   LIKE ama_file.ama05, 
                       ama07   LIKE ama_file.ama07, 
                       ama13   LIKE ama_file.ama13,   #No:FUN-690020
                       ama14   LIKE ama_file.ama14,   #No:FUN-690020
                       ama15   LIKE ama_file.ama15,   #No:FUN-690020
                       ama23   LIKE ama_file.ama23,   #FUN-980090
                       ama24   LIKE ama_file.ama24,   #FUN-990021
                       ama08   LIKE ama_file.ama08, 
                       ama09   LIKE ama_file.ama09, 
                       ama12   LIKE ama_file.ama12, 
                       ama10   LIKE ama_file.ama10, 
                       ama16   LIKE ama_file.ama16,   #FUN-950013 add
                       ama17   LIKE ama_file.ama17,   #FUN-950013 add
                       ama18   LIKE ama_file.ama18,   #FUN-950013 add
                       ama21   LIKE ama_file.ama21,   #FUN-980024 add
                       ama19   LIKE ama_file.ama19,   #FUN-950013 add
                       ama22   LIKE ama_file.ama22,   #FUN-980024 add
                       ama20   LIKE ama_file.ama20,   #FUN-950013 add
                       ama106  LIKE ama_file.ama106,  #FUN-C70030 add
                       ama107  LIKE ama_file.ama107,  #FUN-C70030 add
                       ama108  LIKE ama_file.ama108,  #FUN-C70030 add
                       amaacti LIKE ama_file.amaacti  #No:FUN-680074 CHAR(1)
                    END RECORD,
       g_ama_t      RECORD                 #程式變數 (舊值)
                       ama01   LIKE ama_file.ama01, 
                       ama02   LIKE ama_file.ama02,  
                       ama11   LIKE ama_file.ama11, 
                       ama03   LIKE ama_file.ama03,   
                       ama04   LIKE ama_file.ama04, 
                       ama05   LIKE ama_file.ama05, 
                       ama07   LIKE ama_file.ama07, 
                       ama13   LIKE ama_file.ama13,   #No:FUN-690020
                       ama14   LIKE ama_file.ama14,   #No:FUN-690020
                       ama15   LIKE ama_file.ama15,   #No:FUN-690020
                       ama23   LIKE ama_file.ama23,   #FUN-980090
                       ama24   LIKE ama_file.ama24,   #FUN-990021
                       ama08   LIKE ama_file.ama08, 
                       ama09   LIKE ama_file.ama09, 
                       ama12   LIKE ama_file.ama12, 
                       ama10   LIKE ama_file.ama10,
                       ama16   LIKE ama_file.ama16,   #FUN-950013 add
                       ama17   LIKE ama_file.ama17,   #FUN-950013 add
                       ama18   LIKE ama_file.ama18,   #FUN-950013 add
                       ama21   LIKE ama_file.ama21,   #FUN-980024 add
                       ama19   LIKE ama_file.ama19,   #FUN-950013 add
                       ama22   LIKE ama_file.ama22,   #FUN-980024 add
                       ama20   LIKE ama_file.ama20,   #FUN-950013 add 
                       ama106  LIKE ama_file.ama106,  #FUN-C70030 add
                       ama107  LIKE ama_file.ama107,  #FUN-C70030 add
                       ama108  LIKE ama_file.ama108,  #FUN-C70030 add
                       amaacti LIKE ama_file.amaacti   #No:FUN-680074 CHAR(1) 
                    END RECORD,
#FUN-BA0021--Begin--
#FUN-B40054--Add--Begin---
#       g_ama_1     RECORD 
#          ama25    LIKE type_file.num10,
#          ama26    LIKE type_file.num10,
#          ama27    LIKE type_file.num10,
#          ama28    LIKE type_file.num10,
#          ama29    LIKE type_file.num10,
#          ama30    LIKE type_file.num10,
#          ama31    LIKE type_file.num10,
#          ama32    LIKE type_file.num10,
#          ama33    LIKE type_file.num10,
#          ama34    LIKE type_file.num10,
#          ama35    LIKE type_file.num10,
#          ama36    LIKE type_file.num10,
#          ama37    LIKE type_file.num10,
#          ama38    LIKE type_file.num10,
#          ama39    LIKE type_file.num10,
#          ama40    LIKE type_file.num10,
#          ama41    LIKE type_file.num10,
#          ama42    LIKE type_file.num10,
#          ama43    LIKE type_file.num10,
#          ama44    LIKE type_file.num10,
#          ama45    LIKE type_file.num10,
#          ama46    LIKE type_file.num10,
#          ama47    LIKE type_file.num10,
#          ama48    LIKE type_file.num10,
#          ama49    LIKE type_file.num10,
#          ama50    LIKE type_file.num10,
#          ama51    LIKE type_file.num10,
#          ama52    LIKE type_file.num10,
#          ama53    LIKE type_file.num10,
#          ama54    LIKE type_file.num10,
#          ama55    LIKE type_file.num10,
#          ama56    LIKE type_file.num10,
#          ama57    LIKE type_file.num10,
#          ama58    LIKE type_file.num10,
#          ama59    LIKE type_file.num10,
#          ama60    LIKE type_file.num10,
#          ama61    LIKE type_file.num10,
#          ama62    LIKE type_file.num10,
#          ama63    LIKE type_file.num10,
#          ama64    LIKE type_file.num10,
#          ama65    LIKE type_file.num10,
#          ama66    LIKE type_file.num10,
#          ama67    LIKE type_file.num10,
#          ama68    LIKE type_file.num10,
#          ama69    LIKE type_file.num10,
#          ama70    LIKE type_file.num10,
#          ama71    LIKE type_file.num10,
#          ama72    LIKE type_file.num10,
#          ama73    LIKE type_file.num10,
#          ama74    LIKE type_file.num10,
#          ama75    LIKE type_file.num10,
#          ama76    LIKE type_file.num10,
#          ama77    LIKE type_file.num10,
#          ama78    LIKE type_file.num10,
#          ama79    LIKE type_file.num10,
#          ama80    LIKE type_file.num10,
#          ama81    LIKE type_file.num10,
#          ama82    LIKE type_file.num10,
#          ama83    LIKE type_file.num10,
#          ama84    LIKE type_file.num10,
#          ama85    LIKE type_file.num10,
#          ama86    LIKE type_file.num10,
#          ama87    LIKE type_file.num10,
#          ama88    LIKE type_file.num10,
#          ama89    LIKE type_file.num10,
#          ama90    LIKE type_file.num10,
#          ama91    LIKE type_file.num10,
#          ama92    LIKE type_file.num10,
#          ama93    LIKE type_file.num10,
#          ama94    LIKE type_file.num10,
#          ama95    LIKE type_file.num10,
#          ama96    LIKE type_file.num10,
#          ama97    LIKE type_file.num10,
#          ama98    LIKE type_file.num10
#                   END RECORD
#DEFINE g_ama_1_t   RECORD 
#          ama25    LIKE type_file.num10,
#          ama26    LIKE type_file.num10,
#          ama27    LIKE type_file.num10,
#          ama28    LIKE type_file.num10,
#          ama29    LIKE type_file.num10,
#          ama30    LIKE type_file.num10,
#          ama31    LIKE type_file.num10,
#          ama32    LIKE type_file.num10,
#          ama33    LIKE type_file.num10,
#          ama34    LIKE type_file.num10,
#          ama35    LIKE type_file.num10,
#          ama36    LIKE type_file.num10,
#          ama37    LIKE type_file.num10,
#          ama38    LIKE type_file.num10,
#          ama39    LIKE type_file.num10,
#          ama40    LIKE type_file.num10,
#          ama41    LIKE type_file.num10,
#          ama42    LIKE type_file.num10,
#          ama43    LIKE type_file.num10,
#          ama44    LIKE type_file.num10,
#          ama45    LIKE type_file.num10,
#          ama46    LIKE type_file.num10,
#          ama47    LIKE type_file.num10,
#          ama48    LIKE type_file.num10,
#          ama49    LIKE type_file.num10,
#          ama50    LIKE type_file.num10,
#          ama51    LIKE type_file.num10,
#          ama52    LIKE type_file.num10,
#          ama53    LIKE type_file.num10,
#          ama54    LIKE type_file.num10,
#          ama55    LIKE type_file.num10,
#          ama56    LIKE type_file.num10,
#          ama57    LIKE type_file.num10,
#          ama58    LIKE type_file.num10,
#          ama59    LIKE type_file.num10,
#          ama60    LIKE type_file.num10,
#          ama61    LIKE type_file.num10,
#          ama62    LIKE type_file.num10,
#          ama63    LIKE type_file.num10,
#          ama64    LIKE type_file.num10,
#          ama65    LIKE type_file.num10,
#          ama66    LIKE type_file.num10,
#          ama67    LIKE type_file.num10,
#          ama68    LIKE type_file.num10,
#          ama69    LIKE type_file.num10,
#          ama70    LIKE type_file.num10,
#          ama71    LIKE type_file.num10,
#          ama72    LIKE type_file.num10,
#          ama73    LIKE type_file.num10,
#          ama74    LIKE type_file.num10,
#          ama75    LIKE type_file.num10,
#          ama76    LIKE type_file.num10,
#          ama77    LIKE type_file.num10,
#          ama78    LIKE type_file.num10,
#          ama79    LIKE type_file.num10,
#          ama80    LIKE type_file.num10,
#          ama81    LIKE type_file.num10,
#          ama82    LIKE type_file.num10,
#          ama83    LIKE type_file.num10,
#          ama84    LIKE type_file.num10,
#          ama85    LIKE type_file.num10,
#          ama86    LIKE type_file.num10,
#          ama87    LIKE type_file.num10,
#          ama88    LIKE type_file.num10,
#          ama89    LIKE type_file.num10,
#          ama90    LIKE type_file.num10,
#          ama91    LIKE type_file.num10,
#          ama92    LIKE type_file.num10,
#          ama93    LIKE type_file.num10,
#          ama94    LIKE type_file.num10,
#          ama95    LIKE type_file.num10,
#          ama96    LIKE type_file.num10,
#          ama97    LIKE type_file.num10,
#          ama98    LIKE type_file.num10
#                   END RECORD
#DEFINE g_ama_2     RECORD
#          ama99    LIKE type_file.num10,
#          ama100   LIKE type_file.num10,
#          ama101   LIKE type_file.num10,
#          ama102   LIKE type_file.num10,
#          ama103   LIKE type_file.num10,
#          ama104   LIKE type_file.num10,
#          ama105   LIKE type_file.num10
#                   END RECORD
#DEFINE g_ama_2_t   RECORD
#          ama99    LIKE type_file.num10,
#          ama100   LIKE type_file.num10,
#          ama101   LIKE type_file.num10,
#          ama102   LIKE type_file.num10,
#          ama103   LIKE type_file.num10,
#          ama104   LIKE type_file.num10,
#          ama105   LIKE type_file.num10
#                   END RECORD,
#FUN-B40054--Add--end---
#FUN-BA0021---End---
       g_wc2,g_sql  STRING,  #No.FUN-580092 HCN                   #No.FUN-680074
       g_rec_b      LIKE type_file.num5,    #單身筆數             #No.FUN-680074 SMALLINT
       l_ac         LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-680074 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL    #No.FUN-680074
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-680074 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose       #No.FUN-680074 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570108            #No.FUN-680074 SMALLINT
DEFINE l_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
DEFINE g_wc         STRING
DEFINE l_cmd        LIKE type_file.chr1000    #FUN-BA0021
MAIN
   DEFINE p_row,p_col   LIKE type_file.num5   #No.FUN-680074 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
      RETURNING g_time    #No.FUN-6A0068
   LET l_sql ="ama01.ama_file.ama01,",
              "ama02.ama_file.ama02,",
              "ama03.ama_file.ama03,",
              "ama04.ama_file.ama04,",
              "ama05.ama_file.ama05,",
              "ama07.ama_file.ama07,",
              "ama11.ama_file.ama11,",
              "ama12.ama_file.ama12,",
              "amaacti.ama_file.amaacti"
   LET l_table = cl_prt_temptable('amdi001',l_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF           
   LET p_row = 3 LET p_col=5
 
   OPEN WINDOW i001_w AT p_row,p_col 
     WITH FORM "amd/42f/amdi001" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1'
 
   CALL i001_b_fill(g_wc2)
 
   CALL i001_menu()
 
   CLOSE WINDOW i001_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
      RETURNING g_time    #No.FUN-6A0068
 
END MAIN
 
FUNCTION i001_menu()
 
   WHILE TRUE
      CALL i001_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i001_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#FUN-B40054--add---Begin---
         WHEN "JXSEFT"
           #IF cl_chk_act_auth() THEN    #FUN-BA0021 Mark
           #   CALL i001_jxseft()        #FUN-BA0021 Mark
           #FUN-BA0021--Begin--
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               LET l_cmd = "amdt001 '", g_ama[l_ac].ama01,"'"
              #LET l_cmd = "amdt001", g_ama[l_ac].ama01,"'"
               CALL cl_cmdrun(l_cmd)
            END IF
           #FUN-BA0021---End---
         WHEN "GWLW"
           #IF cl_chk_act_auth() THEN    #FUN-BA0021 Mark
           #   CALL i001_gwlw()          #FUN-BA0021 Mark
           #FUN-BA0021--Begin--
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               LET l_cmd = "amdt002 '", g_ama[l_ac].ama01,"'"
              #LET l_cmd = "amdt002", g_ama[l_ac].ama01,"'"
               CALL cl_cmdrun(l_cmd)
            END IF
           #FUN-BA0021---End---
#FUN-B40054--add---end---
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
         WHEN "exporttoexcel"     #FUN-4B0007
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ama),'','')
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i001_q()
 
   CALL i001_b_askkey()
 
END FUNCTION
 
FUNCTION i001_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680074 SMALLINT
       l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680074 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680074 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680074 VARCHAR(1)
       l_allow_insert  LIKE type_file.chr1,                                   #No.FUN-680074 VARCHAR(1)
       l_allow_delete  LIKE type_file.chr1                                    #No.FUN-680074 VARCHAR(1)
 
   LET g_action_choice = ""  
 
   IF s_shut(0) THEN RETURN END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')                         
   LET l_allow_delete = cl_detail_input_auth('delete')    
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ama01,ama02,ama11,ama03,ama04,ama05,ama07,",
                      "       ama13,ama14,ama15,ama23,ama24,ama08,ama09,ama12,ama10,",  #FUN-980090 add ama23       #FUN-990021 add ama24
                      "       ama16,ama17,ama18,ama21,ama19,ama22,ama20, ",   #No:FUN-690020 #FUN-950013 add   #FUN-980024 add ama21,ama22
                      "       ama106,ama107,ama108,amaacti",    #FUN-C70030 add ama106,ama107,ama108
                      "  FROM ama_file ",
                      " WHERE ama01 = ?  FOR UPDATE"                  #No.MOD-510007
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_ama WITHOUT DEFAULTS FROM s_ama.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,           
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)   
      BEFORE INPUT                                                            
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)                                           
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'
            LET g_ama_t.* = g_ama[l_ac].*  #BACKUP
            LET g_before_input_done = FALSE                                 
            CALL i001_set_entry(p_cmd)                                      
            CALL i001_set_no_entry(p_cmd)                                   
            CALL i001_set_no_required()  #FUN-980024
            CALL i001_set_required()     #FUN-980024
            LET g_before_input_done = TRUE                                  
            BEGIN WORK
            OPEN i001_bcl USING g_ama_t.ama01
            IF STATUS THEN
               CALL cl_err("OPEN i001_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i001_bcl INTO g_ama[l_ac].* 
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ama_t.ama01,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         NEXT FIELD ama01
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                 
         CALL i001_set_entry(p_cmd)                                      
         CALL i001_set_no_entry(p_cmd)                                   
         CALL i001_set_no_required()  #FUN-980024
         CALL i001_set_required()     #FUN-980024
         LET g_before_input_done = TRUE                                  
         INITIALIZE g_ama[l_ac].* TO NULL      #900423
         LET g_ama_t.* = g_ama[l_ac].*         #新輸入資料
         LET g_ama[l_ac].amaacti = 'Y'         #Body default
         LET g_ama[l_ac].ama24 = 'N'           #FUN-990021
         DISPLAY BY NAME g_ama[l_ac].ama24     #FUN-990021
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD ama01
 
      AFTER INSERT                                                            
         IF INT_FLAG THEN                                                    
            CALL cl_err('',9001,0)                                           
            LET INT_FLAG = 0                                                 
            CANCEL INSERT
            CLOSE i001_bcl                                                   
         END IF                 
         INSERT INTO ama_file(ama01,ama02,ama03,ama04,ama05,ama07,   #MOD-6B0142     
                              ama13,ama14,ama15,   #No.FUN-690020
                              ama08,ama09,ama10,ama11,ama12,
                              ama16,ama17,ama18,ama19,ama20,    #FUN-950013
                              ama21,ama22,                      #FUN-980024 add
                              ama23,                            #FUN-980090 add
                              ama24,                            #FUN-990021 add
                              ama106,ama107,ama108,             #FUN-C70030 add
                              amaacti,amauser,amadate,amaoriu,amaorig)
                       VALUES(g_ama[l_ac].ama01,g_ama[l_ac].ama02,
                              g_ama[l_ac].ama03,g_ama[l_ac].ama04,
                              g_ama[l_ac].ama05,g_ama[l_ac].ama07,
                              g_ama[l_ac].ama13,g_ama[l_ac].ama14,   #No.FUN-690020
                              g_ama[l_ac].ama15,g_ama[l_ac].ama08,   #No.FUN-690020
                              g_ama[l_ac].ama09,g_ama[l_ac].ama10,
                              g_ama[l_ac].ama11,g_ama[l_ac].ama12,
                              g_ama[l_ac].ama16,g_ama[l_ac].ama17,   #FUN-950013
                              g_ama[l_ac].ama18,g_ama[l_ac].ama19,   #FUN-950013
                              g_ama[l_ac].ama20,                     #FUN-950013
                              g_ama[l_ac].ama21,g_ama[l_ac].ama22,   #FUN-980024 add
                              g_ama[l_ac].ama23,                     #FUN-980090
                              g_ama[l_ac].ama24,                     #FUN-990021 add
                              g_ama[l_ac].ama106,g_ama[l_ac].ama107,g_ama[l_ac].ama108,   #FUN-C70030 add
                              g_ama[l_ac].amaacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN                                   
            CALL cl_err3("ins","ama_file",g_ama[l_ac].ama01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660093     
            CANCEL INSERT
         ELSE                                                    
            MESSAGE 'INSERT O.K'                                
            LET g_rec_b=g_rec_b+1                           
            DISPLAY g_rec_b TO FORMONLY.cn2                 
         END IF                   
 
      AFTER FIELD ama01                        #check 編號是否重複
         IF NOT cl_null(g_ama[l_ac].ama01) THEN
            IF g_ama[l_ac].ama01 != g_ama_t.ama01 OR
              (g_ama[l_ac].ama01 IS NOT NULL AND g_ama_t.ama01 IS NULL) THEN
               SELECT COUNT(*) INTO l_n FROM ama_file
                WHERE ama01 = g_ama[l_ac].ama01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_ama[l_ac].ama01 = g_ama_t.ama01
                  NEXT FIELD ama01
               END IF
               CALL i001_ama01(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ama[l_ac].ama01,g_errno,0)
                  LET g_ama[l_ac].ama01=g_ama_t.ama01
                  NEXT FIELD ama01
               END IF
            END IF
         END IF
         
      BEFORE FIELD ama15
        CALL i001_set_entry(p_cmd)                                      
        CALL i001_set_no_required()  
       
      AFTER FIELD ama15
        IF g_ama[l_ac].ama15 != '2' THEN   #FUN-990021
            LET g_ama[l_ac].ama23  = g_ama[l_ac].ama02 
            DISPLAY BY NAME g_ama[l_ac].ama23
        END IF
        CALL i001_set_no_entry(p_cmd)                                   
        CALL i001_set_required()    

      BEFORE FIELD ama16
        CALL cl_set_comp_entry("ama20",TRUE) 
 
      AFTER FIELD ama16
         IF cl_null(g_ama[l_ac].ama16) THEN
            CALL cl_err('','aim-927',1)
            NEXT FIELD ama16
         ELSE
            IF g_ama[l_ac].ama16 = '1' THEN 
               LET g_ama[l_ac].ama20='' #MOD-980072
               CALL cl_set_comp_entry("ama20",FALSE) 
            END IF 
         END IF 
         CALL i001_set_no_required()  #FUN-980024
         CALL i001_set_required()     #FUN-980024
         
         
       AFTER FIELD ama18
         IF g_ama[l_ac].ama16 != '1' THEN 
            IF cl_null(g_ama[l_ac].ama18) THEN 
               CALL cl_err('','amd-027',0)
               NEXT FIELD ama18
            END IF 
         END IF
         
       AFTER FIELD ama19
         IF g_ama[l_ac].ama16 != '1' THEN 
            IF cl_null(g_ama[l_ac].ama19) THEN 
               CALL cl_err('','amd-027',0)
               NEXT FIELD ama19
            END IF 
         END IF       
            	         
      AFTER FIELD ama10
          IF NOT cl_null(g_ama[l_ac].ama10) THEN
             IF g_ama[l_ac].ama10 < 0 THEN
                CALL cl_err(g_ama[l_ac].ama10,'axm-179',0)
                NEXT FIELD ama10
             END IF
          END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_ama_t.ama01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM ama_file WHERE ama01 = g_ama_t.ama01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ama_file",g_ama_t.ama01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660093
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"                                             
            CLOSE i001_bcl                                                  
            COMMIT WORK    
         END IF
 
      ON ROW CHANGE                                                           
         IF INT_FLAG THEN                                                      
            CALL cl_err('',9001,0)                                             
            LET INT_FLAG = 0                                                   
            LET g_ama[l_ac].* = g_ama_t.*                                      
            CLOSE i001_bcl                                                     
            ROLLBACK WORK                                                      
            EXIT INPUT                                                         
         END IF                                                                
         IF l_lock_sw = 'Y' THEN                                               
            CALL cl_err(g_ama[l_ac].ama01,-263,1)                            
            LET g_ama[l_ac].* = g_ama_t.*                                      
         ELSE 
            UPDATE ama_file SET
                   ama01 = g_ama[l_ac].ama01,ama02=g_ama[l_ac].ama02,
                   ama03 = g_ama[l_ac].ama03,ama04=g_ama[l_ac].ama04,
                   ama05 = g_ama[l_ac].ama05,ama07=g_ama[l_ac].ama07,
                   ama13 = g_ama[l_ac].ama13,ama14=g_ama[l_ac].ama14,   #No.FUN-690020
                   ama15 = g_ama[l_ac].ama15,   #No.FUN-690020
                   ama08 = g_ama[l_ac].ama08,ama09=g_ama[l_ac].ama09,
                   ama10 = g_ama[l_ac].ama10,ama11=g_ama[l_ac].ama11,
                   ama12 = g_ama[l_ac].ama12,ama16=g_ama[l_ac].ama16,   #FUN-950013
                   ama17 = g_ama[l_ac].ama17,ama18=g_ama[l_ac].ama18,   #FUN-950013
                   ama19 = g_ama[l_ac].ama19,ama20=g_ama[l_ac].ama20,   #FUN-950013
                   ama21 = g_ama[l_ac].ama21,ama22=g_ama[l_ac].ama22,   #FUN-980024 add
                   ama23 = g_ama[l_ac].ama23,                           #FUN-980090
                   ama24 = g_ama[l_ac].ama24,                           #FUN-990021
                   ama106= g_ama[l_ac].ama106,                          #FUN-C70030 add
                   ama107= g_ama[l_ac].ama107,                          #FUN-C70030 add
                   ama108= g_ama[l_ac].ama108,                          #FUN-C70030 add
                   amaacti=g_ama[l_ac].amaacti,
                   amamodu=g_user,amadate=g_today
                   WHERE ama01=g_ama_t.ama01 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ama_file",g_ama[l_ac].ama01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660093
               LET g_ama[l_ac].* = g_ama_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR() 
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ama[l_ac].* = g_ama_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_ama.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i001_bcl                                                     
            ROLLBACK WORK   
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac                                                     
         CLOSE i001_bcl                                                        
         COMMIT WORK  
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ama01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_ama[l_ac].ama01
               CALL cl_create_qry() RETURNING g_ama[l_ac].ama01
               DISPLAY BY NAME g_ama[l_ac].ama01            #No.MOD-490344
               NEXT FIELD ama01  
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(ama01) AND l_ac > 1 THEN
            LET g_ama[l_ac].* = g_ama[l_ac-1].*
            NEXT FIELD ama01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
        
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
        
   END INPUT
 
   CLOSE i001_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i001_ama01(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680074 VARCHAR(1)
          l_gem02     LIKE gem_file.gem02,
          l_gem05     LIKE gem_file.gem05,
          l_gemacti   LIKE gem_file.gemacti
 
   LET g_errno = ' '
 
   SELECT gem02,gem05,gemacti 
     INTO l_gem02,l_gem05,l_gemacti FROM gem_file
     WHERE gem01 = g_ama[l_ac].ama01 
 
   CASE
      WHEN STATUS=100
         LET g_errno = 'agl-003'  #No.7926
      WHEN l_gemacti = 'N'
         LET g_errno = '9028' 
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE 
 
END FUNCTION
 
FUNCTION i001_b_askkey()
 
   CLEAR FORM
   CALL g_ama.clear()
 
   CONSTRUCT g_wc2 ON ama01,ama02,ama11,ama03,ama04,ama05,ama07,
                      ama13,ama14,ama15,   #No:FUN-690020
                      ama23,               #FUN-980090
                      ama24,               #FUN-990021 
                      ama08,ama09,ama12,ama10,ama16,ama17,ama18,  #FUN-950013
                      ama21,ama19,ama22,ama20,amaacti  #FUN-950013  #FUN-980024 ama21,ama22 add   #MOD-980155 add
           FROM s_ama[1].ama01,s_ama[1].ama02,s_ama[1].ama11,s_ama[1].ama03,
                s_ama[1].ama04,s_ama[1].ama05,s_ama[1].ama07,
                s_ama[1].ama13,s_ama[1].ama14,s_ama[1].ama15,   #No:FUN-690020
                s_ama[1].ama23,   #FUN-980090
                s_ama[1].ama24,   #FUN-990021
                s_ama[1].ama08,s_ama[1].ama09,s_ama[1].ama12,
                s_ama[1].ama10,s_ama[1].ama16,s_ama[1].ama17,   #FUN-950013
                s_ama[1].ama18,s_ama[1].ama21,s_ama[1].ama19,s_ama[1].ama22,s_ama[1].ama20,   #FUN-950013  #FUN-980024
                s_ama[1].amaacti
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(ama01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_ama[1].ama01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ama01
                  NEXT FIELD ama01  
              OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_select
         CALL cl_qbe_select() 
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('amauser', 'amagrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL i001_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i001_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2   LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(200)
 
   LET g_sql = "SELECT ama01,ama02,ama11,ama03,ama04,ama05,ama07,",
               "       ama13,ama14,ama15,ama23,ama24,ama08,ama09,ama12,ama10,",  #FUN-980090 add ama15  #FUN-990021 add ama24
               "       ama16,ama17,ama18,ama21,ama19,ama22,ama20,",   #No:FUN-690020 #FUn-950013  #FUN-980024 add ama21,ama22
               "       ama106,ama107,ama108,amaacti ",   #FUN-C70030 add ama106,ama107,ama108 
               "  FROM ama_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY ama01"
   PREPARE i001_pb FROM g_sql
   DECLARE ama_curs CURSOR FOR i001_pb
 
   CALL g_ama.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH ama_curs INTO g_ama[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   MESSAGE ""
   CALL g_ama.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i001_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680074 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ama TO s_ama.* ATTRIBUTE(COUNT=g_rec_b) 
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
#FUN-B40054--add---Begin---
      ON ACTION JXSEFT
         LET g_action_choice="JXSEFT"
         EXIT DISPLAY

      ON ACTION GWLW
         LET g_action_choice="GWLW"
         EXIT DISPLAY
#FUN-B40054--add---end---

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = ARR_CURR()                                                  
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0007
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  #TQC-5B0076
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i001_out()
   DEFINE l_ama    RECORD LIKE ama_file.*,
          l_i      LIKE type_file.num5,          #No.FUN-680074 SMALLINT
          l_name   LIKE type_file.chr20,         #No.FUN-680074 VARCHAR(20)
          l_za05   LIKE type_file.chr1000        #No.FUN-680074 VARCHAR(40)
   CALL cl_del_data(l_table)                     #NO.FUN-850045
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'amdi001' #NO.FUN-850045   
   IF g_wc2 IS NULL THEN 
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   LET g_sql="SELECT * FROM ama_file ",          # 組合出 SQL 指令
             " WHERE ",g_wc2 CLIPPED
 
   PREPARE i001_p1 FROM g_sql
   DECLARE i001_co CURSOR FOR i001_p1
 
 
   FOREACH i001_co INTO l_ama.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      EXECUTE insert_prep USING
        l_ama.ama01,l_ama.ama02,l_ama.ama03,l_ama.ama04,l_ama.ama05,
        l_ama.ama07,l_ama.ama11,l_ama.ama12,l_ama.amaacti
   END FOREACH
 
 
   CLOSE i001_co
   ERROR ""
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(g_wc,'ama01,ama02,ama11,ama03,ama04,ama05,ama07,
                      ama13,ama14,ama15,ama08,ama09,ama12,ama10,
                      amaacti')                 #FUN-950013
           RETURNING g_wc
     END IF
     LET g_str = g_wc
     CALL cl_prt_cs3('amdi001','amdi001',l_sql,g_str) 
 
END FUNCTION
FUNCTION i001_set_entry(p_cmd)                                                  
   DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680074 CHAR(1)
                                                                                
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN                            
      CALL cl_set_comp_entry("ama01",TRUE)
   END IF                                                                       
   CALL cl_set_comp_entry("ama20",TRUE)    #FUN-950013
   CALL cl_set_comp_entry("ama23",TRUE)    #FUN-980090
   CALL cl_set_comp_entry("ama24",TRUE)    #FUN-990021

END FUNCTION                                                                    

FUNCTION i001_set_no_entry(p_cmd)                                               
   DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680074 CHAR(1)
                                                                                
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN           
      CALL cl_set_comp_entry("ama01",FALSE)                                      
   END IF                                                                       
    IF g_ama[l_ac].ama16 = '1' THEN 
       CALL cl_set_comp_entry("ama20",FALSE) 
    END IF 

    IF g_ama[l_ac].ama15 != '2' THEN    #FUN-990021
       CALL cl_set_comp_entry("ama23",FALSE) 
    END IF 

   IF g_ama[l_ac].ama15 != '1' THEN 
      CALL cl_set_comp_entry("ama24",FALSE) 
   END IF 

END FUNCTION                                                                    

FUNCTION i001_set_no_required()
  CALL cl_set_comp_required("ama17,ama18,ama19,ama20,ama21",FALSE)
  CALL cl_set_comp_required("ama23",FALSE)  #FUN-980090

END FUNCTION

FUNCTION i001_set_required()   
  IF g_ama[l_ac].ama16 <> '1' THEN
      CALL cl_set_comp_required("ama18,ama19,ama20,ama21",TRUE)  #FUN-990034 mod
  END IF
  IF g_ama[l_ac].ama16 = '1' THEN
      CALL cl_set_comp_required("ama18,ama19,ama21",TRUE)  #FUN-990034 mod
  END IF

  IF g_ama[l_ac].ama15 = '2' THEN
      CALL cl_set_comp_required("ama23",TRUE)
  END IF
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14
#FUN-BA0021--Begin--
#FUN-B40054--add-Begin---
#FUNCTION i001_jxseft()
#
#   open WINDOW amdi001_1 WITH FORM "amd/42f/amdi001_1"
#      ATTRIBUTE (STYLE = g_win_style CLIPPED)
#
#   CALL cl_ui_init()
#   
#   LET g_sql = "SELECT ama25,ama26,ama27,ama28,ama29,ama30,ama31,ama32,ama33,ama34,ama35,ama36,",
#               "       ama37,ama38,ama39,ama40,ama41,ama42,ama43,ama44,ama45,ama46,ama47,ama48,",
#               "       ama49,ama50,ama51,ama52,ama53,ama54,ama55,ama56,ama57,ama58,ama59,ama60,",
#               "       ama61,ama62,ama63,ama64,ama65,ama66,ama67,ama68,ama69,ama70,ama71,ama72,",
#               "       ama73,ama74,ama75,ama76,ama77,ama78,ama79,ama80,ama81,ama82,ama83,ama84,",
#               "       ama85,ama86,ama87,ama88,ama89,ama90,ama91,ama92,ama93,ama94,ama95,ama96,",
#               "       ama97,ama98 FROM ama_file ",
#               " WHERE ama01 = ?"
#   PREPARE i001_1_pre FROM g_sql
#   DECLARE i001_1_cl CURSOR FOR i001_1_pre
#
#   Call amdi001_1_tm()
#
#   CLOSE WINDOW amdi001_1
#END FUNCTION
#
#FUNCTION amdi001_1_tm()
#
#   IF s_shut(0) THEN
#      RETURN
#   END IF
#
#   IF g_ama[l_ac].ama01 IS NULL THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
#
#   IF g_ama[l_ac].amaacti ='N' THEN  
#      CALL cl_err(g_ama[l_ac].ama01,'mfg1000',0)
#      RETURN
#   END IF
#   MESSAGE ""
#   CALL cl_opmsg('u')
#   BEGIN WORK
# 
#   OPEN i001_1_cl USING g_ama[l_ac].ama01
#   IF STATUS THEN
#      CALL cl_err("OPEN i001_1_cl:", STATUS, 1)
#      CLOSE i001_1_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH i001_1_cl INTO g_ama_1.* 
#   IF SQLCA.sqlcode THEN
#       CALL cl_err('',SQLCA.sqlcode,0) 
#       CLOSE i001_1_cl
#       ROLLBACK WORK
#       RETURN
#   END IF
#
#   CALL i001_1_show()
#
#   WHILE TRUE
#      LET g_ama_1_t.* = g_ama_1.*
#      CALL i001_1_i("u")  
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         LET g_ama_1.* = g_ama_1_t.*
#         CALL i001_1_show()
#         CALL cl_err('','9001',0)
#         EXIT WHILE
#      END IF
#
#      UPDATE ama_file SET ama26 = g_ama_1.ama26,ama27 = g_ama_1.ama27,ama28 = g_ama_1.ama28,
#                          ama29 = g_ama_1.ama29,ama30 = g_ama_1.ama30,ama32 = g_ama_1.ama32,
#                          ama33 = g_ama_1.ama33,ama34 = g_ama_1.ama34,ama35 = g_ama_1.ama35,
#                          ama36 = g_ama_1.ama36,ama38 = g_ama_1.ama38,ama39 = g_ama_1.ama39,
#                          ama40 = g_ama_1.ama40,ama41 = g_ama_1.ama41,ama42 = g_ama_1.ama42,
#                          ama44 = g_ama_1.ama44,ama45 = g_ama_1.ama45,ama46 = g_ama_1.ama46,
#                          ama47 = g_ama_1.ama47,ama48 = g_ama_1.ama48,ama50 = g_ama_1.ama50,
#                          ama51 = g_ama_1.ama51,ama52 = g_ama_1.ama52,ama53 = g_ama_1.ama53,
#                          ama54 = g_ama_1.ama54,ama56 = g_ama_1.ama56,ama57 = g_ama_1.ama57,
#                          ama58 = g_ama_1.ama58,ama59 = g_ama_1.ama59,ama60 = g_ama_1.ama60,
#                          ama62 = g_ama_1.ama62,ama63 = g_ama_1.ama63,ama64 = g_ama_1.ama64,
#                          ama65 = g_ama_1.ama65,ama66 = g_ama_1.ama66,ama68 = g_ama_1.ama68,
#                          ama69 = g_ama_1.ama69,ama70 = g_ama_1.ama70,ama71 = g_ama_1.ama71,
#                          ama72 = g_ama_1.ama72,ama74 = g_ama_1.ama74,ama75 = g_ama_1.ama75,
#                          ama76 = g_ama_1.ama76,ama77 = g_ama_1.ama77,ama78 = g_ama_1.ama78,
#                          ama80 = g_ama_1.ama80,ama81 = g_ama_1.ama81,ama82 = g_ama_1.ama82,
#                          ama83 = g_ama_1.ama83,ama84 = g_ama_1.ama84,ama86 = g_ama_1.ama86,
#                          ama87 = g_ama_1.ama87,ama88 = g_ama_1.ama88,ama89 = g_ama_1.ama89,
#                          ama90 = g_ama_1.ama90,ama92 = g_ama_1.ama92,ama93 = g_ama_1.ama93,
#                          ama94 = g_ama_1.ama94,ama95 = g_ama_1.ama95,ama96 = g_ama_1.ama96,
#                          ama97 = g_ama_1.ama97
#       WHERE ama01 = g_ama[l_ac].ama01
#      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL cl_err3("upd","ama_file","","",SQLCA.sqlcode,"","",1)  
#         CONTINUE WHILE
#      END IF
#      EXIT WHILE
#   END WHILE
# 
#   CLOSE i001_1_cl
#   COMMIT WORK
#
#END FUNCTION
#
#FUNCTION i001_1_i(p_cmd)
#DEFINE l_n         LIKE type_file.num5
#DEFINE l_n1        LIKE type_file.num20_6
#DEFINE p_cmd       LIKE type_file.chr8  
#DEFINE li_result   LIKE type_file.num5
# 
#   IF s_shut(0) THEN
#      RETURN
#   END IF
# 
#   DISPLAY BY NAME g_ama_1.ama25,g_ama_1.ama26,g_ama_1.ama27,g_ama_1.ama28,g_ama_1.ama29,g_ama_1.ama30,
#                   g_ama_1.ama31,g_ama_1.ama32,g_ama_1.ama33,g_ama_1.ama34,g_ama_1.ama35,g_ama_1.ama36,
#                   g_ama_1.ama37,g_ama_1.ama38,g_ama_1.ama39,g_ama_1.ama40,g_ama_1.ama41,g_ama_1.ama42,
#                   g_ama_1.ama43,g_ama_1.ama44,g_ama_1.ama45,g_ama_1.ama46,g_ama_1.ama47,g_ama_1.ama48,
#                   g_ama_1.ama49,g_ama_1.ama50,g_ama_1.ama51,g_ama_1.ama52,g_ama_1.ama53,g_ama_1.ama54,
#                   g_ama_1.ama55,g_ama_1.ama56,g_ama_1.ama57,g_ama_1.ama58,g_ama_1.ama59,g_ama_1.ama60,
#                   g_ama_1.ama61,g_ama_1.ama62,g_ama_1.ama63,g_ama_1.ama64,g_ama_1.ama65,g_ama_1.ama66,
#                   g_ama_1.ama67,g_ama_1.ama68,g_ama_1.ama69,g_ama_1.ama70,g_ama_1.ama71,g_ama_1.ama72,
#                   g_ama_1.ama73,g_ama_1.ama74,g_ama_1.ama75,g_ama_1.ama76,g_ama_1.ama77,g_ama_1.ama78,
#                   g_ama_1.ama79,g_ama_1.ama80,g_ama_1.ama81,g_ama_1.ama82,g_ama_1.ama83,g_ama_1.ama84,
#                   g_ama_1.ama85,g_ama_1.ama86,g_ama_1.ama87,g_ama_1.ama88,g_ama_1.ama89,g_ama_1.ama90,
#                   g_ama_1.ama91,g_ama_1.ama92,g_ama_1.ama93,g_ama_1.ama94,g_ama_1.ama95,g_ama_1.ama96,
#                   g_ama_1.ama97,g_ama_1.ama98
# 
#   INPUT BY NAME   g_ama_1.ama26,g_ama_1.ama27,g_ama_1.ama30,g_ama_1.ama32,g_ama_1.ama33,g_ama_1.ama36,
#                   g_ama_1.ama38,g_ama_1.ama39,g_ama_1.ama42,g_ama_1.ama44,g_ama_1.ama45,g_ama_1.ama48,
#                   g_ama_1.ama50,g_ama_1.ama51,g_ama_1.ama54,g_ama_1.ama56,g_ama_1.ama57,g_ama_1.ama60,
#                   g_ama_1.ama62,g_ama_1.ama63,g_ama_1.ama66,g_ama_1.ama68,g_ama_1.ama69,g_ama_1.ama72,
#                   g_ama_1.ama74,g_ama_1.ama75,g_ama_1.ama78,g_ama_1.ama80,g_ama_1.ama81,g_ama_1.ama84
#       WITHOUT DEFAULTS
# 
#      AFTER FIELD ama26	
#         IF NOT cl_null(g_ama_1.ama26) AND NOT cl_null(g_ama_1.ama27) AND NOT cl_null(g_ama_1.ama30)  THEN
#            LET l_n = g_ama_1.ama26 + g_ama_1.ama27 + g_ama_1.ama30
#            IF l_n != g_ama_1.ama25 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama26,g_ama_1.ama38,g_ama_1.ama50,g_ama_1.ama62,g_ama_1.ama74) RETURNING g_ama_1.ama86
#         LET g_ama_1.ama97 = g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama86,g_ama_1.ama97
#	 
#      AFTER FIELD ama27		
#         IF NOT cl_null(g_ama_1.ama27) THEN
#            CALL i001_temp(g_ama_1.ama27) RETURNING g_ama_1.ama28
#            LET g_ama_1.ama29 = g_ama_1.ama27 - g_ama_1.ama28
#         ELSE
#            LET g_ama_1.ama28 = NULL
#            LET g_ama_1.ama29 = NULL
#         END IF
#         IF NOT cl_null(g_ama_1.ama26) AND NOT cl_null(g_ama_1.ama27) AND NOT cl_null(g_ama_1.ama30)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama26 + g_ama_1.ama27 + g_ama_1.ama30
#            IF l_n != g_ama_1.ama25 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama27,g_ama_1.ama39,g_ama_1.ama51,g_ama_1.ama63,g_ama_1.ama75) RETURNING g_ama_1.ama87
#         CALL i001_1_sum(g_ama_1.ama28,g_ama_1.ama40,g_ama_1.ama52,g_ama_1.ama64,g_ama_1.ama76) RETURNING g_ama_1.ama88
#         CALL i001_1_sum(g_ama_1.ama29,g_ama_1.ama41,g_ama_1.ama53,g_ama_1.ama65,g_ama_1.ama77) RETURNING g_ama_1.ama89
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama28,g_ama_1.ama29,g_ama_1.ama87,g_ama_1.ama88,g_ama_1.ama89,g_ama_1.ama97
#
#      AFTER FIELD ama30									
#         IF NOT cl_null(g_ama_1.ama26) AND NOT cl_null(g_ama_1.ama27) AND NOT cl_null(g_ama_1.ama30)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama26 + g_ama_1.ama27 + g_ama_1.ama30
#            IF l_n != g_ama_1.ama25 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama30,g_ama_1.ama42,g_ama_1.ama54,g_ama_1.ama66,g_ama_1.ama78) RETURNING g_ama_1.ama90
#         DISPLAY BY NAME g_ama_1.ama90
#	
#      AFTER FIELD ama32									
#         IF NOT cl_null(g_ama_1.ama32) AND NOT cl_null(g_ama_1.ama33) AND NOT cl_null(g_ama_1.ama36)  THEN
#            LET l_n = 0
#            IF g_ama_1.ama32 ! = g_ama_1.ama32 + g_ama_1.ama33 + g_ama_1.ama36 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama32,g_ama_1.ama44,g_ama_1.ama56,g_ama_1.ama68,g_ama_1.ama80) RETURNING g_ama_1.ama92
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama92,g_ama_1.ama97
#
#      AFTER FIELD ama33		
#         IF NOT cl_null(g_ama_1.ama33) THEN
#            CALL i001_temp(g_ama_1.ama33) RETURNING g_ama_1.ama34
#            LET g_ama_1.ama35 = g_ama_1.ama33 - g_ama_1.ama34	
#         ELSE
#            LET g_ama_1.ama33 = NULL
#            LET g_ama_1.ama34 = NULL
#         END IF
#         IF NOT cl_null(g_ama_1.ama32) AND NOT cl_null(g_ama_1.ama33) AND NOT cl_null(g_ama_1.ama36)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama32 + g_ama_1.ama33 + g_ama_1.ama36
#            IF l_n != g_ama_1.ama31 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF			
#         CALL i001_1_sum(g_ama_1.ama33,g_ama_1.ama45,g_ama_1.ama57,g_ama_1.ama69,g_ama_1.ama81) RETURNING g_ama_1.ama93
#         CALL i001_1_sum(g_ama_1.ama34,g_ama_1.ama46,g_ama_1.ama58,g_ama_1.ama70,g_ama_1.ama82) RETURNING g_ama_1.ama94
#         CALL i001_1_sum(g_ama_1.ama35,g_ama_1.ama47,g_ama_1.ama59,g_ama_1.ama71,g_ama_1.ama83) RETURNING g_ama_1.ama95
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama34,g_ama_1.ama35,g_ama_1.ama93,g_ama_1.ama94,g_ama_1.ama95,g_ama_1.ama97
#	
#      AFTER FIELD ama36									
#         IF NOT cl_null(g_ama_1.ama32) AND NOT cl_null(g_ama_1.ama33) AND NOT cl_null(g_ama_1.ama36)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama32 + g_ama_1.ama33 + g_ama_1.ama36
#            IF l_n != g_ama_1.ama31 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama36,g_ama_1.ama48,g_ama_1.ama60,g_ama_1.ama72,g_ama_1.ama84) RETURNING g_ama_1.ama96
#         DISPLAY BY NAME g_ama_1.ama96
#
#      AFTER FIELD ama38									
#         IF NOT cl_null(g_ama_1.ama38) AND NOT cl_null(g_ama_1.ama39) AND NOT cl_null(g_ama_1.ama42)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama38 + g_ama_1.ama39 + g_ama_1.ama40
#            IF l_n != g_ama_1.ama37 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama26,g_ama_1.ama38,g_ama_1.ama50,g_ama_1.ama62,g_ama_1.ama74) RETURNING g_ama_1.ama86
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama86,g_ama_1.ama97
#
#      AFTER FIELD ama39	
#         IF NOT cl_null(g_ama_1.ama39) THEN
#            CALL i001_temp(g_ama_1.ama39) RETURNING g_ama_1.ama40
#            LET g_ama_1.ama41 = g_ama_1.ama39 - g_ama_1.ama40	
#         ELSE
#            LET g_ama_1.ama39 = NULL
#            LET g_ama_1.ama40 = NULL
#         END IF
#         IF NOT cl_null(g_ama_1.ama38) AND NOT cl_null(g_ama_1.ama39) AND NOT cl_null(g_ama_1.ama42)  THEN
#         LET l_n = 0
#         LET l_n = g_ama_1.ama38 + g_ama_1.ama39 + g_ama_1.ama40
#         IF l_n != g_ama_1.ama37 THEN
#            CALL cl_err('','amd-034',0)
#         END IF
#      END IF
#      CALL i001_1_sum(g_ama_1.ama27,g_ama_1.ama39,g_ama_1.ama51,g_ama_1.ama63,g_ama_1.ama75) RETURNING g_ama_1.ama87
#      CALL i001_1_sum(g_ama_1.ama28,g_ama_1.ama40,g_ama_1.ama52,g_ama_1.ama64,g_ama_1.ama76) RETURNING g_ama_1.ama88
#      CALL i001_1_sum(g_ama_1.ama29,g_ama_1.ama41,g_ama_1.ama53,g_ama_1.ama65,g_ama_1.ama77) RETURNING g_ama_1.ama89
#      LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#      DISPLAY BY NAME g_ama_1.ama40,g_ama_1.ama41,g_ama_1.ama87,g_ama_1.ama88,g_ama_1.ama89,g_ama_1.ama97
#
#      AFTER FIELD ama42
#         IF NOT cl_null(g_ama_1.ama38) AND NOT cl_null(g_ama_1.ama39) AND NOT cl_null(g_ama_1.ama42)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama38 + g_ama_1.ama39 + g_ama_1.ama40
#            IF l_n != g_ama_1.ama37 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama30,g_ama_1.ama42,g_ama_1.ama54,g_ama_1.ama66,g_ama_1.ama78) RETURNING g_ama_1.ama90
#         DISPLAY BY NAME g_ama_1.ama90
#
#      AFTER FIELD ama44									
#         IF NOT cl_null(g_ama_1.ama44) AND NOT cl_null(g_ama_1.ama45) AND NOT cl_null(g_ama_1.ama48)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama44 + g_ama_1.ama45 + g_ama_1.ama48
#            IF l_n != g_ama_1.ama43 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama32,g_ama_1.ama44,g_ama_1.ama56,g_ama_1.ama68,g_ama_1.ama80) RETURNING g_ama_1.ama92
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama92,g_ama_1.ama97
#	
#      AFTER FIELD ama45		
#         IF NOT cl_null(g_ama_1.ama45) THEN
#            CALL i001_temp(g_ama_1.ama45) RETURNING g_ama_1.ama46
#            LET g_ama_1.ama47 = g_ama_1.ama45 - g_ama_1.ama46
#         ELSE
#            LET g_ama_1.ama45 = NULL
#            LET g_ama_1.ama46 = NULL 
#         END IF
#         IF NOT cl_null(g_ama_1.ama44) AND NOT cl_null(g_ama_1.ama45) AND NOT cl_null(g_ama_1.ama48)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama44 + g_ama_1.ama45 + g_ama_1.ama48
#            IF l_n != g_ama_1.ama43 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF	
#         CALL i001_1_sum(g_ama_1.ama33,g_ama_1.ama45,g_ama_1.ama57,g_ama_1.ama69,g_ama_1.ama81) RETURNING g_ama_1.ama93
#         CALL i001_1_sum(g_ama_1.ama34,g_ama_1.ama46,g_ama_1.ama58,g_ama_1.ama70,g_ama_1.ama82) RETURNING g_ama_1.ama94
#         CALL i001_1_sum(g_ama_1.ama35,g_ama_1.ama47,g_ama_1.ama59,g_ama_1.ama71,g_ama_1.ama83) RETURNING g_ama_1.ama95
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama46,g_ama_1.ama47,g_ama_1.ama93,g_ama_1.ama94,g_ama_1.ama95,g_ama_1.ama97
#
#      AFTER FIELD ama48
#         IF NOT cl_null(g_ama_1.ama44) AND NOT cl_null(g_ama_1.ama45) AND NOT cl_null(g_ama_1.ama48)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama44 + g_ama_1.ama45 + g_ama_1.ama48
#            IF l_n != g_ama_1.ama43 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama36,g_ama_1.ama48,g_ama_1.ama60,g_ama_1.ama72,g_ama_1.ama84) RETURNING g_ama_1.ama96
#         DISPLAY BY NAME g_ama_1.ama96
#	
#      AFTER FIELD ama50									
#         IF NOT cl_null(g_ama_1.ama50) AND NOT cl_null(g_ama_1.ama51) AND NOT cl_null(g_ama_1.ama54)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama50 + g_ama_1.ama51 + g_ama_1.ama54
#            IF l_n != g_ama_1.ama49 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama26,g_ama_1.ama38,g_ama_1.ama50,g_ama_1.ama62,g_ama_1.ama74) RETURNING g_ama_1.ama86
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama86,g_ama_1.ama97
#	
#      AFTER FIELD ama51		
#         IF NOT cl_null(g_ama_1.ama51) THEN
#            CALL i001_temp(g_ama_1.ama51) RETURNING g_ama_1.ama52
#            LET g_ama_1.ama53 = g_ama_1.ama51 - g_ama_1.ama52
#         ELSE
#            LET g_ama_1.ama51 = NULL
#            LET g_ama_1.ama52 = NULL
#         END IF
#         IF NOT cl_null(g_ama_1.ama50) AND NOT cl_null(g_ama_1.ama51) AND NOT cl_null(g_ama_1.ama54)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama50 + g_ama_1.ama51 + g_ama_1.ama54
#            IF l_n != g_ama_1.ama49 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF		
#         CALL i001_1_sum(g_ama_1.ama27,g_ama_1.ama39,g_ama_1.ama51,g_ama_1.ama63,g_ama_1.ama75) RETURNING g_ama_1.ama87
#         CALL i001_1_sum(g_ama_1.ama28,g_ama_1.ama40,g_ama_1.ama52,g_ama_1.ama64,g_ama_1.ama76) RETURNING g_ama_1.ama88
#         CALL i001_1_sum(g_ama_1.ama29,g_ama_1.ama41,g_ama_1.ama53,g_ama_1.ama65,g_ama_1.ama77) RETURNING g_ama_1.ama89
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama52,g_ama_1.ama53,g_ama_1.ama87,g_ama_1.ama88,g_ama_1.ama89,g_ama_1.ama97
#
#      AFTER FIELD ama54
#         IF NOT cl_null(g_ama_1.ama50) AND NOT cl_null(g_ama_1.ama51) AND NOT cl_null(g_ama_1.ama54)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama50 + g_ama_1.ama51 + g_ama_1.ama54
#            IF l_n != g_ama_1.ama49 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama30,g_ama_1.ama42,g_ama_1.ama54,g_ama_1.ama66,g_ama_1.ama78) RETURNING g_ama_1.ama90
#         DISPLAY BY NAME g_ama_1.ama90
#
#      AFTER FIELD ama56									
#         IF NOT cl_null(g_ama_1.ama56) AND NOT cl_null(g_ama_1.ama57) AND NOT cl_null(g_ama_1.ama60)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama56 + g_ama_1.ama57 + g_ama_1.ama60
#            IF l_n != g_ama_1.ama55 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama32,g_ama_1.ama44,g_ama_1.ama56,g_ama_1.ama68,g_ama_1.ama80) RETURNING g_ama_1.ama92
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama92,g_ama_1.ama97
#
#      AFTER FIELD ama57
#         IF NOT cl_null(g_ama_1.ama57) THEN
#            CALL i001_temp(g_ama_1.ama57) RETURNING g_ama_1.ama58
#            LET g_ama_1.ama59 = g_ama_1.ama57 - g_ama_1.ama58
#         ELSE
#            LET g_ama_1.ama57 = NULL
#            LET g_ama_1.ama58 = NULL
#         END IF
#         IF NOT cl_null(g_ama_1.ama56) AND NOT cl_null(g_ama_1.ama57) AND NOT cl_null(g_ama_1.ama60)  THEN
#         LET l_n = 0
#         LET l_n = g_ama_1.ama56 + g_ama_1.ama57 + g_ama_1.ama60
#         IF l_n != g_ama_1.ama55 THEN
#            CALL cl_err('','amd-034',0)
#         END IF
#      END IF
#      CALL i001_1_sum(g_ama_1.ama33,g_ama_1.ama45,g_ama_1.ama57,g_ama_1.ama69,g_ama_1.ama81) RETURNING g_ama_1.ama93
#      CALL i001_1_sum(g_ama_1.ama34,g_ama_1.ama46,g_ama_1.ama58,g_ama_1.ama70,g_ama_1.ama82) RETURNING g_ama_1.ama94
#      CALL i001_1_sum(g_ama_1.ama35,g_ama_1.ama47,g_ama_1.ama59,g_ama_1.ama71,g_ama_1.ama83) RETURNING g_ama_1.ama95
#      LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#      DISPLAY BY NAME g_ama_1.ama58,g_ama_1.ama59,g_ama_1.ama93,g_ama_1.ama94,g_ama_1.ama95,g_ama_1.ama97
#
#      AFTER FIELD ama60
#         IF NOT cl_null(g_ama_1.ama62) AND NOT cl_null(g_ama_1.ama63) AND NOT cl_null(g_ama_1.ama66)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama62 + g_ama_1.ama63 + g_ama_1.ama66
#            IF l_n != g_ama_1.ama61 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama26,g_ama_1.ama38,g_ama_1.ama50,g_ama_1.ama62,g_ama_1.ama74) RETURNING g_ama_1.ama86
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama86,g_ama_1.ama97
#
#      AFTER FIELD ama62
#         IF NOT cl_null(g_ama_1.ama62) AND NOT cl_null(g_ama_1.ama63) AND NOT cl_null(g_ama_1.ama66)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama62 + g_ama_1.ama63 + g_ama_1.ama66
#            IF l_n != g_ama_1.ama61 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama26,g_ama_1.ama38,g_ama_1.ama50,g_ama_1.ama62,g_ama_1.ama74) RETURNING g_ama_1.ama86
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama86,g_ama_1.ama93
#
#      AFTER FIELD ama63
#         IF NOT cl_null(g_ama_1.ama63) THEN
#            CALL i001_temp(g_ama_1.ama63) RETURNING g_ama_1.ama64
#            LET g_ama_1.ama65 = g_ama_1.ama63 - g_ama_1.ama64
#         ELSE
#            LET g_ama_1.ama63 = NULL
#            LET g_ama_1.ama64 = NULL
#         END IF
#         IF NOT cl_null(g_ama_1.ama62) AND NOT cl_null(g_ama_1.ama63) AND NOT cl_null(g_ama_1.ama66)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama62 + g_ama_1.ama63 + g_ama_1.ama66
#            IF l_n != g_ama_1.ama61 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF	
#      CALL i001_1_sum(g_ama_1.ama27,g_ama_1.ama39,g_ama_1.ama51,g_ama_1.ama63,g_ama_1.ama75) RETURNING g_ama_1.ama87
#      CALL i001_1_sum(g_ama_1.ama28,g_ama_1.ama40,g_ama_1.ama52,g_ama_1.ama64,g_ama_1.ama76) RETURNING g_ama_1.ama88
#      CALL i001_1_sum(g_ama_1.ama29,g_ama_1.ama41,g_ama_1.ama53,g_ama_1.ama65,g_ama_1.ama77) RETURNING g_ama_1.ama89
#      LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#      DISPLAY BY NAME g_ama_1.ama64,g_ama_1.ama65,g_ama_1.ama87,g_ama_1.ama88,g_ama_1.ama89,g_ama_1.ama97
#
#      AFTER FIELD ama66
#         IF NOT cl_null(g_ama_1.ama62) AND NOT cl_null(g_ama_1.ama63) AND NOT cl_null(g_ama_1.ama66)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama62 + g_ama_1.ama63 + g_ama_1.ama66
#            IF l_n != g_ama_1.ama61 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama30,g_ama_1.ama42,g_ama_1.ama54,g_ama_1.ama66,g_ama_1.ama78) RETURNING g_ama_1.ama90
#         DISPLAY BY NAME g_ama_1.ama90
#
#      AFTER FIELD ama68									
#         IF NOT cl_null(g_ama_1.ama68) AND NOT cl_null(g_ama_1.ama69) AND NOT cl_null(g_ama_1.ama72)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama68 + g_ama_1.ama69 + g_ama_1.ama72
#            IF l_n != g_ama_1.ama67 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama32,g_ama_1.ama44,g_ama_1.ama56,g_ama_1.ama68,g_ama_1.ama80) RETURNING g_ama_1.ama92
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama92,g_ama_1.ama97
#
#      AFTER FIELD ama69
#         IF NOT cl_null(g_ama_1.ama69) THEN
#            CALL i001_temp(g_ama_1.ama69) RETURNING g_ama_1.ama70
#            LET g_ama_1.ama71 = g_ama_1.ama69 - g_ama_1.ama70
#         ELSE
#            LET g_ama_1.ama69 = NULL
#            LET g_ama_1.ama70 = NULL
#         END IF
#         IF NOT cl_null(g_ama_1.ama68) AND NOT cl_null(g_ama_1.ama69) AND NOT cl_null(g_ama_1.ama72)  THEN
#         LET l_n = 0
#         LET l_n = g_ama_1.ama68 + g_ama_1.ama69 + g_ama_1.ama72
#            IF l_n != g_ama_1.ama67 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#        END IF	
#         CALL i001_1_sum(g_ama_1.ama33,g_ama_1.ama45,g_ama_1.ama57,g_ama_1.ama69,g_ama_1.ama81) RETURNING g_ama_1.ama93
#         CALL i001_1_sum(g_ama_1.ama34,g_ama_1.ama46,g_ama_1.ama58,g_ama_1.ama70,g_ama_1.ama82) RETURNING g_ama_1.ama94
#         CALL i001_1_sum(g_ama_1.ama35,g_ama_1.ama47,g_ama_1.ama59,g_ama_1.ama71,g_ama_1.ama83) RETURNING g_ama_1.ama95
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama70,g_ama_1.ama71,g_ama_1.ama93,g_ama_1.ama94,g_ama_1.ama95,g_ama_1.ama97
#
#      AFTER FIELD ama72
#         IF NOT cl_null(g_ama_1.ama68) AND NOT cl_null(g_ama_1.ama69) AND NOT cl_null(g_ama_1.ama72)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama68 + g_ama_1.ama69 + g_ama_1.ama72
#            IF l_n != g_ama_1.ama67 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama36,g_ama_1.ama48,g_ama_1.ama60,g_ama_1.ama72,g_ama_1.ama84) RETURNING g_ama_1.ama96
#         DISPLAY BY NAME g_ama_1.ama96
#
#      AFTER FIELD ama74									
#         IF NOT cl_null(g_ama_1.ama74) AND NOT cl_null(g_ama_1.ama75) AND NOT cl_null(g_ama_1.ama78)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama74 + g_ama_1.ama75 + g_ama_1.ama78
#            IF l_n != g_ama_1.ama73 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama26,g_ama_1.ama38,g_ama_1.ama50,g_ama_1.ama62,g_ama_1.ama74) RETURNING g_ama_1.ama86
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama86,g_ama_1.ama97
#
#      AFTER FIELD ama75
#         IF NOT cl_null(g_ama_1.ama75) THEN
#            CALL i001_temp(g_ama_1.ama75) RETURNING g_ama_1.ama76
#            LET g_ama_1.ama77 = g_ama_1.ama75 - g_ama_1.ama76
#         ELSE
#            LET g_ama_1.ama75 = NULL
#            LET g_ama_1.ama76 = NULL
#         END IF
#         IF NOT cl_null(g_ama_1.ama74) AND NOT cl_null(g_ama_1.ama75) AND NOT cl_null(g_ama_1.ama78)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama74 + g_ama_1.ama75 + g_ama_1.ama78
#            IF l_n != g_ama_1.ama73 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama27,g_ama_1.ama39,g_ama_1.ama51,g_ama_1.ama63,g_ama_1.ama75) RETURNING g_ama_1.ama87
#         CALL i001_1_sum(g_ama_1.ama28,g_ama_1.ama40,g_ama_1.ama52,g_ama_1.ama64,g_ama_1.ama76) RETURNING g_ama_1.ama88
#         CALL i001_1_sum(g_ama_1.ama29,g_ama_1.ama41,g_ama_1.ama53,g_ama_1.ama65,g_ama_1.ama77) RETURNING g_ama_1.ama89
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama76,g_ama_1.ama77,g_ama_1.ama87,g_ama_1.ama88,g_ama_1.ama89,g_ama_1.ama97
#
#      AFTER FIELD ama78
#         IF NOT cl_null(g_ama_1.ama80) AND NOT cl_null(g_ama_1.ama81) AND NOT cl_null(g_ama_1.ama84)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama80 + g_ama_1.ama81 + g_ama_1.ama84
#            IF l_n != g_ama_1.ama79 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama32,g_ama_1.ama44,g_ama_1.ama56,g_ama_1.ama68,g_ama_1.ama80) RETURNING g_ama_1.ama92
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama92,g_ama_1.ama97
#
#      AFTER FIELD ama80
#         IF NOT cl_null(g_ama_1.ama80) AND NOT cl_null(g_ama_1.ama81) AND NOT cl_null(g_ama_1.ama84)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama80 + g_ama_1.ama81 + g_ama_1.ama84
#            IF l_n != g_ama_1.ama79 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama32,g_ama_1.ama44,g_ama_1.ama56,g_ama_1.ama68,g_ama_1.ama80) RETURNING g_ama_1.ama92
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama92,g_ama_1.ama97
#
#      AFTER FIELD ama81
#         IF NOT cl_null(g_ama_1.ama81) THEN
#            CALL i001_temp(g_ama_1.ama81) RETURNING g_ama_1.ama82
#            LET g_ama_1.ama83 = g_ama_1.ama81 - g_ama_1.ama82
#         ELSE
#            LET g_ama_1.ama81 = NULL
#            LET g_ama_1.ama82 = NULL
#         END IF
#         IF NOT cl_null(g_ama_1.ama80) AND NOT cl_null(g_ama_1.ama81) AND NOT cl_null(g_ama_1.ama84)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama80 + g_ama_1.ama81 + g_ama_1.ama84
#            IF l_n != g_ama_1.ama79 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama33,g_ama_1.ama45,g_ama_1.ama57,g_ama_1.ama69,g_ama_1.ama81) RETURNING g_ama_1.ama93
#         CALL i001_1_sum(g_ama_1.ama34,g_ama_1.ama46,g_ama_1.ama58,g_ama_1.ama70,g_ama_1.ama82) RETURNING g_ama_1.ama94
#         CALL i001_1_sum(g_ama_1.ama35,g_ama_1.ama47,g_ama_1.ama59,g_ama_1.ama71,g_ama_1.ama83) RETURNING g_ama_1.ama95
#         LET g_ama_1.ama97 =  g_ama_1.ama86 + g_ama_1.ama87 + g_ama_1.ama92 + g_ama_1.ama93
#         DISPLAY BY NAME g_ama_1.ama82,g_ama_1.ama83,g_ama_1.ama93,g_ama_1.ama94,g_ama_1.ama95,g_ama_1.ama97
#
#      AFTER FIELD ama84
#         IF NOT cl_null(g_ama_1.ama80) AND NOT cl_null(g_ama_1.ama81) AND NOT cl_null(g_ama_1.ama84)  THEN
#            LET l_n = 0
#            LET l_n = g_ama_1.ama80 + g_ama_1.ama81 + g_ama_1.ama84
#            IF l_n != g_ama_1.ama79 THEN
#               CALL cl_err('','amd-034',0)
#            END IF
#         END IF
#         CALL i001_1_sum(g_ama_1.ama36,g_ama_1.ama48,g_ama_1.ama60,g_ama_1.ama72,g_ama_1.ama84) RETURNING g_ama_1.ama96
#         DISPLAY BY NAME g_ama_1.ama96
#
#      ON ACTION CONTROLG
#         CALL cl_cmdask()
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
#      AFTER INPUT
#         IF INT_FLAG THEN
#            LET INT_FLAG = 0
#            LET g_ama_1.ama26 = g_ama_1_t.ama26
#            LET g_ama_1.ama27 = g_ama_1_t.ama27
#            LET g_ama_1.ama30 = g_ama_1_t.ama30
#      
#            LET g_ama_1.ama32 = g_ama_1_t.ama32
#            LET g_ama_1.ama33 = g_ama_1_t.ama33
#            LET g_ama_1.ama36 = g_ama_1_t.ama36
#
#            LET g_ama_1.ama38 = g_ama_1_t.ama38
#            LET g_ama_1.ama39 = g_ama_1_t.ama39
#            LET g_ama_1.ama42 = g_ama_1_t.ama42
#
#            LET g_ama_1.ama44 = g_ama_1_t.ama44
#            LET g_ama_1.ama45 = g_ama_1_t.ama45
#            LET g_ama_1.ama48 = g_ama_1_t.ama48
#
#            LET g_ama_1.ama50 = g_ama_1_t.ama50
#            LET g_ama_1.ama51 = g_ama_1_t.ama51
#            LET g_ama_1.ama54 = g_ama_1_t.ama54
#
#            LET g_ama_1.ama56 = g_ama_1_t.ama56
#            LET g_ama_1.ama57 = g_ama_1_t.ama57
#            LET g_ama_1.ama60 = g_ama_1_t.ama60
#
#            LET g_ama_1.ama62 = g_ama_1_t.ama62
#            LET g_ama_1.ama63 = g_ama_1_t.ama63
#            LET g_ama_1.ama66 = g_ama_1_t.ama66
#
#            LET g_ama_1.ama68 = g_ama_1_t.ama68
#            LET g_ama_1.ama69 = g_ama_1_t.ama69
#            LET g_ama_1.ama72 = g_ama_1_t.ama72
#
#            LET g_ama_1.ama74 = g_ama_1_t.ama74
#            LET g_ama_1.ama75 = g_ama_1_t.ama75
#            LET g_ama_1.ama78 = g_ama_1_t.ama78
#
#            LET g_ama_1.ama80 = g_ama_1_t.ama80
#            LET g_ama_1.ama81 = g_ama_1_t.ama81
#            LET g_ama_1.ama84 = g_ama_1_t.ama84
#            RETURN
#         END IF
#         IF g_ama_1.ama25 != g_ama_1.ama26 + g_ama_1.ama27 + g_ama_1.ama30 THEN
#             CALL cl_err('','amd-034',1)
#             NEXT FIELD ama26
#         END IF
#         IF g_ama_1.ama31 != g_ama_1.ama32 + g_ama_1.ama33 + g_ama_1.ama36 THEN
#             CALL cl_err('','amd-034',1)
#             NEXT FIELD ama32
#         END IF
#         IF g_ama_1.ama37 != g_ama_1.ama38 + g_ama_1.ama39 + g_ama_1.ama42 THEN
#            CALL cl_err('','amd-034',1)
#            NEXT FIELD ama38
#         END IF
#         IF g_ama_1.ama43 != g_ama_1.ama44 + g_ama_1.ama45 + g_ama_1.ama48 THEN
#            CALL cl_err('','amd-034',1)
#            NEXT FIELD ama44 
#         END IF
#         IF g_ama_1.ama49 != g_ama_1.ama50 + g_ama_1.ama51 + g_ama_1.ama54 THEN
#            CALL cl_err('','amd-034',1)
#            NEXT FIELD ama50
#         END IF
#         IF g_ama_1.ama55 != g_ama_1.ama56 + g_ama_1.ama57 + g_ama_1.ama60 THEN
#            CALL cl_err('','amd-034',1)
#            NEXT FIELD ama56
#         END IF
#         IF g_ama_1.ama61 != g_ama_1.ama62 + g_ama_1.ama63 + g_ama_1.ama66 THEN
#            CALL cl_err('','amd-034',1)
#            NEXT FIELD ama62
#         END IF
#         IF g_ama_1.ama67 != g_ama_1.ama68 + g_ama_1.ama69 + g_ama_1.ama72  THEN
#            CALL cl_err('','amd-034',1)
#            NEXT FIELD ama68
#         END IF
#         IF g_ama_1.ama73 != g_ama_1.ama74 + g_ama_1.ama75 + g_ama_1.ama78 THEN
#            CALL cl_err('','amd-034',1)
#            NEXT FIELD ama74
#         END IF
#         IF g_ama_1.ama79 != g_ama_1.ama80 + g_ama_1.ama81 + g_ama_1.ama84 THEN
#            CALL cl_err('','amd-034',1)
#            NEXT FIELD ama80
#         END IF
#   END INPUT
#END FUNCTION
#
#FUNCTION i001_temp(p_ama01)
#DEFINE p_ama01,l_ama98  LIKE type_file.num10
#DEFINE l_n1             LIKE type_file.num20_6
#DEFINE temp_num         LIKE type_file.num10
#   SELECT ama98 INTO l_ama98 FROM ama_file WHERE ama01 = g_ama[l_ac].ama01
#   LET l_n1 = p_ama01*(1 - l_ama98/100)		
#   CALL cl_digcut(l_n1,0) RETURNING temp_num
#   RETURN temp_num
#END FUNCTION
#
#FUNCTION i001_1_show()
#   
#   SELECT ama25,ama26,ama27,ama28,ama29,ama30,ama31,ama32,ama33,ama34,ama35,ama36,
#          ama37,ama38,ama39,ama40,ama41,ama42,ama43,ama44,ama45,ama46,ama47,ama48,
#          ama49,ama50,ama51,ama52,ama53,ama54,ama55,ama56,ama57,ama58,ama59,ama60,
#          ama61,ama62,ama63,ama64,ama65,ama66,ama67,ama68,ama69,ama70,ama71,ama72,
#          ama73,ama74,ama75,ama76,ama77,ama78,ama79,ama80,ama81,ama82,ama83,ama84,
#          ama85,ama86,ama87,ama88,ama89,ama90,ama91,ama92,ama93,ama94,ama95,ama96,
#          ama97,ama98 INTO g_ama_1.* FROM ama_file
#    WHERE ama01 = g_ama[l_ac].ama01
#   DISPLAY BY NAME g_ama_1.ama25,g_ama_1.ama26,g_ama_1.ama27,g_ama_1.ama28,g_ama_1.ama29,g_ama_1.ama30,
#                   g_ama_1.ama31,g_ama_1.ama32,g_ama_1.ama33,g_ama_1.ama34,g_ama_1.ama35,g_ama_1.ama36,
#                   g_ama_1.ama37,g_ama_1.ama38,g_ama_1.ama39,g_ama_1.ama40,g_ama_1.ama41,g_ama_1.ama42,
#                   g_ama_1.ama43,g_ama_1.ama44,g_ama_1.ama45,g_ama_1.ama46,g_ama_1.ama47,g_ama_1.ama48,
#                   g_ama_1.ama49,g_ama_1.ama50,g_ama_1.ama51,g_ama_1.ama52,g_ama_1.ama53,g_ama_1.ama54,
#                   g_ama_1.ama55,g_ama_1.ama56,g_ama_1.ama57,g_ama_1.ama58,g_ama_1.ama59,g_ama_1.ama60,
#                   g_ama_1.ama61,g_ama_1.ama62,g_ama_1.ama63,g_ama_1.ama64,g_ama_1.ama65,g_ama_1.ama66,
#                   g_ama_1.ama67,g_ama_1.ama68,g_ama_1.ama69,g_ama_1.ama70,g_ama_1.ama71,g_ama_1.ama72,
#                   g_ama_1.ama73,g_ama_1.ama74,g_ama_1.ama75,g_ama_1.ama76,g_ama_1.ama77,g_ama_1.ama78,
#                   g_ama_1.ama79,g_ama_1.ama80,g_ama_1.ama81,g_ama_1.ama82,g_ama_1.ama83,g_ama_1.ama84,
#                   g_ama_1.ama85,g_ama_1.ama86,g_ama_1.ama87,g_ama_1.ama88,g_ama_1.ama89,g_ama_1.ama90,
#                   g_ama_1.ama91,g_ama_1.ama92,g_ama_1.ama93,g_ama_1.ama94,g_ama_1.ama95,g_ama_1.ama96,
#                   g_ama_1.ama97,g_ama_1.ama98
#END FUNCTION
#
#FUNCTION i001_1_sum(a1,a2,a3,a4,a5)
#DEFINE a1    LIKE type_file.num20_6,
#       a2    LIKE type_file.num20_6,
#       a3    LIKE type_file.num20_6,
#       a4    LIKE type_file.num20_6,
#       a5    LIKE type_file.num20_6,
#       a6    LIKE type_file.num20_6
#
#      if cl_null(a1) then LET a1 = 0 end if
#      if cl_null(a2) then LET a2 = 0 end if
#      if cl_null(a3) then LET a3 = 0 end if
#      if cl_null(a4) then LET a4 = 0 end if
#      if cl_null(a5) then LET a5 = 0 end if
#
#      LET a6 = a1 + a2 + a3 + a4 - a5
#      CALL cl_digcut(a6,0) RETURNING a6 
#      return a6
#
#END FUNCTION
#
#FUNCTION i001_gwlw()
#
#   open WINDOW amdi001_2 WITH FORM "amd/42f/amdi001_2"
#      ATTRIBUTE (STYLE = g_win_style CLIPPED)
#
#   CALL cl_ui_init()
#   
#   LET g_sql = "SELECT ama99,ama100,ama101,ama102,ama103,ama104,ama105 ",
#               "  FROM ama_file ",
#               " WHERE ama01 = ?"
#   PREPARE i001_2_pre FROM g_sql
#   DECLARE i001_2_cl CURSOR FOR i001_2_pre
#
#   Call amdi001_2_tm()
#
#   CLOSE WINDOW amdi001_2
#END FUNCTION
#
#FUNCTION amdi001_2_tm()
#
#   IF s_shut(0) THEN
#      RETURN
#   END IF
#
#   IF g_ama[l_ac].ama01 IS NULL THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
#
#   SELECT ama99,ama100,ama101,ama102,ama103,ama104,ama105 INTO g_ama_2.* FROM ama_file
#    WHERE ama01 = g_ama[l_ac].ama01
#
#   IF g_ama[l_ac].amaacti ='N' THEN  
#      CALL cl_err(g_ama[l_ac].ama01,'mfg1000',0)
#      RETURN
#   END IF
#   MESSAGE ""
#   CALL cl_opmsg('u')
#   BEGIN WORK
# 
#   OPEN i001_2_cl USING g_ama[l_ac].ama01
#   IF STATUS THEN
#      CALL cl_err("OPEN i001_2_cl:", STATUS, 1)
#      CLOSE i001_2_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH i001_2_cl INTO g_ama_2.* 
#   IF SQLCA.sqlcode THEN
#       CALL cl_err('',SQLCA.sqlcode,0) 
#       CLOSE i001_2_cl
#       ROLLBACK WORK
#       RETURN
#   END IF
#
#   CALL i001_2_show()
#
#   WHILE TRUE
#      LET g_ama_2_t.* = g_ama_2.*
#      CALL i001_2_i("u")  
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         LET g_ama_2.* = g_ama_2_t.*
#         CALL i001_2_show()
#         CALL cl_err('','9001',0)
#         EXIT WHILE
#      END IF
#
#      UPDATE ama_file SET  ama99 = g_ama_2.ama99,ama100 = g_ama_2.ama100,
#                          ama101 = g_ama_2.ama101,ama102 = g_ama_2.ama102,
#                          ama103 = g_ama_2.ama103,ama104 = g_ama_2.ama104,
#                          ama105 = g_ama_2.ama105
#       WHERE ama01 = g_ama[l_ac].ama01
#      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL cl_err3("upd","ama_file","","",SQLCA.sqlcode,"","",1)  
#         CONTINUE WHILE
#      END IF
#      EXIT WHILE
#   END WHILE
# 
#   CLOSE i001_2_cl
#   COMMIT WORK
#
#END FUNCTION
#
#FUNCTION i001_2_i(p_cmd)
#DEFINE l_n         LIKE type_file.num5
#DEFINE l_n1       LIKE type_file.num20_6
#DEFINE p_cmd       LIKE type_file.chr8  
#DEFINE li_result   LIKE type_file.num5
#DEFINE l_ama98     LIKE type_file.num10
# 
#   IF s_shut(0) THEN
#      RETURN
#   END IF
# 
#   DISPLAY BY NAME g_ama_2.ama99,g_ama_2.ama100,g_ama_2.ama101,g_ama_2.ama102,
#                   g_ama_2.ama103,g_ama_2.ama104,g_ama_2.ama105
#                   
#   INPUT BY NAME   g_ama_2.ama100,g_ama_2.ama101,g_ama_2.ama102
#          WITHOUT DEFAULTS
# 
#      BEFORE INPUT
#         LET g_before_input_done = FALSE
#         SELECT ama98 INTO l_ama98 FROM ama_file WHERE ama01 = g_ama[l_ac].ama01
#         DISPLAY l_ama98 TO ama98
#         LET g_before_input_done = TRUE
#
#      AFTER FIELD ama100
#         if not cl_null(g_ama_2.ama100) then
#            LET l_n1 = g_ama_2.ama100 * 0.05
#            CALL cl_digcut(l_n1,0) RETURNING g_ama_2.ama104
#            if not cl_null(g_ama_2.ama105) then
#               LET g_ama_2.ama103 = g_ama_2.ama104 + g_ama_2.ama105
#            end if
#            if not cl_null(g_ama_2.ama101) and not cl_null(g_ama_2.ama102) then
#               IF g_ama_2.ama99 != g_ama_2.ama100 + g_ama_2.ama101 + g_ama_2.ama102 THEN
#                   CALL cl_err('','amd-035',0) 
#               END IF
#            end if
#         ELSE 
#            LET g_ama_2.ama104 = 0
#            IF NOT cl_null(g_ama_2.ama105) THEN
#               LET g_ama_2.ama103 = g_ama_2.ama105
#            ELSE
#               LET g_ama_2.ama103 = 0
#            END IF
#         END if
#         DISPLAY BY NAME g_ama_2.ama99,g_ama_2.ama103,g_ama_2.ama104
#      
#      AFTER FIELD ama101
#         if not cl_null(g_ama_2.ama101) then
#            LET l_n1 = g_ama_2.ama101 *  l_ama98 * 0.05
#            CALL cl_digcut(l_n1,0) RETURNING g_ama_2.ama105
#            if not cl_null(g_ama_2.ama104) then
#               LET g_ama_2.ama103 = g_ama_2.ama104 + g_ama_2.ama105
#            end if
#            if not cl_null(g_ama_2.ama100) and not cl_null(g_ama_2.ama102) then
#               IF g_ama_2.ama99 != g_ama_2.ama100 + g_ama_2.ama101 + g_ama_2.ama102 THEN
#                   CALL cl_err('','amd-035',0) 
#               END IF
#            end if
#         ELSE
#            LET g_ama_2.ama105 = 0
#            IF NOT cl_null(g_ama_2.ama104) THEN
#               LET g_ama_2.ama103 = g_ama_2.ama104
#            ELSE
#               LET g_ama_2.ama103 = 0
#            END IF
#         END if
#         DISPLAY BY NAME g_ama_2.ama99,g_ama_2.ama103,g_ama_2.ama105
#
#      AFTER FIELD ama102
#         if not cl_null(g_ama_2.ama100) and not cl_null(g_ama_2.ama101) and not cl_null(g_ama_2.ama102) then
#             IF g_ama_2.ama99 != g_ama_2.ama100 + g_ama_2.ama101 + g_ama_2.ama102 THEN
#                 CALL cl_err('','amd-035',0) 
#             END IF
#         end if
#         DISPLAY BY NAME g_ama_2.ama99,g_ama_2.ama104,g_ama_2.ama105
# 
#      ON ACTION CONTROLG
#         CALL cl_cmdask()
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
#      AFTER INPUT
#         IF INT_FLAG THEN
#            LET INT_FLAG = 0
#            LET g_ama_2.ama100 = g_ama_2_t.ama100
#            LET g_ama_2.ama101 = g_ama_2_t.ama101
#            LET g_ama_2.ama102 = g_ama_2_t.ama102
#            RETURN
#         END IF
#
#         IF g_ama_2.ama99 != g_ama_2.ama100 + g_ama_2.ama101 + g_ama_2.ama102 THEN
#             CALL cl_err('','amd-035',0) 
#             NEXT FIELD ama100
#         END IF
#   END INPUT
#END FUNCTION
#
#FUNCTION i001_2_show()
#   SELECT ama99,ama100,ama101,ama102,ama103,ama104,ama105 INTO g_ama_2.* FROM ama_file
#    WHERE ama01 = g_ama[l_ac].ama01
#    
#   DISPLAY BY NAME g_ama_2.ama99,g_ama_2.ama100,g_ama_2.ama101,g_ama_2.ama102,
#                   g_ama_2.ama103,g_ama_2.ama104,g_ama_2.ama105
#
#END FUNCTION
##FUN-B40054--add-end---
#FUN-BA0021---End---
