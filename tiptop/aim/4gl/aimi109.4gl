# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimi109.4gl
# Descriptions...: 料件資料 FM
# Date & Author..: 94/11/21 By Roger
# Modify.........: No:7643 03/08/25 By Mandy 新增 aimi100料號時應default ima30=料件建立日期,以便循環盤點機制
# Modify.........: No:7703 03/08/25 By Mandy 應該增加 imz24 檢驗否 之欄位於主分群碼中
# Modify.........: No:8380 03/09/30 By Mandy 245 行應改成 LET g_ima[l_ac].ima08='Z'
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-4A0246 04/10/15 By Melody prompt出來的視窗只能按Y/N,不能按確定或放棄
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-510017 05/01/17 By Mandy 報表轉XML
# Modify.........: No:BUG-530301 05/03/25 By kim MOD-530348 查詢出來後，現有的料號(Key值)不可修改
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-550077 05/06/20 By alex 增加多語言轉換功能
# Modify.........: No.FUN-560119 05/06/20 By saki 料件編號長度限制
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.MOD-560129 05/06/20 By kim 料號已有庫存異動,庫存單位不可修改
# Modify.........: No.MOD-5A0412 05/11/01 By Sarah 將i109_b()的AFTER FIELD ima01的FUN-530065段取消
# Modify.........: No.FUN-570012 05/11/03 By Pengu 1.將單身"新增"和"刪除"功能Disabled掉
# Modify.........: No.TQC-5B0059 05/11/08 By Sarah 修改列印表尾時,(接下頁),(結束)的位置
# Modify.........: No.MOD-610088 06/01/19 By pengu ring menu[預設上筆]action拿掉
# Modify.........: No.TQC-650066 06/05/16 By Claire ima79 mark
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: NO.FUN-670070 06/07/19 By Joe 新增ima1010,imaacti兩欄位 
# Modify.........: No.FUN-690026 06/09/13 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690059 06/09/14 By Mandy 當參數設定使用料件申請作業時,修改時不可更改料號/品名/規格
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time改為g_time
# Modify.........: No.TQC-6C0060 07/01/08 By alexstar 多語言功能單純化
# Modify.........: No.CHI-6B0050 07/01/18 By rainy 當沒做QBE查詢時(g_wc=null)，不應可以列印資料
# Modify.........: No.TQC-740144 07/04/20 By dxfwo  執行程序，單身未立即顯示資料，要查詢才能顯示    
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
# Modify.........: No.FUN-780040 07/08/31 By zhoufeng 報表打印改為p_query
# Modify.........: No.MOD-780061 07/10/17 By pengu INSERT ima_file時ima911欄位未default值
# Modify.........: NO.MOD-7A0192 07/10/30 BY yiting 按action "建立料件單位轉換"  應該帶料號至開啟視窗中
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-830009 08/03/20 By Pengu 取消畫面"資料有效碼"欄位的查詢功能
# Modify.........: No.FUN-830132 08/03/28 By hellen 將imaicd_file變成icd專用
# Modify.........: No.FUN-840194 08/06/25 By sherry 增加變動前置時間批量（ima061）
# Modify.........: NO.FUN-860036 08/07/07 by kim  MDM整合 for GP5.1
# Modify.........: No.MOD-860149 08/07/16 By Pengu 調整MOD-560129修改地方
# Modify.........: No.FUN-870166 08/09/02 By kevin MDM整合call aws_mdmdata
# Modify.........: No.MOD-890201 08/09/22 By claire 修改資料應回寫修改者及修改日
# Modify.........: No.MOD-920082 09/02/05 By claire 修改分群碼,詢問是否要更新,選否仍更新資料
# Modify.........: No.FUN-970063 09/07/20 By mike 在修改段(寫在on row CHANGE段)新增記錄azo_file，                                   
# Modify.........: No.FUN-980004 09/08/06 By TSD.Ken GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0099 09/11/18 By douzh 给ima926设定默认值,避免栏位为NULL情况出现
# Modify.........: No.FUN-9C0072 10/01/14 By vealxu 精簡程式碼
# Modify.........: No.FUN-A20044 10/03/22 By vealxu ima26x 調整
# Modify.........: No:MOD-A50067 10/05/12 By Sarah 變更主分群碼時,若該料件已被使用.就不依主分群碼更新庫存單位
# Modify.........: No:FUN-A80150 10/09/20 By sabrina 在insert into ima_file之前，當ima156/ima158為null時要給"N"值
# Modify.........: No.FUN-AA0014 10/10/06 By Nicola 預設ima927
# Modify.........: No.FUN-A90049 10/10/20 By vealxu imaa_file加一料件性質判斷為企業料號或商戶料號 
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  开窗查询只查询出企业料号
# Modify.........: No:TQC-AB0026 10/11/04 By Carrier aimi108放在bp中进行执行
# Modify.........: No:FUN-AB0025 10/11/10 By lixh1  開窗BUG處理	
# Modify.........: No:FUN-AB0059 10/11/15 By lixh1  開窗處理
# Modify.........: No.TQC-AB0038 10/12/09 By vealxu sybase err
# Modify.........: No.FUN-B80070 11/08/08 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.FUN-B90104 11/10/21 By huangrh GP5.3服飾版本開發
# Modify.........: No.FUN-B80032 11/10/31 By yangxf ima_file 更新揮寫rtepos
# Modify.........: No:FUN-C20065 12/02/10 By lixh1 在insert into ima_file之前，當ima159為null時要給'3'
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值
# Modify.........: No:CHI-C50068 12/11/06 By bart 新增ima721
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     m_ima	    RECORD LIKE ima_file.*,   
     g_ima          DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        ima01       LIKE ima_file.ima01,      #料件編號
        ima02       LIKE ima_file.ima02,      #品名
        ima021      LIKE ima_file.ima021,     #規格
        ima06       LIKE ima_file.ima06,      #分群碼
        ima08       LIKE ima_file.ima08,      #來源碼
        ima130      LIKE ima_file.ima130,     #產品銷售特性
        ima25       LIKE ima_file.ima25,      #庫存單位
        ima37       LIKE ima_file.ima37,      #補貨策略
        ima1010     LIKE ima_file.ima1010,    #狀態碼      ##NO.FUN-670070
        imaacti     LIKE ima_file.imaacti     #資料有效碼  ##NO.FUN-670070
                    END RECORD,
    g_ima_t         RECORD                    #程式變數 (舊值)
        ima01       LIKE ima_file.ima01,      #料件編號
        ima02       LIKE ima_file.ima02,      #品名
        ima021      LIKE ima_file.ima021,     #規格
        ima06       LIKE ima_file.ima06,      #分群碼
        ima08       LIKE ima_file.ima08,      #來源碼
        ima130      LIKE ima_file.ima130,     #產品銷售特性
        ima25       LIKE ima_file.ima25,      #庫存單位
        ima37       LIKE ima_file.ima37,      #補貨策略
        ima1010     LIKE ima_file.ima1010,    #狀態碼      ##NO.FUN-670070
        imaacti     LIKE ima_file.imaacti     #資料有效碼  ##NO.FUN-670070
                    END RECORD,
    g_wc            STRING,                 #TQC-630166
    g_sql           STRING,                 #TQC-630166
    g_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
    g_rec_b         LIKE type_file.num5,    #單身筆數  #No.FUN-690026 SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_choice     STRING                  #
