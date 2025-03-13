# Prog. Version..: '5.30.06-13.04.18(00010)'     #
#
# Pattern name...: amdp020.4gl
# Descriptions...: 進項資料擷取作業
# Date & Author..: 01/05/21 by
# Modify.........: 此程式由 amdi100_g() copy 過來獨立成一支新程式
# Modify.........: No.B597 010524 增加amd40-amd43 欄位
#                  No.+111 進項折讓時必須依發票group 顯示資料
# Modify.........: No:7785 03/08/15 By Wiky OUTER問題將OUTER FILE 例 "AND gec_file.gec011= '1'"
#                : 改為" gec_file.gec011='1' " 醬才可抓到資料(FOR ORACLE)
# Modify.........: No:8111 03/09/05 By Wiky AND apz053 != 'N'======>改為azp053
# Modify.........: No:8005 03/11/04 By Kitty 在AFTER INPUT增加判斷工廠不可為空白
# Modify.........: No:8684 03/11/14 By Kitty CONSTRUCT應該條件都要下
# Modify.........: No:8708 03/12/02 By Kitty 若輸入稅藉部門後,直接ESC g_ary[1].plant未帶入值
# Modify.........: No.9017 04/01/12 By Kitty plant長度修改
# Modify.........: No.9041 04/01/15 By Kitty apa175 是 number 型態  不能有 OR apa175 = ' '
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-560247 05/06/29 By wujie  單據編號，發票號碼加大之返工
# Modify.........: No.MOD-570356 05/07/27 By Smapmin 無傳票日期時,以帳款日期做為amdi100的資料年月
# Modify.........: No.MOD-610027 06/01/06 By Smapmin insert到amd_file時,先判斷發票編號+格式是否有重複的
# Modify.........: no.FUN-570123 06/03/07 By yiting 批次作業修改
# Modify.........: No.MOD-640146 06/04/09 By Smapmin insert錯誤時要秀出錯誤訊息
# Modify.........: No.MOD-640310 06/04/10 By Smapmin LET g_success='Y'
# Modify.........: No.MOD-640414 06/04/12 By Smapmin 修正NOT MATCHES的語法
# Modify.........: No.FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No.MOD-670004 06/07/03 By Smapmin 多發票資料,稅別應抓取apk11而非apa15
# Modify.........: No.FUN-680074 06/08/23 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6C0054 06/12/27 By rainy 固定資產資料insert 到 amf_file
# Modify.........: No.MOD-7B0111 07/11/13 By Pengu l_k = 143，l_buf 就被劫掉了
# Modify.........: No.MOD-7B0130 07/11/14 By Smapmin 非請款折讓單據的傳票來源應先抓取自己的傳票編號為優先
# Modify.........: No.MOD-7C0223 08/01/08 By Smapmin 折讓轉媒體申報發票日期應為折讓帳款日
# Modify.........: No.FUN-770040 08/06/04 By Smapmin 增加新增發票聯數到媒體申報檔
# Modify.........: No.MOD-8B0153 08/11/14 By Sarah 當amd031為4或X時設定amd29='2'
# Modify.........: No.MOD-8B0164 08/11/20 By Sarah 檢核帳款單別之apydmy3是否為'N',若為'N'才需要帶出aapt330的傳票資料
# Modify.........: No.CHI-920017 09/02/24 By Sarah amd-011建議改成彙總訊息的方式,最後再統一顯示
# Modify.........: No.CHI-8C0011 09/03/11 By Sarah 進項資料稅別26,27格式需預設amd09(彙加註記)為'A'
# Modify.........: No.MOD-950149 09/05/14 By Sarah 刪除amf_file時,amf02應等於前面amd_file的amd02的值
# Modify.........: No.FUN-8B0081 09/07/30 By hongmei 拋轉至amd_file時，預設amd44 = '3'(空白)
# Modify.........: No.FUN-980004 09/08/31 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-970108 09/08/20 By hongmei 申報稅籍部門，放開all的控管
# Modify.........: No.MOD-990140 09/09/16 By mike 第1158行LET l_amd09 = 'A'應調整為LET l_apk.apk09='A'。                            
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No:MOD-9C0427 09/12/29 By Sarah 1.當aza94<>'Y'時,(1)將dummy01隱藏(2)若amd22輸入ALL需顯示錯誤訊息
#                                                  2.當amd22輸入ALL時,請以apa77/apk32串amdi001抓出ama01,再將ama01寫入amd22
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No:MOD-A40093 10/04/19 By sabrina 直接select，無法抓到該營運中心的資料
# Modify.........: No:MOD-A40109 10/04/22 By sabrina 補充MOD-A40093修改
# Modify.........: No.FUN-A50102 10/07/08 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A70169 10/07/22 By Dido g_amd22 應直接給予 l_ama01 
# Modify.........: No:MOD-A30056 10/08/03 By sabrina 若失敗或沒有產生資料要顯示錯誤訊息
# Modify.........: No:MOD-A80176 10/08/25 By Dido 資料重複可往下執行,不認定為 g_scuess = 'N' 
# Modify.........: No:MOD-AB0226 10/11/25 By Dido 折讓格式 apk171 增加 26/27 轉換  
# Modify.........: No:MOD-B20095 11/02/18 By Dido 若有重複資料不設定 g_success = 'N'  
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting  1、將cl_used()改成標準，使用g_prog
#                                                          2、未加離開前的 cl_used(2) 
# Modify.........: No:MOD-B50189 11/05/23 By Dido apk171='22'AND gec05 = '4','X' 不檢查發票編號 
# Modify.........: No:MOD-BC0073 11/12/08 By Polly aza94=N時增加統一編號條件
# Modify.........: No:MOD-CA0188 12/10/29 By Polly 22格式在擷取pak時，調整為應稅、零稅、免稅都需擷取
# Modify.........: No:CHI-D20007 13/02/06 By apo 屬於0.單一營運中心者(ama15),不予以用統編為條件來抓取前端應收/應付的資料

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_tran   LIKE oay_file.oayslip,          #No.FUN-680074 VARCHAR(5)#No.FUN-560247 
       g_ama    RECORD LIKE ama_file.*,
       g_ary    ARRAY [08] OF RECORD
                 plant   LIKE azp_file.azp01,   #No.FUN-680074 VARCHAR(10)#No:9017
                 dbs_new LIKE type_file.chr21   #No.FUN-680074 VARCHAR(21)
                END RECORD,
       g_wc,g_wc2,g_wc3  STRING,                #No.FUN-580092 HCN  #No.FUN-680074
       g_amd22           LIKE amd_file.amd22,
       g_plant_1         LIKE azp_file.azp01,
       g_plant_2         LIKE azp_file.azp01,
       g_plant_3         LIKE azp_file.azp01,
       g_plant_4         LIKE azp_file.azp01,
       g_plant_5         LIKE azp_file.azp01,
       g_plant_6         LIKE azp_file.azp01,
       g_plant_7         LIKE azp_file.azp01,
       g_plant_8         LIKE azp_file.azp01,
       g_row,g_col       LIKE type_file.num5,    #No.FUN-680074 SMALLINT
       g_cnt             LIKE type_file.num10,   #No.FUN-680074 INTEGER
       g_change_lang     LIKE type_file.chr1,    #No.FUN-680074 VARCHAR(1)#FUN-570123
       l_flag            LIKE type_file.chr1,    #FUN-570123        #No.FUN-680074 VARCHAR(1)
       g_t1              LIKE apy_file.apyslip,  #MOD-8B0164 add
       g_apydmy3         LIKE apy_file.apydmy3   #MOD-8B0164 add
