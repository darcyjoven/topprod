# Prog. Version..: '5.30.06-13.04.22(00010)'     #
# 
# Pattern name...: aglt120.4gl 
# Descriptions...: 轉回傳票維護作業 
# Date & Author..: 92/04/11 BY MAY 
# modify.........: 92/09/23 By Pin 
#                  加二欄位(簽核處理修正)--->s_signm() 
# Modify.........: By Apple     額外摘要維護改 CALL s_agl_memo() 
# Modify.........: By Melody    修正自動編號方式 
# Modify.........: By Melody    q_aac 改為不區分帳別 
#                  By Melody 過帳後可更改傳票摘要,修改單身應update modu、date 
# Modify         : 97/04/16 By Melody aaa07 改為關帳日期 
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中 
# Modify.........: No.8735 03/11/20 By Kammy 傳票輸入完成並且立刻列印,則就會出現err 
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法 
# Modify.........: No.MOD-480581 04/09/03 By Nicola 新增完後的直接列印無效 
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display 
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能 
# Modify.........: No.MOD-4A0304 04/10/22 Kammy aba07 不應卡關帳日 
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能 
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改 
# Modify.........: No.MOD-4C0171 05/02/15 By Smapmin 接收參數時,第一個必為帳別,若第一個不是帳別,則加入Null 
# Modify.........: No.MOD-550002 05/05/18 By ching fix _z()問題 
# Modify.........: NO.FUN-550057 05/06/02 By jackie 單據編號加大 
# Modify.........: NO.FUN-560014 05/06/08 By wujie  單據編號修改 
# Modify.........: No.MOD-560125 05/06/19 By Yuna 在原傳票編號欄位開窗,若查出傳票資料後按放棄時,則原傳票欄位每次都會回寫多二個00 
# Modify.........: No.TQC-5A0086 05/10/27 By Smapmin 單別寫死 
# Modify.........: No.MOD-5B0027 05/11/09 By Nicola 查詢時，加入單號開窗 
# Modify.........: No.FUN-5C0015 06/01/05 BY GILL 處理abb31~abb37 
# Modify.........: No.MOD-640121 06/04/09 By Sarah 1.單身的摘要輸入完按Enter無效,一定要用右方確認才能完成輸入 
#                                                  2.科目異動碼為必輸入及檢查卻不會跳到該欄位 
# Modify.........: No.FUN-640103 06/04/09 BY Alexstar 新增申請人(表單關係人)欄位 
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能 
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3 
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正 
# Modify.........: No.FUN-670048 06/07/19 By Smapmin 增加立沖帳資料 
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used 
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改  
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time 
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能 
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值 
# Modify.........: No.TQC-710062 07/01/16 By chenl 修正打印功能問題。 
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上 
# Modify.........: No.FUN-740020 07/04/05 By lora  會計科目加帳套 
# Modify.........: No.FUN-740020 07/04/13 By dxfwo 會計科目加帳套 
# Modify.........: No.MOD-740164 07/04/22 By Smapmin 傳票日小於等於關帳日時,不可確認與取消確認 
# Modify.........: No.MOD-740142 07/04/23 By Smapmin 增加單別控管 
# Modify.........: No.MOD-740203 07/04/23 By dxfwo  aag_file 增加 aag00 key 值導致單身分錄 double 問題 
# Modify.........: No.TQC-750071 07/05/15 By rainy QBE輸入日期會跳出 
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用 
# Modify.........: No.FUN-810069 08/02/26 By lynn 項目預算取消abb15的管控 
# Modify.........: No.MOD-840276 08/04/21 By Smapmin 原傳票編號必需為已確認/已過帳 
# Modify.........: No.FUN-850038 08/05/13 by TSD.zeak 自訂欄位功能修改  
# Modify.........: No.FUN-850066 08/05/20 By Sarah 加上「傳票過帳」「過帳還原」的ACTION 
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管 
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題 
# Modify.........: No.FUN-920155 09/02/20 By shiwuying 程序名稱由s_post改為aglp102_post 
# Modify.........: No.MOD-920353 09/02/26 By Sarah 詢問agl-042前,需先去COUNT單身有無資料,有資料才印 
# Modify.........: No.TQC-930014 09/03/11 By chenl 單身無資料則不可打印報表.  
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法 
  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定 
# Modify.........: No.FUN-980094 09/09/14 By TSD.hoho GP5.2 跨資料庫語法修改 
# Modify.........: No.FUN-980014 09/09/14 By rainy _i()中的INPUT abauser重覆造成 -8090錯誤程式並卡死 
# Modify.........: No.TQC-9C0127 09/12/15 By jan _a()中INSERT 時，新增abaoriu/abaorig 
# Modify.........: No.MOD-A10073 10/01/13 By Sarah 過帳/過帳還原批次程式裡已經UPDATE過帳碼與過帳人員了,維護程式裡不需再UPDATE 
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼 
# Modify.........: No.MOD-A20092 10/02/25 By sabrina 若aza26='2'則列印報表須改用gglr304 
# Modify.........: No.FUN-9B0098 10/03/01 by tommas delete cl_doc 
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AGL 
# Modify.........: No:MOD-A80136 10/08/18 By Dido 新增至 aba_file 時,提供 aba24/aba37 預設值  
# Modify.........: No:MOD-AB0008 10/11/01 By Dido aag371 增加檢核 4  
# Modify.........: No:CHI-AA0016 10/11/04 By Summer aba01單別設定為紅字傳票時金額變成負數 
# Modify.........: No:TQC-960205 10/11/08 By sabrina _cs()中PREPARE t120_precount的SQL在WHERE少了一個"AND"  
# Modify.........: No:TQC-AB0115 10/11/28 By suncx1 “確認”“取消確認”時，版本號aba18會在取消確認時變化，但是重新查詢時，版本號不能顯示。 
# Modify.........: No:MOD-AC0401 10/12/29 By Dido agl-144 應增加檢核是否有效 
# Modify.........: No:MOD-B40160 11/04/18 By Dido 傳遞參數語法調整  
# Modify.........: No.FUN-B50105 11/05/20 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8) 
# Modify.........: No.FUN-B40056 11/06/03 By guoch 
# Modify.........: No.FUN-B50062 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤 
# Modify.........: No.FUN-B40026 11/06/13 By zhangweib  INSERT INTO abh_file , abg_file時，取消寫入abh31~abh36,abg31~abg36 
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file 
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正 
# Modify.........: No.MOD-B90136 11/09/19 By Polly 1.顯示異動碼10(預算項目)2.調整abb35、abb36欄位順序和欄位名稱 
# Modify.........: No.CHI-B70028 11/09/27 By Polly aglr903增加帳別選項 
# Modify.........: No.MOD-BB0234 11/11/24 By Polly 調整欄位抓取順序 
# Modify.........: No.TQC-BB0269 11/11/30 By Sarah (1)FUNCTION t120_b(),g_forupd_sql需調整: 
#                                                     1.abb35與abb36移到abb08後面 2.abbud01~abbud15需加入 
#                                                  (2)FUNCTION t120_abb03(),不應判斷g_aag351與g_aag361來清空abb35與abb36 
# Modify.........: No.FUN-BB0116 11/12/14 By Lori 帳套拋轉時提供整批確認功能,以利於IFRS帳套與ROC帳套併行使用兩套帳的拋轉 
# Modify.........: No.TQC-C10097 12/01/29 By wujie 传票过帐和取消时没有更新图片  
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定 
# Modify.........: No:MOD-C20031 12/02/06 By Polly 增加檢核aco-228，已做沖帳則不可做迴轉傳票 
# Modify.........: No:MOD-C30079 12/03/08 By wujie s_check_no增加传入帐别 
# Modify.........: No:TQC-C40196 12/04/20 By wujie 取消审核时刷新状态码 
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30078 12/06/04 By jinjj調整列印額外摘要參數tm.v預設值為 'N'
# Modify.........: No.CHI-C30051 12/06/04 By wangrr 新4fd aglt120_2用於大陸版本，摘要欄位在第二列
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30085 12/06/29 By lixiang 串CR 報表改串GR報表
# Modify.........: No:MOD-CB0063 12/11/09 By yinhy 加傳參數
# Modify.........: No:CHI-C80041 12/12/22 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:TQC-D30067 13/03/25 By xumm 审核报错，但画面显示为已审核
# Modify.........: No:FUN-D20058 13/03/26 By xumm 取消確認賦值確認異動人員
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds 
  
GLOBALS "../../config/top.global" 
  
#模組變數(Module Variables) 
DEFINE 
    g_aba01t        LIKE aba_file.aba01,    #No.FUN-550057 
    g_aba           RECORD LIKE  aba_file.*, 
    g_aac           RECORD LIKE aac_file.*,       #單據性質 
    g_aba_t         RECORD LIKE  aba_file.*, 
    g_aba_o         RECORD LIKE aba_file.*,       #傳票編號 (舊值) 
    g_aba01_t       LIKE aba_file.aba01,   # 
    g_aba00_t       LIKE aba_file.aba00,   # 
    g_mxno          LIKE type_file.num10,      #No.FUN-680098   integer 
    g_tail          LIKE type_file.num10,      #ROWID為更新項次之用      #No.FUN-680098  integer 
    g_aaa           RECORD LIKE aaa_file.*, 
    g_abb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables) 
        abb02       LIKE abb_file.abb02,   #項次 
        abb04       LIKE abb_file.abb04,    #add by dengsy170412
        abb03       LIKE abb_file.abb03,   #科目編號 
        aag02       LIKE aag_file.aag02,   #科目名稱 
        abb05       LIKE abb_file.abb05,   #部門 
        gem02       LIKE gem_file.gem02,   #部門 
        abb06       LIKE abb_file.abb06,   #借貸別 
        abb24       LIKE abb_file.abb24,   #借貸別 
        abb25       LIKE abb_file.abb25,   #借貸別 
        abb07f      LIKE abb_file.abb07f,   #異動金額 
        abb07       LIKE abb_file.abb07,   #異動金額 
        abb15       LIKE abb_file.abb15,   #異動金額 
        abb08       LIKE abb_file.abb08,   #專案號碼 
        abb35       LIKE abb_file.abb35,   #異動別-9     #MOD-B90136 add 
        abb36       LIKE abb_file.abb36,   #異動別-10    #MOD-B90136 add 
        abb11       LIKE abb_file.abb11,   #異動別-1 
        abb12       LIKE abb_file.abb12,   #異動別-2 
        abb13       LIKE abb_file.abb13,   #異動別-3 
        abb14       LIKE abb_file.abb14,   #異動別-4 
  
        abb31       LIKE abb_file.abb31,   #異動別-5 
        abb32       LIKE abb_file.abb32,   #異動別-6 
        abb33       LIKE abb_file.abb33,   #異動別-7 
        abb34       LIKE abb_file.abb34,   #異動別-8 
       #abb35       LIKE abb_file.abb35,   #異動別-9      #MOD-B90136 mark 
       #abb36       LIKE abb_file.abb36,   #異動別-10     #MOD-B90136 mark 
        abb37       LIKE abb_file.abb37,   #關係人異動別 
  
        #abb04       LIKE abb_file.abb04,    #摘要  #mark by dengsy170412
        abbud01 LIKE abb_file.abbud01, 
        abbud02 LIKE abb_file.abbud02, 
        abbud03 LIKE abb_file.abbud03, 
        abbud04 LIKE abb_file.abbud04, 
        abbud05 LIKE abb_file.abbud05, 
        abbud06 LIKE abb_file.abbud06, 
        abbud07 LIKE abb_file.abbud07, 
        abbud08 LIKE abb_file.abbud08, 
        abbud09 LIKE abb_file.abbud09, 
        abbud10 LIKE abb_file.abbud10, 
        abbud11 LIKE abb_file.abbud11, 
        abbud12 LIKE abb_file.abbud12, 
        abbud13 LIKE abb_file.abbud13, 
        abbud14 LIKE abb_file.abbud14, 
        abbud15 LIKE abb_file.abbud15 
                    END RECORD, 
    g_abb_t         RECORD                 #程式變數 (舊值) 
        abb02       LIKE abb_file.abb02,   #項次
        abb04       LIKE abb_file.abb04,  #add by dengsy170412 
        abb03       LIKE abb_file.abb03,   #科目編號 
        aag02       LIKE aag_file.aag02,   #科目名稱 
        abb05       LIKE abb_file.abb05,   #部門 
        gem02       LIKE gem_file.gem02,   #部門 
        abb06       LIKE abb_file.abb06,   #借貸別 
        abb24       LIKE abb_file.abb24,   #借貸別 
        abb25       LIKE abb_file.abb25,   #借貸別 
        abb07f      LIKE abb_file.abb07f,   #異動金額 
        abb07       LIKE abb_file.abb07,   #異動金額 
        abb15       LIKE abb_file.abb15,   #異動金額 
        abb08       LIKE abb_file.abb08,   #專案號碼 
        abb35       LIKE abb_file.abb35,   #異動別-9   #MOD-B90136 add 
        abb36       LIKE abb_file.abb36,   #異動別-10  #MOD-B90136 add 
        abb11       LIKE abb_file.abb11,   #異動別-1 
        abb12       LIKE abb_file.abb12,   #異動別-2 
        abb13       LIKE abb_file.abb13,   #異動別-3 
        abb14       LIKE abb_file.abb14,   #異動別-4 
  
        abb31       LIKE abb_file.abb31,   #異動別-5 
        abb32       LIKE abb_file.abb32,   #異動別-6 
        abb33       LIKE abb_file.abb33,   #異動別-7 
        abb34       LIKE abb_file.abb34,   #異動別-8 
       #abb35       LIKE abb_file.abb35,   #異動別-9    #MOD-B90136 mark 
       #abb36       LIKE abb_file.abb36,   #異動別-10   #MOD-B90136 mark 
        abb37       LIKE abb_file.abb37,   #關係人異動別 
  
        #abb04       LIKE abb_file.abb04   #摘要  #mark by dengsy170412
        abbud01 LIKE abb_file.abbud01, 
        abbud02 LIKE abb_file.abbud02, 
        abbud03 LIKE abb_file.abbud03, 
        abbud04 LIKE abb_file.abbud04, 
        abbud05 LIKE abb_file.abbud05, 
        abbud06 LIKE abb_file.abbud06, 
        abbud07 LIKE abb_file.abbud07, 
        abbud08 LIKE abb_file.abbud08, 
        abbud09 LIKE abb_file.abbud09, 
        abbud10 LIKE abb_file.abbud10, 
        abbud11 LIKE abb_file.abbud11, 
        abbud12 LIKE abb_file.abbud12, 
        abbud13 LIKE abb_file.abbud13, 
        abbud14 LIKE abb_file.abbud14, 
        abbud15 LIKE abb_file.abbud15 
                    END RECORD, 
    g_aag151        LIKE aag_file.aag151,   #異動碼-1控制方式 
    g_aag161        LIKE aag_file.aag161,   #異動碼-2控制方式 
    g_aag171        LIKE aag_file.aag171,   #異動碼-3控制方式 
    g_aag181        LIKE aag_file.aag181,   #異動碼-4控制方式 
    g_aag311        LIKE aag_file.aag311,   #異動碼-5控制方式 
    g_aag321        LIKE aag_file.aag321,   #異動碼-6控制方式 
    g_aag331        LIKE aag_file.aag331,   #異動碼-7控制方式 
    g_aag341        LIKE aag_file.aag341,   #異動碼-8控制方式 
    g_aag351        LIKE aag_file.aag351,   #異動碼-9控制方式 
    g_aag361        LIKE aag_file.aag361,   #異動碼-10控制方式 
    g_aag371        LIKE aag_file.aag371,   #異動碼關係人控制方式    
    g_wc,g_wc2,g_sql STRING,  #No.FUN-580092 HCN        
    g_bookno        LIKE aba_file.aba00, 
    g_aba01         LIKE aba_file.aba01,       #MOD-CB0063
    g_t1            LIKE aac_file.aac01,       #No.FUN-550057        #No.FUN-680098 VARCHAR(5) 
    g_statu         LIKE type_file.chr1,       #No.FUN-680098    VARCHAR(1) 
    g_rec_b         LIKE type_file.num5,       #單身筆數        #No.FUN-680098 smallint 
    l_ac            LIKE type_file.num5,       #目前處理的ARRAY CNT        #No.FUN-680098 smallint 
    l_sl            LIKE type_file.num5,       #目前處理的SCREEN LINE   #No.FUN-680098 smallint  
    g_depno         LIKE type_file.chr20       #No.FUN-680098  VARCHAR(20) 
  
#主程式開始 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL      
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680098 smallint 
DEFINE g_chr                 LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1) 
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680098 integer 
DEFINE g_i                   LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint 
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)  
DEFINE g_row_count           LIKE type_file.num10         #No.FUN-680098 integer 
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680098 integer 
DEFINE g_jump                LIKE type_file.num10         #No.FUN-680098 integer 
DEFINE mi_no_ask             LIKE type_file.num5          #No.FUN-680098 smallint 
DEFINE g_only_one            LIKE type_file.chr1          #CHAR(1)  #FUN-BB0116 判斷單張傳或多張傳票確認已決定是否顯示axm-108訊息 
DEFINE g_void                LIKE type_file.chr1      #CHI-C80041
  