DEFINE g_chr        LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(72)
DEFINE g_on_change_02  LIKE type_file.num5     #FUN-550077  #No.FUN-690026 SMALLINT
DEFINE g_on_change_021 LIKE type_file.num5     #FUN-550077  #No.FUN-690026 SMALLINT
DEFINE l_cmd        LIKE type_file.chr1000  #No.FUN-780040
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    LET p_row = 3 LET p_col =10
 
    OPEN WINDOW i109_w AT p_row,p_col WITH FORM "aim/42f/aimi109"
           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_wc = '1=1'           #No.TQC-740144
    CALL i109_b_fill(g_wc)     #No.TQC-740144
    CALL i109_menu()
    CLOSE WINDOW i109_w                    #結束畫面
 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i109_menu()
   WHILE TRUE
      CALL i109_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i109_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i109_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #No.TQC-AB0026  --Begin                                                
         WHEN "account_extra_description"                                       
            IF cl_chk_act_auth() THEN                                           
               IF l_ac > 0 THEN                                                 
                  LET g_msg = "aimi108 '",g_ima[l_ac].ima01,"'" CLIPPED         
                  CALL cl_cmdrun_wait(g_msg)                                    
               END IF                                                           
            END IF                                                              
         #No.TQC-AB0026  --End
         WHEN "output"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_wc) THEN 
                  LET g_wc=" 1=1" 
               END IF
               LET l_cmd='p_query "aimi109" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ima),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i109_q()
   CALL i109_b_askkey()
END FUNCTION
 
FUNCTION i109_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用  #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態    #No.FUN-690026 VARCHAR(1)
    l_misc          LIKE type_file.chr4,   #處理狀態  #No.FUN-690026 VARCHAR(4)
    l_allow_insert  LIKE type_file.chr1,   #可新增否  #No.FUN-690026 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1    #可刪除否  #No.FUN-690026 VARCHAR(1)
 
DEFINE lc_sma119    LIKE sma_file.sma119,      #No.FUN-560119
       li_len       LIKE type_file.num5        #No.FUN-690026 SMALLINT
