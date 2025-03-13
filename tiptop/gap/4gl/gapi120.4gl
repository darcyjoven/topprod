# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: gapi120.4gl
# Descriptions...: 收/退貨單發票資料維護作業
# Date & Author..: 02/03/25 By Danny
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0237 04/10/26 By Kammy apm-241的判斷移到BEFORE ROW
# Modify.........: No.MOD-4B0004 04/11/01 By ching 依匯率算本幣
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-4B0228 04/11/24 By ching 抓幣別取位
# Modify.........: No.MOD-530687 05/03/28 By Elva 修正大陸版運輸發票的算法
# Modify ........: No.MOD-540169 05/07/18 By ice 以大陸的情況,發票錄入時對應入庫單,不再對應收貨單。
# Modify ........: No.FUN-580006 05/08/17 By ice 有稅控時,發票代碼Required
# Modify ........: No.FUN-630068 06/04/05 By Ray 修改‘A’性質稅種的稅額計算方法，同‘T’性質稅種
# Modify.........: No.FUN-660071 06/06/13 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0009 06/10/12 By jamie 1.FUNCTION i120()_q 一開始應清空g_head_1.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.MOD-710023 07/01/03 By Smapmin 幣別開窗
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740069 07/04/13 By Judy 單身"品名規格"顯示為"1"
# Modify.........: No.MOD-750109 07/05/23 By Smapmin 取消項次開窗
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-750089 07/05/30 By Rayven 加一個整批產生單身的Action
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: No.MOD-8B0247 08/11/24 By chenyu 本幣金額算法調整成和gapi140一樣 
# Modify.........: No.MOD-910042 09/01/06 By chenyu 刪除時，發票號碼要還原成和原來一樣的NULL
# Modify.........: No.FUN-940083 09/06/02 By douzh VMI新增相關流程
# Modify.........: No.MOD-980053 09/08/10 By Smapmin 發票數量不正確
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-970028 09/09/21 By baofei 由發票金額帶出數量，增加發票金額和入庫金額不等時的控管                          
# Modify.........: No.FUN-9B0146 09/11/26 By lutingting rvw_file去除rvwplant
# Modify.........: No:MOD-A10029 10/01/06 By Sarah 當異動類別為3.退貨時,若數量>0則需*-1;當異動類別為1.入庫時,若數量<0則需*-1
# Modify.........: No:MOD-A20066 10/02/09 By Sarah 刪除發票前,檢查該發票是否存在折讓單(aapt210)裡,若存在則不可刪除
# Modify.........: No.FUN-A60056 10/06/25 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:MOD-A80052 10/08/09 By Dido 若為運輸發票(gec05='T')時,稅額與未稅金額邏輯調整 
# Modify.........: No:MOD-B30660 11/03/24 By Dido 單身異動時 rvw17 需再重新抓取
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B50016 11/05/04 By Sarah 若為樣品時,金額部份(rvw17,rvw05,rvw05f,rvw06,rvw06f)應帶0
# Modify.........: No:MOD-B70210 11/07/25 By Polly 修正用gapi140查詢時，營運中心為NULL
# Modify.........: No.FUN-C80027 12/08/07 By minpp 增加原币含税，本币含税，原币未税合计，本币未税合计
# Modify.........: No.FUN-D10064 13/03/19 By minpp rvw_file新增字段非空rvwacti，给rvwacti默认值'Y'
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_head_1        RECORD
                     #No.MOD-540169 --start--
                    rvu01  LIKE rvu_file.rvu01,
                    rvu03  LIKE rvu_file.rvu03,
                    rvu04  LIKE rvu_file.rvu04,
                    rvu05  LIKE rvu_file.rvu05
                     #No.MOD-540169 --end--
                    END RECORD,
    g_type          LIKE type_file.chr1,         #NO FUN-690009 VARCHAR(01)
    g_rvw           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    rvw09     LIKE rvw_file.rvw09,
                    rvw07     LIKE rvw_file.rvw07,
                    rvw01     LIKE rvw_file.rvw01,
                    rvw02     LIKE rvw_file.rvw02,
                    rvw03     LIKE rvw_file.rvw03,
                    rvw04     LIKE rvw_file.rvw04,
                    #modify 030425 bug no:A069
                    rvw11     LIKE rvw_file.rvw11,
                    rvw12     LIKE rvw_file.rvw12,
                    rvw05f    LIKE rvw_file.rvw05f,
                    rvw06f    LIKE rvw_file.rvw06f,
                    sum1      LIKE rvw_file.rvw05f,         #FUN-C80027 #原币含税金额 
                    ####
                    rvw05     LIKE rvw_file.rvw05,
                    rvw06     LIKE rvw_file.rvw06,
                    sum2      LIKE rvw_file.rvw05,           #FUN-C80027 #本币含税金额
                    rvw10     LIKE rvw_file.rvw10,
                    part      LIKE ima_file.ima01,
                    desc      LIKE ima_file.ima02
                    END RECORD,
    g_rvw_t         RECORD    #程式變數(Program Variables)
                    rvw09     LIKE rvw_file.rvw09,
                    rvw07     LIKE rvw_file.rvw07,
                    rvw01     LIKE rvw_file.rvw01,
                    rvw02     LIKE rvw_file.rvw02,
                    rvw03     LIKE rvw_file.rvw03,
                    rvw04     LIKE rvw_file.rvw04,
                    #030425 bug no:A069
                    rvw11     LIKE rvw_file.rvw11,
                    rvw12     LIKE rvw_file.rvw12,
                    rvw05f    LIKE rvw_file.rvw05f,
                    rvw06f    LIKE rvw_file.rvw06f,
                    sum1      LIKE rvw_file.rvw05f,         #FUN-C80027 #原币含税金额  
                    ####
                    rvw05     LIKE rvw_file.rvw05,
                    rvw06     LIKE rvw_file.rvw06,
                    sum2      LIKE rvw_file.rvw05,           #FUN-C80027 #本币含税金额
                    rvw10     LIKE rvw_file.rvw10,
                    part      LIKE ima_file.ima01,
                    desc      LIKE ima_file.ima02
                    END RECORD,
     g_argv1                   LIKE type_file.chr1,   #No.MOD-540169   #NO FUN-690009 VARCHAR(01)
     g_argv2                   LIKE rvw_file.rvw01,   #No.MOD-540169
     g_rvw_rvw17               LIKE rvw_file.rvw17,   #No.MOD-540169
     g_rvw10                   LIKE rvw_file.rvw10,   #No.MOD-540169   記錄未請款入庫數量
     g_rvw05f                  LIKE rvw_file.rvw05f,    #CHI-970028 add  記錄未請款入庫原幣金額                                               
     g_rvw05                   LIKE rvw_file.rvw05,     #CHI-970028 add  記錄未請款入庫本幣金額   
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
     g_tabname      STRING,       #No.FUN-660071
    g_rec_b         LIKE type_file.num5,     #NO FUN-690009 SMALLINT   #單身筆數
    g_buf           LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(40)
    l_ac            LIKE type_file.num5,     #NO FUN-690009 SMALLINT   #目前處理的ARRAY CNT
    g_gec05         LIKE gec_file.gec05,
    g_gec07         LIKE gec_file.gec07      #MOD-A80052
 
#主程式開始
DEFINE   g_forupd_sql    STRING            #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10     #NO FUN-690009 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03        #NO FUN-690009 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5     #NO FUN-690009 SMALLINT
 
DEFINE   g_row_count     LIKE type_file.num10     #NO FUN-690009 INTEGER 
DEFINE   g_curs_index    LIKE type_file.num10     #NO FUN-690009 INTEGER
DEFINE   g_jump          LIKE type_file.num10     #NO FUN-690009 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5      #NO FUN-690009 INTEGER
DEFINE   g_rvuplant      LIKE rvu_file.rvuplant   #FUN-A60056
#FUN-C80027---ADD---STR
DEFINE   
         g_rvw05f_sum LIKE rvw_file.rvw05f,        #未稅金額
         g_rvw06f_sum LIKE rvw_file.rvw06f,        #稅額
         g_sum3       LIKE rvw_file.rvw05f,        #原币含税金额合计
         g_rvw05_sum  LIKE rvw_file.rvw05,         #未稅金額
         g_rvw06_sum  LIKE rvw_file.rvw06,         #稅額
         g_sum4       LIKE rvw_file.rvw05          #本币含税金额合计
#FUN-C80027---ADD---end 

MAIN
DEFINE
#       l_time   LIKE type_file.chr8            #No.FUN-6A0097
   p_row,p_col   LIKE type_file.num5      #NO FUN-690009 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GAP")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
    LET g_argv1 = ARG_VAL(1)               #參數值(1) Type#No.MOD-540169
    LET g_argv2 = ARG_VAL(2)               #參數值(1) Invoice#No.MOD-540169
   LET p_row = 3 LET p_col = 4
   OPEN WINDOW i120_w AT p_row,p_col      #顯示畫面
        WITH FORM "gap/42f/gapi120"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
    #No.MOD-540169 --start--
   IF NOT cl_null(g_argv2) THEN
       LET g_action_choice="query"                       #MOD-4B0255
         IF cl_chk_act_auth() THEN
         CALL i120_q()
         LET g_argv2 = NULL
      END IF
   END IF
    #No.MOD-540169 --end--
 
   IF g_aza.aza26 != '2' THEN
      CALL cl_err('','tis-004',1) EXIT PROGRAM
   END IF
 
#    SELECT azi04,azi05 INTO g_azi04,g_azi05    #幣別檔小數位數讀取
#    FROM azi_file
#    WHERE azi01=g_aza.aza17                     #No.CHI-6A0004     
           
    LET g_type='1'                      #No.MOD-540169
   CALL i120_menu()
 
   CLOSE WINDOW i120_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
END MAIN
 
#QBE 查詢資料
FUNCTION i120_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01  #No.FUN-580031  HCN
DEFINE  l_wc            LIKE type_file.chr1000  #NO FUN-690009 VARCHAR(300)
DEFINE  i               LIKE type_file.num5     #NO FUN-690009 SMALLINT
 
   IF NOT cl_null(g_argv2) THEN
      LET g_type = g_argv1
      LET g_wc= " 1=1 "
      LET g_wc2= " rvw01 = '",g_argv2,"'"
   ELSE
      CLEAR FORM                          #清除畫面
      CALL g_rvw.clear()
      INPUT BY NAME g_type WITHOUT DEFAULTS
 
         BEFORE INPUT
            #No.FUN-580031 --start--     HCN
            CALL cl_qbe_init()
            #No.FUN-580031 --end--       HCN
 
         AFTER FIELD g_type
            IF cl_null(g_type) OR g_type NOT MATCHES '[13]' THEN
               NEXT FIELD g_type
            END IF
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
		#No.FUN-580031 --end--       HCN
 
      END INPUT
      IF INT_FLAG THEN RETURN END IF
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
      INITIALIZE g_head_1.* TO NULL      #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON rvu01,rvu03,rvu04
                #No.FUN-580031 --start--     HCN
                BEFORE CONSTRUCT
                   CALL cl_qbe_display_condition(lc_qbe_sn)
                #No.FUN-580031 --end--       HCN
 
            INITIALIZE g_head_1.* TO NULL
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
		#No.FUN-580031 --end--       HCN
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup') #FUN-980030
      IF INT_FLAG THEN RETURN END IF
 
      #modify 030425 bug no:A069
      CONSTRUCT g_wc2 ON rvw09,rvw07,rvw01,rvw02,rvw03,  # 螢幕上取單身條件
                         rvw04,rvw11,rvw12,rvw05f,rvw06f,sum1,rvw05,rvw06,sum2,rvw10    #FUN-C80027  add--sum1,sum2
                    FROM s_rvw[1].rvw09, s_rvw[1].rvw07, s_rvw[1].rvw01,
                         s_rvw[1].rvw02, s_rvw[1].rvw03, s_rvw[1].rvw04,
                         s_rvw[1].rvw11, s_rvw[1].rvw12, s_rvw[1].rvw05f,
                         s_rvw[1].rvw06f,s_rvw[1].sum1,  s_rvw[1].rvw05,      #FUN-C80027  add--sum1
                         s_rvw[1].rvw06,s_rvw[1].sum2,                        #FUN-C80027  add--sum2
                         s_rvw[1].rvw10
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
         ON ACTION CONTROLP
            CASE