MAIN 
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680098 smallint 
  
    OPTIONS                                #改變一些系統預設值 
        INPUT NO WRAP 
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理 
  
   IF (NOT cl_user()) THEN 
      EXIT PROGRAM 
   END IF 
  
   WHENEVER ERROR CALL cl_err_msg_log 
  
   IF (NOT cl_setup("AGL")) THEN 
      EXIT PROGRAM 
   END IF 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114 
  
    LET g_bookno = ARG_VAL(1) 
    LET g_aba01 = ARG_VAL(2)   #MOD-CB0063
    IF g_bookno IS NULL OR g_bookno = ' ' THEN 
       LET g_bookno = g_aaz.aaz64 
    END IF 
  
    LET g_forupd_sql = "SELECT * FROM aba_file WHERE aba00 = ? AND aba01 = ? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) 
    DECLARE t120_cl CURSOR FROM g_forupd_sql 
  
    SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_bookno 
    IF SQLCA.sqlcode THEN  
       CALL cl_err3("sel","aaa_file",g_bookno,"",'agl-095',"","",1) # NO.FUN-660123 
     END IF 
  
    CALL s_dsmark(g_bookno) 
  
    IF INT_FLAG THEN  
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114 
       EXIT PROGRAM  
    END IF 
    LET p_row = 2 LET p_col = 2
    #CHI-C30051--add--str--
    ###注意:aglt120_2同aglt120這兩個4fd區別只在於摘要abb04位置不同,Screen Record順序是完全一樣的
    ###若單身新增字段請同時調整兩隻4fd,并注意Screen Record順序,以及TAB順序
    IF g_aza.aza26 = '2' THEN ##大陸版本
       OPEN WINDOW t120_w AT p_row,p_col WITH FORM "agl/42f/aglt120_2"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    ELSE
    #CHI-C30051--add--end 
    OPEN WINDOW t120_w AT p_row,p_col WITH FORM "agl/42f/aglt120" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN 
    END IF      #CHI-C30051 add
    CALL cl_ui_init() 
  
    CALL t120_show_field() #FUN-5C0015 BY GILL 
  
    CALL s_shwact(3,2,g_bookno) 
    #No.MOD-CB0063  --Begin
    IF NOT cl_null(g_bookno) AND NOT cl_null(g_aba01) THEN 
        CALL t120_q()
    END IF
    #No.MOD-CB0063  --End
  
    CALL t120_menu() 
  
    CLOSE WINDOW t120_w                 #結束畫面 
  
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114 
END MAIN 
  
#QBE 查詢資料 
FUNCTION t120_cs() 
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN 
    CLEAR FORM                             #清除畫面 
   CALL g_abb.clear() 
    CALL s_shwact(3,2,g_bookno) 
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0029  
    #No.MOD-CB0063  --Begin
   IF NOT cl_null(g_bookno) AND NOT cl_null(g_aba01) THEN
        LET g_wc = " aba00 = '",g_bookno CLIPPED,"'"," AND aba01 = '",g_aba01 CLIPPED,"'"
        LET g_wc2 = " 1=1"
   ELSE
   #No.MOD-CB0063  --End 
   INITIALIZE g_aba.* TO NULL    #No.FUN-750051 
    CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件 
        aba01,aba02,aba03,aba04,aba05,abauser,aba11,aba24,aba18, #FUN-640103 
       #aba06,aba07,abaprno,aba20,abamksg,abasign,aba19,abapost,               #MOD-A80136 mark 
        aba06,aba07,abaprno,aba20,abamksg,abasign,aba19,aba37,abapost,aba38,   #MOD-A80136 
        abagrup,abamodu,abadate,abaacti 
        ,abaud01,abaud02,abaud03,abaud04,abaud05, 
        abaud06,abaud07,abaud08,abaud09,abaud10, 
        abaud11,abaud12,abaud13,abaud14,abaud15 
               BEFORE CONSTRUCT 
                  CALL cl_qbe_init() 
  
       ON ACTION controlp 
           CASE 
              WHEN INFIELD(aba01) #傳票編號 
                 CALL cl_init_qry_var() 
                 LET g_qryparam.form ="q_aba01" 
                 LET g_qryparam.state = "c" 
                 LET g_qryparam.arg1 = "RV" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO aba01 
                 NEXT FIELD aba01 
  
              WHEN INFIELD(aba07) 
                 CALL cl_init_qry_var() 
                 LET g_qryparam.form ="q_aba" 
                 LET g_qryparam.state= "c" 
                 LET g_qryparam.default1 = g_aba.aba07   #MOD-840276 
                 LET g_qryparam.arg1 = g_bookno 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret to aba07 
              WHEN INFIELD(aba24) #申請人 
                CALL cl_init_qry_var() 
                LET g_qryparam.form = "q_gen" 
                LET g_qryparam.state = 'c' 
                CALL cl_create_qry() RETURNING g_qryparam.multiret 
                DISPLAY g_qryparam.multiret TO aba24 
                NEXT FIELD aba24 
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn 
		   CALL cl_qbe_display_condition(lc_qbe_sn) 
    END CONSTRUCT 
    IF INT_FLAG THEN RETURN END IF 
  
    LET g_wc=t120_subchr(g_wc,'"',"'") 
  
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup') 
  
  
  
    CONSTRUCT g_wc2 ON abb02,abb03,abb04,abb05,abb06,abb24,abb25,abb07f,abb07,abb15,   # 螢幕上取單身條件 
                      #abb08,abb11,abb12,abb13,abb14,               #MOD-B90136 mark 
                       abb08,abb35,abb36,abb11,abb12,abb13,abb14,   #MOD-B90136 add    
                      #abb31,abb32,abb33,abb34,abb35,abb36,abb37    #MOD-B90136 mark 
                       abb31,abb32,abb33,abb34,abb37,               #MOD-B90136 add 
                       abbud01,abbud02,abbud03,abbud04,abbud05, 
                       abbud06,abbud07,abbud08,abbud09,abbud10, 
                       abbud11,abbud12,abbud13,abbud14,abbud15 
            FROM s_abb[1].abb02,s_abb[1].abb03,s_abb[1].abb04, 
                 s_abb[1].abb05,s_abb[1].abb06, 
                 s_abb[1].abb24, s_abb[1].abb25, s_abb[1].abb07f, 
                 s_abb[1].abb07,s_abb[1].abb15, 
                #s_abb[1].abb08,s_abb[1].abb11,s_abb[1].abb12,                               #MOD-B90136 mark 
                 s_abb[1].abb08,s_abb[1].abb35,s_abb[1].abb36,s_abb[1].abb11,s_abb[1].abb12, #MOD-B90136 add 
                 s_abb[1].abb13,s_abb[1].abb14, 
                 s_abb[1].abb31,s_abb[1].abb32,s_abb[1].abb33,s_abb[1].abb34, 
                #s_abb[1].abb35,s_abb[1].abb36,s_abb[1].abb37                                #MOD-B90136 mark 
                 s_abb[1].abb37,                                                             #MOD-B90136 add 
                 s_abb[1].abbud01,s_abb[1].abbud02,s_abb[1].abbud03, 
                 s_abb[1].abbud04,s_abb[1].abbud05,s_abb[1].abbud06, 
                 s_abb[1].abbud07,s_abb[1].abbud08,s_abb[1].abbud09, 
                 s_abb[1].abbud10,s_abb[1].abbud11,s_abb[1].abbud12, 
                 s_abb[1].abbud13,s_abb[1].abbud14,s_abb[1].abbud15 
  
       BEFORE CONSTRUCT 
          CALL cl_qbe_display_condition(lc_qbe_sn) 
 
       ON IDLE g_idle_seconds 
          CALL cl_on_idle() 
          CONTINUE CONSTRUCT 
  
       ON ACTION about         #MOD-4C0121 
          CALL cl_about()      #MOD-4C0121 
  
       ON ACTION help          #MOD-4C0121 
          CALL cl_show_help()  #MOD-4C0121 
  
       ON ACTION controlg      #MOD-4C0121 
          CALL cl_cmdask()     #MOD-4C0121 
  
       ON ACTION qbe_save 
          CALL cl_qbe_save() 
    END CONSTRUCT 
    END IF     #MOD-CB0063
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF 
  
    LET g_wc2=t120_subchr(g_wc2,'"',"'") 
  
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件 
       LET g_sql = "SELECT  aba01,aba00 ", 
                   " FROM aba_file", 
                   " WHERE ", g_wc CLIPPED, 
                   " AND aba06 = 'RV' ", 
                   " AND aba00 = '",g_bookno,"'", 
                   " ORDER BY aba01" 
     ELSE					# 若單身有輸入條件 
       LET g_sql = "SELECT DISTINCT aba_file. aba01,aba00 ", 
                   "  FROM aba_file, abb_file ", 
                   " WHERE aba01 = abb01", 
                   " AND aba06 = 'RV' ", 
                   " AND aba00 = abb00 ", 
                   " AND aba00 = '",g_bookno,"'", 
                   " AND abb02 !=0 ", 
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED, 
                   " ORDER BY aba01" 
    END IF 
  
    PREPARE t120_prepare FROM g_sql 
    DECLARE t120_cs                         #SCROLL CURSOR 
        SCROLL CURSOR WITH HOLD FOR t120_prepare 
  
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數 
        LET g_sql="SELECT COUNT(*) FROM aba_file WHERE ",g_wc CLIPPED, 
                  " AND aba00 = '",g_bookno,"'", 
                  " AND aba06 = 'RV' " 
    ELSE 
        LET g_sql="SELECT COUNT(DISTINCT aba01) FROM aba_file,abb_file WHERE ", 
                  "abb01=aba01 AND aba00 = abb00 ", 
                  " AND aba00 = '",g_bookno,"'", 
                  " AND aba06 = 'RV' ", 
                 #g_wc CLIPPED," AND ",g_wc2 CLIPPED             #TQC-960205 mark 
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED     #TQC-960205 add 
    END IF 
    PREPARE t120_precount FROM g_sql 
    DECLARE t120_count CURSOR FOR t120_precount 
END FUNCTION 
  
FUNCTION t120_menu() 
DEFINE    l_bookno         LIKE aba_file.aba00 
DEFINE    l_cmd            LIKE type_file.chr1000   #FUN-850066 add 
  
   WHILE TRUE 
      CALL t120_bp("G") 
      CASE g_action_choice 
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL t120_a() 
            END IF 
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL t120_q() 
            END IF 
         WHEN "delete" 
            IF cl_chk_act_auth() THEN 
               CALL t120_r() 
            END IF 
         WHEN "invalid" 
            IF cl_chk_act_auth() THEN 
               CALL t120_x() 
            END IF 
         WHEN "detail" 
            IF cl_chk_act_auth() THEN 
               CALL t120_b(' ') 
            ELSE 
               LET g_action_choice = NULL 
            END IF 
         WHEN "help" 
            CALL cl_show_help() 
         WHEN "exit" 
            EXIT WHILE 
         WHEN "controlg" 
            CALL cl_cmdask() 
         WHEN "enter_book_no" 
            CALL s_selact(0,0,g_lang) RETURNING l_bookno 
            IF NOT cl_null(l_bookno) THEN 
               LET g_bookno = l_bookno 
               CLEAR FORM 
               CALL g_abb.clear() 
               CLOSE t120_cs 
               CALL s_shwact(3,2,g_bookno) 
               IF cl_fglgui() MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                  CALL s_dsmark(g_bookno) 
               END IF 
               SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_bookno 
            ELSE 
               DISPLAY g_bookno TO g_bookno 
            END IF 
         WHEN "confirm" 
            IF cl_chk_act_auth() THEN 
               #CALL t120_y()    #FUN-BB0116 
               #FUN-BB0116--Begin-- 
               CALL s_showmsg_init() 
               LET g_success = 'Y' 
               CALL t120_y_chk() 
               CALL s_showmsg() 
               #FUN-BB0116--End-- 
            END IF 
         WHEN "undo_confirm" 
            IF cl_chk_act_auth() THEN 
               CALL t120_z() 
            END IF 
         WHEN "output" 
            IF cl_chk_act_auth() 
               THEN CALL t120_out() 
            END IF 
         WHEN "voucher_post"   #傳票過帳 
            IF g_aba.aba19 ='N' THEN    #檢查資料是否為未確認 
               CALL cl_err(g_aba.aba01,'aba-100',0) 
            ELSE 
               IF g_aba.abapost ='Y' THEN    #檢查資料是否為過帳 
                  CALL cl_err(g_aba.aba01,'aap-742',0) 
               ELSE 
                 IF cl_chk_act_auth() THEN 
                    IF cl_sure(21,21) THEN 
                       LET g_success = "Y" 
                       BEGIN WORK 
                       CALL aglp102_post(g_aba.aba00,g_aba.aba02,g_aba.aba02,g_aba.aba01,g_aba.aba01,'N',' 1=1')#No.FUN-920155 
                       IF g_success='Y' THEN 
                          COMMIT WORK 
                       ELSE 
                          ROLLBACK WORK 
                       END IF 
                      #str MOD-A10073 mod 
                      #批次程式裡已經UPDATE過帳碼與過帳人員了,這邊不需再UPDATE 
                      #IF g_success='Y' THEN 
                      #   SELECT abapost INTO g_aba.abapost 
                      #     FROM aba_file 
                      #    WHERE aba00=g_aba.aba00 
                      #      AND aba01=g_aba.aba01 
                      #   LET g_aba.aba38=g_user              #FUN-630066 
                      #   UPDATE aba_file SET aba38 = g_aba.aba38 
                      #    WHERE aba01 = g_aba.aba01 
                      #      AND aba00 = g_aba.aba00  #No.TQC-690116 
                      #   DISPLAY g_aba.abapost TO abapost 
                      #   DISPLAY g_aba.aba38 TO aba38        #FUN-630066 
                      #END IF 
                       SELECT abapost,aba38 INTO g_aba.abapost,g_aba.aba38 
                         FROM aba_file 
                        WHERE aba00=g_aba.aba00 
                          AND aba01=g_aba.aba01 
                       DISPLAY BY NAME g_aba.abapost,g_aba.aba38   
                       CALL cl_set_field_pic(g_aba.aba19,g_aba.abamksg,g_aba.abapost,"","",g_aba.abaacti)  #No.TQC-C10097  
                      #end MOD-A10073 mod 
                    END IF 
                 END IF 
               END IF 
            END IF 
  
         WHEN "undo_post"      #過帳還原 
            IF g_aba.abapost ='N' THEN    #檢查資料是否為未過帳 
               CALL cl_err(g_aba.aba01,'aba-108',0)        #FUN-630066 
            ELSE 
              IF cl_chk_act_auth() THEN 
                 IF cl_sure(21,21) THEN 
                    LET g_success='Y' 
                    BEGIN WORK 
                   #LET l_cmd = "aglp109 '",g_aba.aba00,"' '",g_aba.aba02,"' '",g_aba.aba01,"' '' ,'Y'"   #MOD-6C0177 #MOD-B40160 mark 
                    LET l_cmd = "aglp109 '",g_aba.aba00,"' '",g_aba.aba02,"' '",g_aba.aba01,"' '' 'Y'"                #MOD-B40160 
                    CALL cl_cmdrun_wait(l_cmd) 
                    IF g_success='Y' THEN 
                       COMMIT WORK 
                    ELSE 
                       ROLLBACK WORK 
                    END IF 
                   #str MOD-A10073 mod 
                   #批次程式裡已經UPDATE過帳碼與過帳人員了,這邊不需再UPDATE 
                   #IF g_success='Y' THEN 
                   #   SELECT abapost INTO g_aba.abapost 
                   #     FROM aba_file 
                   #    WHERE aba00=g_aba.aba00 
                   #      AND aba01=g_aba.aba01 
                   #   LET g_aba.aba38=NULL                #FUN-630066 
                   #   UPDATE aba_file SET aba38 = g_aba.aba38 
                   #    WHERE aba01 = g_aba.aba01 
                   #      AND aba00 = g_aba.aba00  #No.TQC-690116 
                   #   DISPLAY g_aba.abapost TO abapost 
                   #   DISPLAY g_aba.aba38 TO aba38        #FUN-630066 
                   #END IF 
                    SELECT abapost,aba38 INTO g_aba.abapost,g_aba.aba38 
                      FROM aba_file 
                     WHERE aba00=g_aba.aba00 
                       AND aba01=g_aba.aba01 
                    DISPLAY BY NAME g_aba.abapost,g_aba.aba38   
                    CALL cl_set_field_pic(g_aba.aba19,g_aba.abamksg,g_aba.abapost,"","",g_aba.abaacti)  #No.TQC-C10097  
                   #str MOD-A10073 mod 
                 END IF 
              END IF 
            END IF 
          WHEN "related_document"  #No.MOD-470515 
            IF cl_chk_act_auth() THEN 
               IF g_aba.aba01 IS NOT NULL THEN 
                  LET g_doc.column1 = "aba00" 
                  LET g_doc.value1 = g_aba.aba00 
                  LET g_doc.column2 = "aba01" 
                  LET g_doc.value2 = g_aba.aba01 
                  CALL cl_doc() 
               END IF 
            END IF 
         WHEN "exporttoexcel"   #No.FUN-4B0010 
            IF cl_chk_act_auth() THEN 
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_abb),'','')  
            END IF  
#No.TQC-B70021 --begin 
         WHEN "flows" 
            IF cl_chk_act_auth() THEN 
               CALL  s_flows('2',g_bookno,g_aba.aba01,g_aba.aba02,g_aba.aba19,'',FALSE)  #No.TQC-B70021 
            END IF        
#No.TQC-B70021 --end  
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t120_v()
               IF g_aba.aba19='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_aba.aba19,g_aba.abamksg,g_aba.abapost,"",g_void,g_aba.abaacti)
            END IF
         #CHI-C80041---end
         END CASE 
    END WHILE 
END FUNCTION 
  