DEFINE l_imaicd     RECORD LIKE imaicd_file.*  #No.FUN-7B0018
DEFINE l_ima151     LIKE ima_file.ima151       #No.FUN-B90104
DEFINE l_imaag      LIKE ima_file.imaag        #No.FUN-B90104
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE
 
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET g_forupd_sql = "SELECT * FROM ima_file WHERE ima01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i109_bcl CURSOR FROM g_forupd_sql  #LOCK CURSOR
 
   SELECT sma119 INTO lc_sma119 FROM sma_file
   CASE lc_sma119
      WHEN "0"
         LET li_len = 20
      WHEN "1"
         LET li_len = 30
      WHEN "2"
         LET li_len = 40
   END CASE
 
       INPUT ARRAY g_ima WITHOUT DEFAULTS FROM s_ima.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           CALL cl_chg_comp_att("ima01","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET g_on_change_02  =TRUE      #FUN-550077
            LET g_on_change_021 =TRUE      #FUN-550077
 
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_ima_t.* = g_ima[l_ac].*  #BACKUP #FUN-690059
               CALL i109_set_no_entry(p_cmd) #MOD-530301
               BEGIN WORK
               OPEN i109_bcl USING g_ima_t.ima01 #表示更改狀態
               IF STATUS THEN
                  CALL cl_err("OPEN i109_bcl:", STATUS, 1)
                  LET l_lock_sw = 'Y'
               ELSE
                  FETCH i109_bcl INTO m_ima.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ima_t.ima01,SQLCA.sqlcode,1)
                     LET l_lock_sw = 'Y'
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
             CALL i109_set_entry(p_cmd) #MOD-530301
            INITIALIZE g_ima[l_ac].* TO NULL      #900423
            INITIALIZE m_ima.* TO NULL            #900423
            CALL ima_default()
            LET g_ima_t.* = g_ima[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ima01
 
 
        AFTER FIELD ima01                        #check 編號是否重複
 
            IF g_ima[l_ac].ima01 != g_ima_t.ima01 OR
               (g_ima[l_ac].ima01 IS NOT NULL AND g_ima_t.ima01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM ima_file
                 WHERE ima01 = g_ima[l_ac].ima01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_ima[l_ac].ima01 = g_ima_t.ima01
                   NEXT FIELD ima01
                END IF
            END IF
            IF g_ima[l_ac].ima01[1,4]='MISC' THEN #NO:6808(養生)
               LET g_ima[l_ac].ima08='Z' #No:8380
            END IF
 
 
        ON CHANGE ima02   # FUN-550077
           IF g_aza.aza44 = "Y" THEN
              IF g_zx14 = "Y" AND g_on_change_02 THEN
                 CALL p_itemname_update("ima_file","ima02",g_ima[l_ac].ima01) #TQC-6C0060 
                 CALL cl_show_fld_cont()   #TQC-6C0060 
              END IF
           ELSE
              CALL cl_err(g_ima[l_ac].ima02,"lib-151",1)
           END IF
 
        ON CHANGE ima021  # FUN-550077
           IF g_aza.aza44 = "Y" THEN
              IF g_zx14 = "Y" AND g_on_change_021 THEN
                 CALL p_itemname_update("ima_file","ima021",g_ima[l_ac].ima01) #TQC-6C0060
                 CALL cl_show_fld_cont()   #TQC-6C0060 
              END IF
           ELSE
              CALL cl_err(g_ima[l_ac].ima021,"lib-151",1)
           END IF
 
        AFTER FIELD ima06
            IF g_ima[l_ac].ima06 IS NULL THEN NEXT FIELD ima06 END IF
            IF g_ima_t.ima06 IS NULL OR g_ima_t.ima06!=g_ima[l_ac].ima06 THEN
              #str MOD-A50067 add
              #檢查料號是否已經被使用,若已被使用,就不依主分群碼更新庫存單位
               LET g_errno=NULL
               CALL s_chkitmdel(g_ima[l_ac].ima01) RETURNING g_errno
               IF cl_null(g_errno) THEN
              #end MOD-A50067 add
                  CALL i109_ima06()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD ima06
                  END IF
               END IF   #MOD-A50067 add
            END IF
 
        AFTER FIELD ima08
            #NO:6068(養生)
            LET l_misc=g_ima[l_ac].ima01[1,4]
            IF l_misc='MISC' AND g_ima[l_ac].ima08 <>'Z' THEN
                CALL cl_err('','aim-805',0)
                NEXT FIELD ima08
            END IF
 
        AFTER FIELD ima130
            IF g_ima[l_ac].ima01[1,4]='MISC' THEN
               LET g_ima[l_ac].ima130='2'
               DISPLAY BY NAME g_ima[l_ac].ima130
            END IF
            IF g_ima[l_ac].ima130 NOT MATCHES '[0123]' THEN
               NEXT FIELD ima130
	    END IF
 
        AFTER FIELD ima25
            SELECT gfe01 FROM gfe_file
             WHERE gfe01=g_ima[l_ac].ima25 AND gfeacti IN ('Y','y')
            IF STATUS THEN 
               CALL cl_err3("sel","gfe_file",g_ima[l_ac].ima25,"",
                            "mfg1200","","",1)  #No.FUN-660156
               NEXT FIELD ima25 
            END IF
            IF m_ima.ima31 IS NULL THEN LET m_ima.ima31=g_ima[l_ac].ima25
                                        LET m_ima.ima31_fac = 1           END IF
            IF m_ima.ima44 IS NULL THEN LET m_ima.ima44=g_ima[l_ac].ima25
                                        LET m_ima.ima44_fac = 1           END IF
            IF m_ima.ima55 IS NULL THEN LET m_ima.ima55=g_ima[l_ac].ima25
                                        LET m_ima.ima55_fac = 1           END IF
            IF m_ima.ima63 IS NULL THEN LET m_ima.ima63=g_ima[l_ac].ima25
                                        LET m_ima.ima63_fac = 1           END IF
            LET m_ima.ima86=g_ima[l_ac].ima25 #FUN-560183
            LET m_ima.ima86_fac = 1           #FUN-560183
        AFTER FIELD ima37
            IF g_ima[l_ac].ima37 NOT MATCHES'[012345]' THEN NEXT FIELD ima37
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ima_t.ima01 IS NOT NULL THEN
                CALL i109_del() #check 後端資料只要有存在就不允許刪除
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ima_t.ima01,g_errno,1)
                   CANCEL DELETE
                END IF
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM ima_file WHERE ima01 = g_ima_t.ima01
                IF SQLCA.sqlcode THEN ROLLBACK WORK CANCEL DELETE END IF
                IF s_industry('icd') THEN           #No.FUN-830132 add
                   IF NOT s_del_imaicd(g_ima_t.ima01,'') THEN
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
                DELETE FROM imc_file WHERE imc01 = g_ima_t.ima01
                IF SQLCA.sqlcode THEN ROLLBACK WORK CANCEL DELETE END IF
 
                DELETE FROM ind_file WHERE ind01 = g_ima_t.ima01
                IF SQLCA.sqlcode THEN ROLLBACK WORK CANCEL DELETE END IF
 
                DELETE FROM imb_file WHERE imb01 = g_ima_t.ima01
                IF SQLCA.sqlcode THEN ROLLBACK WORK CANCEL DELETE END IF
 
                DELETE FROM aps_ima  WHERE pid   = g_ima_t.ima01
                IF SQLCA.sqlcode THEN ROLLBACK WORK CANCEL DELETE END IF
 
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
#FUN-B90104----add--begin---- 服飾行業，子料件不可更改
           IF s_industry('slk') THEN
              SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file WHERE ima01=g_ima_t.ima01
              IF l_ima151='N' AND l_imaag='@CHILD' THEN
                 CALL cl_err(g_ima_t.ima01,'axm_665',1)
                 LET INT_FLAG =TRUE
              END IF
           END IF
#FUN-B90104----add--end---

           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ima[l_ac].* = g_ima_t.*
              CLOSE i109_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
 
           IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ima[l_ac].ima01,-263,1)
               LET g_ima[l_ac].* = g_ima_t.*
           ELSE
               LET m_ima.ima01   = g_ima[l_ac].ima01
               LET m_ima.ima02   = g_ima[l_ac].ima02
               LET m_ima.ima021  = g_ima[l_ac].ima021
               LET m_ima.ima06   = g_ima[l_ac].ima06
               LET m_ima.ima08   = g_ima[l_ac].ima08
               LET m_ima.ima130  = g_ima[l_ac].ima130
               LET m_ima.ima25   = g_ima[l_ac].ima25
               LET m_ima.ima37   = g_ima[l_ac].ima37
               LET m_ima.imadate = g_today            #MOD-890201
               LET m_ima.imamodu = g_user             #MOD-890201
              #FUN-B80032---------STA-------
               IF g_ima_t.ima02 <> g_ima[l_ac].ima02 OR g_ima_t.ima021 <> g_ima[l_ac].ima021
               OR g_ima_t.ima25 <> g_ima[l_ac].ima25 THEN 
                  IF g_aza.aza88 = 'Y' THEN
                    UPDATE rte_file SET rtepos = '2' WHERE rte03 = g_ima_t.ima01 AND rtepos = '3'
                  END IF
               END IF
              #FUN-B80032---------END-------  
 
               UPDATE ima_file SET * = m_ima.*
                WHERE ima01=g_ima_t.ima01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","ima_file",g_ima_t.ima01,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660156
                  LET g_ima[l_ac].* = g_ima_t.*
                  ROLLBACK WORK
               ELSE
                  LET g_errno = TIME                                                                                                
                  LET g_msg = 'Chg No:',g_ima[l_ac].ima01                

                  #FUN-B80070 增加空行
                                                           
                  INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #No.FUN-980004                                                       
                     VALUES ('aimi109',g_user,g_today,g_errno,g_ima_t.ima01,g_msg,g_plant,g_legal)    #No.FUN-980004                                              
                  IF SQLCA.sqlcode THEN                                                                                             
                     CALL cl_err3("ins","azo_file","aimi109","",SQLCA.sqlcode,"","",1)                                              
                     ROLLBACK WORK                                                                                                  
                  END IF                                                                                                            
                  CASE aws_mdmdata('ima_file','update',g_ima[l_ac].ima01,base.TypeInfo.create(g_ima[l_ac]),'CreateItemMasterData') #FUN-870166
                     WHEN 0  #無與 MDM 整合
                          CALL cl_msg('Update O.K')
                     WHEN 1  #呼叫 MDM 成功
                          CALL cl_msg('Update O.K, Update MDM O.K')
                     WHEN 2  #呼叫 MDM 失敗
                          RETURN FALSE
                     OTHERWISE
                          MESSAGE 'UPDATE O.K'
                  END CASE