#-----MOD-750109---------
{
               WHEN INFIELD(rvw09)
                   #No.MOD-540169 --start--
                  CALL q_rvv(TRUE,TRUE,g_head_1.rvu04,g_head_1.rvu01,'') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvw09
#                 IF g_type = '1' THEN
#                    CALL q_rvb7(0,0,g_head.rvu01,g_rvw[1].rvw09,g_head.rvu01) RETURNING g_rvw[1].rvw09
#                    CALL q_rvb7(TRUE,TRUE,g_head.rvu01,g_rvw[1].rvw09,g_head.rvu01) RETURNING g_qryparam.multiret
#                 ELSE
#                    CALL q_rvv(0,0,g_head.rvu04,g_head.rvu01,'') RETURNING g_buf,g_rvw[1].rvw09
#                    CALL q_rvv(TRUE,TRUE,g_head.rvu04,g_head.rvu01,'') RETURNING g_qryparam.multiret
#                 END IF
                  NEXT FIELD rvw09
                   #No.MOD-540169 --end--
}
#-----END MOD-750109-----
               WHEN INFIELD(rvw03)
#                 CALL q_gec(0,0,g_rvw[1].rvw03,'1') RETURNING g_rvw[1].rvw03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gec"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvw03
                  NEXT FIELD rvw03
               #-----MOD-710023---------
               WHEN INFIELD(rvw11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvw11
                  NEXT FIELD rvw11
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
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    END IF                        #No.MOD-540169
 
   IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
     #LET g_sql = "SELECT rvu01 FROM rvu_file",    #FUN-A60056
      LET g_sql = "SELECT rvu01,rvuplant FROM ",cl_get_target_table(g_plant,'rvu_file'),   #FUN-A60056
                  " WHERE rvu00 = '",g_type,"' ",      #No.MOD-540169
                  "   AND rvuconf = 'Y' ",
                  "   AND ", g_wc CLIPPED,
                  " ORDER BY rvu01"
   ELSE					# 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE rvu01,rvuplant ",  #FUN-A60056 add rvuplant
                 #"  FROM rvu_file, rvw_file",   #FUN-A60056
                  "  FROM ",cl_get_target_table(g_plant,'rvu_file'),",rvw_file",
                  " WHERE rvu00 = '",g_type,"' ",   #No.MOD-540169
                  "   AND rvuconf = 'Y' ",
                  "   AND rvu01 = rvw08 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY rvu01"
   END IF
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql    #FUN-A60056
   PREPARE i120_prepare FROM g_sql
   IF STATUS THEN
      CALL cl_err('i120_prepare',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE i120_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i120_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
     #LET g_sql="SELECT COUNT(*) FROM rvu_file ",   #FUN-A60056
      LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant,'rvu_file'),   #FUN-A60056
                 " WHERE rvu00 = '",g_type,"' ",  #No.MOD-540169
                "   AND rvuconf = 'Y' ",
                "   AND ",g_wc CLIPPED
   ELSE
     #LET g_sql="SELECT COUNT(DISTINCT rvu01) FROM rvu_file,rvw_file",   #FUN-A60056
      LET g_sql="SELECT COUNT(DISTINCT rvu01) FROM ",cl_get_target_table(g_plant,'rvu_file'),",rvw_file",   #FUN-A60056
                 " WHERE rvu00 = '",g_type,"' ",  #No.MOD-540169
                "   AND rvuconf = 'Y' ",
                "   AND rvu01 = rvw08 ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql    #FUN-A60056
   PREPARE i120_precount FROM g_sql
   IF STATUS THEN
      CALL cl_err('i120_precount',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE i120_count CURSOR FOR i120_precount
END FUNCTION
 
FUNCTION i120_menu()
 
   WHILE TRUE
      CALL i120_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i120_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i120_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0009
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_rvw),'','')
             END IF
         #--
 
         #No.FUN-750089 --start--
         WHEN "batchi_generate_body_data"
             IF cl_chk_act_auth() THEN
                CALL i120_bgbd()
             END IF
         #No.FUN-750089 --end--
 
         #No.FUN-6A0009-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_head_1.rvu01 IS NOT NULL THEN
                 LET g_doc.column1 = "rvu01"
                 LET g_doc.value1 = g_head_1.rvu01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0009-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i120_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_head_1.* TO NULL             #No.FUN-6A0009
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i120_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_head_1.* TO NULL
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN i120_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_head_1.* TO NULL
   ELSE
      OPEN i120_count
      FETCH i120_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i120_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i120_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(1)  #處理方式
   l_abso          LIKE type_file.num10     #NO FUN-690009 INTEGER  #絕對的筆數
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i120_cs INTO g_head_1.rvu01,g_rvuplant   #FUN-A60056 add rvuplant
      WHEN 'P' FETCH PREVIOUS i120_cs INTO g_head_1.rvu01,g_rvuplant   #FUN-A60056 add rvuplant
      WHEN 'F' FETCH FIRST    i120_cs INTO g_head_1.rvu01,g_rvuplant   #FUN-A60056 add rvuplant
      WHEN 'L' FETCH LAST     i120_cs INTO g_head_1.rvu01,g_rvuplant   #FUN-A60056 add rvuplant
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
                ON ACTION about         #MOD-4C0121
                   CALL cl_about()      #MOD-4C0121
 
                ON ACTION help          #MOD-4C0121
                   CALL cl_show_help()  #MOD-4C0121
 
                ON ACTION controlg      #MOD-4C0121
                   CALL cl_cmdask()     #MOD-4C0121
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i120_cs INTO g_head_1.rvu01,g_rvuplant   #FUN-A60056 add rvuplant
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_head_1.rvu01,SQLCA.sqlcode,0)
      INITIALIZE g_head_1.* TO NULL  #TQC-6B0105
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
#FUN-A60056--mod--str--
#   #No.MOD-540169 --start--
#  SELECT rvu01,rvu03,rvu04,rvu05 INTO g_head_1.* FROM rvu_file
#   WHERE rvu01 = g_head_1.rvu01
#   #No.MOD-540169 --end--
   LET g_sql = "SELECT rvu01,rvu03,rvu04,rvu05 ",
               "  FROM ",cl_get_target_table(g_rvuplant,'rvu_file'),
               " WHERE rvu01 = '",g_head_1.rvu01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   
   CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
   PREPARE sel_rvu FROM g_sql
   EXECUTE sel_rvu INTO g_head_1.*
#FUN-A60056--mod--end
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_head_1.rvu01,SQLCA.sqlcode,0)  #No.FUN-660071
      CALL cl_err3("sel","rvu_file",g_head_1.rvu01,"",SQLCA.sqlcode,"","",1) #No.FUN-660071
      INITIALIZE g_head_1.* TO NULL
      RETURN
   END IF
   
   #FUN-C80027----ADD--STR
   SELECT SUM(rvw05f),SUM(rvw06f),SUM(rvw05),SUM(rvw06)
     INTO g_rvw05f_sum,g_rvw06f_sum,g_rvw05_sum,g_rvw06_sum
     FROM rvw_file
    WHERE rvw08 = g_head_1.rvu01  
    LET g_rvw05f_sum=cl_digcut(g_rvw05f_sum,t_azi04)
    LET g_rvw06f_sum=cl_digcut(g_rvw06f_sum,t_azi04)
    LET g_rvw05_sum =cl_digcut(g_rvw05_sum,t_azi04)
    LET g_rvw06_sum =cl_digcut(g_rvw06_sum,t_azi04)
    LET g_sum3= g_rvw05f_sum + g_rvw06f_sum
    LET g_sum4= g_rvw05_sum + g_rvw06_sum

   #FUN-C80027----ADD--END
   CALL i120_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i120_show()
 
    #No.MOD-540169 --start--
   DISPLAY BY NAME g_type
   DISPLAY g_head_1.rvu01,g_head_1.rvu03,g_head_1.rvu04,g_head_1.rvu05
        TO rvu01,rvu03,rvu04,rvu05
    #No.MOD-540169 --end--
    #FUN-C80027--ADD--STR
    SELECT SUM(rvw05f),SUM(rvw06f),SUM(rvw05),SUM(rvw06)
      INTO g_rvw05f_sum,g_rvw06f_sum,g_rvw05_sum,g_rvw06_sum
      FROM rvw_file WHERE rvw08=g_head_1.rvu01
       LET g_sum3=g_rvw05f_sum+g_rvw06f_sum
       LET g_sum4=g_rvw05_sum+g_rvw06_sum
       DISPLAY g_rvw05f_sum TO rvw05f_sum
       DISPLAY g_rvw06f_sum TO rvw06f_sum
       DISPLAY g_rvw05_sum  TO rvw05_sum
       DISPLAY g_rvw06_sum  TO rvw06_sum
       DISPLAY g_sum3       TO sum3
       DISPLAY g_sum4       TO sum4
   #FUN-C80027--ADD--END
   CALL i120_b_fill(g_wc2)                 #單身
END FUNCTION
 
FUNCTION i120_b()
DEFINE l_ac_t          LIKE type_file.num5,     #NO FUN-690009 SMALLINT       #未取消的ARRAY CNT
       l_n             LIKE type_file.num5,     #NO FUN-690009 SMALLINT       #檢查重複用
       l_lock_sw       LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(1)        #單身鎖住否
       p_cmd           LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(01) 
       l_cnt           LIKE type_file.num5,     #NO FUN-690009 SMALLINT
       l_rvw05f        LIKE rvw_file.rvw05f,    #CHI-970028                                                                             
       l_rvv39         LIKE rvv_file.rvv39,     #CHI-970028     
       l_rvw05f_t      LIKE rvw_file.rvw05f,    #No.MOD-530687 
       l_rvw05f_o      LIKE rvw_file.rvw05f,    #No.MOD-530687
       l_allow_insert  LIKE type_file.num5,     #NO FUN-690009 SMALLINT        #可新增否
       l_allow_delete  LIKE type_file.num5      #NO FUN-690009 SMALLINT        #可刪除否