#Add  輸入 
FUNCTION t120_a() 
DEFINE l_str       LIKE type_file.chr1000     #No.FUN-680098  VARCHAR(17) 
DEFINE li_result   LIKE type_file.num5        #No.FUN-550057 #No.FUN-680098 SMALLINT 
DEFINE l_cnt       LIKE type_file.num5        #MOD-920353 add 
  
    IF s_shut(0) THEN RETURN END IF 
    MESSAGE "" 
    CLEAR FORM 
    CALL g_abb.clear() 
    CALL s_shwact(3,2,g_bookno) 
    INITIALIZE g_aba.* TO NULL  # LIKE aba_file.*             #DEFAULT 設定 
    LET g_aba01_t = NULL 
    LET g_aba00_t = NULL 
    LET g_aba_o.* = g_aba.* 
    LET g_aba.aba02 = g_today 
    LET g_aba.aba05 = g_today 
    LET g_aba.aba06 = 'RV' 
    LET g_aba.aba08 = 0 
    LET g_aba.aba09 = 0 
    LET g_aba.aba19 = 'N' 
    LET g_aba.aba20 = '0' 
    LET g_aba.abasseq = 0 
    LET g_aba.abapost = 'N' 
    LET g_aba.aba37 = NULL         #MOD-A80136  
    LET g_aba.aba38 = NULL         #MOD-A80136 
    LET g_aba.abaprno = 0 
    CALL cl_opmsg('a') 
    WHILE TRUE 
        LET g_aba.abauser=g_user 
        LET g_aba.abaoriu = g_user #FUN-980030 
        LET g_aba.abaorig = g_grup #FUN-980030 
        LET g_aba.abagrup=g_grup 
        LET g_aba.abadate=g_today 
        LET g_aba.abamksg = 'N'            #不需簽核 
        LET g_aba.abaacti='Y'              #資料有效 
        LET g_aba.aba24=g_user                             
        CALL t120_aba24('d') 
        IF NOT cl_null(g_errno) THEN 
           LET g_aba.aba24 = '' 
        END IF 
        CALL t120_i("a")                #輸入單頭 
        IF INT_FLAG THEN                   #使用者不玩了 
            INITIALIZE g_aba.* TO NULL 
            LET INT_FLAG = 0 
            CALL cl_err('',9001,0) 
            EXIT WHILE 
        END IF 
        IF g_aba.aba01 IS NULL THEN                # KEY 不可空白 
            CONTINUE WHILE 
        END IF 
        MESSAGE " Waiting " 
        #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號 
        BEGIN WORK  #No.7875 
            CALL s_auto_assign_no("agl",g_aba.aba01,g_aba.aba02,"","aba_file","aba01",g_plant,"",g_bookno) #FUN-980094 
            RETURNING li_result,g_aba.aba01 
  
            DISPLAY BY NAME g_aba.aba01 
        	INSERT INTO aba_file(aba00,aba01,aba02,aba03,aba04,aba05,   #No.MOD-470041 
                             aba06,aba07,aba08,aba09,aba10,aba11, 
                             aba12,aba13,aba14,aba15,aba16,aba17, 
                             aba18,aba19,aba20,aba21,aba22,aba23,aba24, #FUN-640103 
                             abamksg,abasign,abadays,abaprit,abasmax,#No.MOD-470574 
                             abasseq,abaprno,abapost,abaacti,abauser, 
                             abagrup,abamodu,abadate,abaoriu,abaorig   #TQC-9C0127 
                             ,abaud01,abaud02,abaud03,abaud04,abaud05, 
                             abaud06,abaud07,abaud08,abaud09,abaud10, 
                             abaud11,abaud12,abaud13,abaud14,abaud15,abalegal,aba37,aba38)  #FUN-980003 add abalegal #MOD-A80136 add aba37/aba38 
             VALUES(g_aba.aba00,g_aba.aba01,g_aba.aba02,g_aba.aba03, 
                    g_aba.aba04,g_aba.aba05,g_aba.aba06,g_aba.aba07, 
                    g_aba.aba08,g_aba.aba09,g_aba.aba10,g_aba.aba11, 
                    'N',0,'','','','','',g_aba.aba19, 
                    g_aba.aba20,'','','',g_aba.aba24,g_aba.abamksg,g_aba.abasign, #FUN-640103 
                    g_aba.abadays,g_aba.abaprit,g_aba.abasmax, 
                    g_aba.abasseq,g_aba.abaprno,g_aba.abapost, 
                    g_aba.abaacti,g_aba.abauser,g_aba.abagrup, 
                    g_aba.abamodu,g_aba.abadate,g_aba.abaoriu,g_aba.abaorig  #TQC-9C0127 
                    ,g_aba.abaud01,g_aba.abaud02,g_aba.abaud03, 
                    g_aba.abaud04,g_aba.abaud05,g_aba.abaud06, 
                    g_aba.abaud07,g_aba.abaud08,g_aba.abaud09, 
                    g_aba.abaud10,g_aba.abaud11,g_aba.abaud12, 
                    g_aba.abaud13,g_aba.abaud14,g_aba.abaud15,g_legal,g_aba.aba37,g_aba.aba38) #FUN-980003 add g_legal #MOD-A80136 add aba37/aba38 
                     
  
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功 
           CALL cl_err3("ins","aba_file",g_aba.aba00,g_aba.aba01,SQLCA.sqlcode,"","",1) # NO.FUN-660123  #No.FUN-B80057---調整至回滾事務前--- 
           ROLLBACK WORK   #No.7875 
           CONTINUE WHILE 
        END IF 
        IF SQLCA.sqlerrd[3]= 0 THEN 
           CALL cl_err(g_aba.aba01,SQLCA.sqlcode,1)  #No.FUN-B80057---調整至回滾事務前--- 
           ROLLBACK WORK   #No.7875 
           CONTINUE WHILE 
        END IF 
        COMMIT WORK #No.7875 
        SELECT aba00 INTO g_aba.aba00 FROM aba_file 
            WHERE aba01 = g_aba.aba01 
              AND aba00 = g_bookno   #No.FUN-740020 
        LET g_aba01_t = g_aba.aba01        #保留舊值 
        LET g_aba_t.* = g_aba.* 
        CALL g_abb.clear() 
        LET g_rec_b = 0 
        CALL t120_gen()                    #-->產生傳票 
        CALL t120_b_fill('1=1') 
        CALL t120_b('u')                   #-->輸入單身 
        LET l_cnt = 0 
        SELECT COUNT(*) INTO l_cnt FROM abb_file 
         WHERE abb01=g_aba.aba01 
        IF l_cnt = 0 THEN 
           CALL cl_err(g_aba.aba01,"arm-034",1) 
        ELSE 
           #-->馬上列印(Y/N) 
           CALL cl_confirm('agl-042') RETURNING g_chr 
           IF g_chr='1' THEN 
              LET g_wc = " aba01='",g_aba.aba01,"' " 
              CALL t120_out() 
           END IF 
        END IF   #MOD-920353 add 
        IF g_aac.aacpass ='Y' AND g_aba.abamksg = 'N' THEN 
           CALL t120_y() 
        END IF 
        EXIT WHILE 
    END WHILE 
END FUNCTION 
  
#處理INPUT 
FUNCTION t120_i(p_cmd) 
DEFINE 
    l_flag          LIKE type_file.chr1,       #判斷必要欄位是否有輸入        #No.FUN-680098 VARCHAR(1) 
    l_azn02         LIKE azn_file.azn02, 
    l_azn04         LIKE azn_file.azn04, 
    l_aag07         LIKE aag_file.aag07, 
    l_aba02         LIKE aba_file.aba02, 
    l_aba03         LIKE aba_file.aba03, 
    l_aba04         LIKE aba_file.aba04, 
    l_direct        LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1) 
    l_n             LIKE type_file.num5,          #No.FUN-680098 SMALLINT 
    p_cmd           LIKE type_file.chr1,          #a:輸入 u:更改        #No.FUN-680098 VARCHAR(1) 
    li_pos          LIKE type_file.num5,           #No.FUN-680098  SMALLINT 
    li_left         STRING, 
    li_right        STRING, 
    li_str          STRING, 
    li_result       LIKE type_file.num5                 #No.FUN-560014        #No.FUN-680098 SMALLINT 
DEFINE l_aba06      LIKE aba_file.aba06    #MOD-740142 
DEFINE l_amt        LIKE abg_file.abg072          #MOD-C20031 add 
  
    LET g_aba.aba00 = g_bookno 
    DISPLAY BY NAME g_aba.aba05,g_aba.aba06,g_aba.aba19, 
                    g_aba.aba20,g_aba.abamksg,g_aba.abapost,g_aba.abaprno 
    CALL cl_set_head_visible("","YES")            #No.FUN-6B0029  
  
    INPUT BY NAME g_aba.abaoriu,g_aba.abaorig, 
        g_aba.aba01,g_aba.aba02,g_aba.aba05,g_aba.abauser,g_aba.aba11,g_aba.aba24, #FUN-640103 
        g_aba.aba07,g_aba.aba06,g_aba.abaprno, 
        g_aba.aba20,g_aba.abamksg,g_aba.abasign,g_aba.aba19,g_aba.abapost, 
        g_aba.abagrup,g_aba.abamodu,g_aba.abadate,g_aba.abaacti                 #FUN-980014 
        ,g_aba.abaud01,g_aba.abaud02,g_aba.abaud03,g_aba.abaud04, 
        g_aba.abaud05,g_aba.abaud06,g_aba.abaud07,g_aba.abaud08, 
        g_aba.abaud09,g_aba.abaud10,g_aba.abaud11,g_aba.abaud12, 
        g_aba.abaud13,g_aba.abaud14,g_aba.abaud15  
        WITHOUT DEFAULTS 
  
        BEFORE INPUT 
        LET g_before_input_done = FALSE 
        CALL t120_set_entry(p_cmd) 
        CALL t120_set_no_entry(p_cmd) 
        LET g_before_input_done = TRUE 
           CALL cl_set_docno_format("aba01") 
  
        BEFORE FIELD aba01 
           CALL t120_set_entry(p_cmd) 
  
        #-->CHECK 單據性質,DEFAULT來源碼及傳票編號 
        AFTER FIELD aba01 
            IF NOT cl_null(g_aba.aba01) THEN 
               #取消mark 
               LET g_t1 = s_get_doc_no(g_aba.aba01) 
               SELECT * INTO g_aac.* FROM aac_file		 #讀取單據性質資料 
                   WHERE aac01=g_t1 AND aacacti = 'Y' AND aac11='2' 
               IF SQLCA.sqlcode THEN			 #抱歉, 讀不到 
                  CALL cl_err(g_t1,"agl-035",0) #無此單別 
                  LET g_aba.aba01 = g_aba_o.aba01 
                  DISPLAY BY NAME g_aba.aba01 
                  NEXT FIELD aba01 
               END IF 
               IF g_aba_t.aba01 IS NULL OR 
                     (g_aba.aba01 != g_aba_t.aba01 ) THEN 
                   LET  g_aba.abamksg = g_aac.aac08 
                   LET  g_aba.abasign = g_aac.aacsign 
                   #-->若為轉帳性質則不預設收支科目 
                   IF g_aac.aac03 = '0' THEN 
                      LET g_aba.aba10 = ' ' 
                   ELSE 
                      LET  g_aba.aba10   = g_aac.aac04 
                   END IF 
                   DISPLAY BY NAME g_aba.abamksg 
                   DISPLAY BY NAME g_aba.aba10 
               END IF 
#             CALL s_check_no(g_sys,g_aba.aba01,g_aba01_t,"*","aba_file","aba01","") 
#              CALL s_check_no("agl",g_aba.aba01,g_aba01_t,"*","aba_file","aba01","")   #No.FUN-A40041 
              CALL s_check_no("agl",g_aba.aba01,g_aba01_t,"*","aba_file","aba01",g_aba.aba00)    #No.MOD-C30079  
                   RETURNING li_result,g_aba.aba01 
              DISPLAY BY NAME g_aba.aba01 
              IF (NOT li_result) THEN 
                  LET g_aba.aba01 = g_aba01_t 
                  LET g_aba.aba00 = g_aba00_t 
                  NEXT FIELD aba01 
               END IF 
                      NEXT FIELD aba02			 #輸入 
                  END IF 
            CALL t120_set_no_entry(p_cmd) 
  
        AFTER FIELD aba02 
            IF NOT cl_null(g_aba.aba02) THEN 
               SELECT azn02,azn04 INTO l_azn02,l_azn04  FROM azn_file 
                    WHERE azn01 = g_aba.aba02 
               IF SQLCA.sqlcode  OR l_azn02 = 0 OR l_azn02 IS NULL THEN 
                 CALL cl_err3("sel","azn_file",g_aba.aba02,"","agl-022","","",1)  #No.FUN-660123 
                 NEXT FIELD aba02  
               ELSE LET g_aba.aba03 = l_azn02 
                    LET g_aba.aba04 = l_azn04 
               END IF 
               IF g_aba.aba02 <= g_aaa.aaa07 THEN 
                    CALL cl_err('','agl-086',0) 
                    NEXT FIELD aba02 
               END IF 
               DISPLAY BY NAME g_aba.aba03,g_aba.aba04 
               LET g_aba_o.aba02 = g_aba.aba02 
             END IF 
  
        AFTER FIELD aba06 
            IF NOT cl_null(g_aba.aba06) THEN 
               IF  g_aba.aba06 != 'GL' THEN 
                  LET g_aba.aba06 = g_aba_o.aba06 
                  DISPLAY BY NAME g_aba.aba06 
                  NEXT FIELD aba06 
               END IF 
            END IF 
            LET g_aba_o.aba06 = g_aba.aba06 
  
       #---- 97/05/28 check 總號不可重複 
       AFTER FIELD aba11 
            IF NOT cl_null(g_aba.aba02) THEN 
               IF p_cmd='a' OR (p_cmd='u' AND g_aba.aba11!=g_aba_t.aba11) THEN 
                  SELECT COUNT(*) INTO l_n FROM aba_file WHERE aba11=g_aba.aba11 
                  IF l_n>0 THEN 
                       CALL cl_err(g_aba.aba11,-239,0) 
                       NEXT FIELD aba11 
                  END IF 
               END IF 
            END IF 
  
        AFTER FIELD aba07 
            IF NOT cl_null(g_aba.aba07) THEN 
               #-->請注意借、貸方金額必需反轉........IMPORTANT 
               SELECT aba02,aba03,aba04,aba08,aba09,aba10 
                 INTO l_aba02,l_aba03,l_aba04,g_aba.aba09,g_aba.aba08, 
                      g_aba.aba10 FROM aba_file 
                WHERE aba00 = g_bookno AND 
                      aba01 = g_aba.aba07 AND 
                      abaacti IN ('Y','y') AND  
                      aba19 = 'Y' AND    #MOD-840276 
                      abapost = 'Y'   #MOD-840276 
                IF SQLCA.sqlcode THEN 
                   CALL cl_err3("sel","aba_file",g_aba.aba07,g_bookno,"agl-087","","",1)  #No.FUN-660123 
                   LET g_aba.aba08 = ' ' 
                   LET g_aba.aba09 = ' ' 
                   LET g_aba.aba10 = ' ' 
                   NEXT FIELD aba07 
               END IF 
               SELECT COUNT(*) INTO g_cnt  FROM aba_file 
                WHERE aba00 = g_bookno AND aba06 = 'RV' 
                  AND aba07 = g_aba.aba07 
                  AND abaacti = 'Y'                         #MOD-AC0401  
                  AND aba19 <> 'X'  #CHI-C80041 
                  IF g_cnt > 0           THEN  #No.7926 
                     CALL cl_err(g_aba.aba07,'agl-144',0) 
                     LET g_aba.aba08 = ' ' 
                     LET g_aba.aba09 = ' ' 
                     LET g_aba.aba10 = ' ' 
                     NEXT FIELD aba07 
                 END IF 
               LET l_aba06 = '' 
               SELECT aba06 INTO l_aba06 FROM aba_file  
                 WHERE aba00 = g_bookno AND aba01=g_aba.aba07 
                   AND abaacti = 'Y'                         #MOD-AC0401  
                   AND aba19 <> 'X'  #CHI-C80041 
               IF l_aba06 <> 'GL' THEN 
                  CALL cl_err(g_aba.aba07,'agl-150',0) 
                  NEXT FIELD aba07 
               END IF  
              #-----------------------------MOD-C20031-------------------start 
               LET l_amt = ' ' 
               SELECT sum(abg072+abg073) INTO l_amt FROM abg_file 
                WHERE abg01 = g_aba.aba07 
                  AND abg00 = g_aba.aba00 
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF 
               IF l_amt > 0 THEN 
                  CALL cl_err(g_aba.aba07,'aco-228',1) 
                  NEXT FIELD aba07 
               END IF 
              #-----------------------------MOD-C20031---------------------end 
               DISPLAY BY NAME g_aba.aba08,g_aba.aba09,g_aba.aba10 
          END IF 
        AFTER FIELD aba24 
            IF NOT cl_null(g_aba.aba24) THEN 
               CALL t120_aba24('a') 
               IF NOT cl_null(g_errno) THEN 
                  LET g_aba.aba24 = g_aba_t.aba24 
                  CALL cl_err(g_aba.aba24,g_errno,0) 
                  DISPLAY BY NAME g_aba.aba24 # 
                  NEXT FIELD aba24 
               END IF 
            ELSE 
               DISPLAY '' TO FORMONLY.gen02 
            END IF 
  
        AFTER FIELD abaud01 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abaud02 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abaud03 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abaud04 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abaud05 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abaud06 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abaud07 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abaud08 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abaud09 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abaud10 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abaud11 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abaud12 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abaud13 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abaud14 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abaud15 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入 
           LET g_aba.abauser = s_get_data_owner("aba_file") #FUN-C10039 
           LET g_aba.abagrup = s_get_data_group("aba_file") #FUN-C10039 
            IF INT_FLAG THEN EXIT INPUT  END IF 
             SELECT COUNT(*) INTO g_cnt  FROM aba_file 
              WHERE aba00 = g_bookno AND aba06 = 'RV' 
                AND aba07 = g_aba.aba07 
                AND abaacti = 'Y'                         #MOD-AC0401   
                AND aba19 <> 'X'  #CHI-C80041
            IF g_cnt > 0           THEN  #No.7926 
               CALL cl_err(g_aba.aba07,'agl-144',0) 
               LET g_aba.aba08 = ' ' 
               LET g_aba.aba09 = ' ' 
               LET g_aba.aba10 = ' ' 
            END IF 
  
        ON ACTION controlp 
           CASE 
              WHEN INFIELD(aba01) #單據性質 
                 IF g_aaz.aaz70 MATCHES '[yY]' THEN 
                    CALL q_aac(FALSE,TRUE,g_aba.aba01,'2','',g_user,'AGL')   #TQC-670008  
                    RETURNING g_aba.aba01 
                 ELSE 
                    CALL q_aac(FALSE,TRUE,g_aba.aba01,'2','',' ','AGL')  #TQC-670008 
                    RETURNING g_aba.aba01 
                 END IF 
                 DISPLAY  BY NAME g_aba.aba01 
                 NEXT FIELD aba01 
  
              WHEN INFIELD(aba07) 
                 CALL cl_init_qry_var() 
                 LET g_qryparam.form ="q_aba3"   #MOD-740142 
                  LET g_qryparam.default1 = g_aba.aba07  #MOD-560125 
                 LET g_qryparam.arg1 = g_bookno 
                 CALL cl_create_qry() RETURNING g_aba.aba07 
                 DISPLAY BY NAME g_aba.aba07 
              WHEN INFIELD(aba24) 
                   CALL cl_init_qry_var() 
                   LET g_qryparam.form = "q_gen" 
                   LET g_qryparam.default1 = g_aba.aba24 
                   CALL cl_create_qry() RETURNING g_aba.aba24 
                   DISPLAY BY NAME g_aba.aba24 
                   NEXT FIELD aba24 
            END CASE 
  
        ON ACTION CONTROLF                  #欄位說明 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913 
  
        ON ACTION CONTROLR 
           CALL cl_show_req_fields() 
  
        ON ACTION CONTROLG 
           CALL cl_cmdask() 
       ON IDLE g_idle_seconds 
          CALL cl_on_idle() 
          CONTINUE INPUT 
  
      ON ACTION about         #MOD-4C0121 
         CALL cl_about()      #MOD-4C0121 
  
      ON ACTION help          #MOD-4C0121 
         CALL cl_show_help()  #MOD-4C0121 
  
  
    END INPUT 