#FUN-B90104----add--begin---- 服飾行業，母料件更改后修改，更新子料件資料
                  IF s_industry('slk') THEN
                     IF l_ima151='Y' THEN
                        CALL i109_upslk_ima()
                        CLOSE i109_bcl
                        COMMIT WORK
                        CALL i109_b_fill(g_wc)
                        EXIT INPUT
                     END IF
                  END IF
#FUN-B90104----add--end---
                  COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ima[l_ac].* = g_ima_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_ima.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i109_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac
           CLOSE i109_bcl
           COMMIT WORK
 
        AFTER INSERT
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i109_bcl
               CANCEL INSERT
            END IF
            LET m_ima.ima01 = g_ima[l_ac].ima01
            LET m_ima.ima02 = g_ima[l_ac].ima02
            LET m_ima.ima021 = g_ima[l_ac].ima021
            LET m_ima.ima06 = g_ima[l_ac].ima06
            LET m_ima.ima08 = g_ima[l_ac].ima08
            LET m_ima.ima130 = g_ima[l_ac].ima130
            LET m_ima.ima25 = g_ima[l_ac].ima25
            LET m_ima.ima37 = g_ima[l_ac].ima37
            LET m_ima.ima911 = 'N'     #No.MOD-780061 add
            LET m_ima.ima918 = 'N'  #No.FUN-810036
            LET m_ima.ima921 = 'N'  #No.FUN-810036
            LET m_ima.ima925 = '1'  #No.FUN-810036
            LET m_ima.ima601 = 1    #No.FUN-840194
            LET m_ima.ima120 = '1'  #No.FUN-A90049 
 
            CALL i109_check()        #檢查若重要欄位為空白者,要設預設值
 
            LET m_ima.imaoriu = g_user      #No.FUN-980030 10/01/04
            LET m_ima.imaorig = g_grup      #No.FUN-980030 10/01/04
           #FUN-A80150---add---start---
            IF cl_null(m_ima.ima156) THEN 
               LET m_ima.ima156 = 'N'
            END IF
            IF cl_null(m_ima.ima158) THEN 
               LET m_ima.ima158 = 'N'
            END IF
           #FUN-A80150---add---end---
            LET m_ima.ima927='N'   #No:FUN-AA0014
           #FUN-C20065 ---------Begin----------   
            IF cl_null(m_ima.ima159) THEN
               LET m_ima.ima159 = '3'
            END IF  
           #FUN-C20065 ---------End------------
            IF cl_null(m_ima.ima928) THEN LET m_ima.ima928 = 'N' END IF      #TQC-C20131  add
            IF cl_null(m_ima.ima160) THEN LET m_ima.ima160 = 'N' END IF      #FUN-C50036  add
            INSERT INTO ima_file VALUES(m_ima.*)
            IF SQLCA.sqlcode THEN
               DISPLAY m_ima.ima01
               CALL cl_err3("ins","ima_file",g_ima[l_ac].ima01,"",
                             SQLCA.sqlcode,"","",1)  #No.FUN-660156
               CANCEL INSERT
            ELSE
               INITIALIZE l_imaicd.* TO NULL
               LET l_imaicd.imaicd00 = m_ima.ima01
               IF NOT s_industry('std') THEN
                  IF NOT s_ins_imaicd(l_imaicd.*,'') THEN
                     CANCEL INSERT
                  END IF
               END IF
               MESSAGE 'INSERT O.K'
               LET g_rec_b = g_rec_b + 1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ACTION enter_item_detail
           CLOSE i109_bcl
           LET g_msg='aimi100 ',g_ima[l_ac].ima01 CALL cl_cmdrun(g_msg)
 
        #No.TQC-AB0026  --Begin
        #ON ACTION account_extra_description
        #   LET g_msg = "aimi108 '",g_ima[l_ac].ima01,"'" CLIPPED
        #   CALL cl_cmdrun(g_msg)
        #No.TQC-AB0026  --End  
 
        ON ACTION create_item_grouping_code
           CALL cl_cmdrun("aimi110 ") #分群代碼
 
        ON ACTION create_unit
           CALL cl_cmdrun("aooi101") #單位主檔
 
        ON ACTION CONTROLP     #查詢條件
           CASE
              WHEN INFIELD(ima01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ima"
                    LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"  #FUN-AB0059
                    LET g_qryparam.default1 = g_ima[l_ac].ima01
                    CALL cl_create_qry() RETURNING g_ima[l_ac].ima01
                    DISPLAY BY NAME g_ima[l_ac].ima01
                    NEXT FIELD ima01
 
              WHEN INFIELD(ima06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imz"
                    LET g_qryparam.default1 = g_ima[l_ac].ima06
                    CALL cl_create_qry() RETURNING g_ima[l_ac].ima06
                     DISPLAY BY NAME g_ima[l_ac].ima06  #No.MOD-490371
                    NEXT FIELD ima06
 
              WHEN INFIELD(ima25) #單位主檔
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.default1 = g_ima[l_ac].ima25
                    CALL cl_create_qry() RETURNING g_ima[l_ac].ima25
                     DISPLAY BY NAME g_ima[l_ac].ima25   #No.MOD-490371
                    NEXT FIELD ima25
             END CASE
 
        ON ACTION create_item
           LET l_cmd = "aooi103 '",g_ima[l_ac].ima01,"'"
           CALL cl_cmdrun_wait(l_cmd)
 
        ON ACTION unit_conversion
           CALL cl_cmdrun("aooi102 ") #單位換算
 
 
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
 
        ON ACTION update_item
           IF g_aza.aza44 = "Y" THEN
              CASE
                 WHEN INFIELD(ima02)
                    CALL GET_FLDBUF(ima02) RETURNING g_ima[l_ac].ima02
                    CALL p_itemname_update("ima_file","ima02",g_ima[l_ac].ima01)  #TQC-6C0060
                    LET g_on_change_02=FALSE
                    CALL cl_show_fld_cont()   #TQC-6C0060 
                 WHEN INFIELD(ima021)
                    CALL GET_FLDBUF(ima021) RETURNING g_ima[l_ac].ima021
                    CALL p_itemname_update("ima_file","ima021",g_ima[l_ac].ima01) #TQC-6C0060 
                    LET g_on_change_021=FALSE
                    CALL cl_show_fld_cont()   #TQC-6C0060 
              END CASE
           END IF
 
        END INPUT
 
    CLOSE i109_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION ima_default()
    LET m_ima.ima07 = 'A'
    LET m_ima.ima08 = 'P'
    LET m_ima.ima108 = 'N'
    LET m_ima.ima14 = 'N'
    LET m_ima.ima15 = 'N'
    LET m_ima.ima16 = 99
    LET m_ima.ima18 = 0
    LET m_ima.ima09 =' '
    LET m_ima.ima10 =' '
    LET m_ima.ima11 =' '
    LET m_ima.ima12 =' '
    LET m_ima.ima23 = ' '
    LET m_ima.ima24 = 'N'
#    LET m_ima.ima26 = 0         #FUN-A20044
#    LET m_ima.ima261 = 0        #FUN-A20044
#    LET m_ima.ima262 = 0        #FUN-A20044
    LET m_ima.ima27 = 0
    LET m_ima.ima271 = 0
    LET m_ima.ima28 = 0
    LET m_ima.ima31_fac = 1
    LET m_ima.ima32 = 0
    LET m_ima.ima33 = 0
    LET m_ima.ima37 = '0'
    LET m_ima.ima38 = 0
    LET m_ima.ima40 = 0
    LET m_ima.ima41 = 0
    LET m_ima.ima42 = '0'
    LET m_ima.ima44_fac = 1
    LET m_ima.ima45 = 0
    LET m_ima.ima46 = 0
    LET m_ima.ima47 = 0
    LET m_ima.ima48 = 0
    LET m_ima.ima49 = 0
    LET m_ima.ima491 = 0
    LET m_ima.ima50 = 0
    LET m_ima.ima51 = 1
    LET m_ima.ima52 = 1
    LET m_ima.ima140= 'N'
    LET m_ima.ima53 = 0
    LET m_ima.ima531 = 0
    LET m_ima.ima55_fac = 1
    LET m_ima.ima56 = 1
    LET m_ima.ima561 = 1  #最少生產數量
    LET m_ima.ima562 = 0  #生產時損耗率
    LET m_ima.ima57 = 0
    LET m_ima.ima58 = 0
    LET m_ima.ima59 = 0
    LET m_ima.ima60 = 0
    LET m_ima.ima61 = 0
    LET m_ima.ima62 = 0
    LET m_ima.ima63_fac = 1
    LET m_ima.ima64 = 1
    LET m_ima.ima641 = 1   #最少發料數量
    LET m_ima.ima65 = 0
    LET m_ima.ima66 = 0
    LET m_ima.ima68 = 0
    LET m_ima.ima69 = 0
    LET m_ima.ima70 = 'N'
    LET m_ima.ima107= 'N'
    LET m_ima.ima147= 'N' #No:8750
    LET m_ima.ima71 = 0
    LET m_ima.ima72 = 0
    LET m_ima.ima721 = 0  #CHI-C50068
    LET m_ima.ima75 = ''
    LET m_ima.ima76 = ''
    LET m_ima.ima77 = 0
    LET m_ima.ima78 = 0
    LET m_ima.ima80 = 0
    LET m_ima.ima81 = 0
    LET m_ima.ima82 = 0
    LET m_ima.ima83 = 0
    LET m_ima.ima84 = 0
    LET m_ima.ima85 = 0
    LET m_ima.ima852= 'N'
    LET m_ima.ima853= 'N'
    LET m_ima.ima86_fac = 1 #FUN-560183
    LET m_ima.ima871 = 0
    LET m_ima.ima873 = 0
    LET m_ima.ima88 = 1
    LET m_ima.ima91 = 0
    LET m_ima.ima92 = 'N'
    LET m_ima.ima93 = "NNNNNNNN"
    LET m_ima.ima94 = ''
    LET m_ima.ima95 = 0
    LET m_ima.ima96 = 0
    LET m_ima.ima97 = 0
    LET m_ima.ima98 = 0
    LET m_ima.ima99 = 0
    LET m_ima.ima100 = 'N'
    LET m_ima.ima101 = '1'
    LET m_ima.ima102 = '1'
    LET m_ima.ima103 = '0'
    LET m_ima.ima104 =  0
    LET m_ima.ima105 = 'N'
    LET m_ima.ima110 = '1'
    LET m_ima.ima139 = 'N'
    LET m_ima.imaacti = 'Y'
    LET m_ima.imauser = g_user
    LET m_ima.imadate = g_today
    LET m_ima.imagrup = g_grup
    LET m_ima.ima901 = g_today
#產品資料
    LET m_ima.ima130 = '1'
    LET m_ima.ima121 = 0
    LET m_ima.ima122 = 0
    LET m_ima.ima123 = 0
    LET m_ima.ima124 = 0
    LET m_ima.ima125 = 0
    LET m_ima.ima126 = 0
    LET m_ima.ima127 = 0
    LET m_ima.ima128 = 0
    LET m_ima.ima129 = 0
    LET m_ima.ima141 = '0'
END FUNCTION
 
FUNCTION i109_del()
 DEFINE l_n LIKE type_file.num5    #No.FUN-690026 SMALLINT
 DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3,   #No.FUN-A20044
        l_unavl_stk      LIKE type_file.num15_3,   #No.FUN-A20044
        l_avl_stk        LIKE type_file.num15_3    #No.FUN-A20044
 
 LET g_errno = ' '
# IF m_ima.ima26  >0 THEN LET g_errno='mfg9161' RETURN END IF           #FUN-A20044 
# IF m_ima.ima261 >0 THEN LET g_errno='mfg9162' RETURN END IF           #FUN-A20044
# IF m_ima.ima262 >0 THEN LET g_errno='mfg9163' RETURN END IF           #FUN-A20044
#No.FUN-A20044 ---start---
  CALL s_getstock(g_ima_t.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
  IF l_avl_stk_mpsmrp > 0 THEN LET g_errno='mfg9161' RETURN END IF
  IF l_unavl_stk > 0 THEN LET g_errno='mfg9162' RETURN END IF
  IF l_avl_stk > 0 THEN LET g_errno='mfg9163' RETURN END IF
#No.FUN-A20044 ---end---
 #--->產品結構(bma_file,bmb_file)須有效BOM
 SELECT COUNT(*) INTO l_n FROM bma_file
  WHERE bma01 = g_ima[l_ac].ima01
 IF l_n > 0 THEN LET g_errno='mfg9191' RETURN END IF
 SELECT COUNT(*) INTO l_n FROM bmb_file
  WHERE bmb03 = g_ima[l_ac].ima01
    AND (bmb04<=g_today OR bmb04 IS NULL) #BugNo:6039
    AND (bmb05> g_today OR bmb05 IS NULL)
 IF l_n > 0 THEN LET g_errno='mfg9191' RETURN END IF
 #--->請購單 (pml_file)，必須尚未結案 -> 只要有存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM pml_file
  WHERE pml04 = g_ima[l_ac].ima01
 IF l_n > 0 THEN LET g_errno='mfg9194' RETURN END IF
 #--->採購單 (pmn_file)，必須尚未結案 -> 只要有存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM pmn_file
  WHERE pmn04 = g_ima[l_ac].ima01
 IF l_n > 0 THEN LET g_errno='mfg9192' RETURN END IF
 #--->工單料件 (sfa_file,sfb_file)，必須尚未結案 -> 只要有存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM sfa_file,sfb_file
  WHERE sfa01=sfb01 AND sfa03 = g_ima[l_ac].ima01
#   AND sfb04 != '8'
 IF l_n > 0 THEN LET g_errno='mfg9193' RETURN END IF
 SELECT COUNT(*) INTO l_n FROM sfb_file
  WHERE sfb05 = g_ima[l_ac].ima01
#   AND sfb04 != '8'
 IF l_n > 0 THEN LET g_errno='mfg9193' RETURN END IF
 #---> 訂單(oeb_file),只要存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM oeb_file
  WHERE oeb04 = g_ima[l_ac].ima01
 IF l_n > 0 THEN LET g_errno='mfg9195' RETURN END IF
 #---> 出貨單(ogb_file),只要存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM ogb_file
  WHERE ogb04 = g_ima[l_ac].ima01
 IF l_n > 0 THEN LET g_errno='mfg9196' RETURN END IF
 #---> 庫存異動單(inb_file),只要存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM inb_file
  WHERE inb04 = g_ima[l_ac].ima01
 IF l_n > 0 THEN LET g_errno='mfg9197' RETURN END IF
 #---> 調撥單(imn_file),只要存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM imn_file
  WHERE imn03 = g_ima[l_ac].ima01
 IF l_n > 0 THEN LET g_errno='mfg9198' RETURN END IF
END FUNCTION
 
FUNCTION i109_check()
   IF cl_null(m_ima.ima31) THEN
      LET m_ima.ima31    =g_ima[l_ac].ima25
      LET m_ima.ima31_fac=1
   END IF
   IF cl_null(m_ima.ima44) THEN
      LET m_ima.ima44    =g_ima[l_ac].ima25
      LET m_ima.ima44_fac=1
   END IF
   IF cl_null(m_ima.ima55) THEN
      LET m_ima.ima55    =g_ima[l_ac].ima25
      LET m_ima.ima55_fac=1
   END IF
   IF cl_null(m_ima.ima63) THEN
      LET m_ima.ima63    =g_ima[l_ac].ima25
      LET m_ima.ima63_fac=1
   END IF
   IF cl_null(m_ima.ima86) THEN
      LET m_ima.ima86    =g_ima[l_ac].ima25
      LET m_ima.ima86_fac=1
   END IF
   IF cl_null(m_ima.ima35) THEN LET m_ima.ima35=' ' END IF
   IF cl_null(m_ima.ima36) THEN LET m_ima.ima36=' ' END IF
   IF cl_null(m_ima.ima571) THEN LET m_ima.ima571 = g_ima[l_ac].ima01 END IF
   IF cl_null(m_ima.ima133) THEN LET m_ima.ima133 = g_ima[l_ac].ima01 END IF
   IF cl_null(m_ima.ima926) THEN LET m_ima.ima926='N' END IF   #FUN-9B0099
 
END FUNCTION
 
FUNCTION i109_ima06()
   DEFINE l_ans          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_msg          LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(57)
          l_imzacti      LIKE imz_file.imzacti
 
   LET g_errno = ' '
   LET l_ans=' '
   SELECT imzacti INTO l_imzacti FROM imz_file WHERE imz01=g_ima[l_ac].ima06
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3179'
        WHEN l_imzacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
   CALL cl_getmsg('mfg5033',g_lang) RETURNING l_msg
   CALL cl_confirm('mfg5033') RETURNING l_ans
 
   IF l_ans = 0  THEN RETURN END IF #MOD-920082
   SELECT * INTO m_ima.ima06,g_chr,m_ima.ima03,m_ima.ima04,
                 m_ima.ima07,m_ima.ima08,m_ima.ima09,m_ima.ima10,
                 m_ima.ima11,m_ima.ima12,m_ima.ima14,m_ima.ima15,
                 m_ima.ima17,m_ima.ima19,m_ima.ima21,
                 m_ima.ima23,m_ima.ima24,m_ima.ima25,m_ima.ima27, #No:7703 add ima24
                 m_ima.ima28,m_ima.ima31,m_ima.ima31_fac,m_ima.ima34,
                 m_ima.ima35,m_ima.ima36,m_ima.ima37,m_ima.ima38,
                 m_ima.ima39,m_ima.ima42,m_ima.ima43,m_ima.ima44,
                 m_ima.ima44_fac,m_ima.ima45,m_ima.ima46,m_ima.ima47,
                 m_ima.ima48,m_ima.ima49,m_ima.ima491,m_ima.ima50,
                 m_ima.ima51,m_ima.ima52,m_ima.ima54,m_ima.ima55,
                 m_ima.ima55_fac,m_ima.ima56,m_ima.ima561,m_ima.ima562,
                 m_ima.ima571,
                 m_ima.ima59, m_ima.ima60,m_ima.ima61,m_ima.ima62,
                 m_ima.ima63, m_ima.ima63_fac,m_ima.ima64,m_ima.ima641,
                 m_ima.ima65, m_ima.ima66,m_ima.ima67,m_ima.ima68,
                 m_ima.ima69, m_ima.ima70,m_ima.ima71,m_ima.ima86,
                 m_ima.ima86_fac, m_ima.ima87,m_ima.ima871,m_ima.ima872,
                 m_ima.ima873, m_ima.ima874,m_ima.ima88,m_ima.ima89,
                 m_ima.ima90, g_chr,g_chr,g_chr,g_chr,g_chr
            FROM imz_file
           WHERE imz01 = g_ima[l_ac].ima06
   LET g_ima[l_ac].ima08 = m_ima.ima08
   LET g_ima[l_ac].ima130 = m_ima.ima130
   LET g_ima[l_ac].ima25 = m_ima.ima25
   LET g_ima[l_ac].ima37 = m_ima.ima37
   IF g_ima[l_ac].ima01[1,4]='MISC' THEN #NO:6808(養生)
      LET g_ima[l_ac].ima08='Z'
   END IF
   DISPLAY BY NAME g_ima[l_ac].ima08
   DISPLAY BY NAME g_ima[l_ac].ima130
   DISPLAY BY NAME g_ima[l_ac].ima25
   DISPLAY BY NAME g_ima[l_ac].ima37
END FUNCTION
 
FUNCTION i109_b_askkey()
    CLEAR FORM
   CALL g_ima.clear()
    CALL cl_opmsg('q')
    CONSTRUCT g_wc ON ima01,ima02,ima021,ima06,ima08,ima130,ima25,ima37,ima1010                 #FUN-690059 add ima1010,imaacti   #No.MOD-830009 del imaacti
            FROM s_ima[1].ima01,s_ima[1].ima02,s_ima[1].ima021,s_ima[1].ima06,
                 s_ima[1].ima08,s_ima[1].ima130,s_ima[1].ima25,s_ima[1].ima37,s_ima[1].ima1010  #FUN-690059    #No.MOD-830009 del imaacti
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        ON ACTION CONTROLP     #查詢條件
            CASE
               WHEN INFIELD(ima01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)" #FUN-AA0059 
                 LET g_qryparam.default1 = g_ima[1].ima01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima01
                 NEXT FIELD ima01
 
               WHEN INFIELD(ima06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imz"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima06
                    NEXT FIELD ima06
               WHEN INFIELD(ima25) #單位主檔
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY  g_qryparam.multiret TO ima25
                    NEXT FIELD ima25
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 LET g_wc = NULL RETURN END IF  #CHI-6B0050
    CALL i109_b_fill(g_wc)
END FUNCTION
 
FUNCTION i109_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING                 #TQC-630166
 
    LET g_sql =
        "SELECT ima01,ima02,ima021,ima06,ima08,ima130,ima25,ima37,ima1010,imaacti",  ##NO.FUN-670070
        " FROM ima_file",
        " WHERE ", p_wc2 CLIPPED," AND imaacti='Y'",
        " AND (ima120 = '1' OR ima120 =  ' ' OR ima120 IS NULL ) ",     #FUN-AB0025 
        " ORDER BY 1"
 
    PREPARE i109_pb FROM g_sql
    DECLARE ima_curs CURSOR FOR i109_pb
 
    CALL g_ima.clear()   #單身 ARRAY 乾洗
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH ima_curs INTO g_ima[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ima.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i109_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ima TO s_ima.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      #No.TQC-AB0026  --Begin                                                   
      ON ACTION account_extra_description                                       
         LET g_action_choice="account_extra_description"                        
         EXIT DISPLAY                                                           
      #No.TQC-AB0026  --End 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
    # &include "qry_string.4gl"      #TQC-AB0038 mark
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i109_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a'  THEN
      CALL cl_set_comp_entry("ima01",TRUE)
   END IF
   CALL cl_set_comp_entry("imaa02,imaa021",TRUE) #FUN-690059
 
END FUNCTION
 
FUNCTION i109_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE   l_errno   STRING #MOD-560129
 
   IF p_cmd = 'u'  THEN
      CALL cl_set_comp_entry("ima01",FALSE)
   END IF
 
   CALL s_chkitmdel(g_ima[l_ac].ima01) RETURNING l_errno
   CALL cl_set_comp_entry("ima25",cl_null(l_errno))
   #當參數設定使用料件申請作業時,修改時不可更改料號/品名/規格
   IF g_aza.aza60='Y' THEN
       CALL cl_set_comp_entry("ima01,ima02,ima021",FALSE)
   END IF
END FUNCTION
#No.FUN-9C0072 精簡程式碼

#FUN-B90104----add--begin---- 服飾行業，母料件更改后修改，更新子料件資料
FUNCTION i109_upslk_ima()

    UPDATE ima_file SET 
                 ima06 =m_ima.ima06,       ima03=m_ima.ima03,        ima04=m_ima.ima04,
                 ima07 =m_ima.ima07,       ima08=m_ima.ima08,        ima09=m_ima.ima09,
                 ima10 =m_ima.ima10,       ima11=m_ima.ima11,        ima12=m_ima.ima12,
                 ima14 =m_ima.ima14,       ima15=m_ima.ima15,        ima17=m_ima.ima17,
                 ima19 =m_ima.ima19,       ima21=m_ima.ima21,        ima23=m_ima.ima23,
                 ima24 =m_ima.ima24,       ima25=m_ima.ima25,        ima27=m_ima.ima27,
                 ima28 =m_ima.ima28,       ima31=m_ima.ima31,        ima31_fac=m_ima.ima31_fac,
                 ima34 =m_ima.ima34,       ima35=m_ima.ima35,        ima36=m_ima.ima36,
                 ima37 =m_ima.ima37,       ima38=m_ima.ima38,        ima39=m_ima.ima39,
                 ima42 =m_ima.ima42,       ima43=m_ima.ima43,        ima44=m_ima.ima44,
                 ima44_fac=m_ima.ima44_fac,ima45=m_ima.ima45,        ima46=m_ima.ima46,
                 ima47=m_ima.ima47,        ima48=m_ima.ima48,        ima49=m_ima.ima49,
                 ima491=m_ima.ima491,      ima50=m_ima.ima50,        ima51=m_ima.ima51,
                 ima52=m_ima.ima52,        ima54=m_ima.ima54,        ima55=m_ima.ima55,
                 ima55_fac=m_ima.ima55_fac,ima56=m_ima.ima56,        ima561=m_ima.ima561,
                 ima562=m_ima.ima562,      ima571=m_ima.ima571,      ima59=m_ima.ima59,
                 ima60=m_ima.ima60,        ima61=m_ima.ima61,        ima62=m_ima.ima62,
                 ima63=m_ima.ima63,        ima63_fac=m_ima.ima63_fac,ima64=m_ima.ima64,
                 ima641=m_ima.ima641,      ima65=m_ima.ima65,        ima66=m_ima.ima66,
                 ima67=m_ima.ima67,        ima68=m_ima.ima68,        ima69=m_ima.ima69,
                 ima70=m_ima.ima70,        ima71=m_ima.ima71,        ima86=m_ima.ima86,
                 ima86_fac=m_ima.ima86_fac,ima87=m_ima.ima87,        ima871=m_ima.ima871,
                 ima872=m_ima.ima872,      ima873=m_ima.ima873,      ima874=m_ima.ima874,
                 ima88=m_ima.ima88,        ima89=m_ima.ima89,        ima90=m_ima.ima90, 
                 ima130=m_ima.ima130,
                 imadate=g_today,
                 imamodu = g_user
      WHERE ima01 IN (SELECT imx000 FROM imx_file WHERE imx00=g_ima_t.ima01)

    IF SQLCA.sqlcode THEN
       CALL cl_err3("up","ima_file","","",SQLCA.sqlcode,"","",1)
    END IF

END FUNCTION
#FUN-B90104----add--end---