DEFINE g_ama02           LIKE ama_file.ama02     #FUN-970108 add
DEFINE g_sql             STRING                  #No.TQC-9B0021
DEFINE begin_no          LIKE amd_file.amd01     #MOD-A30056
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc      = ARG_VAL(1)
   LET g_tran    = ARG_VAL(2)
   LET g_amd22   = ARG_VAL(3)
   LET g_plant_1 = ARG_VAL(4)
   LET g_plant_2 = ARG_VAL(5)
   LET g_plant_3 = ARG_VAL(6)
   LET g_plant_4 = ARG_VAL(7)
   LET g_plant_5 = ARG_VAL(8)
   LET g_plant_6 = ARG_VAL(9)
   LET g_plant_7 = ARG_VAL(10)
   LET g_plant_8 = ARG_VAL(11)
   LET g_bgjob   = ARG_VAL(12)
   LET begin_no = NULL     #MOD-A30056 add
 
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used('amdp020',g_time,1) RETURNING g_time   #No.FUN-6A0068 #FUN-B30211
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0068  #FUN-B30211
   WHILE TRUE
      LET g_success = 'Y'   #MOD-640310
      IF g_bgjob = 'N' THEN
         CALL p020_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            BEGIN WORK
            CALL p020_g()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
              CONTINUE WHILE
            ELSE
              CLOSE WINDOW p020_w
              EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p020_w
      ELSE
         SELECT * INTO g_ama.* from ama_file
          WHERE ama01 = g_amd22 AND amaacti= 'Y'
         CALL p020_chk_db()
         BEGIN WORK
         CALL p020_g()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   #CALL cl_used('amdp020',g_time,2) RETURNING g_time  #No.FUN-6A0068  #FUN-B30211
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0068   #FUN-B30211
END MAIN
 
FUNCTION p020_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680074 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680074
   DEFINE l_dbs      LIKE type_file.chr21,             #No.FUN-680074 VARCHAR(21)
          l_sql      STRING                            #No.FUN-680074
   DEFINE lc_cmd     LIKE type_file.chr1000            #No.FUN-680074 VARCHAR(1000)#FUN-570123
   DEFINE l_plant    LIKE azp_file.azp01               #No.FUN-A50102
 
   LET g_row = 4 LET g_col = 15
   OPEN WINDOW p020_w AT g_row,g_col WITH FORM "amd/42f/amdp020"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
 
   IF g_aza.aza94<>'Y' THEN
      CALL cl_set_comp_visible("dummy01",FALSE)
   ELSE
      CALL cl_set_comp_visible("dummy01",TRUE)
   END IF