END FUNCTION 
  
FUNCTION t120_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1) 
  
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("aba01",TRUE) 
    END IF 
    IF NOT g_before_input_done THEN 
       CALL cl_set_comp_entry("aba11",TRUE) 
    END IF 
END FUNCTION 
  
FUNCTION t120_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1) 
  
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("aba01",FALSE) 
    END IF 
    IF NOT g_before_input_done THEN 
       IF g_aaz.aaz81 = 'N' OR cl_null(g_aaz.aaz81) THEN 
          CALL cl_set_comp_entry("aba11",FALSE) 
       END IF 
    END IF 
END FUNCTION 
  
FUNCTION t120_sign()  #簽核等級相關欄位 
  
    LET g_chr=' ' 
    SELECT COUNT(*) INTO g_aba.abasmax 
        FROM azc_file 
        WHERE azc01=g_aba.abasign 
  
    IF SQLCA.sqlcode OR 
       g_aba.abasmax=0 OR 
       g_aba.abasmax IS NULL THEN 
        LET g_chr='E' 
        LET g_aba.abasign=g_aba_t.abasign 
    END IF 
END FUNCTION 
  
FUNCTION t120_q() 
  
    LET g_row_count = 0 
    LET g_curs_index = 0 
    CALL cl_navigator_setting( g_curs_index, g_row_count ) 
    INITIALIZE g_aba.* TO NULL              #No.FUN-6B0040 
    MESSAGE "" 
    CALL cl_opmsg('q') 
    CLEAR FORM 
    CALL g_abb.clear() 
    DISPLAY '   ' TO FORMONLY.cnt 
    CALL s_shwact(3,2,g_bookno) 
    CALL t120_cs() 
    IF INT_FLAG THEN 
        LET INT_FLAG = 0 
        RETURN 
    END IF 
    OPEN t120_cs                            # 從DB產生合乎條件TEMP(0-30秒) 
    IF SQLCA.sqlcode THEN 
       CALL cl_err('',SQLCA.sqlcode,0) 
       INITIALIZE g_aba.* TO NULL 
    ELSE 
       OPEN t120_count 
       FETCH t120_count INTO g_row_count 
       DISPLAY g_row_count TO FORMONLY.cnt 
       CALL t120_fetch('F')                  # 讀出TEMP第一筆並顯示 
    END IF 
END FUNCTION 
  
#處理資料的讀取 
FUNCTION t120_fetch(p_flag) 
DEFINE 
    p_flag          LIKE type_file.chr1,      #處理方式        #No.FUN-680098    VARCHAR(1) 
    l_abso          LIKE type_file.num10      #絕對的筆數      #No.FUN-680098    integer 
  
    CASE p_flag 
        WHEN 'N' FETCH NEXT     t120_cs INTO g_aba.aba01,g_aba.aba00 
        WHEN 'P' FETCH PREVIOUS t120_cs INTO g_aba.aba01,g_aba.aba00 
        WHEN 'F' FETCH FIRST    t120_cs INTO g_aba.aba01,g_aba.aba00 
        WHEN 'L' FETCH LAST     t120_cs INTO g_aba.aba01,g_aba.aba00 
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
          FETCH ABSOLUTE g_jump t120_cs INTO g_aba.aba01,g_aba.aba00 
          LET mi_no_ask = FALSE 
    END CASE 
  
    IF SQLCA.sqlcode THEN 
        CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0) 
        INITIALIZE g_aba.* TO NULL  #TQC-6B0105 
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
    SELECT * INTO g_aba.* FROM aba_file WHERE aba00 = g_aba.aba00 AND aba01 = g_aba.aba01 
    IF SQLCA.sqlcode THEN 
       CALL cl_err3("sel","aba_file",g_aba_t.aba01,g_aba_t.aba00,SQLCA.sqlcode,"","",1)  #No.FUN-660123 
       INITIALIZE g_aba.* TO NULL 
       RETURN 
    ELSE 
       LET g_data_owner = g_aba.abauser     #No.FUN-4C0048 
       LET g_data_group = g_aba.abagrup     #No.FUN-4C0048 
       CALL t120_show() 
    END IF 
END FUNCTION 
  
#將資料顯示在畫面上 
FUNCTION t120_show() 
    LET g_aba_t.* = g_aba.*                #保存單頭舊值 
    DISPLAY BY NAME g_aba.abaoriu,g_aba.abaorig,                        # 顯示單頭值 
        g_aba.aba01,g_aba.aba02,g_aba.aba03, 
        g_aba.aba04,g_aba.aba05,g_aba.aba06,g_aba.aba07,g_aba.aba08,g_aba.aba09,g_aba.aba24, #FUN-640103 
        g_aba.abamksg,g_aba.abapost,g_aba.aba19,g_aba.aba20, 
        g_aba.abaprno,g_aba.abauser,g_aba.abagrup,g_aba.abamodu, 
        g_aba.abadate,g_aba.abaacti,g_aba.aba37,g_aba.aba38             #MOD-A80136 add aba37/aba38 
        ,g_aba.abaud01,g_aba.abaud02,g_aba.abaud03,g_aba.abaud04, 
        g_aba.abaud05,g_aba.abaud06,g_aba.abaud07,g_aba.abaud08, 
        g_aba.abaud09,g_aba.abaud10,g_aba.abaud11,g_aba.abaud12, 
        g_aba.abaud13,g_aba.abaud14,g_aba.abaud15, 
        g_aba.aba18  #TQC-AB0115 add  
  
    #CALL cl_set_field_pic(g_aba.aba19,g_aba.abamksg,g_aba.abapost,"","",g_aba.abaacti)  #CHI-C80041
    IF g_aba.aba19='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_aba.aba19,g_aba.abamksg,g_aba.abapost,"",g_void,g_aba.abaacti)  #CHI-C80041
    CALL t120_b_fill(g_wc2)                 #單身 
    CALL t120_aba24('d')                      #FUN-640103 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf 
END FUNCTION 
  
FUNCTION t120_x() 
    IF s_shut(0) THEN RETURN END IF 
    IF g_aba.aba01 IS NULL THEN 
        CALL cl_err("",-400,0) 
        RETURN 
    END IF 
    IF g_aba.abapost ='Y' THEN    #檢查資料是否為過帳 
       CALL cl_err(g_aba.aba01,'agl-010',0) 
       RETURN 
    END IF 
    IF g_aba.aba19 ='X' THEN RETURN END IF  #CHI-C80041
    IF g_aba.aba19 ='Y' THEN    #檢查資料是否為確認 
       CALL cl_err(g_aba.aba01,'axm-101',0) 
       RETURN 
    END IF 
    BEGIN WORK 
  
    OPEN t120_cl USING g_aba.aba00,g_aba.aba01 
    IF STATUS THEN 
       CALL cl_err("OPEN t120_cl:", STATUS, 1) 
       CLOSE t120_cl 
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t120_cl INTO g_aba.*               # 鎖住將被更改或取消的資料 
    IF SQLCA.sqlcode THEN 
        CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)          #資料被他人LOCK 
        CLOSE t120_cl ROLLBACK WORK RETURN 
    END IF 
    CALL t120_show() 
    IF cl_exp(0,0,g_aba.abaacti) THEN                   #確認一下 
        LET g_chr=g_aba.abaacti 
        IF g_aba.abaacti='Y' THEN 
            LET g_aba.abaacti='N' 
        ELSE 
            LET g_aba.abaacti='Y' 
        END IF 
        UPDATE aba_file                    #更改有效碼 
            SET abaacti=g_aba.abaacti 
            WHERE aba01=g_aba.aba01 AND aba00 = g_aba.aba00 
        IF SQLCA.SQLERRD[3]=0 THEN 
            CALL cl_err3("upd","aba_file",g_aba.aba00,g_aba.aba01,SQLCA.sqlcode,"","",1)  #No.FUN-660123 
            LET g_aba.abaacti=g_chr 
        END IF 
        DISPLAY BY NAME g_aba.abaacti 
        #CALL cl_set_field_pic(g_aba.aba19,g_aba.abamksg,g_aba.abapost,"","",g_aba.abaacti)  #CHI-C80041
        IF g_aba.aba19='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
        CALL cl_set_field_pic(g_aba.aba19,g_aba.abamksg,g_aba.abapost,"",g_void,g_aba.abaacti)  #CHI-C80041
    END IF 
    CLOSE t120_cl 
    COMMIT WORK 
END FUNCTION 
  
#取消整筆 (所有合乎單頭的資料) 
FUNCTION t120_r() 
    IF s_shut(0) THEN RETURN END IF 
    IF g_aba.aba01 IS NULL THEN 
        CALL cl_err("",-400,0) 
        RETURN 
    END IF 
    SELECT * INTO g_aba.* FROM aba_file WHERE aba00=g_aba.aba00 
                                          AND aba01=g_aba.aba01 
    IF g_aba.abapost ='Y' THEN    #檢查資料是否為過帳 
       CALL cl_err(g_aba.aba01,'agl-010',0) 
       RETURN 
    END IF 
    IF g_aba.aba19 ='X' THEN RETURN END IF  #CHI-C80041
    IF g_aba.aba19 = 'Y' THEN RETURN END IF 
    BEGIN WORK 
    OPEN t120_cl USING g_aba.aba00,g_aba.aba01 
    IF STATUS THEN 
       CALL cl_err("OPEN t120_cl:", STATUS, 1) 
       CLOSE t120_cl 
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t120_cl INTO g_aba.*               # 鎖住將被更改或取消的資料 
    IF SQLCA.sqlcode THEN 
        CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)          #資料被他人LOCK 
        CLOSE t120_cl ROLLBACK WORK RETURN 
    END IF 
    CALL t120_show() 
#   IF cl_delh1(0,0) THEN                   #確認一下   #No.FUN-9B0098 MARK 10/03/01 
    IF cl_delh(0,0) THEN               #No.FUN-9B0098 MODIFY 10/03/01 
        LET g_doc.column1 = "aba00"     #No.FUN-9B0098 ADD 10/03/01 
        LET g_doc.value1 = g_aba.aba00  #No.FUN-9B0098 ADD 10/03/01 
        LET g_doc.column2 = "aba01"     #No.FUN-9B0098 ADD 10/03/01 
        LET g_doc.value2 = g_aba.aba01  #No.FUN-9B0098 ADD 10/03/01 
        CALL cl_del_doc()               #No.FUN-9B0098 ADD 10/03/01 
 
        DELETE FROM aba_file WHERE aba00 = g_aba.aba00 AND 
                                   aba01 = g_aba.aba01 
        IF SQLCA.SQLERRD[3]=0 THEN 
            CALL cl_err3("del","aba_file",g_aba.aba01,g_aba.aba00,SQLCA.sqlcode,"","",1)  #No.FUN-660123 
        END IF 
        DELETE FROM abb_file WHERE abb00 = g_aba.aba00 AND 
                                   abb01 = g_aba.aba01 
        DELETE FROM abc_file WHERE abc00 = g_aba.aba00 AND 
                                   abc01 = g_aba.aba01 
        IF SQLCA.sqlcode THEN 
           CALL cl_err3("del","abc_file",g_aba.aba00,g_aba.aba01,SQLCA.sqlcode,"","aglt120(ckp#3)",1)  #No.FUN-660123 
        END IF 
         
#FUN-B40056 -begin 
        DELETE FROM tic_file WHERE tic00 = g_aba.aba00 AND 
                                   tic04 = g_aba.aba01 
        IF SQLCA.sqlcode THEN 
           CALL cl_err3("del","tic_file",g_aba.aba00,g_aba.aba01,SQLCA.sqlcode,"","aglt120(ckp#3)",1) 
        END IF 
#FUN-B40056 -end 
         
        LET g_msg = TIME 
        INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980003 add azoplant,azolegal 
             VALUES('aglt120',g_user,g_today,g_msg,g_aba.aba01,'delete',g_plant,g_legal) #FUN-980003 add g_plant,g_legal 
        CLEAR  FORM 
        CALL g_abb.clear() 
        OPEN t120_count 
        #FUN-B50062-add-start-- 
        IF STATUS THEN 
           CLOSE t120_cl 
           CLOSE t120_count 
           COMMIT WORK 
           RETURN 
        END IF 
        #FUN-B50062-add-end-- 
        FETCH t120_count INTO g_row_count 
        #FUN-B50062-add-start-- 
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN 
           CLOSE t120_cl 
           CLOSE t120_count 
           COMMIT WORK 
           RETURN 
        END IF 
        #FUN-B50062-add-end--  
        DISPLAY g_row_count TO FORMONLY.cnt 
        OPEN t120_cs 
        IF g_curs_index = g_row_count + 1 THEN 
           LET g_jump = g_row_count 
           CALL t120_fetch('L') 
        ELSE 
           LET g_jump = g_curs_index 
           LET mi_no_ask = TRUE 
           CALL t120_fetch('/') 
        END IF 
  
        CALL s_shwact(3,2,g_bookno) 
  
    END IF 
    CLOSE t120_cl 
    COMMIT WORK 
END FUNCTION 
  
