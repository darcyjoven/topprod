# Prog. Version..: '5.30.06-13.04.02(00010)'     #
#
# Pattern name...: asfp410.4gl
# Descriptions...: 已結案工單重新開啟作業(含委外)
# Date & Author..: 93/01/05 By David
# Modify ........: No.B332 010510 add by linda 增加委外工單還原作業
# Modify ........: MOD-480413 04/09/02 by echo  無法選舉,欲重新開啟的工單
# Modify ........: MOD-4A0200 04/10/13 by Carol 在 select unique max(tlf13)....排除 tlf13='asft700' 資料
#                                               應排除tlf13='asft700'當站下線者
#                                             　才不會造成回復至 1狀態,造成工單無法接續處理
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.MOD-550029 05/05/05 By Carol 恢復委外結案工單重新開啟時將相關的委外採購單同時開啟的功能
# Modify.........: No.MOD-580348 05/09/07 By pengu 若工單為事後扣料生產方式，且該工單已有報工情況，
                                         #         則回寫sfb04應為'5'
# Modify.........: No.MOD-5C0019 05/12/02 By Claire 三段式結案工單,重新執行開啟;造成結案狀態錯誤
# Modify.........: No.MOD-5C0055 05/12/09 By kim 若[委外採購單]為未確認狀態時,應還原成 [1.開立]的狀態,而非[2.發出採購單]
# Modify.........: No.MOD-630039 06/03/14 By Claire 若[委外採購單]為未確認狀態時,應還原成 [0.開立]的狀態,
                                           #        而[委外採購單]為確  認狀態時,應還原成 [1.發出採購單]
# Modify.........: No.MOD-650022 06/05/05 By Claire update段改寫sqlca.sqlerrd[3]判斷
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.MOD-670061 06/07/13 By Pengu MOD-630039應該要先判斷是否為委外工單才走這段
# Modify.........: No.FUN-680121 06/09/12 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.MOD-690123 06/11/15 By pengu 重新開啟時應將sfb37與sfb36清為空白以免無法報工
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-730003 07/03/19 By Smapmin 委外採購單若已有收貨資料時,狀態應UPDATE為2.發出採購單.
# Modify.........: No.MOD-820034 08/02/13 By Pengu 還原結案時工單狀態應改為"2:發放"
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.MOD-860292 08/07/13 By Pengu 製程委外採購單無法做結案開啟
# Modify.........: No.MOD-940163 09/05/25 By Pengu 未確認工單取消結案時狀態碼應是1.開立
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A50015 10/05/13 By Summer UPDATE後增加INSERT INTO azo_file
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No:FUN-9A0095 11/04/14 By abby MES整合追版
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No:FUN-C10065 12/02/08 By Abby MES標準整合外的工單無拋轉至MES，但在進行工單結案時卻拋轉MES並回饋工單不存在，導致該類工單結案失敗。
# Modify.........: No:MOD-CA0012 12/10/12 By Elise 已存在FQC單且確認的話,將工單狀態給予6
# Modify.........: No:CHI-AB0038 13/01/10 By Alberti 在update前需再從抓sfb_file資料，並免同時執行成會結案而錯誤
# Modify.........: No:FUN-CC0122 13/01/18 By Nina 修正MES標準整合外的工單無拋轉至MES，但在進行工單變更時卻拋轉MES並回饋工單不存在，導致該類工單變更拋轉失敗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680121 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000,  #No.FUN-680121 VARCHAR(72)
         g_rec_b         LIKE type_file.num5      #MOD-480413  #No.FUN-680121 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8     #No.FUN-6A0090
      DEFINE    l_sl   LIKE type_file.num5,    #No.FUN-680121 SMALLINT  #No.FUN-6A0090
           p_row     LIKE type_file.num5,    #No.FUN-680121 SMALLINT
           p_col     LIKE type_file.num5     #No.FUN-680121 SMALLINT
      DEFINE l_sql         STRING                       #No:CHI-AB0038 add
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
      #---------No:CHI-AB0038 add
  
     LET l_sql = " SELECT sfb04,sfb28 FROM sfb_file WHERE sfb01 = ? ",
                 " FOR UPDATE "
     LET l_sql = cl_forupd_sql(l_sql)
     DECLARE p410_cl CURSOR FROM l_sql                 # LOCK CURSOR
      #---------No:CHI-AB0038 end
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p410_w AT p_row,p_col WITH FORM "asf/42f/asfp410" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL p410()
   CLOSE WINDOW p410_w               #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