WHILE TRUE
    MESSAGE ""
    CALL ui.Interface.refresh()
    CALL cl_opmsg('p')
    CONSTRUCT BY NAME g_wc ON apa22,apa00,apa01,apa02,apa09,apa08
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
    ON ACTION locale          #genero
       LET g_change_lang = TRUE                  #FUN-570123
       EXIT CONSTRUCT
 
    ON ACTION exit              #加離開功能genero
       LET INT_FLAG = 1
       EXIT CONSTRUCT
 
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
 
  END CONSTRUCT
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup') #FUN-980030
  IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p020_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
  END IF
  IF g_action_choice = "locale" THEN  #genero
     LET g_action_choice = ""
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()                   #No.FUN-570123
     CONTINUE WHILE
  END IF
  IF g_wc=' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF   #No:8684
    LET g_plant_1 = g_plant
    LET l_dbs = NULL
    LET l_plant = NULL                                               #FUN-A50102
    #SELECT azp03  INTO l_dbs   FROM azp_file,apz_file
    SELECT azp01,azp03  INTO l_plant,l_dbs   FROM azp_file,apz_file  #FUN-A50102
     WHERE apz02p = azp01 AND apz00 = '0'
       AND apz02 = 'Y'
       AND azp053 != 'N' #No:8111
    LET l_sql = "SELECT COUNT(*) ",
                #"  FROM ",s_dbstring(l_dbs CLIPPED),"aac_file",
                "  FROM ",cl_get_target_table(l_plant,'aac_file'), #FUN-A50102
                " WHERE aac01 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102	
    PREPARE p020_g_pre FROM l_sql
    DECLARE p020_g_cur CURSOR WITH HOLD FOR p020_g_pre
 
   INPUT g_tran,g_amd22,g_plant_1, g_plant_2, g_plant_3, g_plant_4,
         g_plant_5,g_plant_6, g_plant_7, g_plant_8,g_bgjob #NO.FUN-570123 
         WITHOUT DEFAULTS
         FROM tran,amd22  ,plant_1, plant_2, plant_3, plant_4 ,
              plant_5, plant_6, plant_7, plant_8,g_bgjob #NO.FUN-570123 
 
        AFTER FIELD tran
            IF NOT cl_null(g_tran) THEN
               OPEN p020_g_cur USING g_tran
               FETCH p020_g_cur INTO g_cnt
               IF g_cnt = 0 THEN
                  NEXT FIELD tran
               END IF
            END IF
 
        AFTER FIELD amd22
            IF g_amd22 <> 'ALL' THEN   #FUN-970108 add
               IF NOT cl_null(g_amd22) THEN
                    SELECT * INTO g_ama.* from ama_file
                    WHERE ama01 = g_amd22 AND amaacti= 'Y'
                    SELECT ama02 INTO g_ama02 
                      FROM ama_file WHERE ama01 = g_amd22
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("sel","ama_file",g_amd22,"","amd-002","","",1)  #No.FUN-660093
                       NEXT FIELD amd22
                    END IF
               END IF
               IF g_multpl='N' THEN  #不為多工廠環境
                  LET g_plant_1= g_plant
                  LET g_plant_new= NULL
                  LET g_dbs_new=NULL
                  LET g_ary[1].plant = g_plant_1
                  LET g_ary[1].dbs_new = g_dbs_new CLIPPED
                  DISPLAY g_plant_1 TO FORMONLY.plant_1
                  EXIT INPUT       #將不會I/P plant_2 plant_3 plant_4
               END IF
            ELSE
               IF g_aza.aza94<>'Y' THEN
                  CALL cl_err(g_amd22,"amd-029",0)
                  NEXT FIELD amd22
               END IF
            END IF  #FUN-970108 add 
            
        BEFORE FIELD plant_1
            IF g_multpl='N' THEN  #不為多工廠環境
               LET g_plant_1= g_plant
               LET g_plant_new= NULL
               LET g_dbs_new=NULL
               LET g_ary[1].plant = g_plant_1
               LET g_ary[1].dbs_new = g_dbs_new CLIPPED
               DISPLAY g_plant_1 TO FORMONLY.plant_1
               EXIT INPUT       #將不會I/P plant_2 plant_3 plant_4
            END IF
 
        AFTER FIELD plant_1
            LET g_plant_new= g_plant_1
            IF g_plant_1 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[1].plant = g_plant_1
               LET g_ary[1].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_1) THEN
                  #檢查工廠並將新的資料庫放在g_dbs_new
                  IF NOT s_chknplt(g_plant_1,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_1
                  END IF
                  LET g_ary[1].plant = g_plant_1
                  CALL s_getdbs()
                  LET g_ary[1].dbs_new = g_dbs_new
               ELSE                     #輸入之工廠編號為' '或NULL
                  LET g_ary[1].plant = g_plant_1
               END IF
            END IF
        AFTER FIELD plant_2
            LET g_plant_2 = duplicate(g_plant_2,1)   #不使"工廠編號"重覆
            LET g_plant_new= g_plant_2
            IF g_plant_2 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[2].plant = g_plant_2
               LET g_ary[2].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_2) THEN
                  #檢查工廠並將新的資料庫放在g_dbs_new
                  IF NOT s_chknplt(g_plant_2,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_2
                  END IF
                  LET g_ary[2].plant = g_plant_2
                  CALL s_getdbs()
                  LET g_ary[2].dbs_new = g_dbs_new
               ELSE                     #輸入之工廠編號為' '或NULL
                  LET g_ary[2].plant = g_plant_2
               END IF
            END IF
 
        AFTER FIELD plant_3
            LET g_plant_3 = duplicate(g_plant_3,2)   #不使"工廠編號"重覆
            LET g_plant_new= g_plant_3
            IF g_plant_3 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[3].plant = g_plant_3
               LET g_ary[3].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_3) THEN
                  #檢查工廠並將新的資料庫放在g_dbs_new
                  IF NOT s_chknplt(g_plant_3,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_3
                  END IF
                  LET g_ary[3].plant = g_plant_3
                  CALL s_getdbs()
                  LET g_ary[3].dbs_new = g_dbs_new
               ELSE                     #輸入之工廠編號為' '或NULL
                  LET g_ary[3].plant = g_plant_3
               END IF
            END IF
 
        AFTER FIELD plant_4
            LET g_plant_4 = duplicate(g_plant_4,3)   #不使"工廠編號"重覆
            LET g_plant_new= g_plant_4
            IF g_plant_4 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[4].plant = g_plant_4
               LET g_ary[4].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_4) THEN
                                        #檢查工廠並將新的資料庫放在g_dbs_new
                  IF NOT s_chknplt(g_plant_4,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_4
                  END IF
                  LET g_ary[4].plant = g_plant_4
                  CALL s_getdbs()
                  LET g_ary[4].dbs_new = g_dbs_new
               ELSE                     #輸入之工廠編號為' '或NULL
                  LET g_ary[4].plant = g_plant_4
               END IF
            END IF
 
        AFTER FIELD plant_5
            LET g_plant_5 = duplicate(g_plant_5,3)   #不使"工廠編號"重覆
            LET g_plant_new= g_plant_5
            IF g_plant_5 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[5].plant = g_plant_5
               LET g_ary[5].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_5) THEN
                  IF NOT s_chknplt(g_plant_5,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_5
                  END IF
                  LET g_ary[5].plant = g_plant_5
                  CALL s_getdbs()
                  LET g_ary[5].dbs_new = g_dbs_new
               ELSE LET g_ary[5].plant = g_plant_5
               END IF
            END IF
 
        AFTER FIELD plant_6
            LET g_plant_6 = duplicate(g_plant_6,3)   #不使"工廠編號"重覆
            LET g_plant_new= g_plant_6
            IF g_plant_6 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[6].plant = g_plant_6
               LET g_ary[6].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_6) THEN
                  IF NOT s_chknplt(g_plant_6,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_6
                  END IF
                  LET g_ary[6].plant = g_plant_6
                  CALL s_getdbs()
                  LET g_ary[6].dbs_new = g_dbs_new
               ELSE LET g_ary[6].plant = g_plant_6
               END IF
            END IF
 
        AFTER FIELD plant_7
            LET g_plant_7 = duplicate(g_plant_7,3)   #不使"工廠編號"重覆
            LET g_plant_new= g_plant_7
            IF g_plant_7 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[7].plant = g_plant_7
               LET g_ary[7].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_7) THEN
                  IF NOT s_chknplt(g_plant_7,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_7
                  END IF
                  LET g_ary[7].plant = g_plant_7
                  CALL s_getdbs()
                  LET g_ary[7].dbs_new = g_dbs_new
               ELSE LET g_ary[7].plant = g_plant_7
               END IF
            END IF
 
        AFTER FIELD plant_8
            LET g_plant_8 = duplicate(g_plant_8,3)   #不使"工廠編號"重覆
            LET g_plant_new= g_plant_8
            IF g_plant_8 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[8].plant = g_plant_8
               LET g_ary[8].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_8) THEN
                  IF NOT s_chknplt(g_plant_8,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_8
                  END IF
                  LET g_ary[8].plant = g_plant_8
                  CALL s_getdbs()
                  LET g_ary[8].dbs_new = g_dbs_new
               ELSE LET g_ary[8].plant = g_plant_8
               END IF
            END IF
            IF cl_null(g_plant_1) AND cl_null(g_plant_2) AND
               cl_null(g_plant_3) AND cl_null(g_plant_4) AND
               cl_null(g_plant_5) AND cl_null(g_plant_6) AND
               cl_null(g_plant_7) AND cl_null(g_plant_8) THEN
               CALL cl_err(0,'aap-136',0)
               NEXT FIELD plant_1
            END IF
 
        AFTER INPUT
           IF cl_null(g_amd22)
           THEN DISPLAY g_amd22 TO amd22
                NEXT FIELD amd22
           END IF
           IF cl_null(g_plant_1) AND cl_null(g_plant_2) AND
              cl_null(g_plant_3) AND cl_null(g_plant_4) AND
              cl_null(g_plant_5) AND cl_null(g_plant_6) AND
              cl_null(g_plant_7) AND cl_null(g_plant_8) THEN
              CALL cl_err(0,'aap-136',0)
              NEXT FIELD plant_1
           ELSE
               LET g_ary[1].plant = g_plant_1
               LET g_ary[2].plant = g_plant_2
               LET g_ary[3].plant = g_plant_3
               LET g_ary[4].plant = g_plant_4
               LET g_ary[5].plant = g_plant_5
               LET g_ary[6].plant = g_plant_6
               LET g_ary[7].plant = g_plant_7
               LET g_ary[8].plant = g_plant_8
           END IF
        ON ACTION CONTROLP
            IF INFIELD(amd22) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ama"
              LET g_qryparam.default1 = g_amd22
              CALL cl_create_qry() RETURNING g_amd22
              DISPLAY BY NAME g_amd22
              NEXT FIELD amd22
            END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION exit      #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
     ON ACTION locale                #NO.FUN-570123 
        LET g_change_lang = TRUE     
        EXIT INPUT
 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW p020_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM END IF
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 ='amdp020'
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('amdp020','9031',1)
      ELSE
         LET g_wc = cl_replace_str(g_wc,"'","\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",g_tran CLIPPED,"'",
                      " '",g_amd22 CLIPPED,"'",
                      " '",g_plant_1 CLIPPED,"'",
                      " '",g_plant_2 CLIPPED,"'",
                      " '",g_plant_3 CLIPPED,"'",
                      " '",g_plant_4 CLIPPED,"'",
                      " '",g_plant_5 CLIPPED,"'",
                      " '",g_plant_6 CLIPPED,"'",
                      " '",g_plant_7 CLIPPED,"'",
                      " '",g_plant_8 CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('amdp020',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p020_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
 END WHILE
 
END FUNCTION
 
FUNCTION p020_g()
 DEFINE l_sql           STRING,                 #No.FUN-680074
        l_sql1          STRING,                 #No.FUN-680074
        l_buf           LIKE type_file.chr1000, #No.FUN-680074 VARCHAR(400)
        l_k,l_l         LIKE type_file.num5,    #No.FUN-680074 SMALLINT
        l_apk           RECORD LIKE apk_file.*,
        l_apa           RECORD LIKE apa_file.*,
        t_apa           RECORD LIKE apa_file.*,
        l_apk26         LIKE apk_file.apk26,
        l_invoice       LIKE apk_file.apk03,    #BUGNO4197
        l_tax           LIKE apa_file.apa32,
        l_tot_tax       LIKE apa_file.apa32,
        l_apa16         LIKE apa_file.apa16,
        l_apa01_o       LIKE apa_file.apa01,
        l_gec06         LIKE gec_file.gec06,
        l_gec08         LIKE gec_file.gec08,
        l_apa02         LIKE apa_file.apa02,
        l_apa43         LIKE apa_file.apa43,
        l_apa44         LIKE apa_file.apa44,
        l_apk03         LIKE apk_file.apk03,
        l_tot           LIKE type_file.num10,   #No.FUN-680074 INTEGER
        t_bdate,t_edate LIKE type_file.dat,     #No.FUN-680074 DATE
        g_ama08         LIKE ama_file.ama08,
        g_ama09         LIKE ama_file.ama09,
        g_ama10         LIKE ama_file.ama10,
        l_guidate       LIKE amd_file.amd05,
        l_apa58         LIKE apa_file.apa58,
        l_zx04          LIKE zx_file.zx04,
        l_smu02         LIKE smu_file.smu02,
        l_amd40         LIKE amd_file.amd40,
        l_amd41         LIKE amd_file.amd41,
        l_amd42         LIKE amd_file.amd42,
        l_amd43         LIKE amd_file.amd43,
        old_apk01       LIKE apk_file.apk01,
        l_flag          LIKE type_file.chr1,    #No.FUN-680074 VARCHAR(1)
        l_yy,l_mm       LIKE type_file.num5,    #No.FUN-680074 SMALLINT   
        l_num           LIKE type_file.num5,    #No.FUN-680074 SMALLINT
        l_add_cnt       LIKE type_file.num5,    #No.FUN-680074 SMALLINT 
        l_dbs           LIKE type_file.chr20,   #No.FUN-680074 VARCHAR(20)
        g_idx           LIKE type_file.num5,    #No.FUN-680074 SMALLINT
        l_cnt           LIKE type_file.num5,    #MOD-CA0188 add
        l_cnt2          LIKE type_file.num5,    #MOD-610027        #No.FUN-680074 SMALLINT
        l_msg           LIKE type_file.chr20,   #No.FUN-680074 VARCHAR(20) #MOD-610027
        l_apb01         LIKE apb_file.apb01,    #FUN-6C0054
        l_apb02         LIKE apb_file.apb02,    #FUN-6C0054
        l_apb12         LIKE apb_file.apb12,    #FUN-6C0054
        l_apb27         LIKE apb_file.apb27,    #FUN-6C0054
        l_apb09         LIKE apb_file.apb09,    #FUN-6C0054
        l_gec05         LIKE gec_file.gec05,    #FUN-770040
        l_amd29         LIKE amd_file.amd29,    #MOD-8B0153 add
        l_amd09         LIKE amd_file.amd09,    #CHI-8C0011 add
        f_apa           RECORD LIKE apa_file.*,
        f_apf           RECORD LIKE apf_file.*,
        l_ama01         LIKE ama_file.ama01,    #MOD-9C0427 add
        l_azp03         LIKE azp_file.azp03,    #MOD-A40109 add
        l_check         LIKE type_file.chr1     #MOD-B50189
 
    CALL ui.Interface.refresh()
 
    CALL s_showmsg_init()   #CHI-920017 add
 
    FOR g_idx = 1 TO 8
        IF cl_null(g_ary[g_idx].plant) THEN CONTINUE FOR END IF
        SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=g_ary[g_idx].plant   #MOD-A40109 add
        LET g_ary[g_idx].dbs_new = s_dbstring(l_azp03 CLIPPED)        #MOD-A40109 add
        #依發票帳款編號讀apa_file 資料
        LET l_sql="SELECT apa_file.*,gec06,gec08 ",
                  #"  FROM ",g_ary[g_idx].dbs_new CLIPPED," apa_file,",
                  #"   OUTER ",g_ary[g_idx].dbs_new CLIPPED," gec_file",
                  "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'apa_file'),",", #FUN-A50102
                  "   OUTER ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'),   #FUN-A50102
                  " WHERE  apa01 = ?  ",   #No.+111 010510 by plum
                  "   AND apa_file.apa15 = gec_file.gec01 ",
                  "   AND apa42 = 'N' ",
                  "   AND gec_file.gec011= '1' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql #FUN-A50102
        PREPARE p020_preapa FROM l_sql
        DECLARE p020_curapa
            SCROLL CURSOR WITH HOLD FOR p020_preapa
 
        #----抓傳票編號用--------------------------
        LET l_sql = "SELECT apa_file.* ",
                    #"  FROM ",g_ary[g_idx].dbs_new CLIPPED," apv_file,", #010830
                    #"       ",g_ary[g_idx].dbs_new CLIPPED," apa_file ", #wiky
                    "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'apv_file'),",", #FUN-A50102
                    "       ",cl_get_target_table(g_ary[g_idx].plant,'apa_file'),     #FUN-A50102
                    " WHERE apv03 = ? ",
                    "   AND apa42 = 'N' ",
                    "   AND apv01 = apa01 "
	      IF g_amd22 <> 'ALL' THEN
           LET l_sql = l_sql CLIPPED, " AND apa77  = '",g_ama02,"'"
        END IF
 	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql #FUN-A50102
        PREPARE show_ref_p2 FROM l_sql
        DECLARE show_ref_c2 CURSOR FOR show_ref_p2
 
        LET l_sql = "SELECT apf_file.* ",
                    #"  FROM ",g_ary[g_idx].dbs_new CLIPPED," apf_file,", #010830
                    #"       ",g_ary[g_idx].dbs_new CLIPPED," aph_file ", #wiky
                    "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'apf_file'),",", #FUN-A50102
                    "       ",cl_get_target_table(g_ary[g_idx].plant,'aph_file'),     #FUN-A50102
                    " WHERE aph04 = ? ",
                    "   AND apf01 = aph01 ",
                    "   AND apf41 <> 'X' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql #FUN-A50102
        PREPARE show_ref_p3 FROM l_sql
        DECLARE show_ref_c3 CURSOR FOR show_ref_p3
 
        #-->進項資料--折讓
        #同一發票之折讓要group,不同發票要明細
        LET l_sql = "SELECT apk01,apk03,apk17,apk171,apk172,",
                    "       apk04,apk05,apk26,apk11,apk32,",   #FUN-770040  #MOD-9C0427 add apk32
                    "       SUM(apk06),SUM(apk07),SUM(apk08) ",
                    #"  FROM ",g_ary[g_idx].dbs_new CLIPPED," apa_file,",
                    #"       ",g_ary[g_idx].dbs_new CLIPPED," apb_file,",
                    #"       ",g_ary[g_idx].dbs_new CLIPPED," apk_file ", #010822改
                    #"  ,OUTER ",g_ary[g_idx].dbs_new CLIPPED," gec_file",
                    "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'apa_file'),",", #FUN-A50102
                    "       ",cl_get_target_table(g_ary[g_idx].plant,'apb_file'),",", #FUN-A50102
                    "       ",cl_get_target_table(g_ary[g_idx].plant,'apk_file'),     #FUN-A50102
                    "  ,OUTER ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'),   #FUN-A50102
                    " WHERE apa00 = '21' ",
                    "   AND apa41 = 'Y' AND apaacti = 'Y' ",
                    "   AND apa42 = 'N' ",
                    "   AND apa175 IS NULL ", #No:9041       
                    "   AND apa_file.apa15 = gec_file.gec01 ",
                    "   AND gec_file.gec011= '1' ",
                    "   AND apa01 = apb01 ",
                    "   AND apb01 = apk01 ",  #No.+111 010510 by plum
                    "   AND apb02 = apk02 ",  #No.+111 010510 by plum
                    "   AND apb11 IS NOT NULL AND apb11 <> ' '", #發票號碼
                    "   AND ",g_wc CLIPPED 
	IF g_aza.aza94 = 'Y' THEN
           IF g_amd22 <> 'ALL' THEN
               LET l_sql = l_sql CLIPPED, " AND apk32  = '",g_ama02,"'",
                     " GROUP BY apk01,apk03,apk17,apk171,apk172,apk04,apk05,apk26,apk11,apk32 ",   #MOD-9C0427 add apk32
                     " ORDER BY 1,2"
           ELSE
               LET l_sql = l_sql CLIPPED, 
                     " GROUP BY apk01,apk03,apk17,apk171,apk172,apk04,apk05,apk26,apk11,apk32 ",   #MOD-9C0427 add apk32
                     " ORDER BY 1,2"
           END IF
        ELSE
           IF g_ama.ama15<>0 THEN   #CHI-D20007
              LET l_sql = l_sql CLIPPED,
                          " AND apk32 = '",g_ama02,"'",                                                #MOD-BC0073 
                          " GROUP BY apk01,apk03,apk17,apk171,apk172,apk04,apk05,apk26,apk11,apk32 ",   #MOD-9C0427 add apk32
                          " ORDER BY 1,2"
          #CHI-D20007--
           ELSE
              LET l_sql = l_sql CLIPPED,
                          " GROUP BY apk01,apk03,apk17,apk171,apk172,apk04,apk05,apk26,apk11,apk32 ",
                          " ORDER BY 1,2"
           END IF  
          #CHI-D20007--
        END IF
                 
 	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql #FUN-A50102
        PREPARE p020_21_apkp FROM l_sql
        DECLARE p020_21_apk SCROLL CURSOR WITH HOLD FOR p020_21_apkp
        LET old_apk01='@@@@@@@@'
        FOREACH p020_21_apk INTO l_apk.apk01,l_apk.apk03,
                                 l_apk.apk17,l_apk.apk171,
                                 l_apk.apk172,l_apk.apk04,
                                 l_apk.apk05,l_apk.apk26,
                                 l_apk.apk11,l_apk.apk32,   #FUN-770040  #MOD-9C0427 add apk32
                                 l_apk.apk06,l_apk.apk07,l_apk.apk08
           IF SQLCA.sqlcode THEN
              CALL cl_err('p020_curapa',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           LET l_gec05 = ''
          #MOD-A40109---modify---start---
          #SELECT gec05 INTO l_gec05 FROM gec_file WHERE gec01=l_apk.apk11
           LET l_sql = "SELECT gec05 FROM ",cl_get_target_table(g_ary[g_idx].plant,'gec_file')," WHERE gec01='",l_apk.apk11,"'"
	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
           CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql  
           PREPARE p020_gec05 FROM l_sql
           EXECUTE p020_gec05 INTO l_gec05
          #MOD-A40109---modify---end---
           IF old_apk01<> l_apk.apk01 THEN
              LET l_num=0
           END IF
           LET old_apk01=l_apk.apk01
           CALL ui.Interface.refresh()
           #讀取該發票之帳款資料
           OPEN  p020_curapa  USING l_apk.apk01
           FETCH p020_curapa  INTO l_apa.*,l_gec06,l_gec08
           CLOSE p020_curapa
           IF cl_null(l_apk.apk171) THEN LET l_apk.apk171 = l_gec08 END IF
           IF cl_null(l_apk.apk172) THEN LET l_apk.apk172 = l_gec06 END IF
           IF NOT cl_null(g_tran) THEN
              LET g_sql = " DELETE FROM amd_file WHERE amd01 = '",l_apk.apk01,"'",
                          "          AND amd03 = '",l_apk.apk03,"'",
                          "          AND amd021 = '2' ",
                          "          AND amd28[1,",g_doc_len,"]='",g_tran,"'",     #No.FUN-560247 
                          "          AND amd30 = 'N' "
              PREPARE p020_str_p1 FROM g_sql
              EXECUTE p020_str_p1
           ELSE
              DELETE FROM amd_file WHERE amd01 = l_apk.apk01
                                     AND amd03 = l_apk.apk03
                                     AND amd021 = '2'
                                     AND amd30 = 'N'
           END IF
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","amd_file",l_apk.apk01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660093
              EXIT FOREACH
           END IF
          #-MOD-B50189-add-
           LET l_check = 'Y'
           IF l_apk.apk171 = '22' AND l_gec05 MATCHES '[4X]' THEN
              LET l_check = 'N'
           END IF
          #-MOD-B50189-end-
           #-----更改格式及應稅否
          #IF l_apk.apk171 = '21' THEN                                                 #MOD-AB0226 mark
           IF l_apk.apk171 = '21' OR l_apk.apk171 = '25' OR l_apk.apk171 = '26' THEN   #MOD-AB0226
              LET l_apk.apk171 = '23'
           END IF
          #IF l_apk.apk171 = '22' THEN                           #MOD-AB0226 mark
           IF l_apk.apk171 = '22' OR l_apk.apk171 = '27' THEN    #MOD-AB0226
              LET l_apk.apk171 = '24'
           END IF
          #-MOD-AB0226-mark-
          #IF l_apk.apk171 = '25' THEN
          #   LET l_apk.apk171 = '23'
          #END IF
          #-MOD-AB0226-end-
           IF l_apk.apk171 = '28' THEN     #no:7393
              LET l_apk.apk171 = '29'
           END IF
           #----gec08 = 'XX' 不申報
           IF cl_null(l_gec08) OR l_gec08 = 'XX' THEN CONTINUE FOREACH END IF
           #-->憑證日期不可為兩期之前資料
           IF l_apa.apa00 = '21'
           THEN LET l_guidate = l_apa.apa02    #  帳款日
           ELSE LET l_guidate = l_apa.apa09    #  發票日
           END IF
           CALL s_azn01(g_ama.ama08,g_ama.ama09) RETURNING t_bdate,t_edate
           LET t_bdate = t_bdate - g_ama.ama10 UNITS MONTH + 1 UNITS MONTH
           #--------傳票號碼
           IF l_apa.apa58 = '1' THEN #請款折讓
              #讀取該折讓單對應之請款資料
              OPEN  p020_curapa  USING l_apk.apk26
              FETCH p020_curapa  INTO t_apa.*,l_gec06,l_gec08
              CLOSE p020_curapa
               IF cl_null(t_apa.apa44) THEN LET t_apa.apa44 = ' ' END IF
               IF cl_null(t_apa.apa16) THEN LET t_apa.apa16 = 0 END IF
               IF cl_null(l_apa.apa43) THEN
                  LET l_yy  = YEAR(l_apa.apa02)
                  LET l_mm  = MONTH(l_apa.apa02)
               ELSE
                  LET l_yy  = YEAR(t_apa.apa43)
                  LET l_mm  = MONTH(t_apa.apa43)
               END IF
               #若輸入條件有傳票別, 判斷傳票編號<>畫面之傳票別則離開
               IF NOT cl_null(g_tran) AND t_apa.apa44[1,g_doc_len] <>g_tran THEN         #No.FUN-560247
                  CONTINUE FOREACH
               END IF
               LET l_num=l_num+1
             #IF l_apk.apk171 NOT MATCHES '2[3,4,9]' THEN  #MOD-640414      #MOD-B50189 mark
              IF l_apk.apk171 NOT MATCHES '2[3,4,9]' AND l_check = 'Y' THEN #MOD-B50189 
                 LET l_cnt2=0
                 SELECT COUNT(*) INTO l_cnt2 FROM amd_file
                    WHERE amd03=l_apk.apk03 AND amd171=l_apk.apk171
                 IF l_cnt2 > 0 THEN
                    LET l_msg = l_apk.apk03,'+',l_apk.apk171
                    IF g_bgerr THEN
                       CALL s_errmsg('','',l_msg,'amd-011',1)
                    ELSE
                       CALL cl_err(l_msg,'amd-011',1)
                    END IF
                   #LET g_success = 'N'     #MOD-A30056 add       #MOD-B20095 mark
                   #LET begin_no = l_apk.apk01    #MOD-A30056 add #MOD-B20095 mark
                    CONTINUE FOREACH
                 END IF
              END IF
              IF l_apk.apk171='26' OR l_apk.apk171='27' THEN
                 LET l_amd09 = 'A'
              ELSE
                 LET l_amd09 = ' '
              END IF
             #當amd031為4或X時設定amd29='2'
              IF l_gec05='4' OR l_gec05='X' THEN
                 LET l_amd29='2'
              ELSE
                 LET l_amd29='1'
              END IF
             #MOD-A40093---modify---start---
             #SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=l_apk.apk32  #MOD-9C0427 add
              IF NOT cl_null(l_apk.apk32) THEN
                 SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=l_apk.apk32
              ELSE
                #SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=g_amd22     #MOD-A70169 mark
                 LET l_ama01 = g_amd22                                           #MOD-A70169
              END IF
             #MOD-A40093---modify---end---
              INSERT INTO amd_file (amd01,amd02,amd021,amd03,amd04,amd05,  #No.MOD-470041
                                    amd06,amd07,amd08,amd09,amd10,amd17,
                                    amd171,amd172,amd173,amd174,amd175,
                                    amd22,amd25,amd26,amd27,amd28,amd29,
                                    amd30,amd35,amd36,amd37,amd38,amd39,
                                    amd40,amd41,amd42,amd43,amdacti,amduser,
                                    amdgrup,amdmodu,amddate,amd031,amd44,amdlegal)   #FUN-770040  #FUN-8B0081 add amd44 #FUN-980004 add amdlegal
              VALUES(l_apk.apk01,l_num,'2',l_apk.apk03,l_apk.apk04,
                     l_apa.apa02,l_apk.apk06,l_apk.apk07,l_apk.apk08,   #MOD-7C0223
                     l_amd09,' ',l_apk.apk17,l_apk.apk171,l_apk.apk172, #CHI-8C0011
                     l_yy,l_mm,'',l_ama01,g_ary[g_idx].plant,'','',  #MOD-9C0427 g_amd22->l_ama01
                     t_apa.apa44,l_amd29,'N','','','','','',l_apa.apa06,  #MOD-8B0153
                     l_apa.apa07,l_apa.apa02,l_apa.apa02,'Y',g_user,
                     g_grup,'',g_today,l_gec05,'3',g_legal)   #FUN-770040  #FUN-8B0081 add'3' #FUN-980004 add g_legal
              #IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN            #MOD-A80176 mark
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN                #MOD-A80176
                  CONTINUE FOREACH                                    #MOD-A80176
               ELSE                                                   #MOD-A80176
                  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN         #MOD-A80176 
                    #CALL cl_err3("ins","amd_file",l_apk.apk01,l_num,SQLCA.SQLCODE,"","",1)   #No:FUN-660093     #MOD-A80176 mark
                     LET g_success='N'
                    #EXIT FOREACH                                     #MOD-A80176 mark
                    #-MOD-A80176-add-
                     LET l_msg = l_apk.apk01,'+',l_num
                     IF g_bgerr THEN
                        CALL s_errmsg('ins','',l_msg,SQLCA.SQLCODE,1)
                     ELSE
                        CALL cl_err3("ins","amd_file",l_apk.apk01,l_num,SQLCA.SQLCODE,"","",1)   
                     END IF
                     CONTINUE FOREACH
                  END IF
                 #-MOD-A80176-end-
               END IF
               LET begin_no = l_apk.apk01    #MOD-A30056 add
           ELSE
              #非請款折讓
              LET l_yy  = YEAR(l_apa.apa02)
              LET l_mm  = MONTH(l_apa.apa02)
 
              LET g_t1 = ''   LET g_apydmy3 = ''
              LET g_t1 = s_get_doc_no(l_apa.apa01)
             #MOD-A40109---modify---start---
             #SELECT apydmy3 INTO g_apydmy3 FROM apy_file WHERE apyslip = g_t1
              LET l_sql = "SELECT apydmy3 FROM ",cl_get_target_table(g_ary[g_idx].plant,'apy_file')," WHERE apyslip = '",g_t1,"'"
	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
              CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql  
              PREPARE p020_apy FROM l_sql
              EXECUTE p020_apy INTO g_apydmy3 
             #MOD-A40109---modify---end---
 
              #-抓傳票編號(先抓直接沖帳檔[apv_file)，再抓付款單[apf_file])---
              LET l_apa44 = l_apa.apa44
              IF cl_null(l_apa44) THEN   
                 OPEN  show_ref_c2 USING l_apk.apk01
                 FETCH show_ref_c2 INTO  f_apa.*
                 IF STATUS THEN
                    IF g_apydmy3 = 'N' THEN   #MOD-8B0164 add
                       OPEN  show_ref_c3 USING l_apk.apk01
                       FETCH show_ref_c3 INTO  f_apf.*
                       IF STATUS THEN
                          SLEEP 0
                       ELSE
                          LET l_apa44 = f_apf.apf44
                       END IF
                       CLOSE show_ref_c3
                    ELSE
                       LET l_apa.apa44 = f_apa.apa44
                    END IF
                 ELSE
                    LET l_apa44 = f_apa.apa44
                 END IF
                 CLOSE show_ref_c2
              END IF   #MOD-7B0130
              #若輸入條件有傳票別, 判斷傳票編號<>畫面之傳票別則離開
              IF NOT cl_null(g_tran) AND l_apa44[1,g_doc_len] <>g_tran THEN         #No.FUN-560247   #MOD-7B0130
                    CONTINUE FOREACH
              END IF
              LET l_num=l_num+1
             #IF l_apk.apk171 NOT MATCHES '2[3,4,9]' THEN  #MOD-640414      #MOD-B50189 mark
              IF l_apk.apk171 NOT MATCHES '2[3,4,9]' AND l_check = 'Y' THEN #MOD-B50189 
                 LET l_cnt2=0
                 SELECT COUNT(*) INTO l_cnt2 FROM amd_file
                    WHERE amd03=l_apk.apk03 AND amd171=l_apk.apk171
                 IF l_cnt2 > 0 THEN
                    LET l_msg = l_apk.apk03,'+',l_apk.apk171
                    IF g_bgerr THEN
                       CALL s_errmsg('','',l_msg,'amd-011',1)
                    ELSE
                       CALL cl_err(l_msg,'amd-011',1)
                    END IF
                   #LET g_success = 'N'     #MOD-A30056 add       #MOD-B20095 mark
                   #LET begin_no = l_apk.apk01    #MOD-A30056 add #MOD-B20095 mark
                    CONTINUE FOREACH
                 END IF
              END IF
              IF l_apk.apk171='26' OR l_apk.apk171='27' THEN
                 LET l_amd09 = 'A'
              ELSE
                 LET l_amd09 = ' '
              END IF
             #當amd031為4或X時設定amd29='2'
              IF l_gec05='4' OR l_gec05='X' THEN
                 LET l_amd29='2'
              ELSE
                 LET l_amd29='1'
              END IF
             #MOD-A40093---modify---start---
             #SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=l_apk.apk32  #MOD-9C0427 add
              IF NOT cl_null(l_apk.apk32) THEN
                 SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=l_apk.apk32
              ELSE
                #SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=g_amd22     #MOD-A70169 mark
                 LET l_ama01 = g_amd22                                           #MOD-A70169
              END IF
             #MOD-A40093---modify---end---
              INSERT INTO amd_file (amd01,amd02,amd021,amd03,amd04,amd05,  #No.MOD-470041
                                    amd06,amd07,amd08,amd09,amd10,amd17,
                                    amd171,amd172,amd173,amd174,amd175,
                                    amd22,amd25,amd26,amd27,amd28,amd29,
                                    amd30,amd35,amd36,amd37,amd38,amd39,
                                    amd40,amd41,amd42,amd43,amdacti,amduser,
                                    amdgrup,amdmodu,amddate,amd031,amd44,amdlegal)   #FUN-770040  #FUN-8B0081 add amd44 #FUN-980004 add amdlegal
              VALUES(l_apk.apk01,l_num,'2',l_apk.apk03,l_apk.apk04,
                     l_apa.apa02,l_apk.apk06,l_apk.apk07,l_apk.apk08,   #MOD-7C0223
                     l_amd09,' ',l_apk.apk17,l_apk.apk171,l_apk.apk172, #CHI-8C0011
                     l_yy,l_mm,'',l_ama01,g_ary[g_idx].plant,'','',  #MOD-9C0427 g_amd22->l_ama01
                     l_apa44,l_amd29,'N','','','','','',l_apa.apa06,   #MOD-8B0153
                     l_apa.apa07,l_apa.apa02,l_apa.apa02,'Y',g_user,
                     g_grup,'',g_today,l_gec05,'3',g_legal)   #FUN-770040  #FUN-8B0081 add'3' #FUN-980004 add g_legal
                #IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN            #MOD-A80176 mark
                 IF cl_sql_dup_value(SQLCA.SQLCODE) THEN                #MOD-A80176
                    CONTINUE FOREACH                                    #MOD-A80176
                 ELSE                                                   #MOD-A80176
                    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN         #MOD-A80176 
                      #CALL cl_err3("ins","amd_file",l_apk.apk01,l_num,SQLCA.SQLCODE,"","",1)   #No:FUN-660093   #MOD-A80176 mark
                       LET g_success='N'
                      #EXIT FOREACH                                        #MOD-A80176 mark
                      #-MOD-A80176-add-
                       LET l_msg = l_apk.apk01,'+',l_num
                       IF g_bgerr THEN
                          CALL s_errmsg('ins','',l_msg,SQLCA.SQLCODE,1)
                       ELSE
                          CALL cl_err3("ins","amd_file",l_apk.apk01,l_num,SQLCA.SQLCODE,"","",1)   
                       END IF
                       CONTINUE FOREACH
                     END IF
                    #-MOD-A80176-end-
                 END IF
                 LET begin_no = l_apk.apk01    #MOD-A30056 add
           END IF
        END FOREACH
        IF g_success='N' THEN
           EXIT FOR
        END IF
        INITIALIZE l_apk.* TO NULL
        IF g_wc != " 1=1 " THEN
           LET l_buf=g_wc
           LET l_l=length(l_buf)
           FOR l_k=1 TO l_l
               IF l_k+4 <= l_l THEN    #No.MOD-7B0111 add
                  IF l_buf[l_k,l_k+4]='apa01' THEN
                     LET l_buf[l_k,l_k+4]='apk01'
                  END IF
                  IF l_buf[l_k,l_k+4]='apa09' THEN
                     LET l_buf[l_k,l_k+4]='apk05'
                  END IF
                  IF l_buf[l_k,l_k+4]='apa08' THEN
                     LET l_buf[l_k,l_k+4]='apk03'
                  END IF
               END IF                 #No.MOD-7B0111 add
           END FOR
           LET g_wc = l_buf
        END IF
        #-->進項資料(多發票資料)
        LET l_sql="SELECT apk01,apk02,apk03,apk04,apk05,apk06,apk07,apk08,",
                  " apk09,apk10,apk17,apk171,apk172,apk32,apa02,",  #MOD-9C0427 add apk32
                  " apa44,apa43,gec05,gec06,gec08,",   #FUN-770040
                  " apa06,apa07,apa02,apa02  ",
                  #" FROM  ",g_ary[g_idx].dbs_new CLIPPED," apk_file,",
                  #"  ",g_ary[g_idx].dbs_new CLIPPED," apa_file,",
                  #"       ",g_ary[g_idx].dbs_new CLIPPED," gec_file ",
                  " FROM  ",cl_get_target_table(g_ary[g_idx].plant,'apk_file'),",", #FUN-A50102
                  "       ",cl_get_target_table(g_ary[g_idx].plant,'apa_file'),",", #FUN-A50102
                  "       ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'),     #FUN-A50102
                  " WHERE apk01 = apa01 ",
                  "   AND apa41 = 'Y' AND apaacti = 'Y' ",
                  "   AND apk175 IS NULL ", #No:9041      
                  "   AND ((apk171 = '21' AND apk172 IN ('1','2','3')) ",
                 #"    OR (apk171 = '22' AND apk172 = '1') ",                #MOD-CA0188 mark
                  "    OR (apk171 = '22' AND apk172 IN ('1','2','3')) ",     #MOD-CA0188 add
                  "    OR  (apk171 = '25' AND apk172 IN ('1','2','3')) ",
                  "    OR  (apk171 = '26' AND apk172 IN ('1','2','3')) ", #no:6121
                  "    OR  (apk171 = '27' AND apk172 IN ('1','2','3')) ", #no:6121
                  "    OR  (apk171 = '28' AND apk172 IN ('1','2','3')))",
                  "   AND apk11 = gec01",   #MOD-670004
                  "   AND gec_file.gec011= '1' ",
                  "   AND ",g_wc CLIPPED
        IF NOT cl_null(g_tran) THEN
           LET l_sql = l_sql CLIPPED,"  AND apa44 LIKE '",g_tran,"%'"
        END IF
        IF g_aza.aza94 = 'Y' THEN
           IF g_amd22 <> 'ALL' THEN
              LET l_sql = l_sql CLIPPED, " AND apk32  = '",g_ama02,"'"
           END IF
        ELSE                                                               #MOD-BC0073 add
          IF g_ama.ama15<>0 THEN   #CHI-D20007
             LET l_sql = l_sql CLIPPED, " AND apk32  = '",g_ama02,"'"         #MOD-BC0073 add
          END IF   #CHI-D20007
        END IF
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql #FUN-A50102
        PREPARE p020_g_preapk FROM l_sql
        DECLARE p020_g_curapk CURSOR FOR p020_g_preapk
 
        LET l_sql = "SELECT apb11 ",
                    #"  FROM ",g_ary[g_idx].dbs_new CLIPPED,"apb_file",
                    "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'apb_file'), #FUN-A50102
                    " WHERE apb01 = ? ",
                    "   AND apb02 = ? "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql #FUN-A50102
        PREPARE p020_g_preapb2  FROM l_sql
        DECLARE p020_g_apbcur2  CURSOR FOR p020_g_preapb2
 
        FOREACH p020_g_curapk INTO l_apk.apk01,l_apk.apk02,l_apk.apk03,
                                   l_apk.apk04,
                                   l_apk.apk05,l_apk.apk06,l_apk.apk07,
                                   l_apk.apk08,l_apk.apk09,l_apk.apk10,
                                   l_apk.apk17,l_apk.apk171,l_apk.apk172,
                                   l_apk.apk32,   #MOD-9C0427 add
                                   l_apa02,l_apa44,l_apa43,l_gec05,l_gec06,l_gec08,   #FUN-770040
                                   l_amd40,l_amd41,l_amd42,l_amd43
           IF SQLCA.sqlcode THEN
              CALL cl_err('p020_curapk',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           CALL ui.Interface.refresh()
           IF cl_null(l_apk.apk171) THEN LET l_apk.apk171 = l_gec08 END IF
           IF cl_null(l_apk.apk172) THEN LET l_apk.apk172 = l_gec06 END IF
           IF NOT cl_null(g_tran) THEN

              LET g_sql = " DELETE FROM amd_file WHERE amd01 = '",l_apk.apk01,"'",
                          "          AND amd02 = '",l_apk.apk02,"'",
                          "          AND amd021 = '5' ",
                          "          AND amd28[1,",g_doc_len,"]='",g_tran,"'",     #No.FUN-560247 
                          "          AND amd30 = 'N' "
              PREPARE p020_str_p2 FROM g_sql
              EXECUTE p020_str_p2
           ELSE
              DELETE FROM amd_file WHERE amd01 = l_apk.apk01
                                     AND amd02 = l_apk.apk02
                                     AND amd021 = '5'
				     AND amd30 = 'N'
           END IF
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","amd_file",l_apk.apk01,l_apk.apk02,SQLCA.sqlcode,"","",1)  #No.FUN-660093

              LET g_sql = " DELETE FROM amd_file WHERE amd01 = '",l_apk.apk01,"'",
                          "          AND amd02 = '",l_apk.apk02,"'",
                          "          AND amd021 = '2' ",
                          "          AND amd28[1,",g_doc_len,"]='",g_tran,"'",     #No.FUN-560247 
                          "          AND amd30 = 'N' "
              PREPARE p020_str_p3 FROM g_sql
              EXECUTE p020_str_p3
           ELSE
              DELETE FROM amd_file WHERE amd01 = l_apk.apk01
                                     AND amd02 = l_apk.apk02
                                     AND amd021 = '2'
				     AND amd30 = 'N'
           END IF
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","amd_file",l_apk.apk01,l_apk.apk02,SQLCA.sqlcode,"","",1)   #No.FUN-660093
              EXIT FOREACH
           END IF
           IF cl_null(l_gec08) OR l_gec08 = 'XX' THEN CONTINUE FOREACH END IF
           IF l_apk.apk171 = '23' THEN
              OPEN p020_g_apbcur2 USING l_apk.apk01,l_apk.apk02
              FETCH p020_g_apbcur2 INTO l_invoice
              IF STATUS THEN LET l_invoice = '' END IF
           ELSE
              LET l_invoice = l_apk.apk03
           END IF
           #-->憑證日期不可為兩期之前資料
           LET l_guidate = l_apk.apk05    #  發票日
           CALL s_azn01(g_ama.ama08,g_ama.ama09) RETURNING t_bdate,t_edate
           LET t_bdate = t_bdate - g_ama.ama10 UNITS MONTH + 1 UNITS MONTH
           IF cl_null(l_apa43) THEN
              LET l_yy  = YEAR(l_apa02)
              LET l_mm  = MONTH(l_apa02)
           ELSE
              LET l_yy  =YEAR(l_apa43)
              LET l_mm  =MONTH(l_apa43)
           END IF
           IF cl_null(l_apa44) THEN LET l_apa44 = ' ' END IF
           IF l_apk.apk171 = '22' AND l_gec05 MATCHES '[4X]' THEN #MOD-B50189
           ELSE   #MOD-B50189
              IF l_apk.apk171 NOT MATCHES '2[3,4,9]' THEN  #MOD-640414
                 LET l_cnt2=0
                 SELECT COUNT(*) INTO l_cnt2 FROM amd_file
                    WHERE amd03=l_invoice AND amd171=l_apk.apk171
                 IF l_cnt2 > 0 THEN
                    LET l_msg = l_invoice,'+',l_apk.apk171
                    IF g_bgerr THEN
                       CALL s_errmsg('','',l_msg,'amd-011',1)
                    ELSE
                       CALL cl_err(l_msg,'amd-011',1)
                    END IF
                   #LET g_success = 'N'     #MOD-A30056 add       #MOD-B20095 mark
                   #LET begin_no = l_apk.apk01    #MOD-A30056 add #MOD-B20095 mark
                    CONTINUE FOREACH
                 END IF
              END IF
           END IF   #MOD-B50189
          IF l_apk.apk171='26' OR l_apk.apk171='27' THEN
             LET l_apk.apk09='A' #MOD-990140   
          ELSE
             LET l_apk.apk09=' ' #MOD-990140  
          END IF
         #當amd031為4或X時設定amd29='2'
          IF l_gec05='4' OR l_gec05='X' THEN
             LET l_amd29='2'
          ELSE
             LET l_amd29='1'
          END IF
         #MOD-A40093---modify---start---
         #SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=l_apk.apk32  #MOD-9C0427 add
          IF NOT cl_null(l_apk.apk32) THEN
             SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=l_apk.apk32
          ELSE
            #SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=g_amd22     #MOD-A70169 mark
             LET l_ama01 = g_amd22                                           #MOD-A70169
          END IF
         #MOD-A40093---modify---end---
          INSERT INTO amd_file (amd01,amd02,amd021,amd03,amd04,amd05,  #No.MOD-470041
                                amd06,amd07,amd08,amd09,amd10,amd17,
                                amd171,amd172,amd173,amd174,amd175,
                                amd22,amd25,amd26,amd27,amd28,amd29,
                                amd30,amd35,amd36,amd37,amd38,amd39,
                                amd40,amd41,amd42,amd43,amdacti,amduser,
                                amdgrup,amdmodu,amddate,amd031,amd44,amdlegal)   #FUN-770040  #FUN-8B0081 add amd44 #FUN-980004 add amdlegal
          VALUES(l_apk.apk01,l_apk.apk02,'5',l_invoice,l_apk.apk04,
                 l_apk.apk05,l_apk.apk06,l_apk.apk07,l_apk.apk08,
                 l_apk.apk09,l_apk.apk10,l_apk.apk17,l_apk.apk171,
                 l_apk.apk172,l_yy,l_mm,'',l_ama01,g_ary[g_idx].plant,  #MOD-9C0427 g_amd22->l_ama01
                 '','',l_apa44,l_amd29, 'N','','','','','',l_amd40,  #No.+076 010423  #MOD-8B0153
                 l_amd41,l_amd42,l_amd43,'Y',g_user,g_grup,'',g_today,l_gec05,'3',g_legal)   #FUN-770040  #FUN-8B0081 add'3' #FUN-980004 add g_legal
          #IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN            #MOD-A80176 mark
           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN                #MOD-A80176
              CONTINUE FOREACH                                    #MOD-A80176
           ELSE                                                   #MOD-A80176
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN         #MOD-A80176 
                #CALL cl_err3("ins","amd_file",l_apk.apk01,l_apk.apk02,SQLCA.sqlcode,"","",1)   #No:FUN-660093  #MOD-A80176 mark
                 LET g_success = 'N'
                #EXIT FOREACH                                        #MOD-A80176 mark
                #-MOD-A80176-add-
                 LET l_msg = l_apk.apk01,'+',l_num
                 IF g_bgerr THEN
                    CALL s_errmsg('ins','',l_msg,SQLCA.SQLCODE,1)
                 ELSE
                    CALL cl_err3("ins","amd_file",l_apk.apk01,l_num,SQLCA.SQLCODE,"","",1)   
                 END IF
                 CONTINUE FOREACH
              END IF
             #-MOD-A80176-end-
           END IF
           LET begin_no = l_apk.apk01    #MOD-A30056 add
        END FOREACH
 
        LET l_sql = "SELECT DISTINCT apb01,apb02,apb12,apb27,apb09 ",
                  #"  FROM ",g_ary[g_idx].dbs_new CLIPPED," apa_file,",
                  #"       ",g_ary[g_idx].dbs_new CLIPPED," apb_file,",
                  #"       ",g_ary[g_idx].dbs_new CLIPPED," apk_file ", 
                  #"  ,OUTER ",g_ary[g_idx].dbs_new CLIPPED," gec_file",
                  "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'apa_file'),",",  #FUN-A50102
                  "       ",cl_get_target_table(g_ary[g_idx].plant,'apb_file'),",",  #FUN-A50102
                  "       ",cl_get_target_table(g_ary[g_idx].plant,'apk_file'),      #FUN-A50102
                  "  ,OUTER ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'),    #FUN-A50102
                  " WHERE apa41 = 'Y' AND apaacti = 'Y' ",
                  "   AND apa42 = 'N' ",
                  "   AND apa175 IS NULL ",               
                  "   AND apa_file.apa15 = gec_file.gec01 ",
                  "   AND gec_file.gec011= '1' ",
                  "   AND apb01 = apk01 ",  
                  "   AND apb02 = apk02 ",  
                  "   AND apk17 = '2' ",  
                  "   AND ",g_wc CLIPPED 
        IF g_aza.aza94 = 'Y' THEN
            IF g_amd22 <> 'ALL' THEN
               LET l_sql = l_sql CLIPPED, " AND apk32  = '",g_ama02,"'",
                          " ORDER BY 1,2" 
            ELSE
               LET l_sql = l_sql CLIPPED, 
                          " ORDER BY 1,2" 
            END IF
        ELSE
            IF g_ama.ama15<>0 THEN   #CHI-D20007
               LET l_sql = l_sql CLIPPED,
                           " AND apk32  = '",g_ama02,"'",        #MOD-BC0073 add 
                           " ORDER BY 1,2" 
           #CHI-D20007--
            ELSE
               LET l_sql = l_sql CLIPPED,
                           " ORDER By 1,2"
            END IF  
           #CHI-D20007--
        END IF
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql #FUN-A50102
        PREPARE p020_22_apkp FROM l_sql
        DECLARE p020_22_apk SCROLL CURSOR WITH HOLD FOR p020_22_apkp
        FOREACH p020_22_apk INTO l_apb01,l_apb02,l_apb12,l_apb27,l_apb09
           LET l_cnt = 0                                                   #MOD-CA0188 add
           SELECT COUNT(*) INTO l_cnt FROM amd_file                        #MOD-CA0188 add
            WHERE amd01 = l_apb01                                          #MOD-CA0188 add
              AND amd30 = 'N'                                              #MOD-CA0188 add
           IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                     #MOD-CA0188 add
           IF l_cnt > 0 THEN                                               #MOD-CA0188 add
              DELETE FROM amf_file WHERE amf01 = l_apb01
                 AND amf02=l_apb02 AND amf021='5'   #MOD-950149
             
              INSERT INTO amf_file(amf01,amf02,amf021,amf022,
                                   amf03,amf04,amf06,amf07,amflegal)   #FUN-980004 add amflegal        
              VALUES(l_apb01,l_apb02,'5',l_apb01,l_apb02,  #MOD-950149
                     l_apb12,l_apb27,l_apb09,g_legal) #FUN-980004 add g_legal
             #IF SQLCA.SQLCODE THEN                                                         #MOD-A80176 mark
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN                                   #MOD-A80176 
                #CALL cl_err3("ins","amf_file",l_apb01,"",SQLCA.SQLCODE,"","ins amf1:",1)   #MOD-A80176 mark
                #-MOD-A80176-add-
                 LET l_msg = l_apb01
                 IF g_bgerr THEN
                    CALL s_errmsg('ins','',l_msg,SQLCA.SQLCODE,1)
                 ELSE
                    CALL cl_err3("ins","amf_file",l_apb01,"",SQLCA.SQLCODE,"","ins amf1:",1)
                 END IF
                #-MOD-A80176-end-
                 LET g_success='N'
                #EXIT FOREACH            #MOD-A80176 mark
                 CONTINUE FOREACH        #MOD-A80176
              END IF
           END IF                                                           #MOD-CA0188 add
        END FOREACH
    END FOR

  #MOD-A30056---add---start---
   IF begin_no IS NULL THEN
      LET g_success = 'N'
      CALL s_errmsg('','','','aap-129',1)
   END IF
  #MOD-A30056---add---end---
 
    CALL s_showmsg()   #CHI-920017 add
 
END FUNCTION
 
FUNCTION duplicate(l_plant,n)     #檢查輸入之工廠編號是否重覆
   DEFINE l_plant      LIKE azp_file.azp01
   DEFINE l_idx, n     LIKE type_file.num10        #No.FUN-680074 INTEGER
 
   FOR l_idx = 1 TO n
       IF g_ary[l_idx].plant = l_plant THEN
          LET l_plant = ''
       END IF
   END FOR
   RETURN l_plant
END FUNCTION
 
FUNCTION p020_chk_db()
   DEFINE l_i       LIKE type_file.num5          #No.FUN-680074 SMALLINT
 
   FOR l_i = 1 TO 8 STEP 1
      CASE l_i
         WHEN 1  LET g_plant_new= g_plant_1
         WHEN 2  LET g_plant_new= g_plant_2
         WHEN 3  LET g_plant_new= g_plant_3
         WHEN 4  LET g_plant_new= g_plant_4
         WHEN 5  LET g_plant_new= g_plant_5
         WHEN 6  LET g_plant_new= g_plant_6
         WHEN 7  LET g_plant_new= g_plant_7
         WHEN 8  LET g_plant_new= g_plant_8
      END CASE
      IF cl_null(g_plant_new) THEN
         CONTINUE FOR
      END IF
      IF g_plant_new = g_plant THEN
         LET g_dbs_new=''
         LET g_ary[l_i].plant = g_plant_new
         LET g_ary[l_i].dbs_new = g_dbs_new CLIPPED
      ELSE
         LET g_ary[l_i].plant = g_plant_new
         CALL s_getdbs()
         LET g_ary[l_i].dbs_new = g_dbs_new
      END IF
   END FOR
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14