#單身 
FUNCTION t120_b(p_key) 
DEFINE 
    p_key           LIKE type_file.chr1,       #No.FUN-680098  VARCHAR(1) 
    l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT   #No.FUN-680098 smallint 
    l_n             LIKE type_file.num5,       #檢查重複用        #No.FUN-680098 smallint 
    l_lock_sw       LIKE type_file.chr1,       #單身鎖住否        #No.FUN-680098 VARCHAR(1) 
    p_cmd           LIKE type_file.chr1,       #處理狀態        #No.FUN-680098 VARCHAR(1) 
    l_cmd           LIKE type_file.chr1000,    #No.FUN-680098  VARCHAR(100) 
    l_direct        LIKE type_file.chr1,       #FTER     #No.FUN-680098   VARCHAR(1) 
    l_aag05         LIKE aag_file.aag05, 
    l_cnt           LIKE type_file.num5,          #No.FUN-680098 smallint 
    l_cnt1          LIKE type_file.num5,          #No.FUN-680098 smallint 
    l_abb02         LIKE abb_file.abb02, 
    l_check         LIKE abb_file.abb02, #為check AFTER FIELD abb02時對項次的 
    l_check_t       LIKE abb_file.abb02,#判斷是否跳過AFTER ROW的處理 
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680098 smallint 
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680098 smallint 
  
    LET g_action_choice = "" 
    IF s_shut(0) THEN RETURN END IF 
    IF g_aba.aba01 IS NULL THEN 
        RETURN 
    END IF 
    SELECT * INTO g_aba.* FROM aba_file WHERE aba00=g_aba.aba00 
                                          AND aba01=g_aba.aba01 
    IF g_aba.abaacti ='N' THEN    #檢查資料是否為無效 
        CALL cl_err(g_aba.aba01,'aom-000',0) 
        RETURN 
    END IF 
    IF g_aba.aba19 ='X' THEN RETURN END IF  #CHI-C80041
    IF g_aba.aba19 = 'Y' THEN CALL cl_err('','axm-101',0) RETURN END IF 
    LET g_t1=s_get_doc_no(g_aba.aba01)           #No.FUN-560014 
    SELECT * INTO g_aac.* FROM aac_file		 #讀取單據性質資料 
        WHERE aac01=g_t1 AND aacacti = 'Y' 
    IF SQLCA.sqlcode THEN			 #抱歉, 讀不到 
        CALL cl_err3("sel","aac_file",g_t1,"","agl-035","","",1)  #No.FUN-660123 
 	LET g_aba.aba01 = g_aba_o.aba01 
        DISPLAY BY NAME g_aba.aba01 
    END IF 
  
    CALL cl_opmsg('b') 
  
    LET g_forupd_sql= " SELECT abb02,abb04,abb03,' ',abb05,' ',abb06,abb24,",  #add abb04 by dnegsy170412 
                      "        abb25,abb07f,abb07,abb15,abb08,", 
                      "        abb35,abb36,",   #TQC-BB0269 add 
                      "        abb11,abb12,abb13,abb14,", 
                      "        abb31,abb32,abb33,abb34,abb37,",  #TQC-BB0269 remove abb35,abb36 
                      #"        abb04 ",  #mark by dengsy170412 
                      "       ,abbud01,abbud02,abbud03,abbud04,abbud05,",  #TQC-BB0269 add 
                      "        abbud06,abbud07,abbud08,abbud09,abbud10,",  #TQC-BB0269 add 
                      "        abbud11,abbud12,abbud13,abbud14,abbud15",   #TQC-BB0269 add 
                      " FROM abb_file ", 
                      "  WHERE abb00 = ? ", 
                      "   AND abb01 = ? ", 
                      "   AND abb02 = ? ", 
                      " FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) 
    DECLARE t120_bcl CURSOR FROM g_forupd_sql 
  
    LET l_ac_t = 0 
    LET l_allow_insert = cl_detail_input_auth("insert") 
    LET l_allow_delete = cl_detail_input_auth("delete") 
  
    INPUT ARRAY g_abb WITHOUT DEFAULTS FROM s_abb.*  #No.MOD-470592 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED, 
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE) 
  
        BEFORE INPUT 
            IF g_rec_b!=0 THEN 
               CALL fgl_set_arr_curr(l_ac) 
            END IF 
  
        BEFORE ROW 
            LET p_cmd='' 
            LET l_ac = ARR_CURR() 
            LET l_lock_sw = 'N'            #DEFAULT 
            LET l_n  = ARR_COUNT() 
            BEGIN WORK 
            OPEN t120_cl USING g_aba.aba00,g_aba.aba01 
            IF STATUS THEN 
               CALL cl_err("OPEN t120_cl:", STATUS, 1) 
               CLOSE t120_cl 
               ROLLBACK WORK 
               RETURN 
            END IF 
            FETCH t120_cl INTO g_aba.*               # 鎖住將被更改或取消的資料 
            IF SQLCA.sqlcode THEN 
               CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)          #資料被他人LOCK 
               CLOSE t120_cl ROLLBACK WORK RETURN 
            END IF 
            IF g_rec_b>=l_ac THEN 
                LET p_cmd='u' 
                LET g_abb_t.* = g_abb[l_ac].*  #BACKUP 
                OPEN t120_bcl USING g_aba.aba00, g_aba.aba01,g_abb_t.abb02 
                IF STATUS THEN 
                   CALL cl_err("OPEN t120_bcl:", STATUS, 1) 
                   LET l_lock_sw = "Y" 
                ELSE 
                   FETCH t120_bcl INTO g_abb[l_ac].* 
                   IF SQLCA.sqlcode THEN 
                      CALL cl_err(g_abb_t.abb02,SQLCA.sqlcode,1) 
                      LET l_lock_sw = "Y" 
                   ELSE 
                      CALL t120_abb03('d')           #for referenced field 
                      CALL t120_abb05('d')           #for referenced field 
                   END IF 
                END IF 
                CALL cl_show_fld_cont()     #FUN-550037(smin) 
            END IF 
  
        AFTER INSERT 
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0) 
               LET INT_FLAG = 0 
               CANCEL INSERT 
            END IF 
  
        BEFORE INSERT 
            LET l_n = ARR_COUNT() 
            LET p_cmd='a' 
            INITIALIZE g_abb[l_ac].* TO NULL      #900423 
            LET g_abb_t.* = g_abb[l_ac].*         #新輸入資料 
            CALL cl_show_fld_cont()     #FUN-550037(smin) 
            NEXT FIELD abb02 
  
        ON ROW CHANGE 
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0) 
               LET INT_FLAG = 0 
               LET g_abb[l_ac].* = g_abb_t.* 
               CLOSE t120_bcl 
               ROLLBACK WORK 
               EXIT INPUT 
            END IF 
            IF l_lock_sw = 'Y' THEN 
               CALL cl_err(g_abb[l_ac].abb02,-263,1) 
               LET g_abb[l_ac].* = g_abb_t.* 
            END IF 
            SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_aaa.aaa03          #No.CHI-6A0004 g_azi-->t_azi 
            LET g_abb[l_ac].abb07 = cl_numfor(g_abb[l_ac].abb07,15,t_azi04)         #No.CHI-6A0004 g_azi-->t_azi   
            UPDATE abb_file SET abb04 = g_abb[l_ac].abb04, 
                                abb07 = g_abb[l_ac].abb07 
                                ,abbud01 = g_abb[l_ac].abbud01, 
                                abbud02 = g_abb[l_ac].abbud02, 
                                abbud03 = g_abb[l_ac].abbud03, 
                                abbud04 = g_abb[l_ac].abbud04, 
                                abbud05 = g_abb[l_ac].abbud05, 
                                abbud06 = g_abb[l_ac].abbud06, 
                                abbud07 = g_abb[l_ac].abbud07, 
                                abbud08 = g_abb[l_ac].abbud08, 
                                abbud09 = g_abb[l_ac].abbud09, 
                                abbud10 = g_abb[l_ac].abbud10, 
                                abbud11 = g_abb[l_ac].abbud11, 
                                abbud12 = g_abb[l_ac].abbud12, 
                                abbud13 = g_abb[l_ac].abbud13, 
                                abbud14 = g_abb[l_ac].abbud14, 
                                abbud15 = g_abb[l_ac].abbud15 
            WHERE abb00 = g_aba.aba00 
              AND abb01 = g_aba.aba01 
              AND abb02 = g_abb_t.abb02 
  
            IF SQLCA.sqlcode THEN 
                CALL cl_err3("upd","abb_file",g_aba.aba00,g_aba.aba01,SQLCA.sqlcode,"","",1)  #No.FUN-660123 
                LET g_abb[l_ac].* = g_abb_t.* 
            ELSE 
                MESSAGE 'UPDATE O.K' 
                COMMIT WORK 
            END IF 
  
        AFTER ROW 
            LET l_ac = ARR_CURR() 
            #LET l_ac_t = l_ac   #FUN-D30032
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0) 
               LET INT_FLAG = 0 
               IF p_cmd='u' THEN 
                  LET g_abb[l_ac].* = g_abb_t.* 
               #FUN-D30032--add--str--
               ELSE
                  CALL g_abb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF 
               CLOSE t120_bcl 
               ROLLBACK WORK 
               EXIT INPUT 
            END IF 
            LET l_ac_t = l_ac   #FUN-D30032
            CLOSE t120_bcl 
            COMMIT WORK 
  
       #start MOD-640121 add 增加異動碼欄位AFTER FIELD判斷 
        AFTER FIELD abb11 
            IF cl_null(g_abb[l_ac].abb11) THEN 
               #異動碼-1控制方式 
               IF g_aag151='2' OR g_aag151='3' THEN 
                  CALL cl_err('','mfg0037',0) 
                  NEXT FIELD abb11 
               END IF 
            END IF 
  
        AFTER FIELD abb12 
            IF cl_null(g_abb[l_ac].abb12) THEN 
               #異動碼-2控制方式 
               IF g_aag161='2' OR g_aag161='3' THEN 
                  CALL cl_err('','mfg0037',0) 
                  NEXT FIELD abb12 
               END IF 
            END IF 
  
        AFTER FIELD abb13 
           IF cl_null(g_abb[l_ac].abb13) THEN 
              #異動碼-3控制方式 
              IF g_aag171='2' OR g_aag171='3' THEN 
                 CALL cl_err('','mfg0037',0) 
                 NEXT FIELD abb13 
              END IF 
           END IF 
       
        AFTER FIELD abb14 
           IF cl_null(g_abb[l_ac].abb14) THEN 
              #異動碼-4控制方式 
              IF g_aag181='2' OR g_aag181='3' THEN 
                 CALL cl_err('','mfg0037',0) 
                 NEXT FIELD abb14 
              END IF 
           END IF 
       
        AFTER FIELD abb31 
           IF cl_null(g_abb[l_ac].abb31) THEN 
              #異動碼-5控制方式 
              IF g_aag311='2' OR g_aag311='3' THEN 
                 CALL cl_err('','mfg0037',0) 
                 NEXT FIELD abb31 
              END IF 
           END IF 
       
        AFTER FIELD abb32 
           IF cl_null(g_abb[l_ac].abb32) THEN 
              #異動碼-6控制方式 
              IF g_aag321='2' OR g_aag321='3' THEN 
                 CALL cl_err('','mfg0037',0) 
                 NEXT FIELD abb32 
              END IF 
           END IF 
       
        AFTER FIELD abb33 
           IF cl_null(g_abb[l_ac].abb33) THEN 
              #異動碼-7控制方式 
              IF g_aag331='2' OR g_aag331='3' THEN 
                 CALL cl_err('','mfg0037',0) 
                 NEXT FIELD abb33 
              END IF 
           END IF 
       
        AFTER FIELD abb34 
           IF cl_null(g_abb[l_ac].abb34) THEN 
              #異動碼-8控制方式 
              IF g_aag341='2' OR g_aag341='3' THEN 
                 CALL cl_err('','mfg0037',0) 
                 NEXT FIELD abb34 
              END IF 
           END IF 
       
        AFTER FIELD abb35 
           IF cl_null(g_abb[l_ac].abb35) THEN 
              #異動碼-9控制方式 
              IF g_aag351='2' OR g_aag351='3' THEN 
                 CALL cl_err('','mfg0037',0) 
                 NEXT FIELD abb35 
              END IF 
           END IF 
       
        AFTER FIELD abb36 
           IF cl_null(g_abb[l_ac].abb36) THEN 
              #異動碼-10控制方式 
              IF g_aag361='2' OR g_aag361='3' THEN 
                 CALL cl_err('','mfg0037',0) 
                 NEXT FIELD abb36 
              END IF 
           END IF 
       
        AFTER FIELD abb37 
           IF cl_null(g_abb[l_ac].abb37) THEN 
              #異動碼關係人控制方式 
             #IF g_aag371='2' OR g_aag371='3' THEN  #MOD-AB0008 mark 
              IF g_aag371 MATCHES '[234]' THEN      #MOD-AB0008 
                 CALL cl_err('','mfg0037',0) 
                 NEXT FIELD abb37 
              END IF 
           END IF 
  
        AFTER FIELD abbud01 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abbud02 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abbud03 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abbud04 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abbud05 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abbud06 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abbud07 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abbud08 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abbud09 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abbud10 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abbud11 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abbud12 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abbud13 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abbud14 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        AFTER FIELD abbud15 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
        ON ACTION extra_memo 
            CASE 
                WHEN INFIELD(abb04)  
                     CALL s_agl_memo('a',g_aba.aba00,g_aba.aba01, 
                                               g_abb[l_ac].abb02) 
                OTHERWISE EXIT CASE 
            END CASE 
  
        ON ACTION controlp 
            CASE 
                WHEN INFIELD(abb04)     #查詢常用摘要 
                    CALL q_aad(10,3,g_abb[l_ac].abb04) 
                                RETURNING g_abb[l_ac].abb04 
                    DISPLAY BY NAME g_abb[l_ac].abb04               #No.MOD-490344 
           END CASE 
  
        ON ACTION controlg 
            CALL cl_cmdask() 
  
        ON ACTION controlf 
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913 
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913 
  
        ON IDLE g_idle_seconds 
            CALL cl_on_idle() 
            CONTINUE INPUT 
  
        ON ACTION about          #MOD-4C0121 
            CALL cl_about()      #MOD-4C0121 
  
        ON ACTION help           #MOD-4C0121 
            CALL cl_show_help()  #MOD-4C0121 
        ON ACTION controls                                         
           CALL cl_set_head_visible("","AUTO")                     
  
    END INPUT 
  
    UPDATE aba_file SET abamodu=g_user,abadate=g_today 
       WHERE aba00=g_bookno AND aba01=g_aba.aba01 
  
    #自動賦予簽核等級 
    IF g_aba.abamksg MATCHES  '[Yy]' THEN 
       IF g_aac.aacatsg matches'[Yy]' AND p_key = 'a' 
       THEN CALL s_sign(g_aba.aba01,4,'aba01','aba_file') 
            RETURNING g_aba.abasign 
       END IF 
       IF p_key = 'a' THEN 
          LET g_aba01t = s_get_doc_no(g_aba.aba01)   #TQC-5A0086 
          SELECT aacdays,aacprit INTO g_aba.abadays,g_aba.abaprit FROM 
                 aac_file WHERE aac01 = g_aba01t 
       END IF 
       CALL s_signm(8,34,g_lang,'1',g_aba.aba01,4,g_aba.abasign, 
           g_aba.abadays,g_aba.abaprit,g_aba.abasmax,g_aba.abasseq) 
              RETURNING g_aba.abasign,       #等級 
                        g_aba.abadays, 
                        g_aba.abaprit, 
                        g_aba.abasmax,       #應簽 
                        g_aba.abasseq,       #已簽 
                        g_statu 
       UPDATE aba_file SET abasign = g_aba.abasign, 
                           abadays = g_aba.abadays, 
                           abaprit = g_aba.abaprit, 
                           abasmax = g_aba.abasmax, 
                           abasseq = g_aba.abasseq 
                   WHERE aba01 = g_aba.aba01 
                     AND aba00 = g_bookno 
    ELSE 
       LET g_aba.abasmax  = 0 LET g_aba.abasseq = 0 
       LET g_aba.abadays  = 0 LET g_aba.abaprit = 0 
    END IF 
    CLOSE t120_cl 
    CLOSE t120_bcl 
    CALL t120_delHeader()     #CHI-C30002 add
END FUNCTION 

#CHI-C30002 -------- add -------- begin
FUNCTION t120_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_aba.aba01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM aba_file ",
                  "  WHERE aba01 LIKE '",l_slip,"%' ",
                  "    AND aba01 > '",g_aba.aba01,"'"
      PREPARE t120_pb1 FROM l_sql 
      EXECUTE t120_pb1 INTO l_cnt       
      
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
         CALL t120_v()
         IF g_aba.aba19='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_aba.aba19,g_aba.abamksg,g_aba.abapost,"",g_void,g_aba.abaacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM aba_file WHERE aba01 = g_aba.aba01
                                AND aba00 = g_aba.aba00
         INITIALIZE g_aba.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
  
FUNCTION t120_bp(p_ud) 
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1) 
  
   IF p_ud <> "G" OR g_action_choice = "detail" THEN 
      RETURN 
   END IF 
  
   LET g_action_choice = " " 
  
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DISPLAY ARRAY g_abb TO s_abb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) 
  
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count ) 
#TQC-B70021 --Begin 
         SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file 
         CALL cl_set_act_visible("flows",g_nmz.nmz70 = '2') 
#TQC-B70021 --end  
  
      BEFORE ROW 
         LET l_ac = ARR_CURR() 
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf 
  
      ########################################################################## 
      # Standard 4ad ACTION 
      ########################################################################## 
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
         CALL t120_fetch('F') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 
           IF g_rec_b != 0 THEN 
         CALL fgl_set_arr_curr(1)  ######add in 040505 
           END IF 
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST 
  
      ON ACTION previous 
         CALL t120_fetch('P') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 
           IF g_rec_b != 0 THEN 
         CALL fgl_set_arr_curr(1)  ######add in 040505 
           END IF 
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST 
  
      ON ACTION jump 
         CALL t120_fetch('/') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 
           IF g_rec_b != 0 THEN 
         CALL fgl_set_arr_curr(1)  ######add in 040505 
           END IF 
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST 
  
      ON ACTION next 
         CALL t120_fetch('N') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 
           IF g_rec_b != 0 THEN 
         CALL fgl_set_arr_curr(1)  ######add in 040505 
           END IF 
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST 
  
      ON ACTION last 
         CALL t120_fetch('L') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 
           IF g_rec_b != 0 THEN 
         CALL fgl_set_arr_curr(1)  ######add in 040505 
           END IF 
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST 
  
      ON ACTION invalid 
         LET g_action_choice="invalid" 
         EXIT DISPLAY 
      ON ACTION detail 
         LET g_action_choice="detail" 
         LET l_ac = 1 
         EXIT DISPLAY 
      ON ACTION help 
         LET g_action_choice="help" 
         EXIT DISPLAY 
      ON ACTION exit 
         LET g_action_choice="exit" 
         EXIT DISPLAY 
  
      ON ACTION controlg 
         LET g_action_choice="controlg" 
         EXIT DISPLAY 
      ON ACTION enter_book_no 
         LET g_action_choice="enter_book_no" 
         EXIT DISPLAY 
      #@ON ACTION 確認 
         ON ACTION confirm 
         LET g_action_choice="confirm" 
         EXIT DISPLAY 
      #@ON ACTION 取消確認 
         ON ACTION undo_confirm 
         LET g_action_choice="undo_confirm" 
         EXIT DISPLAY 
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #ON ACTION 列印 
         ON ACTION output 
         LET g_action_choice="output" 
         EXIT DISPLAY 
  
      #str FUN-850066 add 
      ON ACTION voucher_post   #傳票過帳 
         LET g_action_choice="voucher_post" 
         EXIT DISPLAY 
  
      ON ACTION undo_post      #過帳還原 
         LET g_action_choice="undo_post" 
         EXIT DISPLAY 
      #end FUN-850066 add 
  