#入庫發票的入庫數量不能大于入庫異動的入庫數量
DEFINE l_rvv17         LIKE rvv_file.rvv17,     #No.MOD-540169
       l_rvv04         LIKE rvv_file.rvv04,     #No.MOD-540169 收貨單號
       l_rvv05         LIKE rvv_file.rvv05,     #No.MOD-540169 收貨項次
       l_rvv25         LIKE rvv_file.rvv25,     #MOD-B50016 add
       l1_n            LIKE type_file.num5      #NO FUN-690009 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_head_1.rvu01) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   #modify 030425 bug no:A069
 
   LET g_forupd_sql = " SELECT rvw09,rvw07,rvw01,rvw02,rvw03,rvw04,rvw11,rvw12, ",
           #          "        rvw05f,rvw06f,rvw05,rvw06,rvw10,'','' ",                    #FUN-C80027 MARK
                      "        rvw05f,rvw06f,'',rvw05,rvw06,'',rvw10,'','' ",              #FUN-C80027
                      "   FROM rvw_file ",
                      "  WHERE rvw08 = ? ",
                      "    AND rvw09 = ? ",
                      "    AND rvw01 = ? ",
                      "    FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i120_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_rvw WITHOUT DEFAULTS FROM s_rvw.*
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
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_rvw_t.* = g_rvw[l_ac].*  #BACKUP
 
            BEGIN WORK
            OPEN i120_bcl USING g_head_1.rvu01,g_rvw_t.rvw09,g_rvw_t.rvw01
            IF STATUS THEN
               CALL cl_err("OPEN i120_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i120_bcl INTO g_rvw[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_rvw_t.rvw09,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
                #No.MOD-540169 --start--
              #FUN-A60056--mod--str--
              #SELECT rvv31,rvv031 INTO g_rvw[l_ac].part,g_rvw[l_ac].desc
              #  FROM rvv_file
              # WHERE rvv01 = g_head_1.rvu01 AND rvv02 = g_rvw[l_ac].rvw09
               LET g_sql = "SELECT rvv31,rvv031,rvv38 ",       #MOD-B30660 add rvv38
                           "  FROM ",cl_get_target_table(g_rvuplant,'rvv_file'),
                           " WHERE rvv01 = '",g_head_1.rvu01,"'",
                           "   AND rvv02 = '",g_rvw[l_ac].rvw09,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
               PREPARE sel_rvv31 FROM g_sql
               EXECUTE sel_rvv31 INTO g_rvw[l_ac].part,g_rvw[l_ac].desc,g_rvw_rvw17 #MOD-B30660 add rvw17
              #FUN-A60056--mod--end
                #No.MOD-4A0237
               SELECT COUNT(*) INTO l_cnt FROM apk_file
                WHERE apk03 = g_rvw[l_ac].rvw01
                   AND apk01 IN (SELECT apa01 FROM apa_file     #No.MOD-540169
                 WHERE apa00='11')                              #No.MOD-540169
              #str MOD-A20066 add
               #檢查發票是否存在退貨折讓帳款裡
               IF l_cnt = 0 THEN
                  SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
                   WHERE apb11 = g_rvw[l_ac].rvw01
                     AND apb01 = apa01 AND apa00='21'
               END IF
              #end MOD-A20066 add
               IF l_cnt > 0 THEN
                  CALL cl_err('','apm-241',0)
                  CALL i120_set_no_entry_b(p_cmd)
                 #NEXT FIELD rvw09   #MOD-A20066 mark
                  EXIT INPUT         #MOD-A20066 add
               ELSE
                  CALL i120_set_entry_b(p_cmd)
                  MESSAGE " "
               END IF
                #No.MOD-4A0237(end)
                #No.MOD-540169 --end--
#              LET g_before_input_done = FALSE
#              CALL i120_set_entry_b(p_cmd)
#              CALL i120_set_no_entry_b(p_cmd)
#              LET g_before_input_done = TRUE
            END IF
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         #No.FUN-580006 --start--
         IF cl_null(g_rvw[l_ac].rvw07) AND g_aza.aza46 = 'Y' THEN
            CALL cl_err('','gap-142',0)
            NEXT FIELD rvw07
         END IF
         #No.FUN-580006 --end--
         #NO.TQC-790003 start--
         IF cl_null(g_rvw[l_ac].rvw09) THEN LET g_rvw[l_ac].rvw09 = 0 END IF
         #NO.TQC-790003 end----
         INSERT INTO rvw_file(rvw01,rvw02,rvw03,rvw04,rvw11,rvw12,
                 rvw05f,rvw06f,rvw05,rvw06,rvw07,rvw08,rvw09,rvw10,rvw17,  #No.MOD-540169
                #rvwplant,rvwlegal) #FUN-980011 add   #FUN-9B0146
                #rvwlegal)          #FUN-9B0146 #MOD-B70210 mark
                 rvwlegal,rvw99,rvwacti)    #MOD-B70210 ad   #FUN-D10064 add-rvwacti
                VALUES(g_rvw[l_ac].rvw01,g_rvw[l_ac].rvw02,
                       g_rvw[l_ac].rvw03,g_rvw[l_ac].rvw04,
                       g_rvw[l_ac].rvw11,g_rvw[l_ac].rvw12,
                       g_rvw[l_ac].rvw05f,g_rvw[l_ac].rvw06f,
                       g_rvw[l_ac].rvw05,g_rvw[l_ac].rvw06,
                       g_rvw[l_ac].rvw07,g_head_1.rvu01,
                       g_rvw[l_ac].rvw09,g_rvw[l_ac].rvw10,
                       g_rvw_rvw17,                                       #No.MOD-540169
                       #g_plant,g_legal) #FUN-980011 add   #FUN-9B0146
                      #g_legal)          #FUN-9B0146 #MOD-B70210 mark
                       g_legal,g_plant,'Y')  #MOD-B70210 add  #FUN-D10064 add-rvwacti
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_rvw[l_ac].rvw09,SQLCA.sqlcode,0)  #No.FUN-660071
            CALL cl_err3("ins","rvw_file",g_rvw[l_ac].rvw01,g_head_1.rvu01,SQLCA.sqlcode,"","",1) #No.FUN-660071
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_rvw[l_ac].* TO NULL      #900423
         LET g_rvw[l_ac].rvw04 = 0             #Default
         #modify 030425 bug no:A069
         LET g_rvw[l_ac].rvw12 = 0             #Default
         LET g_rvw[l_ac].rvw05f= 0             #Default
         LET g_rvw[l_ac].rvw06f= 0             #Default
         LET g_rvw[l_ac].rvw05 = 0             #Default
         LET g_rvw[l_ac].rvw06 = 0             #Default
         LET g_rvw[l_ac].sum1  = 0             #FUN-C80027
         LET g_rvw[l_ac].sum2  = 0             #FUN-C80027
         LET g_rvw[l_ac].rvw10 = 0             #Default
         LET g_rvw_t.* = g_rvw[l_ac].*         #新輸入資料
         NEXT FIELD rvw09
 
#     BEFORE FIELD rvw07
      AFTER FIELD rvw09
         IF NOT cl_null(g_rvw[l_ac].rvw09) THEN
            IF (p_cmd = 'a') OR
               (p_cmd = 'u' AND g_rvw_t.rvw09 != g_rvw[l_ac].rvw09) THEN
               CALL i120_rvw09()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rvw[l_ac].rvw09,g_errno,0) 
                  LET g_rvw[l_ac].* = g_rvw_t.*         #default舊值
                  NEXT FIELD rvw09
               END IF
              #str MOD-B50016 add
              #若為樣品時,金額部份(rvw17,rvw05,rvw05f,rvw06,rvw06f)應帶0
               LET l_rvv25=""
               LET g_sql = "SELECT rvv25 FROM ",cl_get_target_table(g_rvuplant,'rvv_file'),
                           " WHERE rvv01 = '",g_head_1.rvu01,"'",
                           "   AND rvv02 = '",g_rvw[l_ac].rvw09,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
               PREPARE sel_rvv25 FROM g_sql
               EXECUTE sel_rvv25 INTO l_rvv25
               IF cl_null(l_rvv25) THEN LET l_rvv25="N" END IF
               IF l_rvv25="Y" THEN
                  LET g_rvw_rvw17       =0
                  LET g_rvw[l_ac].rvw05 =0 
                  LET g_rvw[l_ac].rvw05f=0                                                                                              
                  LET g_rvw[l_ac].rvw06 =0 
                  LET g_rvw[l_ac].rvw06f=0
                  LET g_rvw[l_ac].sum1  =0             #FUN-C80027
                  LET g_rvw[l_ac].sum2  =0             #FUN-C80027
                  DISPLAY BY NAME g_rvw[l_ac].rvw05,g_rvw[l_ac].rvw05f,
                                  g_rvw[l_ac].rvw06,g_rvw[l_ac].rvw06f
                                 ,g_rvw[l_ac].sum1,g_rvw[l_ac].sum2      #FUN-C80027
               END IF   
              #end MOD-B50016 add
            END IF
            #No.FUN-750089 --start--
            IF p_cmd = 'u' AND g_rvw[l_ac].rvw07 = '   ' THEN
               NEXT FIELD rvw07
            END IF
            IF p_cmd = 'u' AND g_rvw[l_ac].rvw01 = '   ' THEN
               NEXT FIELD rvw01
            END IF
            #No.FUN-750089 --end--
         END IF
 
      AFTER FIELD rvw07
         #可抵扣/不可抵扣專用發票
          IF cl_null(g_rvw[l_ac].rvw07) THEN  #No.MOD-540169
            IF g_gec05 MATCHES '[sSnN]' THEN
               CALL cl_err(g_gec05,'tis-001',0)
               NEXT FIELD rvw07
            END IF
            #No.FUN-580006 --start--
            IF g_aza.aza46 = 'Y' THEN
               CALL cl_err('','gap-142',0)
               NEXT FIELD rvw07
            END IF
            #No.FUN-580006 --end--
         END IF
 
      AFTER FIELD rvw01
         IF NOT cl_null(g_rvw[l_ac].rvw01) THEN
            IF (p_cmd = 'a') OR
               (p_cmd = 'u' AND g_rvw_t.rvw01 != g_rvw[l_ac].rvw01) THEN
               SELECT COUNT(*) INTO l_n FROM rvw_file
                WHERE rvw01 = g_rvw[l_ac].rvw01
                  AND rvw08 = g_head_1.rvu01
                  AND rvw09 = g_rvw[l_ac].rvw09
               IF l_n > 0  THEN
                  CALL cl_err('',-239,0)
                  LET g_rvw[l_ac].rvw01 = g_rvw_t.rvw01
                  NEXT FIELD rvw01
               END IF
            END IF
             #No.MOD-540169 --start--
            SELECT COUNT(*) INTO l_cnt FROM apk_file
             WHERE apk03 = g_rvw[l_ac].rvw01
               AND apk01 IN (SELECT apa01 FROM apa_file
             WHERE apa00='11')
           #str MOD-A20066 add
            #檢查發票是否存在退貨折讓帳款裡
            IF l_cnt = 0 THEN
               SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
                WHERE apb11 = g_rvw[l_ac].rvw01
                  AND apb01 = apa01 AND apa00='21'
            END IF
           #end MOD-A20066 add
            IF l_cnt > 0 THEN
               CALL cl_err('','apm-241',0)
              #NEXT FIELD rvw09   #MOD-A20066 mark
               EXIT INPUT         #MOD-A20066 add
            END IF
             #No.MOD-540169 --end--
         END IF
         #No.FUN-750089 --start--
         IF p_cmd = 'u' AND g_rvw[l_ac].rvw01 = '   ' THEN
            CALL cl_err('','aap-226',0)
            NEXT FIELD rvw01
         END IF
         #No.FUN-750089 --end--
 
      AFTER FIELD rvw03
         IF NOT cl_null(g_rvw[l_ac].rvw03) THEN
            SELECT gec04,gec05 INTO g_rvw[l_ac].rvw04,g_gec05
              FROM gec_file WHERE gec01 = g_rvw[l_ac].rvw03
            IF STATUS THEN
               #CALL cl_err(g_rvw[l_ac].rvw03,'mfg3044',0)  #No.FUN-660071
               CALL cl_err3("sel","gec_file",g_rvw[l_ac].rvw03,"","mfg3044","","",1) #No.FUN-660071
               NEXT FIELD rvw03
            END IF
            #可抵扣/不可抵扣專用發票
            IF g_gec05 MATCHES '[sSnN]' AND cl_null(g_rvw[l_ac].rvw07) THEN
               CALL cl_err(g_gec05,'tis-001',0)
               NEXT FIELD rvw07
            END IF
 #No.MOD-540169 --start--  rvw10可以修改
#           IF g_gec05 NOT MATCHES '[gG]' THEN   #海關代征完稅憑證
#              LET g_rvw[l_ac].rvw10 = 0
#           END IF
 #No.MOD-540169 --end--
         END IF
 
      #modify 030425 bug no:A069
      AFTER FIELD rvw11
         IF NOT cl_null(g_rvw[l_ac].rvw11) THEN
            SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01 = g_rvw[l_ac].rvw11
            IF STATUS THEN
               #CALL cl_err(g_rvw[l_ac].rvw11,'aap-002',1)  #No.FUN-660071
               CALL cl_err3("sel","azi_file",g_rvw[l_ac].rvw11,"","aap-002","","",1) #No.FUN-660071
               NEXT FIELD rvw11
            ELSE
               CALL s_curr3(g_rvw[l_ac].rvw11,'','S')
                  RETURNING g_rvw[l_ac].rvw12
            END IF
         END IF
 
       #NO.MOD-530687--begin
      AFTER FIELD rvw12
         IF g_gec05 = 'T' OR g_gec05 = 'A' THEN     #FUN-630068
            LET g_rvw[l_ac].rvw05 =g_rvw[l_ac].rvw05f*g_rvw[l_ac].rvw12
            LET g_rvw[l_ac].rvw06 =((g_rvw[l_ac].rvw05f+g_rvw[l_ac].rvw06f)*
                                     g_rvw[l_ac].rvw12)*
                                     g_rvw[l_ac].rvw04/100
            LET g_rvw[l_ac].rvw05 =cl_digcut(g_rvw[l_ac].rvw05,g_azi04)
            LET g_rvw[l_ac].rvw06 =cl_digcut(g_rvw[l_ac].rvw06,g_azi04)
         ELSE
            LET g_rvw[l_ac].rvw05 = g_rvw[l_ac].rvw05f * g_rvw[l_ac].rvw12
            LET g_rvw[l_ac].rvw06 = g_rvw[l_ac].rvw05 * g_rvw[l_ac].rvw04/100
            LET g_rvw[l_ac].rvw05 = cl_digcut(g_rvw[l_ac].rvw05,g_azi04)
            LET g_rvw[l_ac].rvw06 = cl_digcut(g_rvw[l_ac].rvw06,g_azi04)
         END IF
         LET g_rvw[l_ac].sum1 = g_rvw[l_ac].rvw05f + g_rvw[l_ac].rvw06f  #FUN-C80027 
         LET g_rvw[l_ac].sum2 = g_rvw[l_ac].rvw05 + g_rvw[l_ac].rvw06    #FUN-C80027
         DISPLAY BY NAME g_rvw[l_ac].sum1,g_rvw[l_ac].sum2               #FUN-C80027
         DISPLAY BY NAME g_rvw[l_ac].rvw05,g_rvw[l_ac].rvw06
 
      BEFORE FIELD rvw05f
         IF g_gec05 = 'T' OR g_gec05 = 'A' THEN CALL cl_err(0,'aoo-009',0) END IF     #FUN-630068
         LET l_rvw05f_o = g_rvw[l_ac].rvw05f
      #end
 
      AFTER FIELD rvw05f
         IF NOT cl_null(g_rvw[l_ac].rvw05f) THEN
            IF g_type = '3' AND g_rvw[l_ac].rvw05f > 0 THEN   #負值顯示
               LET g_rvw[l_ac].rvw05f = g_rvw[l_ac].rvw05f * -1
            END IF