END MAIN
 
 
#將資料選出, 並進行挑選
FUNCTION p410()
DEFINE
    l_sfb      DYNAMIC ARRAY OF RECORD
               sure     LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
               sfb01    LIKE sfb_file.sfb01,    #工單編號
               sfb02    LIKE sfb_file.sfb02,    #工單編號
               sfb05    LIKE sfb_file.sfb05,    #料件編號
               sfb08    LIKE sfb_file.sfb08,    #生產數量
               sfb09    LIKE sfb_file.sfb09,    #完工數量
               sfb04    LIKE sfb_file.sfb04,    #工單狀態
               sfb28    LIKE sfb_file.sfb28,    #結案狀案
               sfb15    LIKE sfb_file.sfb15     #完工日期
               END RECORD,
    l_ima55_fac LIKE ima_file.ima55_fac,
    l_sfb05    LIKE sfb_file.sfb05,
    l_sfb08    LIKE sfb_file.sfb08,
    l_sfb09    LIKE sfb_file.sfb08,
    l_sfb10    LIKE sfb_file.sfb08,
    l_sfb11    LIKE sfb_file.sfb08,
    l_sfb12    LIKE sfb_file.sfb08,
    l_pmn01    LIKE pmn_file.pmn01,
    l_pmn02    LIKE pmn_file.pmn02,
    l_pmn16    LIKE pmn_file.pmn16,    #MOD-630039
    l_pmm18    LIKE pmm_file.pmm18,    #MOD-630039
    l_pmm25    LIKE pmm_file.pmm25,    #MOD-630039
    l_pmm      LIKE type_file.num5,    #No.FUN-680121 SMALLINT,
    l_qty      LIKE sfb_file.sfb08,
    l_sta      DYNAMIC ARRAY OF RECORD
          sta  LIKE type_file.chr1     #No.FUN-680121 VARCHAR(1)
               END RECORD,  
    l_sfb87    LIKE sfb_file.sfb87,
    l_sfb02    LIKE sfb_file.sfb02,
    l_ac         LIKE type_file.num5,       #program array no  #No.FUN-680121 SMALLINT
    l_exit       LIKE type_file.chr1,       #No.FUN-680121 VARCHAR(01),
    l_flag       LIKE type_file.chr1,       #No.FUN-680121 VARCHAR(1)
    l_sl         LIKE type_file.num5,       #No.FUN-680121 SMALLINT,                  #screen array no
    l_cnt        LIKE type_file.num5,       #所選擇筆數  #No.FUN-680121 SMALLINT
    l_cnt1       LIKE type_file.num5,       #所選擇筆數  #No.FUN-680121 SMALLINT
    l_cnt2       LIKE type_file.num5,       #No.MOD-580348 add  #No.FUN-680121 SMALLINT
    l_cnt3       LIKE type_file.num5,                #MOD-730003
    l_cmd        LIKE type_file.chr1000,    #No.FUN-680121 VARCHAR(400)
    l_wc,l_sql   LIKE type_file.chr1000,    #No.FUN-680121 VARCHAR(400)
    l_sfb04      LIKE sfb_file.sfb04,
    l_tlf13      LIKE tlf_file.tlf13,
 #### MOD-480413 ####
    g_i          LIKE type_file.num5,                #可新增否  #No.FUN-680121 SMALLINT
    l_allow_insert  LIKE type_file.num5,             #可新增否  #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5              #No.FUN-680121 SMALLINT
 #### MOD-480413 ####