#@    ON ACTION 相關文件 
       ON ACTION related_document  #No.MOD-470515 
         LET g_action_choice="related_document" 
         EXIT DISPLAY 
  
   ON ACTION accept 
      LET g_action_choice="detail" 
      LET l_ac = ARR_CURR() 
      EXIT DISPLAY 
  
   ON ACTION cancel 
             LET INT_FLAG=FALSE 		#MOD-570244	mars 
      LET g_action_choice="exit" 
      EXIT DISPLAY 
  
      ON ACTION locale 
         CALL cl_dynamic_locale() 
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf 
         #CALL cl_set_field_pic(g_aba.aba19,g_aba.abamksg,g_aba.abapost,"","",g_aba.abaacti)  #CHI-C80041
         IF g_aba.aba19='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_aba.aba19,g_aba.abamksg,g_aba.abapost,"",g_void,g_aba.abaacti)  #CHI-C80041
         EXIT DISPLAY 
  
      ON IDLE g_idle_seconds 
         CALL cl_on_idle() 
         CONTINUE DISPLAY 
  
      ON ACTION about         #MOD-4C0121 
         CALL cl_about()      #MOD-4C0121 
  
  
      ON ACTION exporttoexcel   #No.FUN-4B0010 
         LET g_action_choice = 'exporttoexcel' 
         EXIT DISPLAY 
 
#No.TQC-B70021 --begin  
      ON ACTION flows 
         LET g_action_choice="flows" 
         EXIT DISPLAY 
#No.TQC-B70021 --end  
      AFTER DISPLAY 
         CONTINUE DISPLAY 
      ON ACTION controls                                         
         CALL cl_set_head_visible("","AUTO")                     
  
      &include "qry_string.4gl" 
   END DISPLAY 
   CALL cl_set_act_visible("accept,cancel", TRUE) 
END FUNCTION 
  
  
#檢查科目名稱 
FUNCTION  t120_abb03(p_cmd) 
DEFINE 
    p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1) 
    l_aag07         LIKE aag_file.aag07, 
    l_aagacti       LIKE aag_file.aagacti 
  
    LET g_errno = ' ' 
    SELECT aag02,aag07,aagacti 
          ,aag151,aag161,aag171,aag181, 
           aag311,aag321,aag331,aag341,aag351,aag361,aag371 
        INTO g_abb[l_ac].aag02,l_aag07,l_aagacti 
            ,g_aag151,g_aag161,g_aag171,g_aag181, 
             g_aag311,g_aag321,g_aag331,g_aag341,g_aag351,g_aag361,g_aag371 
        FROM aag_file 
        WHERE aag01 = g_abb[l_ac].abb03 
          AND aag00 = g_bookno              #No.FUN-740020 
    CASE  WHEN STATUS=100      LET g_errno  = 'agl-001' #No.7926 
          WHEN l_aagacti = 'N' LET g_errno = '9028' 
          WHEN l_aag07 = '1'   LET g_errno = 'agl-015' 
          OTHERWISE            LET g_errno = SQLCA.sqlcode USING '----------' 
    END CASE 
  
    IF cl_null(g_aag151) THEN LET g_abb[l_ac].abb11=NULL END IF 
    IF cl_null(g_aag161) THEN LET g_abb[l_ac].abb12=NULL END IF 
    IF cl_null(g_aag171) THEN LET g_abb[l_ac].abb13=NULL END IF 
    IF cl_null(g_aag181) THEN LET g_abb[l_ac].abb14=NULL END IF 
    IF cl_null(g_aag311) THEN LET g_abb[l_ac].abb31=NULL END IF 
    IF cl_null(g_aag321) THEN LET g_abb[l_ac].abb32=NULL END IF 
    IF cl_null(g_aag331) THEN LET g_abb[l_ac].abb33=NULL END IF 
    IF cl_null(g_aag341) THEN LET g_abb[l_ac].abb34=NULL END IF 
   #IF cl_null(g_aag351) THEN LET g_abb[l_ac].abb35=NULL END IF  #TQC-BB0269 mark 
   #IF cl_null(g_aag361) THEN LET g_abb[l_ac].abb36=NULL END IF  #TQC-BB0269 mark 
    IF cl_null(g_aag371) THEN LET g_abb[l_ac].abb37=NULL END IF 
  
END FUNCTION 
  
FUNCTION t120_abb05(p_cmd) 
DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1) 
       l_gem02         LIKE gem_file.gem02, 
       l_gem05         LIKE gem_file.gem05, 
       l_gemacti       LIKE gem_file.gemacti 
  
   LET g_errno = ' ' 
   SELECT gem02,gem05,gemacti 
     INTO g_abb[l_ac].gem02,l_gem05,l_gemacti FROM gem_file 
      WHERE gem01 = g_abb[l_ac].abb05 
    CASE WHEN STATUS=100         LET g_errno  = 'agl-003' #No.7926 
         WHEN l_gemacti = 'N'     LET g_errno = '9028' 
         WHEN l_gem05  = 'N'      LET g_errno = 'agl-202' 
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------' 
    END CASE 
END FUNCTION 
  
FUNCTION t120_b_askkey() 
DEFINE 
    l_wc2      LIKE type_file.chr1000    #No.FUN-680098  VARCHAR(200) 
  
    CLEAR aag02                           #清除FORMONLY欄位 
    CONSTRUCT l_wc2 ON abb02,abb03 
            FROM s_abb[1].abb02,s_abb[1].abb03 
              BEFORE CONSTRUCT 
                 CALL cl_qbe_init() 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF 
  
    LET l_wc2=t120_subchr(l_wc2,'"',"'") 
  
    CALL t120_b_fill(l_wc2) 
END FUNCTION 
  
FUNCTION t120_b_fill(p_wc2)              #BODY FILL UP 
DEFINE p_wc2   LIKE type_file.chr1000   #No.FUN-680098  VARCHAR(200) 
  
    LET g_sql = 
        " SELECT abb02,abb04,abb03,aag02,abb05,gem02,abb06,abb24, ",  #add abb04 by dengsy170412 
        "        abb25,abb07f,abb07,abb15, ",  
       #"        abb08,abb11,abb12,abb13,abb14,",                    #MOD-BB0234 mark 
        "        abb08,abb35,abb36,abb11,abb12,abb13,abb14,",        #MOD-BB0234 add 
       #"        abb31,abb32,abb33,abb34,abb35,abb36,abb37,",        #MOD-BB0234 mark 
        "        abb31,abb32,abb33,abb34,abb37,",                    #MOD-BB0234 add 
        #"        abb04, ",  #mark by dengsy170412 
        "        abbud01,abbud02,abbud03,abbud04,abbud05,", 
        "        abbud06,abbud07,abbud08,abbud09,abbud10,", 
        "        abbud11,abbud12,abbud13,abbud14,abbud15",  
        " FROM abb_file LEFT OUTER JOIN aag_file ON abb03 = aag_file.aag01 LEFT OUTER JOIN gem_file ON abb05 = gem_file.gem01 AND gem_file.gem05 = 'Y'", 
        " WHERE abb01 ='",g_aba.aba01,"'",  #單頭 
        "  AND abb00 = '",g_aba.aba00,"' ", 
        "  AND abb02 != 0    ", 
        "  AND aag_file.aag00 = '",g_bookno,"'" 
    IF NOT cl_null(p_wc2) THEN 
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED  
    END IF  
    LET g_sql=g_sql CLIPPED," ORDER BY 1 "  
    DISPLAY g_sql 
     
    PREPARE t120_pb FROM g_sql 
    DECLARE abb_curs CURSOR FOR t120_pb 
    CALL g_abb.clear() 
    LET g_rec_b = 0 
    LET g_cnt = 1 
    FOREACH abb_curs INTO g_abb[g_cnt].*  #單身 ARRAY 填充 
        IF SQLCA.sqlcode THEN 
           CALL cl_err('foreach:',STATUS,1) EXIT FOREACH 
        END IF 
        LET g_cnt = g_cnt + 1 
        IF g_cnt > g_max_rec THEN 
           CALL cl_err( '', 9035, 0 ) 
  	 EXIT FOREACH 
        END IF 
    END FOREACH 
    CALL g_abb.deleteElement(g_cnt) 
    LET g_rec_b = g_cnt - 1 
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0 
END FUNCTION 
  
FUNCTION t120_gen() 
 DEFINE  l_sql  LIKE type_file.chr1000,    #No.FUN-680098 VARCHAR(200) 
         l_aba08         LIKE aba_file.aba08, 
         l_aba09         LIKE aba_file.aba09, 
         l_aag09         LIKE aag_file.aag09, 
         l_abb   RECORD LIKE abb_file.* 
 DEFINE  l_aac12         LIKE aac_file.aac12 #CHI-AA0016 add 
 DEFINE  g_t1            LIKE type_file.chr5 #CHI-AA0016 add 
  
    LET l_sql = " SELECT abb_file.*,aag09 ", 
                " FROM abb_file LEFT OUTER JOIN aag_file ON abb03 = aag_file.aag01 ", 
                " WHERE abb01 ='",g_aba.aba07,"'", 
                "   AND abb00 ='",g_aba.aba00,"' ", 
                "   AND aag00 = '",g_bookno,"'",     #No.FUN-740020  
                " ORDER BY abb02" 
  
    PREPARE t120_pgen FROM l_sql 
    DECLARE t120_csgen                    #SCROLL CURSOR 
        CURSOR FOR t120_pgen 
  
    #CHI-AA0016 add --start-- 
    LET g_t1 = s_get_doc_no(g_aba.aba01) 
    SELECT aac12 INTO l_aac12 FROM aac_file WHERE aac01=g_t1 
    IF cl_null(l_aac12) THEN LET l_aac12='N' END IF 
    #CHI-AA0016 add --end-- 
 
    LET l_aba08 = 0    LET l_aba09 = 0 
    FOREACH t120_csgen INTO l_abb.*,l_aag09 
        IF SQLCA.sqlcode THEN 
            CALL cl_err('foreach t120_csgen:',SQLCA.sqlcode,1) 
            EXIT FOREACH 
        END IF 
        LET l_abb.abb00 = g_aba.aba00 
        LET l_abb.abb01 = g_aba.aba01 
        #CHI-AA0016 add --start-- 
        IF l_aac12 = 'Y' THEN   #紅字傳票 
           LET l_abb.abb07 = l_abb.abb07 * -1 
           LET l_abb.abb07f =l_abb.abb07f * -1 
        ELSE 
        #CHI-AA0016 add --end-- 
           CASE l_abb.abb06 
                WHEN '1' LET l_abb.abb06 = '2' 
                WHEN '2' LET l_abb.abb06 = '1' 
           END CASE 
        END IF   #CHI-AA0016 add 
        LET l_abb.abblegal = g_legal #FUN-980003 add g_legal 
        INSERT INTO abb_file VALUES(l_abb.*) 
        IF SQLCA.sqlcode THEN 
           CALL cl_err3("ins","abb_file",l_abb.abb01,l_abb.abb02,SQLCA.sqlcode,"","ins abb_file",1)  #No.FUN-660123 
           EXIT FOREACH 
        END IF 
        IF l_abb.abb06 = '1' AND l_aag09 = 'Y' THEN 
             LET l_aba08 = l_aba08 + l_abb.abb07 
        END IF 
        IF l_abb.abb06 = '2' AND l_aag09 = 'Y' THEN 
             LET l_aba09 = l_aba09 + l_abb.abb07 
        END IF 
    END FOREACH 
    IF cl_null(l_aba08) THEN LET l_aba08 = 0 END IF 
    IF cl_null(l_aba09) THEN LET l_aba09 = 0 END IF 
    LET g_aba.aba08 = l_aba08 
    LET g_aba.aba09 = l_aba09 
    DISPLAY BY NAME g_aba.aba08,g_aba.aba09 
    LET l_ac = 1 
END FUNCTION 
  
FUNCTION t120_out()             # 查詢後整批列印, 印查詢出的數筆 
   DEFINE l_cmd        LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(200) 
          l_prog       LIKE type_file.chr50,         #No.FUN-680098 VARCHAR(40)  
          l_wc,l_wc2   LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(300) 
          i            LIKE type_file.num5,          #No.FUN-680098 SMALLINT   
          l_prtway     LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)  
   DEFINE l_cnt        LIKE type_file.num5           #No.TQC-930014  
  
   IF g_aba.aba01 IS NULL OR g_aba.aba01 = ' ' THEN RETURN END IF 
   SELECT COUNT(*) INTO l_cnt FROM abb_file 
    WHERE abb01 = g_aba.aba01 AND abb00 = g_aba.aba00 
   IF l_cnt = 0 THEN 
      CALL cl_err(g_aba.aba01,'arm-034',0) 
      RETURN 
   END IF 
  
   MENU "" 
      ON ACTION voucher_print_132 
        #LET l_prog='aglr902' #FUN-C30085 mark
         LET l_prog='aglg902' #FUN-C30085 add 
         EXIT MENU        #No.TQC-710062 
  
      ON ACTION voucher_print_80 
        #MOD-A20092---modify---start--- 
         IF g_aza.aza26 = '2' THEN 
            LET l_prog = 'gglr304' 
         ELSE 
           #LET l_prog='aglr903' #FUN-C30085 mark 
            LET l_prog='aglg903' #FUN-C30085 add 
         END IF 
        #MOD-A20092---modify---end--- 
         EXIT MENU 
  
      ON ACTION exit 
         EXIT MENU 
  
      ON IDLE g_idle_seconds 
         CALL cl_on_idle() 
         CONTINUE MENU 
  
      ON ACTION about          
         CALL cl_about()       
  
      ON ACTION help           
         CALL cl_show_help()   
  
      ON ACTION controlg       
         CALL cl_cmdask()      
   END MENU 
  
   IF cl_null(l_prog) THEN 
      RETURN 
   END IF 
  
   IF cl_null(g_wc) THEN 
      LET l_wc = " aba06='RV' " 
   ELSE 
      LET l_wc = g_wc clipped," AND aba06='RV' " 
   END IF 
  
   #zz21:固定列印條件 zz22:固定列印方式 
   LET g_msg = l_prog[1,8] 
  
   SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = g_msg 
   IF SQLCA.sqlcode OR l_wc2 IS NULL THEN 
     #IF g_msg = 'aglr902' THEN #FUN-C30085 mark
      IF g_msg = 'aglg902' THEN #FUN-C30085 add 
         #LET l_wc2 = " '12' ' ' '3' '3' 'Y' "     #CHI-C30078 mark
         LET l_wc2 = " '12' ' ' '3' '3' 'N' "        #CHI-C30078
      ELSE 
        #MOD-A20092---modify---start--- 
        #IF g_msg = 'aglr903' THEN #FUN-C30085 mark
         IF g_msg = 'aglg903' THEN #FUN-C30085 add
            #LET l_wc2 = " '3' '3' 'Y' '3' "       #CHI-C30078 mark
            LET l_wc2 = " '3' '3' 'N' '3' "         #CHI-C30078
         ELSE 
            LET l_wc2 = " '3' '3' '3' 'N' " 
         END IF 
        #MOD-A20092---modify---end--- 
      END IF 
   END IF 
  #IF g_msg = 'aglr902' THEN          #MOD-A20092 mark 
   IF g_msg <> 'gglr304' THEN         #MOD-A20092 add 
      LET l_cmd = l_prog CLIPPED, 
                   ' "',g_bookno,'"', 
                   ' "',g_dbs CLIPPED,'"', 
                   ' "',g_today CLIPPED,'"', 
                   ' "" ', 
                   ' "',g_lang CLIPPED,'"', 
                   ' "Y"', 
                   ' "',l_prtway,'"', 
                   ' " 1" ', 
                   ' "',l_wc CLIPPED,'"', 
                   ' ',l_wc2 CLIPPED,'' 
   ELSE 
        LET l_cmd = l_prog CLIPPED, 
               ' "',g_bookno,'"', 
              #' "',g_dbs CLIPPED,'"',     #MOD-A20092 mark 
               ' "',g_today CLIPPED,'"', 
               ' "" ', 
               ' "',g_lang CLIPPED,'"', 
               ' "Y"', 
               ' "',l_prtway,'"', 
               ' " 1" ', 
               ' "',l_wc CLIPPED,'"', 
               ' ',l_wc2 CLIPPED,'', 
               ' "',g_bookno,'"'           #CHI-B70028 add 
   END IF 
   CALL cl_wait() 
   CALL cl_cmdrun(l_cmd) 
   ERROR "" 
   CLOSE WINDOW w1 
END FUNCTION 
  
FUNCTION t120_out2()            # 輸入後立即列印, 印輸入的單筆 
   DEFINE l_cmd       LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(200) 
          l_prog      LIKE type_file.chr50,         #No.FUN-680098 VARCHAR(40)  
          l_wc,l_wc2  LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(300) 
          l_prtway    LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)  
  
   IF g_aba.aba01 IS NULL OR g_aba.aba01 = ' ' THEN RETURN END IF 
  #MOD-A20092---modify---start--- 
   IF g_aza.aza26 = '2' THEN 
      LET l_prog = 'gglr304'  
   ELSE 
     #LET l_prog='aglr903' #FUN-C30085 mark
      LET l_prog='aglg903' #FUN-C30085 add 
   END IF 
  #MOD-A20092---modify---end--- 
   LET l_wc=" aba01='",g_aba.aba01,"'" 
   LET g_msg = l_prog[1,8] 
   SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = g_msg 
  #MOD-A20092---modify---start--- 
  #IF SQLCA.sqlcode OR l_wc2 IS NULL THEN LET l_wc2 = " '3' '3' 'N' '3' " END IF 
   IF SQLCA.sqlcode OR l_wc2 IS NULL THEN  
     #IF g_msg = 'aglr903' THEN  #FUN-C30085 mark
      IF g_msg = 'aglg903' THEN  #FUN-C30085 add
         LET l_wc2 = " '3' '3' 'N' '3' "  
      ELSE 
         LET l_wc2 = " '3' '3' '3' 'N' " 
      END IF 
   END IF 
   IF g_aza.aza26 = '2' THEN 
      LET l_cmd = l_prog CLIPPED, 
                   ' "',g_bookno,'"', 
                   ' "',g_today CLIPPED,'"', 
                   ' "" ', 
                   ' "',g_lang CLIPPED,'"', 
                   ' "Y"', 
                   ' "',l_prtway,'"', 
                   ' "1" ', 
                   ' "',l_wc CLIPPED,'"', 
                   ' ',l_wc2 CLIPPED,'' 
   ELSE 
      LET l_cmd = l_prog CLIPPED, 
                  ' "',g_bookno,'"', 
                  ' "',g_dbs CLIPPED,'"', 
                  ' "',g_today CLIPPED,'"', 
                  ' "" ', 
                  ' "',g_lang CLIPPED,'"', 
                  ' "Y"', 
                  ' "',l_prtway,'"', 
                  ' " 1" ', 
                  ' "',l_wc CLIPPED,'"', 
                  ' ',l_wc2 CLIPPED,'', 
                  ' "',g_bookno,'"'           #CHI-B70028 add 
   END IF 
  #MOD-A20092---modify---end--- 
   CALL cl_wait() 
   CALL cl_cmdrun(l_cmd) 
   ERROR "" 