#CHI-970028---begin                                                                                                                 
            LET l_rvw05f = 0                                                                                                        
            LET l_rvv39 = 0                                                                                                         
            SELECT SUM(rvw05f) INTO l_rvw05f                                                                                        
              FROM rvw_file                                                                                                         
             WHERE rvw08 = g_head_1.rvu01                                                                                           
               AND rvw09 = g_rvw[l_ac].rvw09                                                                                        
            IF cl_null(l_rvw05f) THEN  LET l_rvw05f = 0 END IF                                                                      
            IF  p_cmd='u'  THEN                                                                                                     
                LET l_rvw05f = l_rvw05f + g_rvw[l_ac].rvw05f - g_rvw_t.rvw05f                                                       
            ELSE                                                                                                                    
                IF p_cmd= 'a'  THEN                                                                                                 
                   LET l_rvw05f = l_rvw05f + g_rvw[l_ac].rvw05f                                                                     
                END IF                                                                                                              
            END IF                                                                                                                  
           #FUN-A60056--mod--str--
           #SELECT rvv39 INTO l_rvv39  from rvv_file                                                                                
           # WHERE rvv01 = g_head_1.rvu01                                                                                           
           #   AND rvv02 = g_rvw[l_ac].rvw09                                                                                        
            LET g_sql = "SELECT rvv39 ",
                        "  FROM ",cl_get_target_table(g_rvuplant,'rvv_file'),
                        " WHERE rvv01 = '",g_head_1.rvu01,"'",
                        "   AND rvv02 = '",g_rvw[l_ac].rvw09,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
            PREPARE sel_rvv39 FROM g_sql
            EXECUTE sel_rvv39 INTO l_rvv39
           #FUN-A60056--mod--end
            IF cl_null(l_rvv39) THEN LET l_rvv39 = 0 END IF                                                                         
            IF l_rvw05f > l_rvv39 THEN                                                                                              
               CALL cl_err('','tis-002',1)                                                                                          
               NEXT FIELD rvw05f                                                                                                    
            END IF                                                                                                                  
#CHI-970028---end    
             #NO.MOD-530687--begin
            IF g_gec05 = 'T' OR g_gec05 = 'A' THEN     #FUN-630068
               IF l_rvw05f_o != g_rvw[l_ac].rvw05f THEN
                  LET l_rvw05f_t = g_rvw[l_ac].rvw05f
                  LET g_rvw[l_ac].rvw05f=g_rvw[l_ac].rvw05f*
                                      (1-g_rvw[l_ac].rvw04/100)
                  LET g_rvw[l_ac].rvw05f=cl_digcut(g_rvw[l_ac].rvw05f,t_azi04)
                  LET g_rvw[l_ac].rvw06f=l_rvw05f_t*g_rvw[l_ac].rvw04/100
                  LET g_rvw[l_ac].rvw06f=cl_digcut(g_rvw[l_ac].rvw06f,t_azi04)
                  LET g_rvw[l_ac].rvw05 =g_rvw[l_ac].rvw05f*g_rvw[l_ac].rvw12
                  LET g_rvw[l_ac].rvw05 =cl_digcut(g_rvw[l_ac].rvw05,g_azi04)
                  LET g_rvw[l_ac].rvw06 =(l_rvw05f_t*g_rvw[l_ac].rvw12)*
                                          g_rvw[l_ac].rvw04/100
                  LET g_rvw[l_ac].rvw06 =cl_digcut(g_rvw[l_ac].rvw06,g_azi04)
                  LET g_rvw[l_ac].sum1 = g_rvw[l_ac].rvw05f + g_rvw[l_ac].rvw06f  #FUN-C80027
                  LET g_rvw[l_ac].sum2 = g_rvw[l_ac].rvw05 + g_rvw[l_ac].rvw06    #FUN-C80027
               END IF
            ELSE
               LET g_rvw[l_ac].rvw06f= g_rvw[l_ac].rvw05f* g_rvw[l_ac].rvw04/100
               LET g_rvw[l_ac].rvw05f= cl_digcut(g_rvw[l_ac].rvw05f,t_azi04)
               LET g_rvw[l_ac].rvw06f= cl_digcut(g_rvw[l_ac].rvw06f,t_azi04)
               LET g_rvw[l_ac].rvw05 = g_rvw[l_ac].rvw05f * g_rvw[l_ac].rvw12
               LET g_rvw[l_ac].rvw06 = g_rvw[l_ac].rvw05 * g_rvw[l_ac].rvw04/100
               LET g_rvw[l_ac].rvw05 = cl_digcut(g_rvw[l_ac].rvw05,g_azi04)
               LET g_rvw[l_ac].rvw06 = cl_digcut(g_rvw[l_ac].rvw06,g_azi04)
               LET g_rvw[l_ac].sum1 = g_rvw[l_ac].rvw05f + g_rvw[l_ac].rvw06f  #FUN-C80027
               LET g_rvw[l_ac].sum2 = g_rvw[l_ac].rvw05 + g_rvw[l_ac].rvw06    #FUN-C80027
            END IF
            LET l_rvw05f_o = g_rvw[l_ac].rvw05f
            #end
           #str MOD-A10029 add
           #當異動類別為3.倉退時,有可能只折讓金額而不退數量,
           #故不做數量(rvw10)的管控,但金額不可為零
            IF g_type = '3' AND g_rvw[l_ac].rvw05f = 0 THEN
               CALL cl_err(g_rvw[l_ac].rvw05f,'gap-143',0)   #異動金額不可為零
               NEXT FIELD rvw05f
            END IF
           #end MOD-A10029 add
#CHI-970028---begin                                                                                                                 
           #FUN-A60056--mod--str--
           #SELECT rvv38 INTO g_rvw_rvw17                                                                                           
           #  FROM rvv_file                                                                                                         
           # WHERE rvv01 = g_head_1.rvu01 AND rvv02 = g_rvw[l_ac].rvw09                                                             
            LET g_sql = "SELECT rvv38 ",
                        "  FROM ",cl_get_target_table(g_rvuplant,'rvv_file'),
                        " WHERE rvv01 = '",g_head_1.rvu01,"'",
                        "   AND rvv02 = '",g_rvw[l_ac].rvw09,"'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql
           CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
           PREPARE sel_rvv38 FROM g_sql
           EXECUTE sel_rvv38 INTO g_rvw_rvw17
           #FUN-A60056--mod--end
            IF cl_null(g_rvw_rvw17) OR g_rvw_rvw17 = 0 THEN                                                                         
               LET g_rvw[l_ac].rvw10 = 0                                                                                            
            ELSE                                                                                                                    
               LET g_rvw[l_ac].rvw10 = g_rvw[l_ac].rvw05f/g_rvw_rvw17                                                               
               LET g_rvw[l_ac].rvw10= cl_digcut(g_rvw[l_ac].rvw10,t_azi04)                                                          
            END IF                                                                                                                  
#CHI-970028---end  
         END IF
 
      AFTER FIELD rvw06f
         IF NOT cl_null(g_rvw[l_ac].rvw06f) THEN
            LET g_rvw[l_ac].rvw06f = cl_digcut(g_rvw[l_ac].rvw06f,t_azi04)    #原幣稅額
            LET g_rvw[l_ac].sum1 = g_rvw[l_ac].rvw05f + g_rvw[l_ac].rvw06f  #FUN-C80027
         END IF
 
      AFTER FIELD rvw05
         IF NOT cl_null(g_rvw[l_ac].rvw05) THEN
            IF g_type = '3' AND g_rvw[l_ac].rvw05 > 0 THEN   #負值顯示
               LET g_rvw[l_ac].rvw05 = g_rvw[l_ac].rvw05 * -1
            END IF
             #NO.MOD-530687--begin
            IF g_gec05 != 'T' AND g_gec05 != 'A' THEN     #FUN-630068
               LET g_rvw[l_ac].rvw06 = g_rvw[l_ac].rvw05 * g_rvw[l_ac].rvw04 / 100
               LET g_rvw[l_ac].rvw05 = cl_digcut(g_rvw[l_ac].rvw05,g_azi04)
               LET g_rvw[l_ac].rvw06 = cl_digcut(g_rvw[l_ac].rvw06,g_azi04)
               LET g_rvw[l_ac].sum2 = g_rvw[l_ac].rvw05 + g_rvw[l_ac].rvw06    #FUN-C80027
            END IF
            #end
           #str MOD-A10029 add
           #當異動類別為3.倉退時,有可能只折讓金額而不退數量,
           #故不做數量(rvw10)的管控,但金額不可為零
            IF g_type = '3' AND g_rvw[l_ac].rvw05 = 0 THEN
               CALL cl_err(g_rvw[l_ac].rvw05,'gap-143',0)   #異動金額不可為零
               NEXT FIELD rvw05
            END IF
           #end MOD-A10029 add
         END IF
 
      AFTER FIELD rvw06
         IF NOT cl_null(g_rvw[l_ac].rvw06) THEN
            LET g_rvw[l_ac].rvw06 = cl_digcut(g_rvw[l_ac].rvw06,t_azi04)    #原幣稅額
            LET g_rvw[l_ac].sum2 = g_rvw[l_ac].rvw05 + g_rvw[l_ac].rvw06    #FUN-C80027
         END IF
         ####bug no:A069 end
 
       #No.MOD-540169 --start--
      AFTER FIELD rvw10
         IF cl_null(g_rvw[l_ac].rvw10) THEN
            NEXT FIELD rvw10
         ELSE
           #str MOD-A10029 add
            IF g_type = '3' THEN
               IF g_rvw[l_ac].rvw10 > 0 THEN
                  LET g_rvw[l_ac].rvw10 = g_rvw[l_ac].rvw10 *-1
                  NEXT FIELD rvw10
               END IF
            END IF
            IF g_type = '1' THEN
               IF g_rvw[l_ac].rvw10 < 0 THEN
                  LET g_rvw[l_ac].rvw10 = g_rvw[l_ac].rvw10 *-1
                  NEXT FIELD rvw10
               END IF
            END IF
           #end MOD-A10029 add
           #FUN-A60056--mod--str--
           #SELECT rvv17-rvv23 INTO l_rvv17 FROM rvv_file
           # WHERE rvv01 = g_head_1.rvu01
           #   AND rvv02 = g_rvw[l_ac].rvw09
            LET g_sql = "SELECT rvv17-rvv23 ",
                        "  FROM ",cl_get_target_table(g_rvuplant,'rvv_file'),
                        " WHERE rvv01 = '",g_head_1.rvu01,"'",
                        "   AND rvv02 = '",g_rvw[l_ac].rvw09,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
            PREPARE sel_rvv17 FROM g_sql
            EXECUTE sel_rvv17 INTO l_rvv17
           #FUN-A60056--mod--end
            IF cl_null(l_rvv17) THEN LET l_rvv17 = 0 END IF
            #計算未生成請款的入庫數量
            CALL i120_rvw10()
            IF p_cmd = 'u' THEN LET g_rvw10 = g_rvw10 - g_rvw_t.rvw10 END IF
            IF g_rvw[l_ac].rvw10 > l_rvv17 - g_rvw10 THEN
               CALL cl_err(' ','apm-282',0)
               NEXT FIELD rvw10
            END IF