DEFINE l_msg     LIKE type_file.chr1000     #CHI-A50015 add
DEFINE l_msg1    LIKE type_file.chr1000     #CHI-A50015 add
DEFINE l_sfbstr  STRING                     #紀錄工單編號  #FUN-9A0095 add
DEFINE l_cnt4    LIKE type_file.num5        #MOD-CA0012 add
 
    WHILE TRUE
        IF s_shut(0) THEN EXIT WHILE END IF
        LET l_exit='Y'
        IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
            CALL cl_getmsg('mfg5050',g_lang) RETURNING g_msg
            MESSAGE g_msg 
            CALL ui.Interface.refresh()
            CALL cl_getmsg('mfg5051',g_lang) RETURNING g_msg
            MESSAGE g_msg 
            CALL ui.Interface.refresh()
        ELSE 
            CALL cl_getmsg('mfg5050',g_lang) RETURNING g_msg
           #DISPLAY g_msg AT 1,1  #CHI-A70049 mark        #顯示操作指引
            CALL cl_getmsg('mfg5051',g_lang) RETURNING g_msg
           #DISPLAY g_msg AT 2,1  #CHI-A70049 mark        #顯示操作指引
        END IF
        IF g_sma.sma72 ='N' THEN
           CALL cl_err('','asf-511',1)
           EXIT WHILE
        END IF
        CLEAR FORM
         CALL cl_set_comp_visible("select_all,cancel_all,cn3",FALSE) #MOD-480413
        CONSTRUCT l_wc ON sfb01,sfb02,sfb05,sfb08,sfb09,sfb04,sfb28,sfb15
            FROM s_sfb[1].sfb01,s_sfb[1].sfb02,s_sfb[1].sfb05,s_sfb[1].sfb08,
                 s_sfb[1].sfb09,s_sfb[1].sfb04,s_sfb[1].sfb28,
                 s_sfb[1].sfb15 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        #MOD-530850                                                                
     ON ACTION CONTROLP                                                         
        CASE                                                                    
          WHEN INFIELD(sfb05)