END FUNCTION 
  
FUNCTION t120_y() 			# when g_aba.aba19='N' (Turn to 'Y') 
   DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021   
 
   #FUN-BB0116--Begin-- 
   IF s_shut(0) THEN 
      LET g_success = 'N' 
      RETURN 
   END IF 
   #FUN-BB0116--End-- 
#CHI-C30107 -------------- add ---------------- begin
   IF g_aba.aba19 ='X' THEN RETURN END IF  #CHI-C80041
   IF g_aba.aba19='Y' THEN
      CALL s_errmsg("aba19",g_aba.aba01,g_aba.aba19,'9023',1)  
      LET g_success = 'N'                                   
   END IF

   #FUN-BB0116--Begin--
   IF g_aba.abapost='Y' THEN
      CALL s_errmsg("abapost",g_aba.aba01,g_aba.abapost,'mfg0175',1)
      LET g_success = 'N'
   END IF

   IF g_aba.abaacti='N' THEN
      CALL s_errmsg("abaacti",g_aba.aba01,g_aba.abaacti,'mfg0301',1)
      LET g_success = 'N'
   END IF
   IF g_only_one = '1' THEN  
      IF NOT cl_confirm('axm-108') THEN
         RETURN
      END IF
   END IF  
   SELECT * INTO g_aba.* FROM aba_file
    WHERE aba01 = g_aba.aba01 AND aba00=g_aba.aba00
#CHI-C30107 -------------- add ---------------- end
 
   IF cl_null(g_aba.aba01) THEN 
      LET g_success = 'N'      #FUN-BB0116  
      RETURN  
   END IF 
    
   IF g_aba.aba02 <= g_aaa.aaa07 THEN 
      #CALL cl_err('','agl-085',0)    #FUN-BB0116 
      LET g_success = 'N'             #FUN-BB0116 
      CALL s_errmsg("aba02",g_aba.aba01,g_aba.aba02,'agl-085',1)    #FUN-BB0116 
      #RETURN 
   END IF 
    
   SELECT * INTO g_aba.* FROM aba_file 
    WHERE aba01 = g_aba.aba01 AND aba00=g_aba.aba00 
   IF g_aba.aba19 ='X' THEN RETURN END IF  #CHI-C80041 
   IF g_aba.aba19='Y' THEN 
      CALL s_errmsg("aba19",g_aba.aba01,g_aba.aba19,'9023',1)  #FUN-BB0116 
      LET g_success = 'N'                                      #FUN-BB0116 
      #RETURN                                                  #FUN-BB0116  
   END IF 
 
   #FUN-BB0116--Begin-- 
   IF g_aba.abapost='Y' THEN 
      CALL s_errmsg("abapost",g_aba.aba01,g_aba.abapost,'mfg0175',1) 
      LET g_success = 'N' 
   END IF 
 
   IF g_aba.abaacti='N' THEN 
      CALL s_errmsg("abaacti",g_aba.aba01,g_aba.abaacti,'mfg0301',1) 
      LET g_success = 'N' 
   END IF 
   #FUN-BB0116--End 
    
   SELECT COUNT(*) INTO g_cnt FROM abb_file 
    WHERE abb01=g_aba.aba01 AND abb00 = g_aba.aba00 
    
   IF g_cnt = 0 THEN 
      #CALL cl_err('','arm-034',1)                  #FUN-BB0116  
      #RETURN                                       #FUN-BB0116 
      CALL s_errmsg("",g_aba.aba01,"",'arm-034',1)  #FUN-BB0116 
      LET g_success = 'N'                           #FUN-BB0116 
   END IF 
 
# CHI-C30107 ------------- mark -------------- begin
#  IF g_only_one = '1' THEN  #FUN-BB0116    
#     IF NOT cl_confirm('axm-108') THEN  
#        RETURN  
#     END IF 
#  END IF                #FUN-BB0116 
# CHI-C30107 ------------- mark -------------- end
 
  #FUN-BB0116--Begin Mark-    
  #BEGIN WORK 
  
  # OPEN t120_cl USING g_aba.aba00,g_aba.aba01 
  #   IF STATUS THEN 
  #      CALL cl_err("OPEN t120_cl:", STATUS, 1) 
  #      CLOSE t120_cl 
  #      ROLLBACK WORK 
  #      RETURN 
  #   END IF 
  #  
  # FETCH t120_cl INTO g_aba.*               # 鎖住將被更改或取消的資料 
  #   IF SQLCA.sqlcode THEN 
  #      CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)          #資料被他人LOCK 
  #      CLOSE t120_cl ROLLBACK WORK RETURN 
  #   END IF 
  # 
  #   LET g_success = 'Y' 
  #   CALL t120_y1() 
  #   CALL t120_ins_abg_abh()   #FUN-670048 
 
  #   #No.TQC-B70021 --begin  
  #   CALL s_chktic(g_aba.aba00,g_aba.aba01) RETURNING l_success  
  #    
  #   IF NOT l_success THEN 
  #      LET g_success ='N' 
  #      RETURN   
  #   END IF  
  #   #No.TQC-B70021 --end    
  # 
  # CLOSE t120_cl 
  # 
  # IF g_success = 'Y' 
  #    THEN COMMIT WORK 
  # ELSE ROLLBACK WORK 
  # END IF 
  #FUN-BB0116--End-- 
 
    #FUN-BB0116--Begin-- 
     IF g_action_choice CLIPPED = "confirm" THEN     #執行 "確認" 功能 
        IF g_aba.abamksg='Y' THEN 
           IF g_aba.aba20 != '1' THEN 
              CALL s_errmsg("aba20",g_aba.aba01,g_aba.aba00,'aws-078',1) 
              LET g_success = 'N' 
           END IF 
        END IF 
     END IF 
 
     CALL s_chktic(g_aba.aba00,g_aba.aba01) RETURNING l_success 
 
     IF NOT l_success THEN 
        LET g_success ='N' 
        RETURN 
     ELSE 
        CALL t120_y1() 
        CALL t120_ins_abg_abh() 
     END IF 
    #FUN-BB0116--End    
   
   #TQC-D30067------Mark----Str
   #SELECT * INTO g_aba.* FROM aba_file WHERE aba01 = g_aba.aba01 
   #                                      AND aba00 = g_aba.aba00 #no.7277 
   #DISPLAY BY NAME g_aba.aba20 
   #DISPLAY BY NAME g_aba.aba19 
   #DISPLAY BY NAME g_aba.aba37      #MOD-A80136 
   #TQC-D30067------Mark----End
    #CALL cl_set_field_pic(g_aba.aba19,g_aba.abamksg,g_aba.abapost,"","",g_aba.abaacti)  #CHI-C80041
    IF g_aba.aba19='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_aba.aba19,g_aba.abamksg,g_aba.abapost,"",g_void,g_aba.abaacti)  #CHI-C80041
END FUNCTION 
  
FUNCTION t120_z() 			# when g_aba.aba19='Y' (Turn to 'N') 
   IF s_shut(0) THEN RETURN END IF 
   IF cl_null(g_aba.aba01) THEN RETURN END IF 
   IF g_aba.aba02 <= g_aaa.aaa07 THEN 
       CALL cl_err('','agl-085',0) 
       RETURN 
   END IF 
   SELECT * INTO g_aba.* FROM aba_file WHERE aba01 = g_aba.aba01 
   IF g_aba.aba19 ='X' THEN RETURN END IF  #CHI-C80041
   IF g_aba.aba19='N' THEN RETURN END IF 
   IF g_aba.abapost='Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF 
   BEGIN WORK 
  
    OPEN t120_cl USING g_aba.aba00,g_aba.aba01 
    IF STATUS THEN 
       CALL cl_err("OPEN t120_cl:", STATUS, 1) 
       CLOSE t120_cl 
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t120_cl INTO g_aba.*               # 鎖住將被更改或取消的資料 
    IF SQLCA.sqlcode THEN 
        CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)          #資料被他人LOCK 
        CLOSE t120_cl ROLLBACK WORK RETURN 
    END IF 
  
   LET g_success = 'Y' 
   CALL t120_z1() 
   CALL t120_del_abg_abh()   #FUN-670048 
   CLOSE t120_cl 
   IF g_success = 'Y' THEN 
      LET g_aba.aba19='N' 
     #LET g_aba.aba37=NULL           #MOD-A80136  #FUN-D20058 Mark
      LET g_aba.aba37=g_user         #FUN-D20058 Add
      COMMIT WORK 
      DISPLAY BY NAME g_aba.aba18 
      DISPLAY BY NAME g_aba.aba19 
      DISPLAY BY NAME g_aba.aba20    #No.TQC-C40196 
      DISPLAY BY NAME g_aba.aba37    #MOD-A80136 
   ELSE 
      LET g_aba.aba19='Y' 
      ROLLBACK WORK 
   END IF 
   #CALL cl_set_field_pic(g_aba.aba19,g_aba.abamksg,g_aba.abapost,"","",g_aba.abaacti)  #CHI-C80041
   IF g_aba.aba19='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_aba.aba19,g_aba.abamksg,g_aba.abapost,"",g_void,g_aba.abaacti)  #CHI-C80041
END FUNCTION 
  
FUNCTION t120_y1() 
   DEFINE l_cmd		LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(400) 
  
   LET g_t1=s_get_doc_no(g_aba.aba01)                 #No.FUN-560014 
   SELECT aac08,aacsign INTO g_aba.abamksg,g_aba.abasign 
          FROM aac_file WHERE aac01=g_t1 
   DISPLAY BY NAME g_aba.abamksg,g_aba.abasign 
# 版本 
   IF g_aba.aba18 IS NULL OR g_aba.aba18 = ' ' THEN 
      LET g_aba.aba18='0' DISPLAY BY NAME g_aba.aba18 
   END IF 
# aba20 (0.開立 1.核準) 
   IF g_aba.aba20 IS NULL OR g_aba.aba20 = ' ' THEN 
      LET g_aba.aba20='0' DISPLAY BY NAME g_aba.aba20 
   END IF 
   IF g_aba.abamksg='N' AND g_aba.aba20='0' THEN 
      LET g_aba.aba20='1' DISPLAY BY NAME g_aba.aba20 
   END IF 
   UPDATE aba_file SET  abamksg = g_aba.abamksg, 
                        abasign = g_aba.abasign, 
                        aba18 = g_aba.aba18, 
                        aba19 = 'Y', 
                        aba37  = g_user,                #MOD-A80136 
                        aba20 = g_aba.aba20 
          WHERE aba01 = g_aba.aba01 
            AND aba00 = g_bookno 
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN 
      CALL cl_err3("upd","aba_file",g_aba.aba01,"",STATUS,"","upd aba19",1)  #No.FUN-660123 
      LET g_success = 'N' RETURN  
   END IF 
# aza09 是否使用 LOTUS NOTES 
   IF g_aza.aza09='Y' AND g_aba.abamksg='Y' THEN 
       LET l_cmd='aglrx01 '' ',g_aba.aba01  #MOD-4C0171 
      CALL cl_cmdrun(l_cmd) 
   END IF 
      LET g_aba.aba20='0' DISPLAY BY NAME g_aba.aba20 
   IF g_aba.abamksg='N' AND g_aba.aba20='0' THEN 
      LET g_aba.aba20='1' DISPLAY BY NAME g_aba.aba20 
   END IF 
   UPDATE aba_file SET (abamksg,      abasign,      aba18,      aba19,aba37,aba20)        #MOD-A80136 add aba37 
                     = (g_aba.abamksg,g_aba.abasign,g_aba.aba18,'Y',g_user,g_aba.aba20)   #MOD-A80136 add g_user 
          WHERE aba01 = g_aba.aba01 
            AND aba00 = g_bookno 
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN 
      CALL cl_err3("upd","aba_file",g_aba.aba01,"",STATUS,"","upd aba19",1)  #No.FUN-660123 
      LET g_success = 'N' RETURN  
   END IF 
# aza09 是否使用 LOTUS NOTES 
   IF g_aza.aza09='Y' AND g_aba.abamksg='Y' THEN 
       LET l_cmd='aglrx01 '' ',g_aba.aba01  #MOD-4C0171 
      CALL cl_cmdrun(l_cmd) 
   END IF 
END FUNCTION 
  
FUNCTION t120_z1() 
# 版本 
   LET g_aba.aba18=g_aba.aba18+1 
   LET g_aba.aba20 = '0'   #No.TQC-C40196 
   UPDATE aba_file SET aba18 = g_aba.aba18, 
                       aba19 = 'N', 
                       aba20 = '0',    #No.TQC-C40196  
                      #aba37=' '       #MOD-A80136   #FUN-D20058 Mark
                       aba37=g_user    #FUN-D20058 Add
          WHERE aba01 = g_aba.aba01 
            AND aba00 = g_bookno 
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN 
      CALL cl_err3("upd","aba_file",g_bookno,"",STATUS,"","upd aba19",1)  #No.FUN-660123 
      LET g_success = 'N' RETURN  
   END IF 
END FUNCTION 
  
FUNCTION t120_ins_abg_abh() 
  DEFINE l_abb DYNAMIC ARRAY OF RECORD LIKE abb_file.* 
  DEFINE l_aag RECORD LIKE aag_file.* 
  DEFINE l_i   LIKE type_file.num5          #No.FUN-680098 smallint 
  
  DECLARE t120_ins_c CURSOR FOR 
    SELECT * FROM abb_file WHERE abb01 = g_aba.aba01 AND abb00 = g_aba.aba00 
  LET l_i = 1 
  FOREACH t120_ins_c INTO l_abb[l_i].* 
    IF cl_null(l_abb[l_i].abb11) THEN LET l_abb[l_i].abb11 = ' ' END IF 
    IF cl_null(l_abb[l_i].abb12) THEN LET l_abb[l_i].abb12 = ' ' END IF 
    IF cl_null(l_abb[l_i].abb13) THEN LET l_abb[l_i].abb13 = ' ' END IF 
    IF cl_null(l_abb[l_i].abb14) THEN LET l_abb[l_i].abb14 = ' ' END IF 
    IF cl_null(l_abb[l_i].abb31) THEN LET l_abb[l_i].abb31 = ' ' END IF 
    IF cl_null(l_abb[l_i].abb32) THEN LET l_abb[l_i].abb32 = ' ' END IF 
    IF cl_null(l_abb[l_i].abb33) THEN LET l_abb[l_i].abb33 = ' ' END IF 
    IF cl_null(l_abb[l_i].abb34) THEN LET l_abb[l_i].abb34 = ' ' END IF 
    IF cl_null(l_abb[l_i].abb35) THEN LET l_abb[l_i].abb35 = ' ' END IF 
    IF cl_null(l_abb[l_i].abb36) THEN LET l_abb[l_i].abb36 = ' ' END IF 
    SELECT * INTO l_aag.* FROM aag_file WHERE aag01=l_abb[l_i].abb03 
                                          AND aag00=g_bookno   # No.FUN-740020 
    IF l_aag.aag20 = 'Y' THEN 
       IF (l_aag.aag222='1' AND l_abb[l_i].abb06='2')  OR 
          (l_aag.aag222='2' AND l_abb[l_i].abb06='1')  THEN 
          INSERT INTO abh_file(abh00,abh01,abh02,abh021,abh03,abh04,abh05, 
                               abh06,abh07,abh08,abh09,abh11,abh12,abh13, 
                              #abh31,abh32,abh33,abh34,abh35,abh36,   #FUN-B40026   Mark 
                               abh14,abh15,abh16,abh17,abhconf,abhlegal) #FUN-980003 add abhlegal 
              VALUES (g_bookno,         #帳別 
                      g_aba.aba01,      #傳票編號(沖帳) 
                      l_abb[l_i].abb02, #項次    (沖帳) 
                      g_aba.aba02,      #傳票日期 
                      l_abb[l_i].abb03, #科目 
                      l_abb[l_i].abb04, #摘要 
                      l_abb[l_i].abb05, #部門 
                      '1',          #行序 
                      g_aba.aba07,      #立帳傳票編號 
                      l_abb[l_i].abb02, #立帳傳票項次 
                      l_abb[l_i].abb07, #沖帳金額 
                      l_abb[l_i].abb11,l_abb[l_i].abb12, 
                      l_abb[l_i].abb13,l_abb[l_i].abb14, 
                     #l_abb[l_i].abb31,l_abb[l_i].abb32,  #FUN-B40026   Mark 
                     #l_abb[l_i].abb33,l_abb[l_i].abb34,  #FUN-B40026   Mark 
                     #l_abb[l_i].abb35,l_abb[l_i].abb36,  #FUN-B40026   Mark 
                      ' ',' ',' ','Y',g_legal) #FUN-980003 add g_legal 
              IF STATUS THEN 
                 CALL cl_err3("ins","abh_file",g_bookno,g_aba.aba01,STATUS, 
                              "","ins abh_file",0) 
                 LET g_success = 'N' EXIT FOREACH 
              END IF 
              UPDATE abg_file SET abg072 = abg072 + l_abb[l_i].abb07 
                              WHERE abg00 = g_bookno 
                                AND abg01 = g_aba.aba07 
                                AND abg02 = l_abb[l_i].abb02 
              IF STATUS THEN 
                 CALL cl_err3("upd","abg_file",g_bookno,g_aba.aba07,STATUS, 
                              "","upd abg_file",0) 
                 LET g_success = 'N' EXIT FOREACH 
              END IF 
       END IF 
       IF (l_aag.aag222='1' AND l_abb[l_i].abb06='1')  OR 
          (l_aag.aag222='2' AND l_abb[l_i].abb06='2')  THEN 
          INSERT INTO abg_file(abg00,abg01,abg02,abg03,abg04,abg05, 
                               abg06,abg071,abg072,abg073,abg11,abg12, 
                               abg13,abg14, 
                              #abg31,abg32,abg33,abg34,abg35,abg36,    #FUN-B40026   Mark 
                               abg15,abg16,abg17,abglegal) #FUN-980003 add abglegal 
             VALUES(g_bookno,g_aba.aba01,l_abb[l_i].abb02,l_abb[l_i].abb03, 
                    l_abb[l_i].abb04,l_abb[l_i].abb05,g_aba.aba02, 
                    l_abb[l_i].abb07,0,0,l_abb[l_i].abb11,l_abb[l_i].abb12, 
                    l_abb[l_i].abb13,l_abb[l_i].abb14, 
                   #l_abb[l_i].abb31,l_abb[l_i].abb32,l_abb[l_i].abb33,   #FUN-B40026   Mark 
                   #l_abb[l_i].abb34,l_abb[l_i].abb35,l_abb[l_i].abb36,   #FUN-B40026   Mark 
                    '1',' ',' ',g_legal) #FUN-980003 add g_legal 
             IF STATUS THEN 
                CALL cl_err3("ins","abg_file",g_bookno,g_aba.aba01,STATUS, 
                             "","ins abg_file",0) 
                LET g_success = 'N' EXIT FOREACH 
             END IF 
       END IF 
    END IF 
    LET l_i = l_i + 1 
  END FOREACH 