#CHI-970028---begin
#            SELECT rvv38 INTO g_rvw_rvw17
#              FROM rvv_file
#             WHERE rvv01 = g_head_1.rvu01 AND rvv02 = g_rvw[l_ac].rvw09
#            IF cl_null(g_rvw_rvw17) THEN LET g_rvw_rvw17 = 0 END IF
#            LET g_rvw[l_ac].rvw05f = g_rvw_rvw17*g_rvw[l_ac].rvw10                  #原幣稅前
#            IF g_type = '3' AND g_rvw[l_ac].rvw05f > 0 THEN                 #負值顯示
#               LET g_rvw[l_ac].rvw05f = g_rvw[l_ac].rvw05f * -1
#            END IF
#            LET g_rvw[l_ac].rvw06f = g_rvw[l_ac].rvw05f * g_rvw[l_ac].rvw04 / 100              #原幣稅額
#            LET g_rvw[l_ac].rvw05f = cl_digcut(g_rvw[l_ac].rvw05f,g_azi04)
#            LET g_rvw[l_ac].rvw06f = cl_digcut(g_rvw[l_ac].rvw06f,g_azi04)
#           #LET g_rvw[l_ac].rvw05  = g_rvw_rvw17*g_rvw[l_ac].rvw10*g_rvw[l_ac].rvw12 #本幣金額  #No.MOD-8B0247 mark
#            LET g_rvw[l_ac].rvw05  = g_rvw[l_ac].rvw05f*g_rvw[l_ac].rvw12 #本幣金額  #No.MOD-8B0247 add
#            IF g_type = '3' AND g_rvw[l_ac].rvw05 > 0 THEN                 #負值顯示
#               LET g_rvw[l_ac].rvw05 = g_rvw[l_ac].rvw05 * -1
#            END IF
#            LET g_rvw[l_ac].rvw06  = g_rvw[l_ac].rvw05 * g_rvw[l_ac].rvw04 / 100                #本幣稅額    rvw04:稅率
#            LET g_rvw[l_ac].rvw05  = cl_digcut(g_rvw[l_ac].rvw05,t_azi04)
#            LET g_rvw[l_ac].rvw06  = cl_digcut(g_rvw[l_ac].rvw06,g_azi04)
#CHI-970028---end
         END IF
       #No.MOD-540169 --end--
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_rvw_t.rvw09) AND NOT cl_null(g_rvw_t.rvw01) THEN
            SELECT COUNT(*) INTO l_cnt FROM apk_file
             WHERE apk03 = g_rvw[l_ac].rvw01
                AND apk01 IN (SELECT apa01 FROM apa_file     #No.MOD-540169
              WHERE apa00='11')                              #No.MOD-540169
           #str MOD-A20066 add
            #檢查發票是否存在退貨折讓帳款裡
            IF l_cnt = 0 THEN
               SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
                WHERE apb11 = g_rvw[l_ac].rvw01
                  AND apb01 = apa01 AND apa00='21'
            END IF
           #end MOD-A20066 add
            IF l_cnt > 0 THEN
               CALL cl_err('','apm-241',0)
               LET l_ac_t = l_ac
               EXIT INPUT
            END IF
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM rvw_file
             WHERE rvw08 = g_head_1.rvu01
               AND rvw09 = g_rvw_t.rvw09
               AND rvw01 = g_rvw_t.rvw01
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               #CALL cl_err(g_rvw_t.rvw09,SQLCA.sqlcode,0)  #No.FUN-660071
               CALL cl_err3("del","rvw_file",g_head_1.rvu01,g_rvw_t.rvw09,SQLCA.sqlcode,"","",1) #No.FUN-660071
               ROLLBACK WORK
               CANCEL DELETE
            END IF
             #No.MOD-540169 --start--
            IF g_type = '1' THEN   #更新驗收單發票號碼
               SELECT COUNT(rvw01) INTO l1_n
                 FROM rvw_file
                WHERE rvw08 = g_head_1.rvu01
                  AND rvw09 = g_rvw_t.rvw09
               IF l1_n = 0 THEN
                 #FUN-A60056--mod--str-- 
                 #SELECT rvv04,rvv05 INTO l_rvv04,l_rvv05
                 #  FROM rvv_file
                 # WHERE rvv01=g_head_1.rvu01 AND rvv02=g_rvw_t.rvw09
                  LET g_sql = "SELECT rvv04,rvv05 ",
                              "  FROM ",cl_get_target_table(g_rvuplant,'rvv_file'),
                              " WHERE rvv01='",g_head_1.rvu01,"'",
                              "   AND rvv02='",g_rvw_t.rvw09,"'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
                  PREPARE sel_rvv04_pre FROM g_sql
                  EXECUTE sel_rvv04_pre INTO l_rvv04,l_rvv05 
                 ##UPDATE rvb_file SET rvb22 = " "    #No.MOD-910042 mark
                 #UPDATE rvb_file SET rvb22 = NULL   #No.MOD-910042 add
                 #              WHERE rvb01 = l_rvv04
                 #                AND rvb02 = l_rvv05
                  LET g_sql = "UPDATE ",cl_get_target_table(g_rvuplant,'rvb_file'),
                              "   SET rvb22 = NULL ",
                              " WHERE rvb01 = '",l_rvv04,"'",
                              "   AND rvb02 = '",l_rvv05,"'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
                  PREPARE upd_rvb_22 FROM g_sql
                  EXECUTE upd_rvb_22
                 #FUN-A60056--mod--end
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                     #CALL cl_err('upd rvb',SQLCA.sqlcode,1) #No.FUN-660071
                     CALL cl_err3("upd","rvb_file",l_rvv04,l_rvv05,SQLCA.sqlcode,"","upd rvb",1) #No.FUN-660071
                  END IF
               ELSE
                  CALL i120_upd_rvb22('d')
               END IF
            END IF
             #No.MOD-540169 --end--
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
            
            #FUN-C80027---ADD--STR
            SELECT SUM(rvw05f),SUM(rvw06f),SUM(rvw05),SUM(rvw06)
              INTO g_rvw05f_sum,g_rvw06f_sum,g_rvw05_sum,g_rvw06_sum
              FROM rvw_file WHERE rvw08=g_head_1.rvu01
            IF cl_null(g_rvw05f_sum) THEN LET g_rvw05f_sum = 0 END IF
            IF cl_null(g_rvw06f_sum) THEN LET g_rvw06f_sum = 0 END IF
            IF cl_null(g_rvw05_sum) THEN LET g_rvw05_sum = 0 END IF
            IF cl_null(g_rvw06_sum) THEN LET g_rvw06_sum = 0 END IF
            LET g_sum3=g_rvw05f_sum+g_rvw06f_sum
            LET g_sum4=g_rvw05_sum+g_rvw06_sum
            DISPLAY g_rvw05f_sum TO rvw05f_sum
            DISPLAY g_rvw06f_sum TO rvw06f_sum
            DISPLAY g_rvw05_sum  TO rvw05_sum
	    DISPLAY g_rvw06_sum  TO rvw06_sum
            DISPLAY g_sum3       TO sum3
            DISPLAY g_sum4       TO sum4           
 
            #FUN-C80027---ADD--END
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_rvw[l_ac].* = g_rvw_t.*
            CLOSE i120_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_rvw[l_ac].rvw09,-263,1)
            LET g_rvw[l_ac].* = g_rvw_t.*
         ELSE
            UPDATE rvw_file SET rvw01=g_rvw[l_ac].rvw01,
                                rvw02=g_rvw[l_ac].rvw02,
                                rvw03=g_rvw[l_ac].rvw03,
                                rvw04=g_rvw[l_ac].rvw04,
                                rvw11=g_rvw[l_ac].rvw11,
                                rvw12=g_rvw[l_ac].rvw12,
                                rvw05f=g_rvw[l_ac].rvw05f,
                                rvw06f=g_rvw[l_ac].rvw06f,
                                rvw05=g_rvw[l_ac].rvw05,
                                rvw06=g_rvw[l_ac].rvw06,
                                rvw07=g_rvw[l_ac].rvw07,
                                rvw09=g_rvw[l_ac].rvw09,
                                 rvw17=g_rvw_rvw17,    #No.MOD-540169
                                rvw10=g_rvw[l_ac].rvw10
                          WHERE rvw08 = g_head_1.rvu01
                            AND rvw09 = g_rvw_t.rvw09
                            AND rvw01 = g_rvw_t.rvw01
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_rvw[l_ac].rvw09,SQLCA.sqlcode,0)  #No.FUN-660071
               CALL cl_err3("upd","rvw_file",g_head_1.rvu01,g_rvw_t.rvw09,SQLCA.sqlcode,"","",1) #No.FUN-660071
               LET g_rvw[l_ac].* = g_rvw_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
               #FUN-C80027---ADD----STR
               SELECT SUM(rvw05f),SUM(rvw06f),SUM(rvw05),SUM(rvw06)
               INTO g_rvw05f_sum,g_rvw06f_sum,g_rvw05_sum,g_rvw06_sum
               FROM rvw_file WHERE rvw08=g_head_1.rvu01
               IF cl_null(g_rvw05f_sum) THEN LET g_rvw05f_sum = 0 END IF
               IF cl_null(g_rvw06f_sum) THEN LET g_rvw06f_sum = 0 END IF
               IF cl_null(g_rvw05_sum) THEN LET g_rvw05_sum = 0 END IF
               IF cl_null(g_rvw06_sum) THEN LET g_rvw06_sum = 0 END IF
               LET g_sum3=g_rvw05f_sum+g_rvw06f_sum
               LET g_sum4=g_rvw05_sum+g_rvw06_sum
               DISPLAY g_rvw05f_sum TO rvw05f_sum
               DISPLAY g_rvw06f_sum TO rvw06f_sum
               DISPLAY g_rvw05_sum  TO rvw05_sum
               DISPLAY g_rvw06_sum  TO rvw06_sum
               DISPLAY g_sum3       TO sum3
               DISPLAY g_sum4       TO sum4 
              #FUN-C80027--ADD---END
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D30032 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_rvw[l_ac].* = g_rvw_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_rvw.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end-- 
            END IF
            CLOSE i120_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30032 Add
         CLOSE i120_bcl
         COMMIT WORK
         #FUN-C80027---ADD--STR
          SELECT SUM(rvw05f),SUM(rvw06f),SUM(rvw05),SUM(rvw06)
            INTO g_rvw05f_sum,g_rvw06f_sum,g_rvw05_sum,g_rvw06_sum
            FROM rvw_file WHERE rvw08=g_head_1.rvu01
          IF cl_null(g_rvw05f_sum) THEN LET g_rvw05f_sum = 0 END IF
          IF cl_null(g_rvw06f_sum) THEN LET g_rvw06f_sum = 0 END IF
          IF cl_null(g_rvw05_sum) THEN LET g_rvw05_sum = 0 END IF
          IF cl_null(g_rvw06_sum) THEN LET g_rvw06_sum = 0 END IF
          LET g_sum3=g_rvw05f_sum+g_rvw06f_sum
          LET g_sum4=g_rvw05_sum+g_rvw06_sum
          DISPLAY g_rvw05f_sum TO rvw05f_sum
          DISPLAY g_rvw06f_sum TO rvw06f_sum
          DISPLAY g_rvw05_sum  TO rvw05_sum
          DISPLAY g_rvw06_sum  TO rvw06_sum
          DISPLAY g_sum3       TO sum3
          DISPLAY g_sum4       TO sum4

            #FUN-C80027---ADD--END

      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
#-----MOD-750109---------
{
            WHEN INFIELD(rvw09)
#No.BUG_540169 --start--
#              IF g_type = '1' THEN
#                 CALL q_rvb7(0,0,g_head.rvu01,g_rvw[l_ac].rvw09,g_head.rvu01) RETURNING g_rvw[l_ac].rvw09
#                 CALL q_rvb7(FALSE,TRUE,g_head.rvu01,g_rvw[l_ac].rvw09,g_head.rvu01) RETURNING g_rvw[l_ac].rvw09
#                  CALL FGL_DIALOG_SETBUFFER( g_rvw[l_ac].rvw09 )
#              ELSE
#                 CALL q_rvv(0,0,g_head.rvu04,g_head.rvu01,'') RETURNING g_buf,g_rvw[l_ac].rvw09
#                 CALL q_rvv(FALSE,TRUE,g_head.rvu04,g_head.rvu01,'') RETURNING g_buf,g_rvw[l_ac].rvw09
#                  CALL FGL_DIALOG_SETBUFFER( g_buf )
#                  CALL FGL_DIALOG_SETBUFFER( g_rvw[l_ac].rvw09 )
#              END IF
                DISPLAY BY NAME g_rvw[l_ac].rvw09       #No.MOD-490344
               NEXT FIELD rvw09
}
#-----END MOD-750109-----
             WHEN INFIELD(rvw03)