#FUN-AA0059---------mod------------str-----------------                                                             
#            CALL cl_init_qry_var()                                              
#            LET g_qryparam.form = "q_ima"                                       
#            LET g_qryparam.state = "c"                                          
#            LET g_qryparam.default1 = l_sfb[1].sfb05                               
#            CALL cl_create_qry() RETURNING g_qryparam.multiret 
             CALL q_sel_ima(TRUE, "q_ima","",l_sfb[1].sfb05,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------                 
            DISPLAY g_qryparam.multiret TO sfb05                                
            NEXT FIELD sfb05                                                    
         OTHERWISE                                                              
            EXIT CASE                                                           
       END CASE                                                                 
    #--
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
        
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
        END CONSTRUCT
        LET l_wc = l_wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT WHILE
        END IF
        LET l_sql = "SELECT ",                      #組合查詢句子
            "'', sfb01, sfb02,sfb05, sfb08, sfb09,sfb04, sfb28, sfb15 ",
            " FROM sfb_file ",
            " WHERE sfb04 = '8' AND sfb28 != '3' ",
          # "   AND sfb02 <> '7' ",   #No.B332 mark
            "   AND ",l_wc CLIPPED
 
        PREPARE p410_prepare FROM l_sql      #預備之
        IF SQLCA.sqlcode THEN                          #有問題了
            CALL cl_err('PREPARE:',SQLCA.sqlcode,1)
            EXIT WHILE
        END IF
        DECLARE p410_curs CURSOR FOR p410_prepare     #宣告之
 
        CALL l_sfb.clear()
 
        LET g_cnt=1                                         #總選取筆數
         LET g_rec_b = 0                                   # MOD-480413
        FOREACH p410_curs INTO l_sfb[g_cnt].*               #逐筆抓出
            IF SQLCA.sqlcode THEN                           #有問題
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
             LET l_sfb[g_cnt].sure = "N"                   # MOD-480413
            LET g_cnt = g_cnt + 1                           #累加筆數
            IF g_cnt > g_max_rec THEN                       #超過肚量了
               CALL cl_err('','9035',0)
               EXIT FOREACH
            END IF
        END FOREACH
        IF g_cnt=1 THEN                                     #沒有抓到
            CALL cl_err('','mfg5052',0)                     #顯示錯誤, 並回去
            CONTINUE WHILE
        END IF
 
 ##### MOD-480413 ######
        CALL l_sfb.deleteElement(g_cnt)
        LET g_rec_b=g_cnt-1                                   #正確的總筆數
        DISPLAY g_rec_b TO FORMONLY.cn2                       
 
        DISPLAY ARRAY l_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #顯示
           BEFORE DISPLAY
              EXIT DISPLAY
         #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
         #MOD-860081------add-----end---
        END DISPLAY
 
{
        CALL SET_COUNT(g_cnt)                               #告之DISPALY ARRAY
        CALL cl_getmsg('mfg5049',g_lang) RETURNING g_msg
        MESSAGE "" 
        MESSAGE g_msg 
        CALL ui.Interface.refresh()
        DISPLAY g_cnt TO FORMONLY.cn3  #顯示總筆數
        LET l_cnt=0                                     #已選筆數
        DISPLAY l_cnt TO FORMONLY.cn2  
        
}
 
#bugno:7463 modify..........................................................
        CALL cl_set_act_visible("accept,cancel", TRUE)
 
# Modify by hjwang:這裡應該放 menu
 
       LET l_allow_insert = FALSE
       LET l_allow_delete = FALSE
 
       LET l_ac = 1
       CALL cl_set_comp_visible("select_all,cancel_all,cn3",TRUE)
       INPUT ARRAY l_sfb WITHOUT DEFAULTS FROM s_sfb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
    #  DISPLAY ARRAY l_sfb TO s_sfb.*  #顯示並進行選擇
       BEFORE INPUT
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
 
      #AFTER FIELD sure
        ON CHANGE   sure  #MOD-4A0017
          IF NOT cl_null(l_sfb[l_ac].sure) THEN
             IF l_sfb[l_ac].sure NOT MATCHES "[YN]" THEN
                NEXT FIELD sure
             END IF
            LET l_cnt = 0
            FOR g_i =1 TO g_rec_b
                IF l_sfb[g_i].sure = 'Y' AND
                   NOT cl_null(l_sfb[g_i].sfb01)  THEN
                   LET l_cnt = l_cnt + 1
                END IF
            END FOR
            DISPLAY l_cnt TO FORMONLY.cn3
          END IF
 
 ###### END MOD-480413 ######
 
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
 
            ON ACTION CONTROLG
                CALL cl_cmdask()
 
            ON ACTION CONTROLN  #重查
                LET l_exit='N'
                # EXIT DISPLAY   ##MOD-480413
                EXIT INPUT
 
 ######  MOD-480413  ######
            ON ACTION select_all
               LET l_cnt=0                
               FOR g_i = 1 TO g_rec_b    #將所有的設為選擇
                   IF l_sfb[g_i].sfb28 ='2' THEN
                         CALL cl_getmsg('mfg7011',g_lang) RETURNING g_msg
                        IF cl_prompt(0,0,g_msg) THEN
                              LET l_sfb[g_i].sure='Y'          #設定為選擇
                              LET l_cnt=l_cnt+1                   #累加已選筆數
                           LET l_sta[g_i].sta = '0'
                        ELSE 
                           LET l_sta[g_i].sta ='1'
                        END IF
                   ELSE
                      LET l_sfb[g_i].sure='Y'          #設定為選擇
                      LET l_cnt=l_cnt+1                   #累加已選筆數
                      LET l_sta[g_i].sta = '0'
                   END IF
               END FOR
               DISPLAY l_cnt TO FORMONLY.cn3
 
            ON ACTION cancel_all
               FOR g_i = 1 TO g_rec_b     #將所有的設為選擇
                   LET l_sfb[g_i].sure="N"
               END FOR
               LET l_cnt = 0
               DISPLAY 0 TO FORMONLY.cn3
       
        {
            ON ACTION select_cancel  #選擇或取消
                LET l_ac = ARR_CURR()
                LET l_sl = SCR_LINE()
                IF l_sfb[l_ac].sure IS NULL OR l_sfb[l_ac].sure=' ' THEN
                   IF l_sfb[l_ac].sfb28 ='2' THEN
                         CALL cl_getmsg('mfg7011',g_lang) RETURNING g_msg
                        IF cl_prompt(0,0,g_msg) THEN
                              LET l_sfb[l_ac].sure='Y'          #設定為選擇
                              LET l_cnt=l_cnt+1                   #累加已選筆數
                           LET l_sta[l_ac].sta = '0'
                        ELSE 
                           LET l_sta[l_ac].sta ='1'
                        END IF
                   ELSE
                      LET l_sfb[l_ac].sure='Y'          #設定為選擇
                      LET l_cnt=l_cnt+1                   #累加已選筆數
                      LET l_sta[l_ac].sta = '0'
                   END IF
                ELSE
                   LET l_sfb[l_ac].sure=' '           #設定為不選擇
                   LET l_cnt=l_cnt-1                   #減少已選筆數
                END IF
                DISPLAY l_sfb[l_ac].sure TO s_sfb[l_sl].sure 
                DISPLAY l_cnt TO FORMONLY.cn2  
         }
 ###### END MOD-480413 ######
 
            ON ACTION qry_wo  #查詢工單明細
                LET l_ac = ARR_CURR()
                SELECT sfb02 INTO l_sfb02 
                FROM sfb_file WHERE sfb01 = l_sfb[l_ac].sfb01
              # IF l_sfb02 = 7 THEN
              # LET l_cmd="asfi320 '",l_sfb[l_ac].sfb01,"' ","'","1","' ",
              #           "'",l_sfb02,"' ","'","Q","'"
              # ELSE
              # LET l_cmd="asfi300 '",l_sfb[l_ac].sfb01,"' ","'","1","' ",
              #           "'",l_sfb02,"' ","'","Q","'"
              # END IF
                LET l_cmd="asfi301 '",l_sfb[l_ac].sfb01,"' "
                CALL cl_cmdrun(l_cmd)
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
            # CONTINUE DISPLAY
               CONTINUE INPUT   #MOD-480413
      # END DISPLAY
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
         END INPUT     #MOD-480413
        CALL cl_set_act_visible("accept,cancel", TRUE)
 
#bugno:7463 end..........................................................
        IF INT_FLAG THEN LET INT_FLAG = 0 LET g_success='N' EXIT WHILE END IF #使用者中斷
        IF l_exit='N' THEN
            CONTINUE WHILE
        END IF
        IF l_cnt < 1 THEN                               #已選筆數超過 0筆
            EXIT WHILE
        END IF
        IF NOT cl_sure(0,0) THEN
            EXIT WHILE
        END IF
        CALL cl_wait()
        BEGIN WORK
        LET l_sl=0
        LET g_success = 'Y'
        LET l_sfbstr = ''                         #FUN-9A0095 add
      # FOR l_ac=1 TO g_cnt                       #MOD-480413
        CALL s_showmsg_init()                     #NO.FUN-710026
        FOR l_ac=1 TO g_rec_b
       #------------------No:CHI-AB0038 add
        OPEN p410_cl USING l_sfb[l_ac].sfb01
        IF STATUS THEN 
           CALL s_errmsg('',l_sfb[l_ac].sfb01,'',STATUS,1) 
           CONTINUE FOR
        END IF
        FETCH p410_cl INTO l_sfb[l_ac].sfb04,l_sfb[l_ac].sfb28            # 對DB鎖定
        IF l_sfb[l_ac].sfb04 != '8' OR l_sfb[l_ac].sfb28 = '3' THEN CONTINUE FOR END IF
       #------------------No:CHI-AB0038 end
#NO.FUN-710026-----begin add
        IF g_success='N' THEN                                                                                                          
           LET g_totsuccess='N'                                                                                                       
           LET g_success="Y"                                                                                                          
        END IF                    
#NO.FUN-710026-----end
            IF l_sfb[l_ac].sure='Y' THEN          #該單據要reopen
   ##1999/09/14 modify
            LET l_tlf13 = ''
            SELECT UNIQUE MAX(tlf13) INTO l_tlf13 FROM tlf_file
             WHERE tlf62 = l_sfb[l_ac].sfb01
                AND tlf13 !='asft700'   #MOD-4A0200 add
             IF STATUS OR l_tlf13 IS NULL THEN LET l_tlf13= 'N' END IF #MOD-480413
             LET l_cnt2 = 0     #No.MOD-580348
            CASE WHEN l_tlf13 MATCHES 'asfi5*'
                  #-----No.MOD-580348 增加判斷是否有報工
                      SELECT COUNT(*) INTO l_cnt2 FROM shb_file
                             WHERE shb05=l_sfb[l_ac].sfb01
                               AND shbconf = 'Y'    #FUN-A70095
                      IF STATUS OR l_cnt2 IS NULL OR l_cnt2=0 THEN
                         LET l_sfb04 = '4'
                      ELSE
                         LET l_sfb04 = '5'
                      END IF
                  #-----end
                  #MOD-CA0012---add---S
                      LET l_cnt4 = 0
                      SELECT COUNT(*) INTO l_cnt4 FROM qcf_file
                       WHERE qcf02 = l_sfb[l_ac].sfb01
                         AND qcf01 IS NOT NULL
                         AND qcf14 = 'Y'
                      IF l_cnt4 > 0 THEN
                         LET l_sfb04 = '6'
                      END IF
                  #MOD-CA0012---add---E
 
                 WHEN l_tlf13 MATCHES 'asft6*'
                      LET l_sfb04 = '7'
                 OTHERWISE
                  #-----No.MOD-580348 增加判斷是否有報工
                      SELECT COUNT(*) INTO l_cnt2 FROM shb_file
                             WHERE shb05=l_sfb[l_ac].sfb01
                               AND shbconf = 'Y'              #FUN-A70095
                      IF STATUS OR l_cnt2 IS NULL OR l_cnt2=0 THEN
                        #---------No.MOD-820034 modify
                        #LET l_sfb04 = '1'
                        #LET l_sfb04 = '2'        #No.MOD-940163 mark
                        #--------------No.MOD-940163 add
                         SELECT sfb87 INTO l_sfb87 FROM sfb_file
                                WHERE sfb01=l_sfb[l_ac].sfb01
                         IF cl_null(l_sfb87) OR l_sfb87 = 'N' THEN
                            LET l_sfb04 = '1'
                         ELSE
                            LET l_sfb04 = '2'
                         END IF
                        #--------------No.MOD-940163 end
                        #---------No.MOD-820034 end
                      ELSE
                         LET l_sfb04 = '5'
                      END IF
                  #-----end
 
            END CASE
   ##-------------------
            #   SELECT sfb87 INTO l_sfb87 FROM sfb_file
            #    WHERE sfb01 = l_sfb[l_ac].sfb01
            IF l_sfb[l_ac].sfb28='1' THEN
              #------------No.MOD-690123 modify
              #UPDATE sfb_file SET sfb04 =l_sfb04,sfb28=''
               UPDATE sfb_file SET sfb04 =l_sfb04,
                                   sfb28 ='',
                                   sfb36 =''
                                   ,sfbdate = g_today #darcy:2024/05/09 add
              #------------No.MOD-690123 end
                WHERE sfb01 = l_sfb[l_ac].sfb01
              #IF SQLCA.sqlcode THEN                       #MOD-650022-mark
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN #MOD-650022
#                 CALL cl_err('update:',SQLCA.sqlcode,0)   #No.FUN-660128
#                 CALL cl_err3("upd","sfb_file",l_sfb[l_ac].sfb01,"",SQLCA.sqlcode,"","update:",0)    #No.FUN-660128 #NO.FUN-710026
                  CALL s_errmsg('sfb01',l_sfb[l_ac].sfb01,'update:',SQLCA.sqlcode,0)                  #NO.FUN_710026
                  LET g_success ='N'
#                 EXIT FOR                                                                            #NO.FUN-710026 
                  CONTINUE FOR                                                                        #NO.FUN-710026
               END IF
               #CHI-A50015 add --start--
               LET g_msg=TIME
               INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
                    VALUES ('asfp410',g_user,g_today,g_msg,l_sfb[l_ac].sfb01,'UPDATE sfb_file')
               #CHI-A50015 add --end--
            ELSE
               IF l_sta[l_ac].sta ='0' THEN
                 #------------No.MOD-690123 modify
                 #UPDATE sfb_file SET sfb04 =l_sfb04,sfb28=''
                  UPDATE sfb_file SET sfb04 =l_sfb04,
                                      sfb28 ='',
                                      sfb37 =''
                                      ,sfbdate = g_today #darcy:2024/05/09 add
                 #------------No.MOD-690123 end
                   WHERE sfb01 = l_sfb[l_ac].sfb01
                 #IF SQLCA.sqlcode THEN                       #MOD-650022-mark
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN #MOD-650022
#                    CALL cl_err('update:',SQLCA.sqlcode,0)   #No.FUN-660128
#                    CALL cl_err3("upd","sfb_file",l_sfb[l_ac].sfb01,"",SQLCA.sqlcode,"","update:",0)    #No.FUN-660128 #NO.FUN-710026
                     CALL s_errmsg('sfb01',l_sfb[l_ac].sfb01,'update:',SQLCA.sqlcode,0)                #NO.FUN-710026
                     LET g_success ='N'
                     EXIT FOR 
                  END IF
                  #CHI-A50015 add --start--
                  LET g_msg=TIME
                  INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
                       VALUES ('asfp410',g_user,g_today,g_msg,l_sfb[l_ac].sfb01,'UPDATE sfb_file')
                  #CHI-A50015 add --end--
                ELSE
                 #MOD-5C0019-begin
                 #UPDATE sfb_file SET sfb04 = l_sfb04,sfb28='1'
                 #------------No.MOD-690123 modify
                 #UPDATE sfb_file SET sfb28='1'
                  UPDATE sfb_file SET sfb28='1',
                                      sfb37=''
                                      ,sfbdate = g_today #darcy:2024/05/09 add
                 #------------No.MOD-690123 end
                 #MOD-5C0019-end
                   WHERE sfb01 = l_sfb[l_ac].sfb01
                 #IF SQLCA.sqlcode THEN                       #MOD-650022-mark
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN #MOD-650022
#                    CALL cl_err('update:',SQLCA.sqlcode,0)   #No.FUN-660128
#                    CALL cl_err3("upd","sfb_file",l_sfb[l_ac].sfb01,"",SQLCA.sqlcode,"","update:",0)    #No.FUN-660128 #NO.FUN-710026
                     CALL s_errmsg('sfb01',l_sfb[l_ac].sfb01,'update:',SQLCA.sqlcode,0)                #NO.FUN-710026  
                     LET g_success ='N'
                     EXIT FOR 
                  END IF
                  #CHI-A50015 add --start--
                  LET g_msg=TIME
                  INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
                       VALUES ('asfp410',g_user,g_today,g_msg,l_sfb[l_ac].sfb01,'UPDATE sfb_file')
                  #CHI-A50015 add --end--
                END IF
             END IF
            #FUN-C10065 add str---
             SELECT sfb02 INTO l_sfb02
               FROM sfb_file
              WHERE sfb01 = l_sfb[l_ac].sfb01
             IF l_sfb02 = '1' OR l_sfb02 = '5' OR l_sfb02 = '13' THEN     #FUN-CC0122 add l_sfb02 = '5'
            #FUN-C10065 add end---
                LET l_sfbstr = l_sfbstr CLIPPED,l_sfb[l_ac].sfb01 CLIPPED, ','     #FUN-9A0095 add
             END IF  #FUN-C10065 add
         #MOD-630039 委外採購單還原時,若該採購單為未確認->還原單身為'0'開立
         #MOD-630039 委外採購單還原時,若該採購單為確認->還原單身為'1'開立,單頭一併還原同單身
         #MOD-550029 恢復委外結案工單重新開啟時將相關的委外採購單同時開啟的功能
         #MOD-550029 恢復委外結案工單重新開啟時將相關的委外採購單同時開啟的功能
         #NO:6961養生工單還原,相對應採購單不一併結案還原
         #No.B332 010510 add by linda 委外採購還原
         #MOD-630039-begin
             #IF l_sfb[l_ac].sfb02 MATCHES '[78]' THEN     #No.MOD-670061 add   #No.MOD-860292 mark
                 DECLARE pmm_cus CURSOR FOR
                    SELECT pmn01,pmn02 
                      FROM pmn_file
                     WHERE pmn41 =  l_sfb[l_ac].sfb01
                        AND pmn011='SUB'
                 FOREACH pmm_cus INTO l_pmn01,l_pmn02 
                    IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
                    #UPDATE pmn_file SET pmn16 = '2', pmn57 = 0 
                    #  WHERE pmn01=l_pmn01
                    #    AND pmn02=l_pmn02
                    #IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                    #   CALL cl_err('Update pmn16 fail:',SQLCA.sqlcode,1)
                    #   LET g_success = 'N'
                    #END IF
                    #LET l_pmm=0
                    #SELECT COUNT(*) INTO l_pmm FROM pmn_file 
                    # WHERE pmn01 = l_pmn01 AND pmn16 IN ('6','7','8')
                    #IF l_pmm IS NULL THEN LET l_pmm = 0 END IF
                    #IF l_pmm = 0  THEN
                    #   UPDATE pmm_file SET pmm25 = '2'
                    #    WHERE pmm01 = l_pmn01
                    #   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                    #      CALL cl_err('Update pmm25 fail:',SQLCA.sqlcode,1)
                    #      LET g_success = 'N'
                    #   END IF
                    #END IF
                    ##MOD-5C0055...............begin
                    #LET l_pmm=0
                    #SELECT COUNT(*) INTO l_pmm FROM pmm_file 
                    #  WHERE pmm01 = l_pmn01 AND pmm02='SUB'
                    #    AND pmm18='N'
                    #IF l_pmm>0 THEN
                    #  UPDATE pmm_file SET pmm25='0' WHERE pmm01=l_pmn01
                    #  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                    #    CALL cl_err('Update pmm25 fail:',SQLCA.sqlcode,1)
                    #    LET g_success = 'N'
                    #  END IF
                    #END IF 
                    ##MOD-5C0055...............end
         #MOD-550029 end
                    LET l_pmm18= ' '
                    LET l_pmm25= ' '
                    SELECT pmm18,pmm25 INTO l_pmm18,l_pmm25 
                      FROM pmm_file 
                     WHERE pmm01 = l_pmn01 AND pmm02='SUB'
                    CASE
                       WHEN l_pmm18='Y'
                            #-----MOD-730003--------- 
                            #LET l_pmm25 = '1'
                            LET l_cnt3 = 0 
                            SELECT COUNT(*) INTO l_cnt3 FROM rvb_file 
                              WHERE rvb04 = l_pmn01
                            IF l_cnt3 > 0 THEN
                               LET l_pmm25 = '2'
                            ELSE
                               LET l_pmm25 = '1'
                            END IF 
                            #-----END MOD-730003-----
                       WHEN l_pmm18='N'
                            LET l_pmm25 = '0'
                    END CASE
                     UPDATE pmm_file SET pmm25=l_pmm25 WHERE pmm01=l_pmn01
                     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#                      CALL cl_err('Update pmm25 fail:',SQLCA.sqlcode,1)   #No.FUN-660128
#                      CALL cl_err3("upd","pmm_file",l_pmn01,"",SQLCA.sqlcode,"","Update pmm25 fail:",1)    #No.FUN-660128 #NO.FUN-710026
                       CALL s_errmsg('pmm01',l_pmn01,'Update pmm25 fail:',SQLCA.sqlcode,1)                #NO.FUN-710026   
                       LET g_success = 'N'
                     END IF
                     #CHI-A50015 add --start--
                     LET g_msg=TIME
                     INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
                          VALUES ('asfp410',g_user,g_today,g_msg,l_pmn01,'UPDATE pmm_file')
                     #CHI-A50015 add --end--
                     UPDATE pmn_file SET pmn16 = l_pmm25 , pmn57 = 0 
                      WHERE pmn01=l_pmn01
                        AND pmn02=l_pmn02
                     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#                       CALL cl_err('Update pmn16 fail:',SQLCA.sqlcode,1)   #No.FUN-660128
#                       CALL cl_err3("upd","pmn_file",l_pmn01,l_pmn02,SQLCA.sqlcode,"","Update pmn16 fail:",1)    #No.FUN-660128 #NO.FUN-710026
                        LET g_showmsg=l_pmn01,"/",l_pmn02                                                         #NO.FUN-710026
                        CALL s_errmsg('pmn01,pmn02',g_showmsg,'Update pmn16 fail:',SQLCA.sqlcode,1)               #NO.FUN-710026 
                        LET g_success = 'N'
                     END IF
                     #CHI-A50015 add --start--
                     SELECT ze03 INTO l_msg1 FROM ze_file
                        WHERE ze01 = 'aap-417' AND ze02 = g_lang
                     LET l_msg = "UPDATE pmn_file,",l_msg1,":",l_pmn02 CLIPPED
                     LET g_msg=TIME
                     INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
                          VALUES ('asfp410',g_user,g_today,g_msg,l_pmn01,l_msg)
                     #CHI-A50015 add --end--
                END FOREACH
             #END IF               #No.MOD-670061 add    #No.MOD-860292 mark
                #No.B332 end---
                #NO:6961====================================================
         #MOD-630039-end
            END IF
        END FOR
#NO.FUN-710026----begin 
        IF g_totsuccess="N" THEN                                                                                                         
           LET g_success="N"                                                                                                             
        END IF 
#NO.FUN-710026----end  
       #FUN-9A0095 add MES ----
        IF g_success ='Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
           IF NOT cl_null(l_sfbstr) THEN  #FUN-C10065
              IF l_sfb02 = '1' OR l_sfb02 = '5' OR l_sfb02 = '13' THEN  #FUN-CC0122 add
                 CALL p410_mes(l_sfbstr)
              END IF                           #FUN-CC0122 add
           END IF  #FUN-C10065
        END IF
       #FUN-9A0095 add end-----
         CALL s_showmsg()           #NO.FUN-710026
         IF g_success='Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
        EXIT WHILE
    END WHILE
    CLOSE WINDOW p410_w
END FUNCTION

#FUN-9A0095 -- add p410_mes() for MES
FUNCTION p410_mes(p_key1)
  DEFINE p_key1   STRING
  DEFINE l_mesg01 VARCHAR(30)

  #CALL aws_mescli
  # 傳入參數: (1)程式代號
  #           (2)功能選項：insert(新增),update(修改),delete(刪除)
  #           (3)Key
  CASE aws_mescli('asfp410','insert',p_key1)
    WHEN 1  #呼叫 MES 成功
         MESSAGE "UNDO CLOSE O.K, UNDO CLOSE MES O.K"
         LET g_success = 'Y'
    WHEN 2  #呼叫 MES 失敗
         LET g_success = 'N'
    OTHERWISE  #其他異常
         LET g_success = 'N'
  END CASE

END FUNCTION
#FUN-9A0095 -- add end-------------