END FUNCTION 
  
FUNCTION t120_del_abg_abh() 
  DEFINE l_abb DYNAMIC ARRAY OF RECORD LIKE abb_file.* 
  DEFINE l_aag RECORD LIKE aag_file.* 
  DEFINE l_i   LIKE type_file.num5          #No.FUN-680098 smallint 
  
  DECLARE t120_del_c CURSOR FOR 
    SELECT * FROM abb_file WHERE abb01 = g_aba.aba01 AND abb00 = g_aba.aba00 
  LET l_i = 1 
  FOREACH t120_del_c INTO l_abb[l_i].* 
    SELECT * INTO l_aag.* FROM aag_file WHERE aag01=l_abb[l_i].abb03 
                                         AND  aag00=g_bookno    #No.FUN-740020   
    IF l_aag.aag20 = 'Y' THEN 
       IF (l_aag.aag222='1' AND l_abb[l_i].abb06='2')  OR 
          (l_aag.aag222='2' AND l_abb[l_i].abb06='1')  THEN 
              DELETE FROM abh_file WHERE abh00 = g_bookno AND 
                                         abh01 = g_aba.aba01 AND 
                                         abh02 = l_abb[l_i].abb02 AND 
                                         abh07 = g_aba.aba07 AND 
                                         abh08 = l_abb[l_i].abb02 
              IF STATUS THEN 
                 CALL cl_err3("del","abh_file",g_bookno,g_aba.aba01,STATUS, 
                              "","del abh_file",0) 
                 LET g_success = 'N' EXIT FOREACH 
              END IF 
              UPDATE abg_file SET abg072 = abg072 - l_abb[l_i].abb07 
                              WHERE abg00 = g_bookno 
                                AND abg01 = g_aba.aba07 
                                AND abg02 = l_abb[l_i].abb02 
              IF STATUS THEN 
                 CALL cl_err3("upd","abg_file",g_bookno,g_aba.aba07,STATUS, 
                              "","upd abg_file",0) 
                 LET g_success = 'N' EXIT FOREACH 
              END IF 
       END IF 
       IF (l_aag.aag222='1' AND l_abb[l_i].abb06='1')  OR 
          (l_aag.aag222='2' AND l_abb[l_i].abb06='2')  THEN 
          DELETE FROM abg_file WHERE abg00 = g_bookno AND 
                                     abg01 = g_aba.aba01 AND 
                                     abg02 = l_abb[l_i].abb02 
             IF STATUS THEN 
                CALL cl_err3("del","abg_file",g_bookno,g_aba.aba01,STATUS, 
                             "","del abg_file",0) 
                LET g_success = 'N' EXIT FOREACH 
             END IF 
       END IF 
    END IF 
    LET l_i = l_i + 1 
  END FOREACH 
END FUNCTION 
  
FUNCTION t120_subchr(p_str,p_chr1,p_chr2) 
DEFINE p_str          LIKE type_file.chr1000,  #No.FUN-680098  VARCHAR(700) 
       p_chr1,p_chr2  LIKE type_file.chr1,     #No.FUN-680098  VARCHAR(1) 
       l_str          LIKE type_file.chr1000   #No.FUN-680098  VARCHAR(700) 
DEFINE l_n  LIKE type_file.num5   #TQC-750071 
  
   LET l_n = LENGTH(p_str)    #TQC-750071 
   LET l_str=p_str            #TQC-750071 
   FOR g_i=1 TO l_n            #MOD-740068 
       IF p_str[g_i,g_i]=p_chr1 
          THEN 
          LET l_str[g_i,g_i]=p_chr2 
       END IF 
   END FOR 
   RETURN l_str 
END FUNCTION 
  
FUNCTION t120_chkb() 
DEFINE g_abb07f_t1,g_abb07_t1 LIKE abb_file.abb07, 
       g_abb07f_t2,g_abb07_t2 LIKE abb_file.abb07 
  SELECT SUM(abb07f),SUM(abb07) INTO g_abb07f_t1,g_abb07_t1 FROM abb_file 
   WHERE abb00 = g_aba.aba00 AND abb01 = g_aba.aba01 AND abb06='1' 
  SELECT SUM(abb07f),SUM(abb07) INTO g_abb07f_t2,g_abb07_t2 FROM abb_file 
   WHERE abb00 = g_aba.aba00 AND abb01 = g_aba.aba01 AND abb06='2' 
  IF cl_null(g_abb07f_t1) THEN LET g_abb07f_t1 = 0 END IF 
  IF cl_null(g_abb07_t1) THEN LET g_abb07_t1 = 0 END IF 
  IF cl_null(g_abb07f_t2) THEN LET g_abb07f_t2 = 0 END IF 
  IF cl_null(g_abb07_t2) THEN LET g_abb07_t2 = 0 END IF 
  DISPLAY g_abb07f_t1,g_abb07_t1,g_abb07f_t2,g_abb07_t2 
     TO FORMONLY.abb07f_t1,FORMONLY.abb07_t1, 
        FORMONLY.abb07f_t2,FORMONLY.abb07_t2 
END FUNCTION 
  
FUNCTION  t120_show_field() 
#依參數決定異動碼的多寡 
  
  DEFINE l_field   STRING 
 
#FUN-B50105   ---start   Mark  
# IF g_aaz.aaz88 = 10 THEN 
#    RETURN 
# END IF 
# 
# IF g_aaz.aaz88 = 0 THEN 
#    LET l_field  = "abb11,abb12,abb13,abb14,abb15,abb31,abb32,abb33,abb34,",          #FUN-810069 
#                   "abb35,abb36" 
# END IF 
# 
# IF g_aaz.aaz88 = 1 THEN 
#    LET l_field  = "abb12,abb13,abb14,abb15,abb31,abb32,abb33,abb34,",    #FUN-810069 
#                   "abb35,abb36" 
# END IF 
# 
# IF g_aaz.aaz88 = 2 THEN 
#    LET l_field  = "abb13,abb14,abb15,abb31,abb32,abb33,abb34,",          #FUN-810069 
#                   "abb35,abb36" 
# END IF 
# 
# IF g_aaz.aaz88 = 3 THEN 
#    LET l_field  = "abb14,abb15,abb31,abb32,abb33,abb34,",              #FUN-810069 
#                   "abb35,abb36" 
# END IF 
# 
# IF g_aaz.aaz88 = 4 THEN 
#    LET l_field  = "abb15,abb31,abb32,abb33,abb34,",                 #FUN-810069 
#                   "abb35,abb36" 
# END IF 
# 
# IF g_aaz.aaz88 = 5 THEN 
#    LET l_field  = "abb15,abb32,abb33,abb34,",                          #FUN-810069 
#                   "abb35,abb36" 
# END IF 
# 
# IF g_aaz.aaz88 = 6 THEN 
#    LET l_field  = "abb15,abb33,abb34,abb35,abb36"                  #FUN-810069 
# END IF 
# 
# IF g_aaz.aaz88 = 7 THEN 
#    LET l_field  = "abb15,abb34,abb35,abb36"                           #FUN-810069 
# END IF 
# 
# IF g_aaz.aaz88 = 8 THEN 
#    LET l_field  = "abb15,abb35,abb36"                                   #FUN-810069 
# END IF 
# 
# IF g_aaz.aaz88 = 9 THEN 
#    LET l_field  = "abb15,abb36"                                       #FUN-810069 
# END IF 
#FUN-B50105   ---start   Mark  
  
#FUN-B50105   ---start   Add 
   IF g_aaz.aaz88 = 0 THEN 
      LET l_field = "abb11,abb12,abb13,abb14,abb15" 
   END IF 
   IF g_aaz.aaz88 = 1 THEN 
      LET l_field = "abb12,abb13,abb14,abb15" 
   END IF 
   IF g_aaz.aaz88 = 2 THEN 
      LET l_field = "abb13,abb14,abb15" 
   END IF 
   IF g_aaz.aaz88 = 3 THEN 
      LET l_field = "abb14,abb15" 
   END IF 
   IF g_aaz.aaz88 = 4 THEN 
      LET l_field = "abb15" 
   END IF 
   IF g_aaz.aaz125 = 5 THEN 
      LET l_field = l_field,",abb32,abb33,abb34,abb35,abb36" 
   END IF 
   IF g_aaz.aaz125 = 6 THEN 
      LET l_field = l_field,",abb33,abb34,abb35,abb36" 
   END IF 
   IF g_aaz.aaz125 = 7 THEN 
      LET l_field = l_field,",abb34,abb35,abb36" 
   END IF 
   IF g_aaz.aaz125 = 8 THEN 
      LET l_field = l_field,",abb35,abb36" 
   END IF 
#FUN-B50105   ---end     Add 
 
  CALL cl_set_comp_visible(l_field,FALSE) 
  CALL cl_set_comp_visible("abb35,abb36",TRUE)   #MOD-B90136 add   #MOD-BB0234 add abb35 
END FUNCTION 
 
FUNCTION t120_aba24(p_cmd) 
DEFINE p_cmd      LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1) 
       l_gen02    LIKE gen_file.gen02, 
       l_gen03    LIKE gen_file.gen03,             #No:7381 
       l_genacti  LIKE gen_file.genacti 
  
    LET g_errno = ' ' 
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti    #No:7381 
      FROM gen_file 
     WHERE gen01 = g_aba.aba24 
    CASE 
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312' 
                                LET l_gen02 = NULL 
                                LET l_genacti = NULL 
       WHEN l_genacti = 'N'  LET g_errno = '9028' 
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------' 
    END CASE 
    IF cl_null(g_errno) OR p_cmd = 'd' 
    THEN DISPLAY l_gen02 TO FORMONLY.gen02 
    END IF 
END FUNCTION 
#No.FUN-9C0072 精簡程式碼 
 
#FUN-BB0116--Begin-- 
FUNCTION t120_y_chk() 
  DEFINE only_one             LIKE type_file.chr1    #No.FUN-680098   CHAR(1) 
  DEFINE p_row,p_col          LIKE type_file.num5    #No.FUN-680098   SMALLINT 
  DEFINE l_uprow_count        LIKE type_file.num5    #SMALLINT  #記錄執行符合畫面輸入範圍條件要進行確認的筆數 
 
  LET p_row = 8 LET p_col = 30 
  LET only_one = '1' 
  LET l_uprow_count = 0 
 
  IF g_action_choice CLIPPED = "confirm"  #執行 "確認" 功能 
    THEN 
    OPEN WINDOW t120_w1 AT p_row,p_col WITH FORM "agl/42f/aglt120_1" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN 
 
      CALL cl_ui_locale("aglt120_1") 
      LET only_one = '1' 
 
      INPUT BY NAME only_one WITHOUT DEFAULTS 
        AFTER FIELD only_one 
 
          IF only_one IS NULL THEN 
            NEXT FIELD only_one 
          END IF 
 
          IF only_one NOT MATCHES "[12]" THEN 
            NEXT FIELD only_one 
          END IF 
 
          LET g_only_one = only_one 
 
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
        LET g_success = 'N' 
        CLOSE WINDOW t120_w1 
        RETURN 
      END IF 
  END IF 
 
  IF only_one = '1' THEN 
    LET g_wc = " aba01 = '",g_aba.aba01,"' " 
  ELSE 
    CONSTRUCT BY NAME g_wc ON aba01,aba02,abauser 
      BEFORE CONSTRUCT 
        #CALL cl_qbe_init()   #FUN-BB0116 
 
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
      LET INT_FLAG=0 
      LET g_success = 'N' 
      CLOSE WINDOW t120_w1 
      RETURN 
    END IF 
  END IF 
 
  IF g_action_choice CLIPPED = "confirm"       #按「確認」時 
    THEN 
      IF NOT cl_confirm('aap-222') THEN 
        LET g_success = 'N' 
        CLOSE WINDOW t120_w1 
        RETURN 
      END IF 
 
      IF g_bgjob='N' OR cl_null(g_bgjob) THEN 
        CLOSE WINDOW t120_w1 
      END IF 
 
      IF only_one != '1' THEN 
        LET g_sql = "SELECT * FROM aba_file WHERE ",g_wc CLIPPED, 
                    "   AND aba06 ='RV' ", 
                    "   AND aba19 = 'N' AND abapost = 'N' AND abaacti = 'Y'" 
        PREPARE aba_pre1 FROM g_sql 
        DECLARE aba_cur1 CURSOR FOR aba_pre1 
        LET g_aba_t.* = g_aba.* 
 
        FOREACH aba_cur1 INTO g_aba.* 
 
          IF STATUS THEN 
            CALL s_errmsg("",g_aba.aba01,'foreach:','STATUS',1) 
            LET g_success = 'N' 
            EXIT FOREACH 
          END IF 
 
          LET l_uprow_count = l_uprow_count + 1 
 
          CALL t120_y() 
 
          IF g_success = 'N' THEN 
            CONTINUE FOREACH 
          END IF 
        END FOREACH 
 
        LET g_aba.* = g_aba_t.* 
 
        IF l_uprow_count = 0 THEN              #表示查詢條件結果為0筆數 
           CALL cl_err(g_aba.aba01,100,0)      #err code:100,無此筆資料,或任何上下筆資料,或其他相關主檔資料 ! 
        END IF 
      ELSE 
        BEGIN WORK 
 
        OPEN t120_cl USING g_aba.aba00,g_aba.aba01 
          IF STATUS THEN 
            CALL cl_err("OPEN t120_cl:", STATUS, 1) 
            CLOSE t120_cl 
            ROLLBACK WORK 
            RETURN 
          END IF 
 
          FETCH t120_cl INTO g_aba.*               # 鎖住將被更改或取消的資料 
            IF SQLCA.sqlcode THEN 
              CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)          #資料被他人LOCK 
              CLOSE t120_cl ROLLBACK WORK RETURN 
            END IF 
            LET g_success = 'Y' 
            CALL t120_y() 
 
        CLOSE t120_cl 
 
        IF g_success = 'Y' THEN 
          COMMIT WORK 
        ELSE 
          ROLLBACK WORK 
        END IF 
      END IF 
  END IF 
  #TQC-D30067------Add----Str
  SELECT * INTO g_aba.* FROM aba_file
   WHERE aba01 = g_aba.aba01
     AND aba00 = g_aba.aba00
  DISPLAY BY NAME g_aba.aba20
  DISPLAY BY NAME g_aba.aba19
  DISPLAY BY NAME g_aba.aba37
  #TQC-D30067------Add----End
END FUNCTION  #End Function:t120_y_chk() 
#FUN-BB0116--End-- 
 #CHI-C80041---begin
FUNCTION t120_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_aba.aba01) OR cl_null(g_aba.aba00) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t120_cl USING g_aba.aba00,g_aba.aba01
   IF STATUS THEN
      CALL cl_err("OPEN t120_cl:", STATUS, 1)
      CLOSE t120_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t120_cl INTO g_aba.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t120_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_aba.aba19 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_aba.aba19)   THEN 
        LET l_chr=g_aba.aba19
        IF g_aba.aba19='N' THEN 
            LET g_aba.aba19='X' 
        ELSE
            LET g_aba.aba19='N'
        END IF
        UPDATE aba_file
            SET aba19=g_aba.aba19,  
                abamodu=g_user,
                abadate=g_today
            WHERE aba00=g_aba.aba00
              AND aba01=g_aba.aba01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","aba_file",g_aba.aba01,"",SQLCA.sqlcode,"","",1)  
            LET g_aba.aba19=l_chr 
        END IF
        DISPLAY BY NAME g_aba.aba19
   END IF
 
   CLOSE t120_cl
   COMMIT WORK
   CALL cl_flow_notify(g_aba.aba01,'V')
 
END FUNCTION
#CHI-C80041---end