#              CALL q_gec(0,0,g_rvw[l_ac].rvw03,'1') RETURNING g_rvw[l_ac].rvw03
#              CALL FGL_DIALOG_SETBUFFER( g_rvw[l_ac].rvw03 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gec"
               LET g_qryparam.default1 = g_rvw[l_ac].rvw03
               LET g_qryparam.arg1     = '1'
               CALL cl_create_qry() RETURNING g_rvw[l_ac].rvw03
#               CALL FGL_DIALOG_SETBUFFER( g_rvw[l_ac].rvw03 )
                DISPLAY BY NAME g_rvw[l_ac].rvw03       #No.MOD-490344
               NEXT FIELD rvw03
               #-----MOD-710023---------
               WHEN INFIELD(rvw11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  CALL cl_create_qry() RETURNING g_rvw[l_ac].rvw11
                  DISPLAY g_rvw[l_ac].rvw11 TO rvw11
                  NEXT FIELD rvw11
               #-----END MOD-710023----- 
           END CASE
 
      ON ACTION CONTROLF                  #欄位說明
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
   CALL i120_chk_amt()
   IF NOT cl_null(g_errno) THEN
#      CALL cl_err('',g_errno,0)   #CHI-970028                                                                                      
      CALL cl_err('',g_errno,1)    #CHI-970028 
   END IF
   IF g_type = '1' THEN   #更新驗收單發票號碼
      CALL i120_upd_rvb22('b')
   END IF
   CLOSE i120_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i120_upd_rvb22(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.MOD-540169 VARCHAR(01)  b:單身新增 d:刪除     #NO FUN-690009
   DEFINE l_rvw    RECORD LIKE rvw_file.*,
          l_guino  LIKE rvw_file.rvw01,
          l_cnt    LIKE type_file.num5    #NO FUN-690009 SMALLINT
   DEFINE l_rvv04  LIKE rvv_file.rvv04,  #No.MOD-540169
          l_rvv05  LIKE rvv_file.rvv05   #No.MOD-540169
 
   DECLARE i120_curs CURSOR FOR
      SELECT * FROM rvw_file
       WHERE rvw08 = g_head_1.rvu01 ORDER BY rvw08,rvw09
   BEGIN WORK
   LET g_success = 'Y'
   FOREACH i120_curs INTO l_rvw.*
      IF STATUS THEN
         CALL cl_err('i120_curs',STATUS,0) LET g_success='N' EXIT FOREACH
      END IF
       #No.MOD-540169 --start--
      IF p_cmd = 'd' AND l_rvw.rvw09 != g_rvw_t.rvw09 THEN
         CONTINUE FOREACH
      END IF
     #FUN-A60056--mod--str--
     #SELECT rvv04,rvv05 INTO l_rvv04,l_rvv05
     #  FROM rvv_file
     # WHERE rvv01=l_rvw.rvw08 AND rvv02=l_rvw.rvw09
     #SELECT COUNT(UNIQUE rvw01) INTO l_cnt
     #  FROM rvw_file,rvv_file
     # WHERE rvv01 = rvw08 AND rvv02 = rvw09
     #   AND rvv04 = l_rvv04 AND rvv05=l_rvv05
     #   AND rvv03 = g_type
      LET g_sql = "SELECT rvv04,rvv05 ",
                  "  FROM ",cl_get_target_table(l_rvw.rvw99,'rvv_file'),
                  " WHERE rvv01='",l_rvw.rvw08,"'",
                  "   AND rvv02='",l_rvw.rvw09,"'" 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_rvw.rvw99) RETURNING g_sql
      PREPARE sel_rvv04_cs FROM g_sql
      EXECUTE sel_rvv04_cs INTO l_rvv04,l_rvv05

      LET g_sql = "SELECT COUNT(UNIQUE rvw01) ",
                  "  FROM rvw_file,",cl_get_target_table(l_rvw.rvw99,'rvv_file'),
                  "  WHERE rvv01 = rvw08 AND rvv02 = rvw09 ",
                  "    AND rvv04 = '",l_rvv04,"' AND rvv05='",l_rvv05,"' ",
                  "    AND rvv03 = '",g_type,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_rvw.rvw99) RETURNING g_sql
      PREPARE sel_rvw01 FROM g_sql
      EXECUTE sel_rvw01 INTO l_cnt
     #FUN-A60056--mod--end
      IF l_cnt > 1 THEN
           LET l_guino = 'MISC'
      ELSE
        LET l_guino = l_rvw.rvw01
      END IF
     #FUN-A60056--mod--str--
     #UPDATE rvb_file SET rvb22 = l_guino
     # WHERE rvb01 = l_rvv04 AND rvb02 = l_rvv05
      LET g_sql = "UPDATE ",cl_get_target_table(l_rvw.rvw99,'rvb_file'),
                  "   SET rvb22 = '",l_guino,"'",
                  " WHERE rvb01 = '",l_rvv04,"' AND rvb02 = '",l_rvv05,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_rvw.rvw99) RETURNING g_sql
      PREPARE upd_rvb FROM g_sql
      EXECUTE upd_rvb
     #FUN-A60056--mod--end
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         #CALL cl_err('upd rvb',STATUS,1)  #No.FUN-660071
         CALL cl_err3("upd","rvb_file",l_rvv04,l_rvv05,STATUS,"","upd rvb",1)  #No.FUN-660071
         LET g_success='N' EXIT FOREACH
      END IF
       #No.MOD-540169 --end--
   END FOREACH
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
FUNCTION i120_rvw09()
DEFINE l_rvv04    LIKE rvv_file.rvv04 
DEFINE l_rvv36    LIKE rvv_file.rvv36 
DEFINE l_rvw05f   LIKE rvw_file.rvw05     #MOD-A80052
DEFINE l_rvw05f_1 LIKE rvw_file.rvw05f    #MOD-A80052  
DEFINE l_rvw05f_2 LIKE rvw_file.rvw05f    #MOD-A80052
DEFINE l_rvu02    LIKE rvu_file.rvu02     #MOD-A80052
 
   LET g_errno = ''
 
#FUN-940083--begin
#FUN-A60056--mod--str--
#  SELECT rvv04,rvv36 INTO l_rvv04,l_rvv36
#    FROM rvv_file
#   WHERE rvv01 = g_head_1.rvu01 AND rvv02 = g_rvw[l_ac].rvw09
   LET g_sql = "SELECT rvv04,rvv36 FROM ",cl_get_target_table(g_rvuplant,'rvv_file'),
               " WHERE rvv01 = '",g_head_1.rvu01,"' AND rvv02 = '",g_rvw[l_ac].rvw09,"'" 
   CALL cl_replace_sqldb(g_sql)RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
   PREPARE sel_rvv04 FROM g_sql
   EXECUTE sel_rvv04 INTO l_rvv04,l_rvv36
#FUN-A60056--mod--end
   IF NOT cl_null(l_rvv36) THEN  
#FUN-940083--end
 
       #No.MOD-540169 --start--
      #modify 030425 bug no:A069
     #FUN-A60056--mod--str--
     #SELECT rvv31,rvv17-rvv23,rvv031,rvv39,pmm22,pmm21,rvv38
     #  INTO g_rvw[l_ac].part,g_rvw[l_ac].rvw10,g_rvw[l_ac].desc,
     #       g_rvw[l_ac].rvw05f,g_rvw[l_ac].rvw11,
     #       g_rvw[l_ac].rvw03,g_rvw_rvw17
     #  FROM rvv_file,pmm_file
     # WHERE rvv01 = g_head_1.rvu01 AND rvv02 = g_rvw[l_ac].rvw09
     #   AND pmm01 = rvv36
     ##FUN-940083--begin
     #   AND rvv89 <>'Y'
      LET g_sql = "SELECT rvv31,rvv17-rvv23,rvv031,rvv39,pmm22,pmm21,rvv38 ",
                  "  FROM ",cl_get_target_table(g_rvuplant,'rvv_file'),",",
                  "       ",cl_get_target_table(g_rvuplant,'pmm_file'),
                  " WHERE rvv01 = '",g_head_1.rvu01,"' " ,
                  "   AND rvv02 = '",g_rvw[l_ac].rvw09,"'",
                  "   AND pmm01 = rvv36"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
      PREPARE sel_rvv31_pre1 FROM g_sql
      EXECUTE sel_rvv31_pre1 INTO g_rvw[l_ac].part,g_rvw[l_ac].rvw10,g_rvw[l_ac].desc,
                                  g_rvw[l_ac].rvw05f,g_rvw[l_ac].rvw11,
                                  g_rvw[l_ac].rvw03,g_rvw_rvw17
     #FUN-A60056--mod--end
   ELSE
      IF NOT cl_null(l_rvv04) THEN
        #FUN-A60056--mod--str--
        #SELECT rvv31,rvv17-rvv23,rvv031,rvv39,rva113,rva115,rvv38
        #  INTO g_rvw[l_ac].part,g_rvw[l_ac].rvw10,g_rvw[l_ac].desc,
        #       g_rvw[l_ac].rvw05f,g_rvw[l_ac].rvw11,
        #       g_rvw[l_ac].rvw03,g_rvw_rvw17
        #  FROM rvv_file,rva_file
        # WHERE rvv01 = g_head_1.rvu01 AND rvv02 = g_rvw[l_ac].rvw09
        #   AND rva01 = rvv04
        #   AND rvv89 <> 'Y'
         LET g_sql = "SELECT rvv31,rvv17-rvv23,rvv031,rvv39,rva113,rva115,rvv38 ",
                     "  FROM ",cl_get_target_table(g_rvuplant,'rvv_file'),",",
                     "       ",cl_get_target_table(g_rvuplant,'rva_file'),
                     " WHERE rvv01 = '",g_head_1.rvu01,"'",
                     "   AND rvv02 = '",g_rvw[l_ac].rvw09,"'",
                     "   AND rva01 = rvv04 AND rvv89 <> 'Y' "
         PREPARE sel_rvv31_pre2 FROM g_sql
         EXECUTE sel_rvv31_pre2 INTO g_rvw[l_ac].part,g_rvw[l_ac].rvw10,g_rvw[l_ac].desc,
                                     g_rvw[l_ac].rvw05f,g_rvw[l_ac].rvw11,
                                     g_rvw[l_ac].rvw03,g_rvw_rvw17
        #FUN-A60056--mod--end
      ELSE
        #FUN-A60056--mod--str--
        #SELECT rvv31,rvv17-rvv23,rvv031,rvv39,rvu113,rvu115,rvv38
        #  INTO g_rvw[l_ac].part,g_rvw[l_ac].rvw10,g_rvw[l_ac].desc,
        #       g_rvw[l_ac].rvw05f,g_rvw[l_ac].rvw11,
        #       g_rvw[l_ac].rvw03,g_rvw_rvw17
        #  FROM rvv_file,rvu_file
        # WHERE rvv01 = g_head_1.rvu01 AND rvv02 = g_rvw[l_ac].rvw09
        #   AND rvu01 = rvv01
        #   AND rvv89 <> 'Y'
         LET g_sql = "SELECT rvv31,rvv17-rvv23,rvv031,rvv39,rvu113,rvu115,rvv38 ",
                     "  FROM ",cl_get_target_table(g_rvuplant,'rvv_file'),",",
                     "       ",cl_get_target_table(g_rvuplant,'rvu_file'),
                     " WHERE rvv01 = '",g_head_1.rvu01,"' AND rvv02 = '",g_rvw[l_ac].rvw09,"'",
                     "   AND rvu01 = rvv01 AND rvv89 <> 'Y'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
         PREPARE sel_rvv31_pre3 FROM g_sql
         EXECUTE sel_rvv31_pre3 INTO g_rvw[l_ac].part,g_rvw[l_ac].rvw10,g_rvw[l_ac].desc,
                                     g_rvw[l_ac].rvw05f,g_rvw[l_ac].rvw11,
                                     g_rvw[l_ac].rvw03,g_rvw_rvw17
        #FUN-A60056--mod--end
      END IF
   END IF
#FUN-940083--end
   IF STATUS THEN
      LET g_errno = 'asf-700' RETURN
   END IF
  #SELECT gec04,gec05 INTO g_rvw[l_ac].rvw04,g_gec05           #MOD-A80052 mark
  #  FROM gec_file                                             #MOD-A80052 mark
  # WHERE gec01 = g_rvw[l_ac].rvw03                            #MOD-A80052 mark
  #-MOD-A80052-add-
   LET g_sql = "SELECT gec04,gec05,gec07 FROM ",cl_get_target_table(g_rvuplant,'gec_file'), 
               " WHERE gec01 = '",g_rvw[l_ac].rvw03,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              									
   CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql              
   PREPARE sel_gec FROM g_sql
   EXECUTE sel_gec INTO g_rvw[l_ac].rvw04,g_gec05,g_gec07       
  #-MOD-A80052-end-
#rvw10改為可修改，dafault rvv17-rvv23
#  IF g_gec05 NOT MATCHES '[gG]' THEN   #海關代征完稅憑證
#     LET g_rvw[l_ac].rvw10 = 0
#  END IF
#計算未生成請款的入庫數量
   CALL i120_rvw10()
   LET g_rvw[l_ac].rvw10 = g_rvw[l_ac].rvw10 - g_rvw10
  #當異動類別(rvu00)為3.倉退時,有可能只折讓金額而不退數量,
  #故不做數量(rvw10)的管控
   IF g_type != '3' THEN   #MOD-A10029 add
      IF g_rvw[l_ac].rvw10 = 0 THEN
         LET g_errno = 'aim-120' RETURN
      END IF
   END IF   #MOD-A10029 add
   #No.MOD-540169 --end--
  #str MOD-A10029 add
   IF g_type = '3' THEN
      LET g_rvw[l_ac].rvw10 = g_rvw[l_ac].rvw10 * -1
   END IF
  #end MOD-A10029 add

  #str CHI-970028 add                                                                                                               
   #計算未生成請款的入庫金額                                                                                                        
   CALL i120_rvw05()                                                                                                                
   LET g_rvw[l_ac].rvw05f = g_rvw[l_ac].rvw05f - g_rvw05f                                                                           
   LET g_rvw[l_ac].rvw05  = g_rvw[l_ac].rvw05  - g_rvw05                                                                            
  #end CHI-970028 add   
    #MOD-4B0228
   LET t_azi04=0
   SELECT azi04 INTO t_azi04 FROM azi_file
    WHERE azi01 = g_rvw[l_ac].rvw11
   #--
 
   CALL s_curr3(g_rvw[l_ac].rvw11,'','S')  #No.FUN-750089
      RETURNING g_rvw[l_ac].rvw12          #No.FUN-750089
 
    #No.MOD-540169 --start--
   IF cl_null(g_rvw[l_ac].rvw05f) OR g_rvw[l_ac].rvw05f = 0 THEN  #No.MOD-8B0247 add
      LET g_rvw[l_ac].rvw05f = g_rvw_rvw17*g_rvw[l_ac].rvw10                  #原幣稅前
   END IF   #No.MOD-8B0247 add
   IF g_type = '3' AND g_rvw[l_ac].rvw05f > 0 THEN                 #負值顯示
      LET g_rvw[l_ac].rvw05f = g_rvw[l_ac].rvw05f * -1
   END IF
  #-MOD-A80052-add-
   IF g_gec07 = 'Y' AND g_gec05 = 'T' THEN
      LET g_sql = "SELECT rvu02 FROM ",cl_get_target_table(g_rvuplant,'rvu_file'), 
                  " WHERE rvu01 = '",g_head_1.rvu01,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              									
      CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql              
      PREPARE sel_rvu02 FROM g_sql
      EXECUTE sel_rvu02 INTO l_rvu02       

      LET g_sql = "SELECT SUM(rvv87*rvv38t) ",
                  "  FROM ",cl_get_target_table(g_rvuplant,'rvv_file'),",",
                  "       ",cl_get_target_table(g_rvuplant,'rvb_file'),",",
                  "       ",cl_get_target_table(g_rvuplant,'rvu_file'),
                  " WHERE rvb01 = '",l_rvu02,"'",
                  "   AND rvb35 <> 'Y' AND rvv04 = rvb01 ",
                  "   AND rvv05 = rvb02 AND rvv03 = '1' ",
                  "   AND rvu01 = rvv01 AND rvuconf <> 'X' ",
                  "   AND (rvb22 = ' ' OR rvb22 IS NULL)"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
      PREPARE sel_rvv87_pre1 FROM g_sql
      EXECUTE sel_rvv87_pre1 INTO l_rvw05f_1

      LET g_sql = "SELECT SUM(rvv87*rvv38t) ",
                  "  FROM ",cl_get_target_table(g_rvuplant,'rvv_File'),",",
                  "       ",cl_get_target_table(g_rvuplant,'rvb_file'),",",
                  "       ",cl_get_target_table(g_rvuplant,'rvu_file'),
                  " WHERE rvb01 = '",l_rvu02,"' ",
                  "   AND rvb35 <> 'Y' AND rvv04 = rvb01",
                  "   AND rvv05 = rvb02 AND rvv03 = '3' ",
                  "   AND rvu01 = rvv01 AND rvuconf <> 'X' ",
                  "   AND (rvb22 = ' ' OR rvb22 IS NULL)"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
      CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
      PREPARE sel_rvv87_pre2 FROM g_sql
      EXECUTE sel_rvv87_pre2 INTO l_rvw05f_2
      IF cl_null(l_rvw05f_1) THEN LET l_rvw05f_1 = 0 END IF
      IF cl_null(l_rvw05f_2) THEN LET l_rvw05f_2 = 0 END IF
      LET l_rvw05f = l_rvw05f_1 - l_rvw05f_2     #入庫-驗退or倉退
      IF cl_null(l_rvw05f) THEN LET l_rvw05f = 0 END IF
      LET g_rvw[l_ac].rvw06f = l_rvw05f * g_rvw[l_ac].rvw04 / 100              #原幣稅額
      LET g_rvw[l_ac].rvw06f = cl_digcut(g_rvw[l_ac].rvw06f,t_azi04)  
      LET g_rvw[l_ac].rvw05f = l_rvw05f - g_rvw[l_ac].rvw06f 
      LET g_rvw[l_ac].sum1  = g_rvw[l_ac].rvw05f + g_rvw[l_ac].rvw06f     #FUN-C80027
   ELSE
      LET g_rvw[l_ac].rvw06f = g_rvw[l_ac].rvw05f * g_rvw[l_ac].rvw04 / 100    #原幣稅額
      LET g_rvw[l_ac].rvw06f = cl_digcut(g_rvw[l_ac].rvw06f,t_azi04) 
      LET g_rvw[l_ac].sum1  = g_rvw[l_ac].rvw05f + g_rvw[l_ac].rvw06f     #FUN-C80027 
   END IF
  #-MOD-A80052-end-
  #LET g_rvw[l_ac].rvw06f = g_rvw[l_ac].rvw05f * g_rvw[l_ac].rvw04 / 100              #原幣稅額   #MOD-A80052 mark
   LET g_rvw[l_ac].rvw05f = cl_digcut(g_rvw[l_ac].rvw05f,t_azi04)           #MOD-A80052 g_azi04 -> t_azi04
  #LET g_rvw[l_ac].rvw06f = cl_digcut(g_rvw[l_ac].rvw06f,g_azi04)           #MOD-A80052 mark 
  #LET g_rvw[l_ac].rvw05  = g_rvw_rvw17*g_rvw[l_ac].rvw10*g_rvw[l_ac].rvw12 #本幣金額 #No.MOD-8B0247 mark 
   LET g_rvw[l_ac].rvw05  = g_rvw[l_ac].rvw05f*g_rvw[l_ac].rvw12 #本幣金額 #No.MOD-8B0247 add
   IF g_type = '3' AND g_rvw[l_ac].rvw05 > 0 THEN                 #負值顯示
      LET g_rvw[l_ac].rvw05 = g_rvw[l_ac].rvw05 * -1
   END IF
   LET g_rvw[l_ac].rvw06  = g_rvw[l_ac].rvw05 * g_rvw[l_ac].rvw04 / 100                #本幣稅額    rvw04:稅率
   LET g_rvw[l_ac].rvw05  = cl_digcut(g_rvw[l_ac].rvw05,g_azi04)            #MOD-A80052 t_azi04 -> g_azi04
   LET g_rvw[l_ac].rvw06  = cl_digcut(g_rvw[l_ac].rvw06,g_azi04)
   LET g_rvw[l_ac].sum2  = g_rvw[l_ac].rvw05 + g_rvw[l_ac].rvw06     #FUN-C80027
#  LET g_rvw[l_ac].rvw06f = g_rvw[l_ac].rvw05f * g_rvw[l_ac].rvw04 / 100
#  LET g_rvw[l_ac].rvw05f = cl_digcut(g_rvw[l_ac].rvw05f,t_azi04)
#  LET g_rvw[l_ac].rvw06f = cl_digcut(g_rvw[l_ac].rvw06f,t_azi04)
 #No.MOD-540169 --end--
   #---bug no:A069 end
 
#No.FUN-750089 --start-- mark
#   #MOD-4B0004
#  CALL s_curr3(g_rvw[l_ac].rvw11,'','S')
#     RETURNING g_rvw[l_ac].rvw12
#   LET g_rvw[l_ac].rvw05 = g_rvw[l_ac].rvw05f * g_rvw[l_ac].rvw12
#   #--
 
#   LET g_rvw[l_ac].rvw06 = g_rvw[l_ac].rvw05 * g_rvw[l_ac].rvw04 / 100
#   LET g_rvw[l_ac].rvw05 = cl_digcut(g_rvw[l_ac].rvw05,g_azi04)
#   LET g_rvw[l_ac].rvw06 = cl_digcut(g_rvw[l_ac].rvw06,g_azi04)
#No.FUN-750089 --end--
END FUNCTION
 
FUNCTION i120_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #NO FUN-690009  VARCHAR(200)
 
    #modify 030425 bug no:A069
    CONSTRUCT l_wc2 ON rvw09,rvw07,rvw01,rvw02,rvw03,rvw04,rvw11,rvw12,
   #                   rvw05f,rvw06f,rvw05,rvw06,rvw10                    #FUN-C80027
                       rvw05f,rvw06f,sum1,rvw05,rvw06,sum2,rvw10 
                  FROM s_rvw[1].rvw09, s_rvw[1].rvw07,s_rvw[1].rvw01,
                       s_rvw[1].rvw02, s_rvw[1].rvw03,s_rvw[1].rvw04,
                       s_rvw[1].rvw11, s_rvw[1].rvw12,s_rvw[1].rvw05f,
                       s_rvw[1].rvw06f,s_rvw[1].sum1,s_rvw[1].rvw05,s_rvw[1].rvw06,s_rvw[1].sum2,    #FUN-C80027  add--sum1,sum2
                       s_rvw[1].rvw10
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i120_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i120_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2     LIKE type_file.chr1000 #NO FUN-690009 VARCHAR(200)
 
   #modify 030425 bug no:A069
    #No.MOD-540169 --start--
   LET g_sql = "SELECT rvw09,rvw07,rvw01,rvw02,rvw03,rvw04,rvw11,rvw12, ",
#              "       rvw05f,rvw06,rvw05,rvw06,rvw10,rvv31,rvv03",  #TQC-740069 mark
#              "       rvw05f,rvw06,rvw05,rvw06,rvw10,rvv31,rvv031", #TQC-740069        #FUN-C80027 mark
               "       rvw05f,rvw06f,'',rvw05,rvw06,'',rvw10,rvv31,rvv031",
              #FUN-A60056--mod--str--
              #"  FROM rvw_file,rvv_file ",  
               "  FROM rvw_file,",cl_get_target_table(g_rvuplant,'rvv_file'),
              #FUN-A60056--mod--end
               " WHERE rvv01 ='",g_head_1.rvu01,"'",  #單頭
               "   AND rvw08 = rvv01 ",
               "   AND rvw09 = rvv02 ",
               "   AND ",p_wc2 CLIPPED,                     #單身
               " ORDER BY rvw09"
    #No.MOD-540169 --end--
 
   PREPARE i120_pb FROM g_sql
   IF STATUS THEN
      CALL cl_err('i120_pb:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE rvw_curs CURSOR FOR i120_pb
 
   CALL g_rvw.clear()
   lET g_rec_b = 0
   LET g_cnt = 1
   FOREACH rvw_curs INTO g_rvw[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_rvw[g_cnt].sum1 = g_rvw[g_cnt].rvw05f + g_rvw[g_cnt].rvw06f    #FUN-C80027
      LET g_rvw[g_cnt].sum2 = g_rvw[g_cnt].rvw05 + g_rvw[g_cnt].rvw06      #FUN-C80027

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_rvw.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt=0
END FUNCTION
 
FUNCTION i120_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #NO FUN-690009  VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvw TO s_rvw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i120_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
      ON ACTION previous
         CALL i120_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
 
      ON ACTION jump
         CALL i120_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
 
      ON ACTION next
         CALL i120_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
 
      ON ACTION last
         CALL i120_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
      #FUN-4B0009
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      #No.FUN-750089 --start--
      ON ACTION batchi_generate_body_data
         LET g_action_choice="batchi_generate_body_data"
         EXIT DISPLAY
      #No.FUN-750089 --end--
  
      ON ACTION related_document                #No.FUN-6A0009  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i120_bp_refresh()
   DISPLAY ARRAY g_rvw TO s_rvw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END DISPLAY
END FUNCTION
 
FUNCTION i120_chk_amt()
   DEFINE l_rvw09          LIKE rvw_file.rvw09
   DEFINE l_amt,l_amt2     LIKE rvw_file.rvw05
 
   #modify 030425 bug no:A069
   DECLARE i120_chk_curs CURSOR FOR
    SELECT rvw09,SUM(rvw05f)
      FROM rvw_file
     WHERE rvw08 = g_head_1.rvu01
     GROUP BY rvw09
     ORDER BY rvw09
   IF STATUS THEN CALL cl_err('i120_chk_curs',STATUS,0) RETURN END IF
   LET g_errno = ''
   FOREACH i120_chk_curs INTO l_rvw09,l_amt
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
       #No.MOD-540169 --start--
#     IF g_type = '1' THEN
#        SELECT SUM(rvb07*rvb10) INTO l_amt2 FROM rvb_file
#         WHERE rvb01 = g_head.rvu01 AND rvb02 = l_rvw09
#        LET l_amt2= cl_digcut(l_amt2,t_azi04)   #bug no:7385
#     ELSE
#        LET l_amt = l_amt * -1
#        SELECT SUM(rvv39) INTO l_amt2 FROM rvv_file
#         WHERE rvv01 = g_head.rvu01 AND rvv02 = l_rvw09
#     END IF
      IF g_type = '3' THEN
         LET l_amt = l_amt * -1
      END IF
     #FUN-A60056--mod--str--
     #SELECT SUM(rvv39) INTO l_amt2 FROM rvv_file
     # WHERE rvv01 = g_head_1.rvu01 AND rvv02 = l_rvw09
      LET g_sql = "SELECT SUM(rvv39) ",
                  "  FROM ",cl_get_target_table(g_rvuplant,'rvv_file'),
                  " WHERE rvv01 = '",g_head_1.rvu01,"'",
                  "   AND rvv02 = '",l_rvw09,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
      PREPARE sel_sum_rvv39 FROM g_sql
      EXECUTE sel_sum_rvv39 INTO l_amt2
     #FUN-A60056--mod--end
      IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
      LET l_amt2= cl_digcut(l_amt2,t_azi04)   #bug no:7385
       #No.MOD-540169 --end--
      #發票金額大於收/退貨金額
      IF l_amt > l_amt2 THEN
         LET g_errno = 'tis-005' RETURN
      END IF
#CHI-970028---begin                                                                                                                 
      IF l_amt < l_amt2 THEN                                                                                                        
        LET g_errno = 'tis-006'  RETURN                                                                                             
      END IF                                                                                                                        
#CHI-970028---end  
  END FOREACH
END FUNCTION
 
#單身
FUNCTION i120_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO FUN-690009 VARCHAR(1) 
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rvw07,rvw01,rvw02,rvw03,rw04,rvw11,
                               rvw12,rvw05f,rvw06f,rvw05,rvw06,rvw10",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i120_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO FUN-690009 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rvw07,rvw01,rvw02,rvw03,rw04,rvw11,
                               rvw12,rvw05f,rvw06f,rvw05,rvw06,rvw10",FALSE)
#      IF g_gec05 NOT MATCHES '[gG]' THEN
#          CALL cl_set_comp_entry("rvw10",FALSE)
#      END IF
   END IF
 
END FUNCTION
 
 #No.MOD-540169 --start--
#計算未生成請款的入庫數量、衝暫估數量
FUNCTION i120_rvw10()
   DEFINE l_sql    LIKE type_file.chr1000  #NO FUN-690009 VARCHAR(300)
   DEFINE l_apb09  LIKE apb_file.apb09   #衝暫估數量
   LET l_sql = " SELECT SUM(rvw10) ",
               "   FROM rvw_file ",
               "  WHERE rvw01 NOT IN ",
               "(SELECT DISTINCT apk03 ",
               "   FROM apk_file,apa_file,apb_file ",
               "  WHERE apk01 = apa01 ",
               "    AND apa01 = apb01 ",
               "    AND apb21 = '",g_head_1.rvu01,"' ",
               "    AND apb22 = ",g_rvw[l_ac].rvw09,") ",
               "    AND rvw08 = '",g_head_1.rvu01,"' ",
               "    AND rvw09 = ",g_rvw[l_ac].rvw09," "
   PREPARE i120_pb1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE rvw_curs1 CURSOR FOR i120_pb1
   OPEN rvw_curs1
   FETCH rvw_curs1 INTO g_rvw10
   IF cl_null(g_rvw10) THEN LET g_rvw10 = 0 END IF
   #-----MOD-980053---------
   #SELECT SUM(apb09) INTO l_apb09
   #  FROM apb_file,apa_file
   # WHERE apa01 = apb01
   #   AND apa08 = 'UNAP'
   #   AND apb21 = g_head_1.rvu01
   #   AND apb22 = g_rvw[l_ac].rvw09
   #IF cl_null(l_apb09) THEN LET l_apb09 = 0 END IF
   #LET g_rvw10 = g_rvw10 - l_apb09
   #-----END MOD-980053-----
 
END FUNCTION
 #No.MOD-540169 --end--
 
#str CHI-970028 add                                                                                                                 
FUNCTION i120_rvw05()   #計算未生成請款的入庫金額                                                                                   
   DEFINE l_sql    LIKE type_file.chr1000                                                                                           
                                                                                                                                    
   LET l_sql = " SELECT SUM(rvw05f),SUM(rvw05) ",                                                                                   
               "   FROM rvw_file ",                                                                                                 
               "  WHERE rvw01 NOT IN ",                                                                                             
               "(SELECT DISTINCT apk03 ",                                                                                           
               "   FROM apk_file,apa_file,apb_file ",                                                                               
               "  WHERE apk01 = apa01 ",                                                                                            
               "    AND apa01 = apb01 ",                                                                                            
               "    AND apb21 = '",g_head_1.rvu01,"' ",                                                                             
               "    AND apb22 = ",g_rvw[l_ac].rvw09,") ",                                                                           
               "    AND rvw08 = '",g_head_1.rvu01,"' ",                                                                             
               "    AND rvw09 = ",g_rvw[l_ac].rvw09," "                                                                             
   PREPARE i120_pb2 FROM l_sql                                                                                                      
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF                                                              
   DECLARE rvw_curs2 CURSOR FOR i120_pb2                                                                                            
   OPEN rvw_curs2                                                                                                                   
   FETCH rvw_curs2 INTO g_rvw05f,g_rvw05                                                                                            
   IF cl_null(g_rvw05f) THEN LET g_rvw05f = 0 END IF                                                                                
   IF cl_null(g_rvw05)  THEN LET g_rvw05  = 0 END IF                                                                                
END FUNCTION                                                                                                                        
#end CHI-970028 add     
 
#No.FUN-750089 --start--
FUNCTION i120_bgbd()
DEFINE tok base.StringTokenizer
DEFINE l_str       STRING
DEFINE l_i         LIKE type_file.num5
DEFINE l_rvw08     LIKE rvw_file.rvw08
DEFINE l_rvw09     LIKE rvw_file.rvw09
DEFINE l_rvv25     LIKE rvv_file.rvv25  #MOD-B50016 add
 
   LET l_ac = 1
   CALL q_rvv5(TRUE,TRUE,g_head_1.rvu04,g_head_1.rvu01,'',g_rvuplant)   #FUN-A60056 add rvuplant 
        RETURNING g_qryparam.multiret
   LET l_str=g_qryparam.multiret CLIPPED
   LET tok = base.StringTokenizer.create(l_str,"|")
   IF NOT cl_null(l_str) THEN
      LET l_i=1
      WHILE tok.hasMoreTokens()
         IF l_i mod 2 THEN
            LET l_rvw08=tok.nextToken()
            LET l_i=l_i+1
            CONTINUE WHILE
         END IF
         LET l_i=l_i+1
         LET l_rvw09=tok.nextToken()
         LET g_rvw[l_ac].rvw09=l_rvw09
         CALL i120_rvw09()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_rvw[l_ac].rvw09,g_errno,0)
            CONTINUE WHILE
         END IF
        #str MOD-B50016 add
        #若為樣品時,金額部份(rvw17,rvw05,rvw05f,rvw06,rvw06f)應帶0
         LET l_rvv25=""
         LET g_sql = "SELECT rvv25 FROM ",cl_get_target_table(g_rvuplant,'rvv_file'),
                     " WHERE rvv01 = '",g_head_1.rvu01,"'",
                     "   AND rvv02 = '",g_rvw[l_ac].rvw09,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_rvuplant) RETURNING g_sql
         PREPARE sel_rvv25_1 FROM g_sql
         EXECUTE sel_rvv25_1 INTO l_rvv25
         IF cl_null(l_rvv25) THEN LET l_rvv25="N" END IF
         IF l_rvv25="Y" THEN
            LET g_rvw_rvw17       =0
            LET g_rvw[l_ac].rvw05 =0 
            LET g_rvw[l_ac].rvw05f=0                  
            LET g_rvw[l_ac].sum1  =0         #FUN-C80027                                                                            
            LET g_rvw[l_ac].rvw06 =0 
            LET g_rvw[l_ac].rvw06f=0
            LET g_rvw[l_ac].sum2  =0         #FUN-C80027
         END IF   
        #end MOD-B50016 add
         #NO.TQC-790003 start--
         IF cl_null(g_rvw[l_ac].rvw09) THEN LET g_rvw[l_ac].rvw09 = 0 END IF
         #NO.TQC-790003 end----
         INSERT INTO rvw_file(rvw01,rvw02,rvw03,rvw04,rvw11,rvw12,rvw05f,
                              rvw06f,rvw05,rvw06,rvw07,rvw08,rvw09,rvw10,rvw17,
                             #rvwplant,rvwlegal) #FUN-980011 add   #FUN-9B0146
                             #rvwlegal)                          #FUN-9B0146 #MOD-B70210 mark
                              rvwlegal,rvw99,rvwacti)                     #MOD-B70210 add    #FUN-D10064 add--rvwacti
                       VALUES('   ',g_today,g_rvw[l_ac].rvw03,g_rvw[l_ac].rvw04,
                              g_rvw[l_ac].rvw11,g_rvw[l_ac].rvw12,
                              g_rvw[l_ac].rvw05f,g_rvw[l_ac].rvw06f,
                              g_rvw[l_ac].rvw05,g_rvw[l_ac].rvw06,'   ',
                              g_head_1.rvu01,g_rvw[l_ac].rvw09,
                              g_rvw[l_ac].rvw10,g_rvw_rvw17,     #No.MOD-540169
                              #g_plant,g_legal) #FUN-980011 add  #FUN-9B0146
                             #g_legal)                           #FUN-9B0146 #MOD-B70210 mark
                              g_legal,g_plant,'Y')                   #MOD-B70210 add     #FUN-D10064 add--rvwacti
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err(g_rvw[l_ac].rvw09,SQLCA.sqlcode,0)
         END IF
      END WHILE
   END IF 
 
   CALL i120_b_fill(' 1=1')
   CALL i120_b()
 
END FUNCTION
#No.FUN-750089 --end--
 
#Patch....NO.TQC-610037 <001,002,003,004,005,006,007,008,009,010,011,012,013,014,015,016,017,018,019,020,021,022,023,024,025,026,027,028,029> #
