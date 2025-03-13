# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asft701.4gl
# Descriptions...: 下線入庫維護作業
# Date & Author..: 99/06/11 By Carol
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.MOD-530437 05/03/28 By pengu   單身輸入完後，按「確定」後，「確定」、「放棄」的按鈕即不應再顯示。
# Modify.........: No.FUN-570110 05/07/15 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-580029 05/08/15 By elva 新增雙單位內容
# Modify.........: No.MOD-590120 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No.TQC-5C0035 05/12/07 By Carrier set_required時去除單位換算率
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-660109 06/06/15 By Sarah 畫面增加顯示入庫日期(shb03)
# Modify.........: No.FUN-660085 06/07/03 By Joe 若單身倉庫欄位已有值，則倉庫開窗查詢時，重新查詢時不會顯示該料號所有的倉儲。
# Modify.........: No.FUN-670103 06/08/01 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-740118 07/04/17 By kim 修改單身時,"查詢倉庫"鈕沒資料
# Modify.........: No.CHI-770019 07/07/25 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.TQC-930155 09/04/14 By Zhangyajun Lock imgg_file 失敗，不能直接Rollback
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0091 10/10/28 By zhangll 控制只能查询和选择属于该营运中心的仓库
# Modify.........: No.TQC-B10221 11/01/21 By jan 程式不能r.c2 
# Modify.........: No:MOD-B30235 11/03/11 By sabrina tlf12轉換率有誤
# Modify.........: No:TQC-BB0043 11/11/04 By lixh1 以確認的報工單要只能查詢不能修改
# Modify.........: No:FUN-BB0084 11/12/19 By lixh1 增加數量欄位小數取位
# Modify.........: No:TQC-C20031 12/02/07 By zhangll 批序号检查
# Modify.........: No:CHI-BA0039 12/03/13 By ck2yuan 料號不可輸入MISC 
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No:CHI-A30032 12/06/15 By Elise 增加批序號功能
# Modify.........: No:CHI-C60008 12/08/15 By ck2yuan 將update img,ima,tlf部分移至確認與取消確認段
# Modify.........: No:TQC-C80176 12/08/31 By chenjing 當sma95=’N’時隱藏批序號處理以及點進單身時的批序號處理
# Modify.........: No.FUN-CB0087 12/12/14 By fengrui 倉庫單據理由碼改善
# Modify.........: No.TQC-D10074 13/01/19 By fengrui 倉庫單據理由碼改善問題修正
# Modify.........: No.FUN-D20060 13/02/22 By yangtt 設限倉庫/儲位控卡
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40092 13/04/25 By lixiang 當站入庫功能只維護資料,不做庫存異動
# Modify.........: No:MOD-D60236 13/06/28 By suncx 控卡當站下線數量與asft700一致

DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_yy,g_mm       LIKE type_file.num5,          #No.FUN-680121 SMALLINT#
    g_shb           RECORD LIKE shb_file.*,
    b_shd           RECORD LIKE shd_file.*,
    g_ima86         LIKE ima_file.ima86,
    g_img09         LIKE img_file.img09,
    g_img22         LIKE img_file.img22,
    g_imd10         LIKE imd_file.imd10,
    g_ime04         LIKE ime_file.ime04,
    g_img10         LIKE img_file.img10,
    g_ima918        LIKE ima_file.ima918,    #CHI-C30118 add
    g_ima921        LIKE ima_file.ima921,    #CHI-C30118 add
    g_shd           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                    shd02     LIKE shd_file.shd02,
                    shb03     LIKE shb_file.shb03,   #FUN-660109 add
                    shd06     LIKE shd_file.shd06,
                    shd03     LIKE shd_file.shd03,
                    shd04     LIKE shd_file.shd04,
                    shd05     LIKE shd_file.shd05,
                    shd16     LIKE shd_file.shd16,   #FUN-BB0084 
                    shd07     LIKE shd_file.shd07,
                    #FUN-580029  --begin
                    shd13     LIKE shd_file.shd13,
                    shd14     LIKE shd_file.shd14,
                    shd15     LIKE shd_file.shd15,
                    shd10     LIKE shd_file.shd10,
                    shd11     LIKE shd_file.shd11,
                    shd12     LIKE shd_file.shd12,
                    shd18     LIKE shd_file.shd18,   #FUN-CB0087 add
                    azf03     LIKE azf_file.azf03    #FUN-CB0087 add
                    #FUN-580029  --end
                    END RECORD,
    g_shd_t         RECORD
                    shd02     LIKE shd_file.shd02,
                    shb03     LIKE shb_file.shb03,   #FUN-660109 add
                    shd06     LIKE shd_file.shd06,
                    shd03     LIKE shd_file.shd03,
                    shd04     LIKE shd_file.shd04,
                    shd05     LIKE shd_file.shd05,
                    shd16     LIKE shd_file.shd16,   #FUN-BB0084
                    shd07     LIKE shd_file.shd07,
                    #FUN-580029  --begin
                    shd13     LIKE shd_file.shd13,
                    shd14     LIKE shd_file.shd14,
                    shd15     LIKE shd_file.shd15,
                    shd10     LIKE shd_file.shd10,
                    shd11     LIKE shd_file.shd11,
                    shd12     LIKE shd_file.shd12,
                    shd18     LIKE shd_file.shd18,   #FUN-CB0087 add
                    azf03     LIKE azf_file.azf03    #FUN-CB0087 add 
                    #FUN-580029  --end
                    END RECORD,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_buf           LIKE imd_file.imd02,          #No.FUN-680121 VARCHAR(20) #TQC-840066
    tot1,tot2,tot3  LIKE img_file.img10,          #No.FUN-680121 DECIMAL(12,3)
    g_rec_b         LIKE type_file.num5,          #單身筆數        #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
DEFINE g_shd01      LIKE shd_file.shd01
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done      LIKE type_file.num5            #No.FUN-570110        #No.FUN-680121 SMALLINT
#FUN-580029  --begin
DEFINE
    g_ima906            LIKE ima_file.ima906,
    g_ima907            LIKE ima_file.ima907,
    g_factor            LIKE inb_file.inb08_fac,
    g_tot               LIKE img_file.img10,
    g_qty               LIKE img_file.img10,
    g_msg               LIKE type_file.chr1000,       #No.FUN-680121 CAHR(72)
    g_flag              LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
#FUN-580029  --end
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_shd16_t       LIKE shd_file.shd16          #FUN-BB0084 
DEFINE   g_shd10_t       LIKE shd_file.shd10          #FUN-BB0084
DEFINE   g_shd13_t       LIKE shd_file.shd13          #FUN-BB0084
 
 
FUNCTION t701(p_shd01)
DEFINE p_shd01   LIKE shd_file.shd01
DEFINE ls_tmp    STRING
 
    WHENEVER ERROR CONTINUE                #忽略一切錯誤
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    LET g_shd01      = p_shd01
 
    OPEN WINDOW t701_w AT 15,3 WITH FORM "asf/42f/asft701"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_locale("asft701")
  
   #-----FUN-610006---------
   CALL t701_def_form()
#  #No.FUN-580029  --begin
#  IF g_sma.sma115 ='N' THEN
#     CALL cl_set_comp_visible("shd13,shd15,shd10,shd12",FALSE)
#     CALL cl_set_comp_visible("shd07",TRUE)
#  ELSE
#     CALL cl_set_comp_visible("shd13,shd15,shd10,shd12",TRUE)
#     CALL cl_set_comp_visible("shd07",FALSE)
#  END IF
#  CALL cl_set_comp_visible("shd14,shd11",FALSE)
#  IF g_sma.sma122 ='1' THEN
#     CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg                         
#     CALL cl_set_comp_att_text("shd13",g_msg CLIPPED)   
#     CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg                         
#     CALL cl_set_comp_att_text("shd15",g_msg CLIPPED)   
#     CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg                         
#     CALL cl_set_comp_att_text("shd10",g_msg CLIPPED)   
#     CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg                         
#     CALL cl_set_comp_att_text("shd12",g_msg CLIPPED)   
#  END IF
#  IF g_sma.sma122 ='2' THEN
#     CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg                         
#     CALL cl_set_comp_att_text("shd13",g_msg CLIPPED)   
#     CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg                         
#     CALL cl_set_comp_att_text("shd15",g_msg CLIPPED)   
#     CALL cl_getmsg('asm-404',g_lang) RETURNING g_msg                         
#     CALL cl_set_comp_att_text("shd10",g_msg CLIPPED)   
#     CALL cl_getmsg('asm-405',g_lang) RETURNING g_msg                         
#     CALL cl_set_comp_att_text("shd12",g_msg CLIPPED)   
#  END IF
#  #No.FUN-580029  --end
   #-----END FUN-610006-----
 
    CALL t701_b_fill(' 1=1') 
 
    CALL t701_menu()

    CLOSE WINDOW t701_w
END FUNCTION
 
FUNCTION t701_menu()
DEFINE l_flag   LIKE type_file.chr1   #TQC-C20031 add
 
   WHILE TRUE
      CALL t701_bp("G")
      CASE g_action_choice
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t701_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            #TQC-C20031 add
            CALL t701_chk_lotin() RETURNING l_flag
            IF l_flag = '1' THEN
               CONTINUE WHILE
            ELSE
            #TQC-C20031 add--end
               EXIT WHILE
            END IF  #TQC-C20031 add
#        WHEN "jump"
#           CALL t701_fetch('/')
         WHEN "controlg"
            CALL cl_cmdask()
       #-----------CHI-A30032 add
        WHEN "qry_lot"
         IF l_ac > 0 THEN
            SELECT ima918,ima921 INTO g_ima918,g_ima921 FROM ima_file WHERE ima01 = g_shd[l_ac].shd06 AND imaacti = 'Y'
            CALL t701_lotin('QRY')
         END IF
       #-----------CHI-A30032 end
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_shd),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t701_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #No.FUN-680121 SMALLINT#分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680121 VARCHAR(1)
    l_ima35,l_ima36 LIKE ima_file.ima35,                #No.FUN-680121 VARCHAR(10)
    l_qty           LIKE img_file.img10,                #No.FUN-680121 DECIMAL(15,3)
    l_shd07         LIKE shd_file.shd07,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否        #No.FUN-680121 SMALLINT
    l_flag          LIKE type_file.chr1                 #No:CHI-A30032 add
DEFINE l_shbconf    LIKE shb_file.shbconf               #TQC-BB0043
DEFINE l_shb10      LIKE shb_file.shb10                 #FUN-BB0084 
DEFINE l_ac2        LIKE type_file.num5                 #CHI-C30118
DEFINE l_shb RECORD LIKE shb_file.*                     #FUN-CB0087 add
DEFINE l_where      STRING                              #FUN-CB0087 add

    LET g_action_choice = ""
    CALL cl_opmsg('b')
    SELECT * INTO l_shb.* FROM shb_file WHERE shb01 = g_shd01 #FUN-CB0087 add
#TQC-BB0043 --------Begin---------
    SELECT shbconf INTO l_shbconf FROM shb_file
     WHERE shb01 = g_shd01
    IF l_shbconf <> 'N' THEN
       CALL cl_err('','asf-198',0)  
       RETURN
    END IF
#TQC-BB0043 --------End-----------
    #FUN-580029  --begin
    LET g_forupd_sql="SELECT shd02,'',shd06,shd03,shd04,shd05,shd16,shd07,shd13,shd14,shd15,",   #FUN-660109 add ''  #FUN-BB0084 add shd16
                     "       shd10,shd11,shd12,shd18,'' FROM shd_file",  #FUN-CB0087 add shd18
                     " WHERE shd01 = ? AND shd02 = ?  FOR UPDATE"
    #FUN-580029  --end
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t701_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    #CKP
    IF g_rec_b=0 THEN CALL g_shd.clear() END IF
 
    INPUT ARRAY g_shd WITHOUT DEFAULTS FROM s_shd.* 
 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
#TQC-C80176  ---begin---add
            IF g_sma.sma95 = 'N' THEN
               CALL cl_set_act_visible("modi_lot",FALSE)
            ELSE
               CALL cl_set_act_visible("modi_lot",TRUE)
            END IF
#TQC-C80176  ---end---
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR() 
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_flag = 'N'           #No:CHI-A30032  add
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_shd_t.* = g_shd[l_ac].*  #BACKUP
               LET g_shd16_t = g_shd[l_ac].shd16     #FUN-BB0084
               LET g_shd10_t = g_shd[l_ac].shd10     #FUN-BB0084
               LET g_shd13_t = g_shd[l_ac].shd13     #FUN-BB0084
#No.FUN-570110--begin                                                           
               LET g_before_input_done = FALSE                                  
               CALL t701_set_entry_b(p_cmd)                                     
               CALL t701_set_no_entry_b(p_cmd)                                  
               LET g_before_input_done = TRUE                                   
#No.FUN-570110--end          
               OPEN t701_bcl USING g_shd01,g_shd_t.shd02
               IF STATUS THEN
                  CALL cl_err("OPEN t701_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t701_bcl INTO g_shd[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock shd',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
              #-----------------------No:CHI-A30032 add
               LET l_flag = 'Y'
               SELECT ima918,ima921 INTO g_ima918,g_ima921 FROM ima_file WHERE ima01=g_shd[l_ac].shd06 AND imaacti='Y'
              #CALL t701_s('d') #FUN-D40092 mark
              #-----------------------No:CHI-A30032 end
               #FUN-580029  --begin
               IF g_sma.sma115 = 'Y' THEN
                  IF NOT cl_null(g_shd[l_ac].shd06) THEN
                     SELECT img09 INTO g_img09 FROM img_file
                      WHERE img01=g_shd[l_ac].shd06 AND img02=g_shd[l_ac].shd03
                        AND img03=g_shd[l_ac].shd04 AND img04=g_shd[l_ac].shd05
                     IF STATUS = 100 THEN
                        SELECT ima25 INTO g_img09
                          FROM ima_file WHERE ima01=g_shd[l_ac].shd06
                     END IF
 
                     CALL s_chk_va_setting(g_shd[l_ac].shd06)
                          RETURNING g_flag,g_ima906,g_ima907
 
                  END IF
               END IF
              #start FUN-660109 add
               SELECT shb03 INTO g_shd[l_ac].shb03 FROM shb_file
                WHERE shb01 = g_shd01           
               IF STATUS THEN LET g_shd[l_ac].shb03 = ' ' END IF
               DISPLAY BY NAME g_shd[l_ac].shb03
              #end FUN-660109 add
               CALL t701_set_entry_b(p_cmd)
               CALL t701_set_no_entry_b(p_cmd)
               #FUN-580029  --end
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            BEGIN WORK
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110--begin                                                           
            LET g_before_input_done = FALSE                                     
            CALL t701_set_entry_b(p_cmd)                                        
            CALL t701_set_no_entry_b(p_cmd)                                     
            LET g_before_input_done = TRUE                                      
#No.FUN-570110--end             
            INITIALIZE g_shd[l_ac].* TO NULL      #900423
            INITIALIZE g_shd_t.* TO NULL
            LET g_shd16_t = NULL            #FUN-BB0084
            LET g_shd10_t = NULL            #FUN-BB0084
            LET g_shd13_t = NULL            #FUN-BB0084
           #start FUN-660109 add
            SELECT shb03 INTO g_shd[l_ac].shb03 FROM shb_file
             WHERE shb01 = g_shd01           
            IF STATUS THEN LET g_shd[l_ac].shb03 = ' ' END IF
            DISPLAY BY NAME g_shd[l_ac].shb03
           #end FUN-660109 add
#FUN-BB0084 ------------Begin------------
            SELECT shb10 INTO l_shb10 FROM shb_file
             WHERE shb01 = g_shd01 
            SELECT ima55 INTO g_shd[l_ac].shd16 FROM ima_file
             WHERE ima01 = l_shb10
            DISPLAY BY NAME g_shd[l_ac].shd16
#FUN-BB0084 ------------End--------------
            LET g_shd[l_ac].shd07=0
            #No.FUN-580029  --begin
            LET g_shd[l_ac].shd11=1
            LET g_shd[l_ac].shd14=1
            #No.FUN-580029  --end
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD shd02
 
        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              #CKP
              INITIALIZE g_shd[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_shd[l_ac].* TO s_shd.*
              CALL g_shd.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
 
            CALL t701_move_shd('a') 
            #FUN-580029  --begin
            IF g_sma.sma115 = 'Y' THEN
              IF NOT cl_null(g_shd[l_ac].shd06) THEN
                 SELECT img09 INTO g_img09 FROM img_file
                  WHERE img01=g_shd[l_ac].shd06 AND img02=g_shd[l_ac].shd03
                    AND img03=g_shd[l_ac].shd04 AND img04=g_shd[l_ac].shd05
              END IF
 
              CALL s_chk_va_setting(g_shd[l_ac].shd06)
                   RETURNING g_flag,g_ima906,g_ima907
              IF g_flag=1 THEN
                 NEXT FIELD shd06
              END IF
 
              CALL t701_du_data_to_correct()
              
              CALL t701_set_origin_field()
            END IF
            #FUN-580029  --end
            LET b_shd.shdoriu = g_user      #No.FUN-980030 10/01/04
            LET b_shd.shdorig = g_grup      #No.FUN-980030 10/01/04
            INSERT INTO shd_file VALUES(b_shd.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins shd',SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE 
               MESSAGE 'INSERT O.K'
               #CALL t701_s('a')          #異動庫存資料  #FUN-D40092 mark
               IF g_success = 'Y' THEN
                  LET l_flag = 'N'    #No:CHI-A30032 add
                  LET g_rec_b=g_rec_b+1
                  COMMIT WORK
                  MESSAGE 'INSERT O.K'
               ELSE 
                  ROLLBACK WORK 
               END IF 
             END IF
 
 
        BEFORE FIELD shd02                            #default 序號
            IF g_shd[l_ac].shd02 IS NULL OR g_shd[l_ac].shd02 = 0 THEN
                SELECT max(shd02)+1 INTO g_shd[l_ac].shd02
                   FROM shd_file WHERE shd01 = g_shd01
                IF g_shd[l_ac].shd02 IS NULL THEN
                    LET g_shd[l_ac].shd02 = 1
                END IF
            END IF
 
        AFTER FIELD shd02                        #check 序號是否重複
            IF NOT cl_null(g_shd[l_ac].shd02) THEN 
               IF g_shd[l_ac].shd02 != g_shd_t.shd02 OR
                  g_shd_t.shd02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM shd_file
                       WHERE shd01 = g_shd01 AND shd02 = g_shd[l_ac].shd02
                   IF l_n > 0 THEN
                       LET g_shd[l_ac].shd02 = g_shd_t.shd02
                       CALL cl_err('',-239,0) NEXT FIELD shd02
                   END IF
               END IF
            END IF
 
        AFTER FIELD shd03   #倉庫
           IF NOT cl_null(g_shd[l_ac].shd03) THEN 
              SELECT imd02,imd10 INTO g_buf,g_imd10 FROM imd_file
               WHERE imd01=g_shd[l_ac].shd03
                  AND imdacti = 'Y' #MOD-4B0169
              IF STATUS THEN 
                 CALL cl_err('sel imd_file','mfg1100',0) NEXT FIELD shd03 END IF
              #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
              IF NOT s_chksmz(g_shd[l_ac].shd06, g_shd01,
                              g_shd[l_ac].shd03, g_shd[l_ac].shd04) THEN
                 NEXT FIELD shd03
              END IF
              IF g_imd10 !='W'  THEN 
                 CALL cl_err('','asf-724',0)      
                 NEXT FIELD shd03
              END IF 
              #---> Add No.FUN-AA0091
              IF NOT s_chk_ware(g_shd[l_ac].shd03) THEN  #检查仓库是否属于当前门店
                 NEXT FIELD shd03
              END IF
              #---> End Add No.FUN-AA0091
              IF NOT t701_shd18_check() THEN NEXT FIELD shd18 END IF  #FUN-CB0087 add #TQC-D10074
           END IF 
 
        AFTER FIELD shd04
           #BugNo:5626 控管是否為全型空白
           IF g_shd[l_ac].shd04 = '　' THEN #全型空白
               LET g_shd[l_ac].shd04 = ' '
           END IF
           IF g_shd[l_ac].shd04 IS NULL THEN LET g_shd[l_ac].shd04 =' ' END IF
           #FUN-D20060---add---str---
           IF g_shd[l_ac].shd03 IS NOT NULL THEN
              IF NOT s_chksmz(g_shd[l_ac].shd06, g_shd01,
                              g_shd[l_ac].shd03, g_shd[l_ac].shd04) THEN
                 NEXT FIELD shd03
              END IF
           END IF
           #FUN-D20060---add---end---
 
        #FUN-580029  --begin
        BEFORE FIELD shd06
            CALL t701_set_entry_b(p_cmd)
            CALL t701_set_no_required()  
        #FUN-580029  --end
 
        AFTER FIELD shd06
           IF NOT cl_null(g_shd[l_ac].shd06) THEN 
             #CHI-BA0039---add---start---
              IF g_shd[l_ac].shd06[1,4]='MISC' THEN
                 CALL cl_err('shd06','asf-306',1)
                 NEXT FIELD shd06
              END IF
             #CHI-BA0039---add---end---
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_shd[l_ac].shd06,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_shd[l_ac].shd06= g_shd_t.shd06
                 NEXT FIELD shd06
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              SELECT COUNT(*) INTO g_cnt FROM ima_file 
               WHERE ima01=g_shd[l_ac].shd06 AND imaacti='Y'
              IF g_cnt=0 THEN
                 CALL cl_err('sel ima','ams-003',0) NEXT FIELD shd06 
              END IF
              SELECT ima918,ima921 INTO g_ima918,g_ima921 FROM ima_file WHERE ima01=g_shd[l_ac].shd06 AND imaacti = 'Y'  #No:CHI-A30032 add
              #No.FUN-580029  --begin
              IF g_sma.sma115 = 'Y' THEN
                 CALL s_chk_va_setting(g_shd[l_ac].shd06) 
                      RETURNING g_flag,g_ima906,g_ima907
                 IF g_flag=1 THEN
                    NEXT FIELD shd06
                 END IF
                 CALL t701_du_default(p_cmd)
                 CALL t701_set_no_entry_b(p_cmd)
                 CALL t701_set_required()
              END IF
              #No.FUN-580029  --end
              IF NOT t701_shd18_check() THEN NEXT FIELD shd18 END IF  #FUN-CB0087 add #TQC-D10074
           END IF
 
        AFTER FIELD shd05    #批號
           #BugNo:5626 控管是否為全型空白
           IF g_shd[l_ac].shd05 = '　' THEN #全型空白
               LET g_shd[l_ac].shd05 = ' '
           END IF
           IF g_shd[l_ac].shd05 IS NULL THEN LET g_shd[l_ac].shd05 =' ' END IF
 
           SELECT img09,img10,img22 INTO g_img09,g_img10,g_img22 FROM img_file
                  WHERE img01=g_shd[l_ac].shd06 AND img02=g_shd[l_ac].shd03
                    AND img03=g_shd[l_ac].shd04 AND img04=g_shd[l_ac].shd05
           IF STATUS=100 THEN
              IF NOT cl_confirm('mfg1401') THEN NEXT FIELD shd04 END IF
              CALL s_add_img(g_shd[l_ac].shd06,g_shd[l_ac].shd03,
                             g_shd[l_ac].shd04,g_shd[l_ac].shd05,
                             g_shd01,          g_shd[l_ac].shd02,
                             g_today)
              IF g_errno='N' THEN NEXT FIELD shd04 END IF
              SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
                  WHERE img01=g_shd[l_ac].shd06 AND img02=g_shd[l_ac].shd03
                    AND img03=g_shd[l_ac].shd04 AND img04=g_shd[l_ac].shd05
           ELSE 
              IF g_img22 !='W'  THEN 
                 CALL cl_err('','asf-724',0)      
                 NEXT FIELD shd05
              END IF 
           END IF
           #No.FUN-580029  --begin
           IF g_sma.sma115 = 'Y' THEN
              IF cl_null(g_shd[l_ac].shd06) THEN NEXT FIELD shd06 END IF
              CALL s_chk_va_setting(g_shd[l_ac].shd06) 
                   RETURNING g_flag,g_ima906,g_ima907
              IF g_flag=1 THEN
                 NEXT FIELD shd06
              END IF
              CALL t701_du_default(p_cmd)
              CALL t701_set_no_entry_b(p_cmd)
              CALL t701_set_required()
           END IF
           #No.FUN-580029  --end
#FUN-BB0084 ------------------Begin-----------------
        AFTER FIELD shd16 
           CALL t701_shd07_chk()
        AFTER FIELD shd07    
           CALL t701_shd07_chk()
           IF g_sma.sma95 = 'Y' THEN             #TQC-C80176--add--
              CALL t701_lotin('MOD')             #No:CHI-A30032 add
           END IF                                #TQC-C80176--add--
           DISPLAY BY NAME g_shd[l_ac].shd07  #No:CHI-A30032 add
#FUN-BB0084 ------------------End-------------------
 
#No.FUN-580029  --begin
        BEFORE FIELD shd13
           IF NOT cl_null(g_shd[l_ac].shd06) THEN
              SELECT img09 INTO g_img09 FROM img_file
               WHERE img01=g_shd[l_ac].shd06 AND img02=g_shd[l_ac].shd03
                 AND img03=g_shd[l_ac].shd04 AND img04=g_shd[l_ac].shd05
           END IF
           CALL t701_set_no_required()
           
        AFTER FIELD shd13  #第二單位
           IF cl_null(g_shd[l_ac].shd06) THEN NEXT FIELD shd06 END IF
           IF NOT cl_null(g_shd[l_ac].shd13) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_shd[l_ac].shd13
                 AND gfeacti='Y'
              IF STATUS THEN 
                 CALL cl_err('gfe:',STATUS,0)
                 NEXT FIELD shd13
              END IF
              CALL s_du_umfchk(g_shd[l_ac].shd06,'','','',
                               g_img09,g_shd[l_ac].shd13,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_shd[l_ac].shd13,g_errno,0)
                 NEXT FIELD shd13
              END IF
              IF cl_null(g_shd_t.shd13) OR g_shd_t.shd13 <> g_shd[l_ac].shd13 THEN
                 LET g_shd[l_ac].shd14 = g_factor
              END IF
              CALL s_chk_imgg(g_shd[l_ac].shd06,g_shd[l_ac].shd03,
                              g_shd[l_ac].shd04,g_shd[l_ac].shd05,
                              g_shd[l_ac].shd13) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD shd13 END IF
                 END IF
                 CALL s_add_imgg(g_shd[l_ac].shd06,g_shd[l_ac].shd03,
                                 g_shd[l_ac].shd04,g_shd[l_ac].shd05,
                                 g_shd[l_ac].shd13,g_shd[l_ac].shd14,
                                 g_shd01,     
                                 g_shd[l_ac].shd02,0) RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD shd13
                 END IF
              END IF
           END IF
           CALL t701_du_data_to_correct()
           CALL t701_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
            
        BEFORE FIELD shd15  
           IF cl_null(g_shd[l_ac].shd06) THEN NEXT FIELD shd06 END IF
           IF NOT cl_null(g_shd[l_ac].shd13) AND g_ima906='3' THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_shd[l_ac].shd13
                 AND gfeacti='Y'
              IF STATUS THEN 
                 CALL cl_err('gfe:',STATUS,0)
                 NEXT FIELD shd06
              END IF
              CALL s_du_umfchk(g_shd[l_ac].shd06,'','','',
                               g_img09,g_shd[l_ac].shd13,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_shd[l_ac].shd13,g_errno,0)
                 NEXT FIELD shd06
              END IF
              IF cl_null(g_shd_t.shd13) OR g_shd_t.shd13 <> g_shd[l_ac].shd13 THEN
                 LET g_shd[l_ac].shd14 = g_factor
              END IF
              CALL s_chk_imgg(g_shd[l_ac].shd06,g_shd[l_ac].shd03,
                              g_shd[l_ac].shd04,g_shd[l_ac].shd05,
                              g_shd[l_ac].shd13) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD shd06 END IF
                 END IF
                 CALL s_add_imgg(g_shd[l_ac].shd06,g_shd[l_ac].shd03,
                                 g_shd[l_ac].shd04,g_shd[l_ac].shd05,
                                 g_shd[l_ac].shd13,g_shd[l_ac].shd14,
                                 g_shd01,     
                                 g_shd[l_ac].shd02,0) RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD shd06
                 END IF
              END IF
           END IF
           CALL t701_du_data_to_correct()
           CALL t701_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
 
        AFTER FIELD shd15  #第二數量
#FUN-BB0084 ------------Begin-----------
           IF NOT t701_shd15_chk(p_cmd) THEN
              NEXT FIELD shd15 
           END IF
#FUN-BB0084 ------------End-------------
    
#FUN-BB0084 --------------Begin------------------
#          IF NOT cl_null(g_shd[l_ac].shd15) THEN
#             IF g_shd[l_ac].shd15 < 0 THEN
#                CALL cl_err('','aim-391',0)  #
#                NEXT FIELD shd15
#             END IF
#             IF p_cmd = 'a' OR  p_cmd = 'u' AND 
#                g_shd_t.shd15 <> g_shd[l_ac].shd15 THEN                                               
#                IF g_ima906='3' THEN
#                   LET g_tot=g_shd[l_ac].shd15*g_shd[l_ac].shd14
#                   IF cl_null(g_shd[l_ac].shd12) OR g_shd[l_ac].shd12=0 THEN #CHI-960022
#                      LET g_shd[l_ac].shd12=g_tot*g_shd[l_ac].shd11
#                      DISPLAY BY NAME g_shd[l_ac].shd12                      #CHI-960022
#                   END IF                                                    #CHI-960022
#                END IF
#             END IF
#          END IF
#          CALL cl_show_fld_cont()                   #No.FUN-560197
#FUN-BB0084 --------------End-------------------
 
        AFTER FIELD shd10  #第一單位
           IF cl_null(g_shd[l_ac].shd06) THEN NEXT FIELD shd03 END IF
           IF NOT cl_null(g_shd[l_ac].shd10) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_shd[l_ac].shd10
                 AND gfeacti='Y'
              IF STATUS THEN 
                 CALL cl_err('gfe:',STATUS,0)
                 NEXT FIELD shd10
              END IF
              CALL s_du_umfchk(g_shd[l_ac].shd06,'','','',
                               g_img09,g_shd[l_ac].shd10,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_shd[l_ac].shd10,g_errno,0)
                 NEXT FIELD shd10
              END IF
              IF cl_null(g_shd_t.shd10) OR g_shd_t.shd10 <> g_shd[l_ac].shd10 THEN
                 LET g_shd[l_ac].shd11 = g_factor
              END IF
              IF g_ima906 = '2' THEN
                 CALL s_chk_imgg(g_shd[l_ac].shd06,g_shd[l_ac].shd03,
                                 g_shd[l_ac].shd04,g_shd[l_ac].shd05,
                                 g_shd[l_ac].shd10) RETURNING g_flag
                 IF g_flag = 1 THEN
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN NEXT FIELD shd10 END IF
                    END IF
                    CALL s_add_imgg(g_shd[l_ac].shd06,g_shd[l_ac].shd03,
                                    g_shd[l_ac].shd04,g_shd[l_ac].shd05,
                                    g_shd[l_ac].shd10,g_shd[l_ac].shd11,
                                    g_shd01,    
                                    g_shd[l_ac].shd02,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD shd10
                    END IF
                 END IF 
              END IF 
           END IF
           CALL t701_du_data_to_correct()
           CALL t701_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
#FUN-BB0084 ---------Begin----------
           CASE t701_shd12_chk()
              WHEN "shd12"
                LET g_shd10_t = g_shd[l_ac].shd10
                NEXT FIELD shd12
              WHEN "shd15"
                LET g_shd10_t = g_shd[l_ac].shd10
                NEXT FIELD shd15
           END CASE
#FUN-BB0084 ---------End------------
 
        AFTER FIELD shd12  #第一數量
#FUN-BB0084 ---------Begin----------
           CASE t701_shd12_chk()
              WHEN "shd12"
                NEXT FIELD shd12
              WHEN "shd15"
                NEXT FIELD shd15
           END CASE
#FUN-BB0084 ---------End------------
#FUN-BB0084 ---------------Begin-----------------
#          IF NOT cl_null(g_shd[l_ac].shd12) THEN
#             IF g_shd[l_ac].shd12 < 0 THEN
#                CALL cl_err('','aim-391',0)  #
#                NEXT FIELD shd12
#             END IF
#             CALL t701_lotin('MOD')      #No:CHI-A30032 add
#          END IF
#          CALL t701_set_origin_field()
#          IF g_flag = '1' THEN
#             IF g_ima906 = '3' OR g_ima906 = '2' THEN  
#                NEXT FIELD shd15
#             ELSE
#                NEXT FIELD shd12
#             END IF
#          END IF
#          CALL cl_show_fld_cont()                   #No.FUN-560197
#FUN-BB0084 ---------------End-------------------
#No.FUN-580029  --end

        #FUN-CB0087--add--str--
        BEFORE FIELD shd18 
           IF g_aza.aza115 = 'Y' AND cl_null(g_shd[l_ac].shd18) THEN 
              CALL s_reason_code(l_shb.shb01,l_shb.shb05,'',g_shd[l_ac].shd06,g_shd[l_ac].shd03,l_shb.shb04,'') RETURNING g_shd[l_ac].shd18
              DISPLAY BY NAME g_shd[l_ac].shd18
           END IF
        AFTER FIELD shd18
           IF NOT cl_null(g_shd[l_ac].shd18) THEN 
              IF NOT t701_shd18_check() THEN 
                 NEXT FIELD shd18
              ELSE 
                 SELECT azf03 INTO g_shd[l_ac].azf03 FROM azf_file WHERE azf01=g_shd[l_ac].shd18 AND azf02='2'
              END IF 
           END IF 
        #FUN-CB0087--add--end-- 
        BEFORE DELETE                            #是否取消單身
            IF g_shd_t.shd02 > 0 AND g_shd_t.shd02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
 
                DELETE FROM shd_file
                 WHERE shd01 = g_shd01 AND shd02 = g_shd_t.shd02
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_shd_t.shd02,SQLCA.sqlcode,0)
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE 
                  #CALL t701_s('d')          #異動庫存資料  #CHI-A30032 mark
                   IF g_success = 'Y' THEN
                     #---------CHI-A30032 add
                      LET l_flag = 'N'
                      IF g_ima918 = 'Y' OR g_ima921 = 'Y' THEN
                         IF NOT s_del_rvbs('2',g_shd01,g_shd[l_ac].shd02,0)  THEN
                            LET g_success = 'N'
                            ROLLBACK WORK
                         END IF
                      END IF
                     #---------CHI-A30032 end
                      LET g_rec_b=g_rec_b-1
                      COMMIT WORK
                   ELSE 
                      ROLLBACK WORK 
                      CANCEL DELETE
                   END IF 
                END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_shd[l_ac].* = g_shd_t.*
               CLOSE t701_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_shd[l_ac].shd03,-263,1)
               LET g_shd[l_ac].* = g_shd_t.*
            ELSE
               #No.FUN-580029  --begin
               IF g_sma.sma115 = 'Y' THEN
                  IF NOT cl_null(g_shd[l_ac].shd06) THEN
                     SELECT img09 INTO g_img09 FROM img_file
                      WHERE img01=g_shd[l_ac].shd06 AND img02=g_shd[l_ac].shd03
                        AND img03=g_shd[l_ac].shd04 AND img04=g_shd[l_ac].shd05
                  END IF
 
                  CALL s_chk_va_setting(g_shd[l_ac].shd06)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD shd06
                  END IF
                
                  CALL t701_du_data_to_correct()
                
                  CALL t701_set_origin_field()
               END IF
               CALL t701_move_shd('u') 
               #FUN-580029  --end
               UPDATE shd_file SET * = b_shd.*
                WHERE shd01=g_shd01 AND shd02=g_shd_t.shd02
               IF SQLCA.sqlcode THEN
                  CALL cl_err('upd shd',SQLCA.sqlcode,0)
                  LET g_shd[l_ac].* = g_shd_t.*
               ELSE
                 #CALL t701_s('d')      #異動庫存資料  #CHI-A30032 mark
                  IF g_success = 'Y' THEN 
                    #CALL t701_s('a')   #異動庫存資料  #FUN-D40092 mark
                     IF g_success = 'Y'  THEN 
                        LET l_flag = 'N'          #No:CHI-A30032 add
                        MESSAGE 'UPDATE O.K'
	                COMMIT WORK
                     ELSE  
                        ROLLBACK WORK 
                     END IF 
                  ELSE 
                     ROLLBACK WORK  
                  END IF 
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac       #FUN-D40030 Mark
           #-------------------No:CHI-A30032 add
            IF g_success = 'Y' AND l_flag = 'Y' THEN 
               #CALL t701_s('a') #FUN-D40092 mark
               IF g_success = 'Y' THEN
                  COMMIT WORK
               ELSE
                  ROLLBACK WORK
               END IF
            END IF
           #-------------------No:CHI-A30032 end
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_shd[l_ac].* = g_shd_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_shd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t701_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac       #FUN-D40030 Add 
            CLOSE t701_bcl
            COMMIT WORK
            #CKP
           #CALL g_shd.deleteElement(g_rec_b+1)    #FUN-D40030 Mark
 
#       ON ACTION CONTROLN
#           CALL t701_b_askkey()
#           EXIT INPUT

       #----------No:CHI-A30032 add
        ON ACTION modi_lot
           CALL t701_lotin('MOD')
       #----------No:CHI-A30032 end
 
        ON ACTION controlp
           CASE WHEN INFIELD(shd06) 
#FUN-AA0059---------mod------------str-----------------           
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form     = "q_ima"
#                     LET g_qryparam.default1 = g_shd[l_ac].shd06
#                     CALL cl_create_qry() RETURNING g_shd[l_ac].shd06
                     CALL q_sel_ima(FALSE, "q_ima","",g_shd[l_ac].shd06,"","","","","",'' ) 
                            RETURNING  g_shd[l_ac].shd06
#FUN-AA0059---------mod------------end-----------------
#                     CALL FGL_DIALOG_SETBUFFER( g_shd[l_ac].shd06 )
                      DISPLAY BY NAME g_shd[l_ac].shd06  #No.MOD-490371
                     NEXT FIELD shd06
                WHEN INFIELD(shd03) OR INFIELD(shd04) OR INFIELD(shd05)
                   #FUN-C30300---begin
                   LET g_ima906 = NULL
                   SELECT ima906 INTO g_ima906 FROM ima_file
                    WHERE ima01 = g_shd[l_ac].shd06
                   #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_shd[l_ac].shd06,g_shd[l_ac].shd03,   ##NO.FUN-660085
                                            g_shd[l_ac].shd04,g_shd[l_ac].shd05)
                                 RETURNING  g_shd[l_ac].shd03,g_shd[l_ac].shd04,
                                            g_shd[l_ac].shd05
                   ELSE
                   #FUN-C30300---end
                      ## CALL q_img4(FALSE,FALSE,g_shd[l_ac].shd06,g_shd[l_ac].shd03,  ##NO.FUN-660085
                      CALL q_img4(FALSE,TRUE,g_shd[l_ac].shd06,g_shd[l_ac].shd03,   ##NO.FUN-660085
                                  g_shd[l_ac].shd04,g_shd[l_ac].shd05,'W')
                       RETURNING  g_shd[l_ac].shd03,g_shd[l_ac].shd04,
                                  g_shd[l_ac].shd05
                      #No.MOD-490028
                   END IF  #FUN-C30300
                     DISPLAY g_shd[l_ac].shd03 TO shd03
                     DISPLAY g_shd[l_ac].shd04 TO shd04
                     DISPLAY g_shd[l_ac].shd05 TO shd05
                      #No.MOD-490028(end)
                     IF INFIELD(shd03) THEN NEXT FIELD shd03 END IF
                     IF INFIELD(shd04) THEN NEXT FIELD shd04 END IF
                     IF INFIELD(shd05) THEN NEXT FIELD shd05 END IF
               #FUN-580029  --begin
               WHEN INFIELD(shd10)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_shd[l_ac].shd10
                    CALL cl_create_qry() RETURNING g_shd[l_ac].shd10
                    DISPLAY g_shd[l_ac].shd10 TO shd10
                    NEXT FIELD shd10
               WHEN INFIELD(shd13)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_shd[l_ac].shd13
                    CALL cl_create_qry() RETURNING g_shd[l_ac].shd13
                    DISPLAY g_shd[l_ac].shd13 TO shd13
                    NEXT FIELD shd13
               #FUN-580029  --end
               #FUN-CB0087--add--str--
               WHEN INFIELD(shd18)       
                  CALL s_get_where(l_shb.shb01,l_shb.shb05,'',g_shd[l_ac].shd06,g_shd[l_ac].shd03,l_shb.shb04,'') RETURNING l_flag,l_where
                  IF l_flag AND g_aza.aza115 = 'Y' THEN 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  ="q_ggc08"
                     LET g_qryparam.where = l_where
                     LET g_qryparam.default1 = g_shd[l_ac].shd18
                  ELSE
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_azf41"             
                     LET g_qryparam.default1 = g_shd[l_ac].shd18               
                  END IF  
                  CALL cl_create_qry() RETURNING g_shd[l_ac].shd18
                  DISPLAY BY NAME g_shd[l_ac].shd18
                  NEXT FIELD shd18
               #FUN-CB0087--add--end--
           END CASE
 
        ON ACTION qry_warehouse
                    #---> Mod No.FUN-AA0091
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_imd"
                    #LET g_qryparam.default1 = g_shd[l_ac].shd03
                    #LET g_qryparam.arg1     = 'SW' #倉庫類別  #TQC-740118
                    #CALL cl_create_qry() RETURNING g_shd[l_ac].shd03
                     CALL q_imd_1(FALSE,TRUE,g_shd[l_ac].shd03,"",g_plant,"","")
                          RETURNING g_shd[l_ac].shd03
                    #---> End Mod No.FUN-AA0091
#                     CALL FGL_DIALOG_SETBUFFER( g_shd[l_ac].shd03 )
                     NEXT FIELD shd03
 
        ON ACTION qry_location
                    #---> Mod No.FUN-AA0091
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_ime"
                    #LET g_qryparam.default1 = g_shd[l_ac].shd04
                    #LET g_qryparam.arg1     = g_shd[l_ac].shd03 #倉庫編號 #MOD-4A0063
                    #LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
                    #CALL cl_create_qry() RETURNING g_shd[l_ac].shd04
                     CALL q_ime_1(FALSE,TRUE,g_shd[l_ac].shd04,g_shd[l_ac].shd03,"",g_plant,"","","")
                          RETURNING g_shd[l_ac].shd04
                    #---> End Mod No.FUN-AA0091
#                     CALL FGL_DIALOG_SETBUFFER( g_shd[l_ac].shd04 )
                     NEXT FIELD shd04
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
        AFTER INPUT
            #------------------------------ 
            SELECT * INTO g_shb.* FROM shb_file WHERE shb01=g_shd01    
            SELECT SUM(shd07) INTO l_shd07 FROM shd_file WHERE shd01=g_shd01      
            IF STATUS OR l_shd07 IS NULL THEN 
               LET l_shd07=0
            END IF
            IF g_shb.shb114 IS NOT NULL AND g_shb.shb114 !=0 THEN 
               IF l_shd07<=0 THEN 
                  CALL cl_err(l_shd07,'asf-915',0)
                  CONTINUE INPUT
               END IF 
              #MOD-D60236 add begin-------------
               IF l_shd07<>g_shb.shb114 THEN #轉入總和不等於轉出,show提示
                  CALL cl_err('','asf-223',1)
                  CONTINUE INPUT
               END IF
              #MOD-D60236 add end---------------
            END IF
            #------------------------------ 
    #CHI-C30118---add---START 回寫批序料號資料
            SELECT COUNT(*) INTO g_cnt FROM shd_file WHERE shd01=g_shb.shb01
            FOR l_ac2 = 1 TO g_cnt
                LET g_ima918 = ' '
                LET g_ima921 = ' '
                SELECT ima918,ima921 INTO g_ima918,g_ima921
                  FROM ima_file
                 WHERE ima01 = g_shd[l_ac2].shd06
                   AND imaacti = "Y"
                   
                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                   UPDATE rvbs_file SET rvbs021 = g_shd[l_ac2].shd06
                     WHERE rvbs00 = g_prog
                       AND rvbs01 = g_shb.shb01
                       AND rvbs02 = g_shd[l_ac2].shd02
                END IF
            END FOR
    #CHI-C30118---add---END             
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
    END INPUT
 
    CLOSE t701_bcl
    COMMIT WORK
 
END FUNCTION

#FUN-BB0084 ----------------------------Begin------------------------
FUNCTION t701_shd07_chk()
   IF NOT cl_null(g_shd[l_ac].shd16) AND NOT cl_null(g_shd[l_ac].shd07) THEN
      IF cl_null(g_shd16_t) OR cl_null(g_shd_t.shd07) OR g_shd16_t! = g_shd[l_ac].shd16
         OR g_shd_t.shd07 ! = g_shd[l_ac].shd07 THEN
         LET g_shd[l_ac].shd07 = s_digqty(g_shd[l_ac].shd07,g_shd[l_ac].shd16) 
         DISPLAY BY NAME g_shd[l_ac].shd07
      END IF 
   END IF    
END FUNCTION         

FUNCTION t701_shd12_chk()
   IF NOT cl_null(g_shd[l_ac].shd12) THEN
      IF g_shd[l_ac].shd12 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN "shd12"
      END IF
   END IF
   IF NOT cl_null(g_shd[l_ac].shd12) AND NOT cl_null(g_shd[l_ac].shd10) THEN
      IF cl_null(g_shd10_t) OR cl_null(g_shd_t.shd12) OR g_shd10_t ! = g_shd[l_ac].shd10
         OR g_shd_t.shd12! = g_shd[l_ac].shd12 THEN
         LET g_shd[l_ac].shd12 = s_digqty(g_shd[l_ac].shd12,g_shd[l_ac].shd10)
         DISPLAY BY NAME g_shd[l_ac].shd12
      END IF
   END IF   
   CALL t701_set_origin_field()
   IF g_flag = '1' THEN
      IF g_ima906 = '3' OR g_ima906 = '2' THEN  
         RETURN "shd15"
      ELSE
         RETURN "shd12"
      END IF
   END IF
   CALL cl_show_fld_cont()   
   RETURN NULL
END FUNCTION 

FUNCTION t701_shd15_chk(p_cmd)
DEFINE 	p_cmd     LIKE type_file.chr1 
   IF NOT cl_null(g_shd[l_ac].shd15) THEN
      IF g_shd[l_ac].shd15 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE
      END IF
      IF NOT cl_null(g_shd13_t) THEN
         IF cl_null(g_shd13_t) OR cl_null(g_shd_t.shd15) OR g_shd13_t!=g_shd[l_ac].shd13
            OR g_shd_t.shd15! = g_shd[l_ac].shd15 THEN
            LET g_shd[l_ac].shd15 = s_digqty(g_shd[l_ac].shd15,g_shd[l_ac].shd13)
            DISPLAY BY NAME g_shd[l_ac].shd15
         END IF
      END IF 
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
         g_shd_t.shd15 <> g_shd[l_ac].shd15 THEN
         IF g_ima906='3' THEN
            LET g_tot=g_shd[l_ac].shd15*g_shd[l_ac].shd14
            IF cl_null(g_shd[l_ac].shd12) OR g_shd[l_ac].shd12=0 THEN
               LET g_shd[l_ac].shd12=g_tot*g_shd[l_ac].shd11
               LET g_shd[l_ac].shd12=s_digqty(g_shd[l_ac].shd12,g_shd[l_ac].shd10)
               DISPLAY BY NAME g_shd[l_ac].shd12                    
            END IF                                                 
         END IF
      END IF
   END IF
   CALL cl_show_fld_cont()          
   RETURN TRUE 
END FUNCTION
#FUN-BB0084 ----------------------------End--------------------------           

#----------------------------------------------------No:CHI-A30032 add --------------------------------------------------
FUNCTION t701_lotin(p_cmd)
   DEFINE l_img09        LIKE img_file.img09
   DEFINE l_r            LIKE type_file.chr1
   DEFINE l_qty          LIKE shd_file.shd07
   DEFINE p_cmd          LIKE type_file.chr3
            
      SELECT img09 INTO l_img09 FROM img_file
       WHERE img01=g_shd[l_ac].shd06 AND img02=g_shd[l_ac].shd03
         AND img03=g_shd[l_ac].shd04 AND img04=g_shd[l_ac].shd05
      IF STATUS = 100 THEN
         SELECT ima25 INTO l_img09
           FROM ima_file WHERE ima01=g_shd[l_ac].shd06
      END IF    
                  
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         CALL s_lotin(g_prog,g_shd01,g_shd[l_ac].shd02,0,
                      g_shd[l_ac].shd06,l_img09,l_img09,   
                      1,g_shd[l_ac].shd07,'',p_cmd)
            RETURNING l_r,l_qty   
         IF l_r = "Y" THEN
            LET g_shd[l_ac].shd07 = l_qty
            DISPLAY BY NAME g_shd[l_ac].shd07
         END IF
      END IF
END FUNCTION
#----------------------------------------------------No:CHI-A30032 add --------------------------------------------------
 
FUNCTION t701_move_shd(p_cmd)
    DEFINE  p_cmd    LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    LET b_shd.shd01 = g_shd01
    LET b_shd.shd02 = g_shd[l_ac].shd02  
    LET b_shd.shd03 = g_shd[l_ac].shd03  
    LET b_shd.shd04 = g_shd[l_ac].shd04  
    LET b_shd.shd05 = g_shd[l_ac].shd05  
    LET b_shd.shd06 = g_shd[l_ac].shd06  
    LET b_shd.shd07 = g_shd[l_ac].shd07  
    LET b_shd.shd16 = g_shd[l_ac].shd16   #FUN-BB0084
    #FUN-580029  --begin
    LET b_shd.shd10 = g_shd[l_ac].shd10  
    LET b_shd.shd11 = g_shd[l_ac].shd11  
    LET b_shd.shd12 = g_shd[l_ac].shd12  
    LET b_shd.shd13 = g_shd[l_ac].shd13  
    LET b_shd.shd14 = g_shd[l_ac].shd14  
    LET b_shd.shd15 = g_shd[l_ac].shd15  
    LET b_shd.shd18 = g_shd[l_ac].shd18   #FUN-CB0087  
    #FUN-580029  --end 
    LET b_shd.shdacti='Y' 
    LET b_shd.shddate=g_today 
    IF p_cmd = 'u'  THEN 
       LET b_shd.shdmodu = g_user
    ELSE   
       LET b_shd.shduser=g_user 
       LET g_data_plant = g_plant #FUN-980030
       LET b_shd.shdgrup=g_grup   
       LET b_shd.shdmodu = ''
    END IF 
 
    LET b_shd.shdplant = g_plant #FUN-980008 add
    LET b_shd.shdlegal = g_legal #FUN-980008 add
END FUNCTION
 
FUNCTION t701_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    #FUN-580029  --begin
    CONSTRUCT l_wc2 ON shd02,shb03,shd03,shd04,shd05,shd06,shd13,shd14,shd15,shd10,shd11,shd12,shd18  #FUN-660109 add shb03  #FUN-CB0087 add shd18
       FROM s_shd[1].shd02, s_shd[1].shb03, s_shd[1].shd03, s_shd[1].shd04, s_shd[1].shd05, #FUN-660109 add s_shd[1].shb03
            s_shd[1].shd06, s_shd[1].shd13, s_shd[1].shd14, s_shd[1].shd15,
            s_shd[1].shd10, s_shd[1].shd11, s_shd[1].shd12, s_shd[1].shd18                  #FUN-CB0087 add shd18 
    #FUN-580029  --end
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    
       #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_select() 
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET l_wc2 = l_wc2 CLIPPED,cl_get_extra_cond('shduser', 'shdgrup') #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t701_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t701_b_fill(p_wc2)                          #BODY FILL UP
DEFINE p_wc2,l_sql     LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    LET l_sql =
    #FUN-580029  --begin
        "SELECT shd02,shb03,shd06,shd03,shd04,shd05,shd16,shd07,shd13,shd14,shd15,",   #FUN-660109 add shb03   #FUN-BB0084 add shd16
        "       shd10,shd11,shd12,shd18,azf03 ",  #FUN-CB0087 add shd18 azf03
        "  FROM shd_file ",
        "  LEFT OUTER JOIN azf_file ON azf01 =shd18 AND azf02='2' , ",  #FUN-CB0087 add
        "       shb_file ",   #FUN-660109 add shb_file
    #FUN-580029  --end
        " WHERE shd01 ='",g_shd01 CLIPPED,"'",       #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        "   AND shd01 = shb01 ",       #FUN-660109 add
        " ORDER BY 1"
 
    PREPARE t701_pb FROM l_sql
    DECLARE shd_curs CURSOR FOR t701_pb
 
    CALL g_shd.clear()
 
    LET g_cnt = 1
 
    FOREACH shd_curs INTO g_shd[g_cnt].*             #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_shd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
    LET g_cnt = 0 
 
END FUNCTION
 
FUNCTION t701_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
  IF p_ud <> "G" OR g_action_choice = "detail" THEN
     RETURN
  END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  #--No.MOD-530437 
 
   DISPLAY ARRAY g_shd TO s_shd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

#TQC-C80176  ---begin---add
      BEFORE DISPLAY 
         IF g_sma.sma95 = 'N' THEN
            CALL cl_set_act_visible("qry_lot",FALSE)
         ELSE
            CALL cl_set_act_visible("qry_lot",TRUE)
         END IF
#TQC-C80176  ---end---
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t701_def_form()   #FUN-610006
 
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

     #------------------CHI-A30032 add
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY
     #------------------CHI-A30032 end
   
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
##
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#FUN-D40092--mark--begin---
#FUNCTION t701_s(p_cmd)
#   DEFINE  p_cmd,l_y    LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
# 
#   IF s_shut(0) THEN RETURN END IF
#   IF g_shd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
# 
# # IF NOT cl_confirm('mfg0176') THEN RETURN END IF
# 
#   SELECT * INTO g_shb.* FROM shb_file WHERE shb01 = g_shd01 
# 
#   LET g_success = 'Y'
#   CALL t701_s1(p_cmd)
#   IF SQLCA.SQLCODE THEN LET g_success='N' END IF
#   MESSAGE ''
# 
#END FUNCTION
# 
#FUNCTION t701_s1(p_cmd)
#  DEFINE   p_cmd,l_cmd     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#           l_img09   LIKE img_file.img09,
#           l_img21   LIKE img_file.img21,
#           l_shd02   LIKE shd_file.shd02
# 
#  LET l_cmd = p_cmd 
#  IF p_cmd='a' THEN
#     LET l_shd02 = g_shd[l_ac].shd02  
#     SELECT * INTO b_shd.* FROM shd_file
#      WHERE shd01= g_shd01 AND shd02=l_shd02
#  ELSE 
#     LET b_shd.shd01= g_shd01   
#     LET b_shd.shd02= g_shd_t.shd02   
#     LET b_shd.shd03= g_shd_t.shd03   
#     LET b_shd.shd04= g_shd_t.shd04   
#     LET b_shd.shd05= g_shd_t.shd05   
#     LET b_shd.shd06= g_shd_t.shd06   
#     LET b_shd.shd07= g_shd_t.shd07   
#     LET b_shd.shd16= g_shd_t.shd16     #FUN-BB0084  
#     #FUN-580029  --begin
#     LET b_shd.shd13= g_shd_t.shd13   
#     LET b_shd.shd14= g_shd_t.shd14   
#     LET b_shd.shd15= g_shd_t.shd15   
#     LET b_shd.shd10= g_shd_t.shd10   
#     LET b_shd.shd11= g_shd_t.shd11   
#     LET b_shd.shd12= g_shd_t.shd12   
#     LET b_shd.shd18= g_shd_t.shd18     #FUN-CB0087
#     #FUN-580029  --end
#  END IF 
# 
#  MESSAGE 't701_s1() read no:',b_shd.shd02 USING '#####&',' parts: ',
#          b_shd.shd06 CLIPPED
#  IF cl_null(b_shd.shd06) THEN LET g_success='N' RETURN  END IF
# 
#  SELECT img09,img21 INTO l_img09,l_img21 FROM img_file
#   WHERE img01=b_shd.shd06 AND img02=b_shd.shd03
#     AND img03=b_shd.shd04 AND img04=b_shd.shd05
# 
#  #FUN-580029  --begin
#  IF g_sma.sma115 = 'Y' THEN
#     IF b_shd.shd12 != 0 OR b_shd.shd15 != 0 THEN 
#        CALL t701_update_du(l_cmd)
#        IF g_success='N' THEN RETURN END IF
#     END IF 
#  END IF 
#  #FUN-580029  --end
#  CALL t701_update(l_cmd,b_shd.shd03,b_shd.shd04,b_shd.shd05,
#                  #b_shd.shd07,l_img09,l_img21)     #MOD-B30235 mark
#                   b_shd. shd07,l_img09,1)           #MOD-B30235 add
# 
#  IF g_success='N' THEN RETURN END IF
#END FUNCTION
# 
#FUNCTION t701_update(p_cmd,p_ware,p_loca,p_lot,p_qty,p_uom,p_factor)
#  DEFINE p_cmd    LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
#  DEFINE p_ware   LIKE imd_file.imd01,         #No.FUN-680121 VARCHAR(10)#倉庫
#         p_loca   LIKE imd_file.imd01,         #No.FUN-680121 VARCHAR(10)#儲位 
#         p_lot    LIKE type_file.chr20,        #No.FUN-680121 VARCHAR(20)#批號   
#         p_qty    LIKE img_file.img10,         #No.FUN-680121 DECIMAL(15,3)#數量
#         p_factor LIKE ima_file.ima31_fac,     #No.FUN-680121 DECIMAL(16,8)#轉換率
#         u_type   LIKE type_file.num5,         #No.FUN-680121 SMALLINT# +1:雜收 -1:雜發  0:報廢
#         l_qty    LIKE img_file.img10,         #No.FUN-680121 DECIMAL(11,3)#異動後數量
#         l_a      LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)
#         l_ima25  LIKE ima_file.ima25,
##        l_imaqty LIKE ima_file.ima262,
#         l_imaqty LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
#         l_imafac LIKE img_file.img21, 
#         l_img RECORD
#               img10   LIKE img_file.img10,
#               img16   LIKE img_file.img16,
#               img23   LIKE img_file.img23,
#               img24   LIKE img_file.img24,
#               img09   LIKE img_file.img09,
#               img21   LIKE img_file.img21
#               END RECORD,
#         l_cnt  LIKE type_file.num5          #No.FUN-680121 SMALLINT
#  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
#  DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
#  DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131
#  DEFINE p_uom   LIKE ima_file.ima25   #TQC-B10221
# 
#    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
#    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
#    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
#    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
# 
#    IF p_uom IS NULL THEN
#       #CALL cl_err('p_uom null:','',1) LET g_success = 'N' RETURN
#       CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
#    END IF
##CHI-C60008 str mark------
###----------------------------------- update img_file
##   MESSAGE "update img_file ..."
##
##   LET g_forupd_sql = 
##       "SELECT img10,img16,img23,img24,img09,img21 FROM img_file",
##       " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? FOR UPDATE"
##   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
##   DECLARE img_lock CURSOR FROM g_forupd_sql
##
##   OPEN img_lock USING b_shd.shd06,p_ware,p_loca,p_lot
##   IF STATUS THEN
##      CALL cl_err("OPEN img_lock:", STATUS, 1)
##      CLOSE img_lock
##      LET g_success='N' 
##      RETURN
##   END IF
##   FETCH img_lock INTO l_img.*
##   IF STATUS THEN
##      CALL cl_err('lock img fail',STATUS,1) 
##      CLOSE img_lock
##      LET g_success='N' 
##      RETURN
##   END IF
##   IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
##   IF p_cmd = 'a'  THEN 
##      LET l_qty= l_img.img10 + p_qty    #下線庫存數量add 
##   ELSE  
##      LET l_qty= l_img.img10 - p_qty   
##   END IF 
##
##   IF p_cmd = 'a'  THEN 
##      LET u_type=+1    #入庫
##   ELSE 
##      LET u_type=-1    
##   END IF
##
##  #CALL s_upimg(l_img.x_u_type,p_qty*p_factor,g_today,    #FUN-8C0084
##   CALL s_upimg(b_shd.shd06,p_ware,p_loca,p_lot,u_type,p_qty*p_factor,g_today,    #FUN-8C0084
##        #'','','','','','','','','','','','','','','','','','')       #CHI-A30032 mark
##         '','','','',b_shd.shd01,b_shd.shd02,'','','','','','','','','','','','')   #No:CHI-A30032 add
##   IF g_success='N' THEN RETURN END IF
##
##------------------------------------------- update ima_file
##   MESSAGE "update ima_file ..."
##  
##   LET g_forupd_sql=
##       "SELECT ima25,ima86 FROM ima_file WHERE ima01= ? FOR UPDATE"
##
##   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
##   DECLARE ima_lock CURSOR FROM g_forupd_sql
##
##   OPEN ima_lock USING b_shd.shd06
##   IF STATUS THEN
##      CALL cl_err('lock ima fail',STATUS,1) 
##      CLOSE ima_lock
##      LET g_success='N' 
##      RETURN
##   END IF 
##
##   FETCH ima_lock INTO l_ima25,g_ima86
##   IF STATUS THEN
##      CALL cl_err('lock ima fail',STATUS,1) 
##      CLOSE ima_lock
##      LET g_success='N' 
##      RETURN
##   END IF
##
##   #shd modify by apple
##   IF p_uom=l_ima25 THEN
##      LET l_imafac = 1
##   ELSE
##      CALL s_umfchk(b_shd.shd06,p_uom,l_ima25)
##               RETURNING g_cnt,l_imafac 
##   #----單位換算率抓不到--------###  
##      IF g_cnt = 1 THEN 
##         CALL cl_err('','abm-731',1)
##         LET g_success ='N' 
##      END IF 
##   END IF
##   IF cl_null(l_imafac)  THEN LET l_imafac = 1 END IF
##   LET l_imaqty = p_qty * l_imafac
##   CALL s_udima(b_shd.shd06,l_img.img23,l_img.img24,l_imaqty,
##                g_today,u_type)  RETURNING l_cnt
##
##   IF g_success='N' THEN RETURN END IF
##
##   #shd 
##-------------------- insert/delete tlf_file ---------------------
##   MESSAGE "insert tlf_file ..."
##
##   IF g_success='Y'  THEN 
##      IF p_cmd = 'a'  THEN 
##         MESSAGE "insert tlf_file ..."
##         CALL t701_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,
##                        u_type)
##      ELSE 
##         MESSAGE "delete tlf_file ..."
## ##NO.FUN-8C0131   add--begin   
##           LET l_sql =  " SELECT  * FROM tlf_file ", 
##                        " WHERE tlf01 = '",g_shd_t.shd06,"'", 
##                        "   AND tlf902 = '",g_shd_t.shd03,"'",  
##                        "   AND tlf903 = '",g_shd_t.shd04,"'", 
##                        "   AND tlf904 = '",g_shd_t.shd05,"'",
##                        "   AND tlf905 = '",g_shd01,"'",
##                        "   AND tlf906 = '",g_shd_t.shd02,"'",
##                        "   AND AND tlf907 = '1' "     
##           DECLARE t701_u_tlf_c CURSOR FROM l_sql
##           LET l_i = 0 
##           CALL la_tlf.clear()
##           FOREACH t701_u_tlf_c INTO g_tlf.* 
##              LET l_i = l_i + 1
##              LET la_tlf[l_i].* = g_tlf.*
##           END FOREACH     
#
## ##NO.FUN-8C0131   add--end 
##         DELETE FROM tlf_file
##          WHERE tlf01  = g_shd_t.shd06
##            AND tlf902 = g_shd_t.shd03
##            AND tlf903 = g_shd_t.shd04
##            AND tlf904 = g_shd_t.shd05
##            AND tlf905 = g_shd01
##            AND tlf906 = g_shd_t.shd02
##            AND tlf907 = '1'
##         IF SQLCA.sqlcode THEN
##           LET INT_FLAG = 0  ######add for prompt bug
##            PROMPT 'delete tlf_file error ....' FOR CHAR l_a
##               ON IDLE g_idle_seconds
##                  CALL cl_on_idle()
##                   CONTINUE PROMPT
##            
##            END PROMPT
##            LET g_success = 'N'  RETURN 
##        #------------CHI-A30032 add
##         ELSE
##            IF g_ima918 = 'Y' OR g_ima921 = 'Y' THEN
##               DELETE FROM tlfs_file
##                WHERE tlfs01 = g_shd_t.shd06
##                  AND tlfs10 = g_shd01
##                  AND tlfs11 = g_shd_t.shd02
##                  AND tlfs111 = g_shb.shb03 
#
##                IF SQLCA.sqlcode THEN
##                   LET g_success = 'N'  RETURN 
##                END IF  
##            END IF 
##        #------------CHI-A30032 end
##         END IF
##   ##NO.FUN-8C0131   add--begin
##                FOR l_i = 1 TO la_tlf.getlength()
##                   LET g_tlf.* = la_tlf[l_i].*
##                   IF NOT s_untlf1('') THEN 
##                      LET g_success='N' RETURN
##                   END IF 
##                END FOR       
## ##NO.FUN-8C0131   add--end           
##      END IF
##   END IF
##   MESSAGE "seq#",b_shd.shd03 USING'<<<',' post ok!'
##CHI-C60008 end mark-----
#
#END FUNCTION
# 
#FUNCTION t701_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
#                  u_type)
#   DEFINE
#      p_ware  LIKE imd_file.imd01,       #No.FUN-680121 VARCHAR(10)#倉庫
#      p_loca  LIKE imd_file.imd01,       #No.FUN-680121 VARCHAR(10)#儲位 
#      p_lot   LIKE type_file.chr20,      #No.FUN-680121 VARCHAR(20)#批號   
#      p_qty   LIKE img_file.img10,       #No.FUN-680121 DECIMAL(11,3)#數量
#      p_factor LIKE ima_file.ima31_fac,  #No.FUN-680121 DECIMAL(16,8)#轉換率
#      p_unit  LIKE ima_file.ima25,       #單位
#      p_img10    LIKE img_file.img10,    #異動後數量
#      u_type     LIKE type_file.num5,    #No.FUN-680121 SMALLINT# +1:雜收 -1:雜發  0:報廢
#      l_sfb02    LIKE sfb_file.sfb02,
#      l_sfb03    LIKE sfb_file.sfb03,
#      l_sfb04    LIKE sfb_file.sfb04,
#      l_sfb22    LIKE sfb_file.sfb22,
#      l_sfb27    LIKE sfb_file.sfb27,
#      l_sta      LIKE type_file.num5,    #No.FUN-680121 SMALLINT
#      g_cnt      LIKE type_file.num5     #No.FUN-680121 SMALLINT
#  DEFINE p_uom   LIKE ima_file.ima25   #TQC-B10221
# 
#      INITIALIZE g_tlf.* TO NULL
#      LET g_tlf.tlf01=b_shd.shd06         #異動料件編號
##-----------------入庫-----------------------------------------
#      #----來源----
#      LET g_tlf.tlf02=60                  #來源狀況:工單製程當站下線
#      LET g_tlf.tlf026=b_shd.shd01        #來源單號
#      #---目的----
#      LET g_tlf.tlf03=50                  #stock:工單製程入庫
#      LET g_tlf.tlf030=g_plant            #工廠別
#      LET g_tlf.tlf031=p_ware             #倉庫
#      LET g_tlf.tlf032=p_loca             #儲位
#      LET g_tlf.tlf033=p_lot              #批號
#      LET g_tlf.tlf034=p_img10            #異動後數量
#      LET g_tlf.tlf035=p_unit             #庫存單位(ima_file or img_file)
#      LET g_tlf.tlf036=b_shd.shd01        #雜收單號
#      LET g_tlf.tlf037=b_shd.shd02        #雜收項次 
# 
#      LET g_tlf.tlf04= ' '             #工作站
#      LET g_tlf.tlf05= ' '             #作業序號
#      LET g_tlf.tlf06=g_shb.shb03      #報工日期
#      LET g_tlf.tlf07=g_today          #異動資料產生日期  
#      LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
#      LET g_tlf.tlf09=g_user           #產生人
#      LET g_tlf.tlf10=p_qty            #異動數量
#      LET g_tlf.tlf11=p_uom            #發料單位
#      LET g_tlf.tlf12=p_factor         #發料/庫存 換算率
#      LET g_tlf.tlf13='asft700'
#      LET g_tlf.tlf14=' '              #異動原因
#      LET g_tlf.tlf17=' '              #Remark
#      LET g_tlf.tlf19=g_shb.shb07      #工作中心 
#      LET g_tlf.tlf20=' '              #Project code
#      LET g_tlf.tlf61= g_ima86
#      LET g_tlf.tlf62=g_shb.shb05      #參考單號
#      LET g_tlf.tlf902 = b_shd.shd03 
#      LET g_tlf.tlf903 = b_shd.shd04 
#      LET g_tlf.tlf904 = b_shd.shd05 
#      LET g_tlf.tlf905 = b_shd.shd01 
#      LET g_tlf.tlf906 = b_shd.shd02 
#      LET g_tlf.tlf907 = '1'
#      #FUN-670103...............begin
#      IF g_aaz.aaz90='Y' THEN
#         SELECT sfb98 INTO g_tlf.tlf930 FROM sfb_file
#                                       WHERE sfb01=g_shb.shb05
#         IF SQLCA.sqlcode THEN
#            LET g_tlf.tlf930=NULL
#         END IF
#      END IF
#      #FUN-670103...............end
#      CALL s_tlf(1,0)                  #insert tlf_file 
#END FUNCTION
##No.FUN-570110--begin  
#FUN-D40092--mark--end----                                                         
 
FUNCTION t701_set_entry_b(p_cmd)                                                
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680121 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("shd02",TRUE)                                       
   END IF                                                                       
   CALL cl_set_comp_entry("shd10,shd11,shd12,shd13,shd14,shd15",TRUE)
END FUNCTION                                                                    
                                                                                
FUNCTION t701_set_no_entry_b(p_cmd)                                             
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680121 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("shd02",FALSE)                                      
   END IF                                                                       
   #No.FUN-580029  --begin
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("shd13,shd14,shd15",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("shd13",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("shd14,shd11",FALSE)
   END IF
   #No.FUN-580029  --end
END FUNCTION                                                                    
#No.FUN-570110--end           
 
#FUN-580029  --begin
FUNCTION t701_set_required()
   #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
   #No.TQC-5C0035  --Begin
   IF g_ima906 = '3' THEN                                                     
      #CALL cl_set_comp_required("shd13,shd14,shd15,shd10,shd11,shd12",TRUE)                                    
      CALL cl_set_comp_required("shd13,shd15,shd10,shd12",TRUE)                                    
   END IF
   #單位不同,轉換率,數量必KEY
   IF NOT cl_null(g_shd[l_ac].shd10) THEN
      #CALL cl_set_comp_required("shd11,shd12",TRUE)   
      CALL cl_set_comp_required("shd12",TRUE)   
   END IF
   IF NOT cl_null(g_shd[l_ac].shd13) THEN
      #CALL cl_set_comp_required("shd14,shd15",TRUE)
      CALL cl_set_comp_required("shd15",TRUE)
   END IF                                                    
   #No.TQC-5C0035  --End  
END FUNCTION
 
FUNCTION t701_set_no_required()                                                 
                                                                                
  CALL cl_set_comp_required("shd13,shd14,shd15,shd10,shd11,shd12",FALSE)                                      
                                                                                
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION t701_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            p_cmd    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac       #No.FUN-680121 DECIMAL(16,8)
 
    LET l_item = g_shd[l_ac].shd06
 
    SELECT ima906,ima907
      INTO l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',g_img09,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2 = 0
    END IF
    
    LET l_unit1 = g_img09
    LET l_fac1  = 1
    LET l_qty1  = 0
    
    IF p_cmd = 'a' THEN
       LET g_shd[l_ac].shd13=l_unit2 
       LET g_shd[l_ac].shd14=l_fac2  
       LET g_shd[l_ac].shd15=l_qty2  
       LET g_shd[l_ac].shd10=l_unit1 
       LET g_shd[l_ac].shd11=l_fac1  
       LET g_shd[l_ac].shd12=l_qty1  
    END IF
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t701_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE shd_file.shd14,
            l_qty2   LIKE shd_file.shd15,
            l_fac1   LIKE shd_file.shd11,
            l_qty1   LIKE shd_file.shd12,
            l_factor LIKE ima_file.ima31_fac        #No.FUN-680121 DECIMAL(16,8)
 
    #No.MOD-590120  --begin
    IF g_sma.sma115='N' THEN RETURN END IF
    #No.MOD-590120  --end  
    LET l_fac2=g_shd[l_ac].shd14
    LET l_qty2=g_shd[l_ac].shd15
    LET l_fac1=g_shd[l_ac].shd11
    LET l_qty1=g_shd[l_ac].shd12
    
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_shd[l_ac].shd07=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2 
                   LET g_shd[l_ac].shd07=l_tot
          WHEN '3' LET g_shd[l_ac].shd07=l_qty1
                   IF l_qty2 <> 0 THEN                                          
                      LET g_shd[l_ac].shd14=l_qty1/l_qty2                      
                   ELSE                                                         
                      LET g_shd[l_ac].shd14=0                                  
                   END IF
       END CASE
       LET g_shd[l_ac].shd07 = s_digqty(g_shd[l_ac].shd07,g_shd[l_ac].shd16)   #FUN-BB0084 
       DISPLAY BY NAME g_shd[l_ac].shd07                                       #FUN-BB0084
    #No.MOD-590120  --begin
    #ELSE  #不使用雙單位
    #   LET g_shd[l_ac].shd07=l_qty1
    #No.MOD-590120  --end  
    END IF
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t701_du_data_to_correct()
 
   IF cl_null(g_shd[l_ac].shd10) THEN 
      LET g_shd[l_ac].shd11 = NULL
      LET g_shd[l_ac].shd12 = NULL
   END IF
   
   IF cl_null(g_shd[l_ac].shd13) THEN 
      LET g_shd[l_ac].shd14 = NULL
      LET g_shd[l_ac].shd15 = NULL
   END IF   
 
   DISPLAY BY NAME g_shd[l_ac].shd11
   DISPLAY BY NAME g_shd[l_ac].shd12
   DISPLAY BY NAME g_shd[l_ac].shd14
   DISPLAY BY NAME g_shd[l_ac].shd15
 
END FUNCTION

#FUN-D40092--mark--begin---
#FUNCTION t701_update_du(p_cmd)
#DEFINE u_type    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#       p_cmd     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
# 
#   IF g_sma.sma115 = 'N' THEN RETURN END IF
#   
#    IF p_cmd = 'a'  THEN 
#       LET u_type=+1    #入庫
#    ELSE 
#       LET u_type=-1    
#    END IF
# 
#   SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
#    WHERE ima01 = b_shd.shd06
#   IF SQLCA.sqlcode THEN
#      LET g_success='N' RETURN
#   END IF
#   IF g_ima906 = '2' THEN  #子母單位
#      IF NOT cl_null(b_shd.shd13) THEN 
#         CALL t701_upd_imgg('1',b_shd.shd06,b_shd.shd03,b_shd.shd04,
#                         b_shd.shd05,b_shd.shd13,b_shd.shd14,b_shd.shd15,u_type,'2')
#         IF g_success='N' THEN RETURN END IF
#         IF p_cmd = 'a' THEN
#            IF NOT cl_null(b_shd.shd15) AND b_shd.shd15 <> 0 THEN  
#               CALL t701_tlff(b_shd.shd03,b_shd.shd04,b_shd.shd05,g_img09,
#                              b_shd.shd15,0,b_shd.shd13,b_shd.shd14,u_type,'2')
#               IF g_success='N' THEN RETURN END IF
#            END IF
#         END IF
#      END IF
#      IF NOT cl_null(b_shd.shd10) THEN 
#         CALL t701_upd_imgg('1',b_shd.shd06,b_shd.shd03,b_shd.shd04,
#                            b_shd.shd05,b_shd.shd10,b_shd.shd11,b_shd.shd12,u_type,'1')
#         IF g_success='N' THEN RETURN END IF
#         IF p_cmd = 'a' THEN
#            IF NOT cl_null(b_shd.shd12) AND b_shd.shd12 <> 0 THEN  
#               CALL t701_tlff(b_shd.shd03,b_shd.shd04,b_shd.shd05,g_img09,
#                           b_shd.shd12,0,b_shd.shd10,b_shd.shd11,u_type,'1')
#               IF g_success='N' THEN RETURN END IF
#            END IF
#         END IF
#      END IF
#      IF p_cmd = 'd' THEN
#         CALL t701_tlff_w()
#         IF g_success='N' THEN RETURN END IF
#      END IF
#   END IF
#   IF g_ima906 = '3' THEN  #參考單位
#      IF NOT cl_null(b_shd.shd13) THEN 
#         CALL t701_upd_imgg('2',b_shd.shd06,b_shd.shd03,b_shd.shd04,
#                            b_shd.shd05,b_shd.shd13,b_shd.shd14,b_shd.shd15,u_type,'2')
#         IF g_success = 'N' THEN RETURN END IF
#         IF p_cmd = 'a' THEN
#            IF NOT cl_null(b_shd.shd15) AND b_shd.shd15 <> 0 THEN  
#               CALL t701_tlff(b_shd.shd03,b_shd.shd04,b_shd.shd05,g_img09,
#                              b_shd.shd15,0,b_shd.shd13,b_shd.shd14,u_type,'2')
#               IF g_success='N' THEN RETURN END IF
#            END IF
#         END IF
#      END IF
#      #No.CHI-770019  --Begin
#      #IF NOT cl_null(b_shd.shd10) AND p_cmd = 'a' THEN
#      #   IF NOT cl_null(b_shd.shd12) AND b_shd.shd12 <> 0 THEN  
#      #      CALL t701_tlff(b_shd.shd03,b_shd.shd04,b_shd.shd05,g_img09,
#      #                     b_shd.shd12,0,b_shd.shd10,b_shd.shd11,u_type,'1')
#      #      IF g_success='N' THEN RETURN END IF
#      #   END IF
#      #END IF
#      #No.CHI-770019  --End  
#      IF p_cmd = 'd' THEN
#         CALL t701_tlff_w()
#         IF g_success='N' THEN RETURN END IF
#      END IF
#   END IF
# 
#END FUNCTION
# 
#FUNCTION t701_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
#                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no)
#  DEFINE p_imgg00   LIKE imgg_file.imgg00,
#         p_imgg01   LIKE imgg_file.imgg01,
#         p_imgg02   LIKE imgg_file.imgg02,
#         p_imgg03   LIKE imgg_file.imgg03,
#         p_imgg04   LIKE imgg_file.imgg04,
#         p_imgg09   LIKE imgg_file.imgg09,
#         p_imgg10   LIKE imgg_file.imgg10,
#         p_imgg211  LIKE imgg_file.imgg211,
#         l_ima25    LIKE ima_file.ima25,                                        
#         l_ima906   LIKE ima_file.ima906,
#         l_imgg21   LIKE imgg_file.imgg21,
#         p_no       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#         p_type     LIKE type_file.num10          #No.FUN-680121 INTEGER
# 
#    LET g_forupd_sql =
#        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
#        "  WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
#        "   AND imgg09= ? FOR UPDATE "
# 
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE imgg_lock CURSOR FROM g_forupd_sql
# 
#    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
#    IF STATUS THEN
#       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
#       LET g_success='N' 
#       CLOSE imgg_lock
##       ROLLBACK WORK  #No.TQC-930155
#       RETURN
#    END IF
#    FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
#    IF STATUS THEN
#       CALL cl_err('lock imgg fail',STATUS,1) 
#       LET g_success='N' 
#       CLOSE imgg_lock
##       ROLLBACK WORK  #No.TQC-930155
#       RETURN
#    END IF
# 
#    SELECT ima25,ima906 INTO l_ima25,l_ima906 
#      FROM ima_file WHERE ima01=p_imgg01                
#    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN                                    
#       CALL cl_err('ima25 null',SQLCA.sqlcode,0)                                
#       LET g_success = 'N' RETURN                                               
#    END IF                                                                      
#                                                                                
#    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)                                    
#          RETURNING g_cnt,l_imgg21                                              
#    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN                                                           
#       CALL cl_err('','mfg3075',0)                                              
#       LET g_success = 'N' RETURN                                               
#    END IF  
#   #CALL s_upimgg(l_p_type,p_imgg10,g_today,  #FUN-8C0084
#    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_today,  #FUN-8C0084
#          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
#    IF g_success='N' THEN RETURN END IF
#    
#END FUNCTION
# 
#FUNCTION t701_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
#                   u_type,p_flag)
#DEFINE
##  l_ima262   LIKE ima_file.ima262,
#   l_avl_stk  LIKE type_file.num15_3,
#   l_ima25    LIKE ima_file.ima25,
#   l_ima55    LIKE ima_file.ima55,
#   l_ima86    LIKE ima_file.ima86,
#   p_ware     LIKE img_file.img02,	 ##倉庫
#   p_loca     LIKE img_file.img03,	 ##儲位 
#   p_lot      LIKE img_file.img04,     	 ##批號   
#   p_unit     LIKE img_file.img09,
#   p_qty      LIKE img_file.img10,       ##數量
#   p_img10    LIKE img_file.img10,       ##異動後數量
#   l_imgg10   LIKE imgg_file.imgg10,     
#   p_uom      LIKE img_file.img09,       ##img 單位
#   p_factor   LIKE img_file.img21,  	 ##轉換率
#   u_type     LIKE type_file.num5,          #No.FUN-680121 INTEGER##+1:雜收 -1:雜發  0:報廢
#   p_flag     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#   g_cnt      LIKE type_file.num5           #No.FUN-680121 INTEGER
# 
##  CALL s_getima(b_shd.shd06) RETURNING l_ima262,l_ima25,l_ima55,l_ima86
#   CALL s_getima(b_shd.shd06) RETURNING l_avl_stk,l_ima25,l_ima55,l_ima86
#   
#   IF cl_null(p_ware) THEN LET p_ware=' ' END IF
#   IF cl_null(p_loca) THEN LET p_loca=' ' END IF
#   IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
#   IF cl_null(p_qty)  THEN LET p_qty=0    END IF
#   
#   IF p_uom IS NULL THEN
#      CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
#   END IF
#   SELECT imgg10 INTO l_imgg10 FROM imgg_file                                  
#     WHERE imgg01=b_shd.shd06 AND imgg02=p_ware                                 
#       AND imgg03=p_loca      AND imgg04=p_lot                                  
#       AND imgg09=p_uom                                                         
#    IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF  
#   INITIALIZE g_tlff.* TO NULL
#    
#   LET g_tlff.tlff01=b_shd.shd06         #異動料件編號
#   LET g_tlff.tlff01=b_shd.shd06         #異動料件編號
##-----------------入庫-----------------------------------------
#   #----來源----
#   LET g_tlff.tlff02=60                  #來源狀況:工單製程當站下線
#   LET g_tlff.tlff026=b_shd.shd01        #來源單號
#   #---目的----
#   LET g_tlff.tlff03=50                  #stock:工單製程入庫
#   LET g_tlff.tlff030=g_plant            #工廠別
#   LET g_tlff.tlff031=p_ware             #倉庫
#   LET g_tlff.tlff032=p_loca             #儲位
#   LET g_tlff.tlff033=p_lot              #批號
#   LET g_tlff.tlff034=l_imgg10           #異動後數量
#   LET g_tlff.tlff035=p_unit             #庫存單位(ima_file or img_file)
#   LET g_tlff.tlff036=b_shd.shd01        #雜收單號
#   LET g_tlff.tlff037=b_shd.shd02        #雜收項次 
# 
#   LET g_tlff.tlff04= ' '             #工作站
#   LET g_tlff.tlff05= ' '             #作業序號
#   LET g_tlff.tlff06=g_shb.shb03      #報工日期
#   LET g_tlff.tlff07=g_today          #異動資料產生日期  
#   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
#   LET g_tlff.tlff09=g_user           #產生人
#   LET g_tlff.tlff10=p_qty            #異動數量
#   LET g_tlff.tlff11=p_uom            #發料單位
#   LET g_tlff.tlff12=p_factor         #發料/庫存 換算率
#   LET g_tlff.tlff13='asft700'
#   LET g_tlff.tlff14=' '              #異動原因
#   LET g_tlff.tlff17=' '              #Remark
#   LET g_tlff.tlff19=g_shb.shb07      #工作中心 
#   LET g_tlff.tlff20=' '              #Project code
#   LET g_tlff.tlff61= g_ima86
#   LET g_tlff.tlff62=g_shb.shb05      #參考單號
#   LET g_tlff.tlff902 = b_shd.shd03 
#   LET g_tlff.tlff903 = b_shd.shd04 
#   LET g_tlff.tlff904 = b_shd.shd05 
#   LET g_tlff.tlff905 = b_shd.shd01 
#   LET g_tlff.tlff906 = b_shd.shd02 
#   LET g_tlff.tlff907 = '1'
#   #FUN-670103...............begin
#   IF g_aaz.aaz90='Y' THEN
#      SELECT sfb98 INTO g_tlff.tlff930 FROM sfb_file
#                                      WHERE sfb01=g_shb.shb05
#      IF SQLCA.sqlcode THEN
#         LET g_tlff.tlff930=NULL
#      END IF
#   END IF
#   #FUN-670103...............end
#   IF cl_null(b_shd.shd15) OR b_shd.shd15=0 THEN 
#      CALL s_tlff(p_flag,NULL)
#   ELSE
#      CALL s_tlff(p_flag,b_shd.shd13)
#   END IF
#END FUNCTION
# 
#FUNCTION t701_tlff_w()                                                            
#                                                                                
#    MESSAGE "d_tlff!"                                                           
#    CALL ui.Interface.refresh()                                                 
#                                                                                
#    DELETE FROM tlff_file                                                       
#     WHERE tlff01 =b_shd.shd06                                                  
#       AND tlff902 = g_shd_t.shd03
#       AND tlff903 = g_shd_t.shd04
#       AND tlff904 = g_shd_t.shd05
#       AND tlff905 = g_shd01
#       AND tlff906 = g_shd_t.shd02
#       AND tlff907 = '1'
#                                                                                
#    IF STATUS THEN                                                              
#       CALL cl_err('del tlff:',STATUS,1) LET g_success='N' RETURN               
#    END IF                                                                      
#END FUNCTION   
##FUN-580018  --end 
#FUN-D40092--mark--end-----
 
#-----FUN-610006---------
FUNCTION t701_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("shd13,shd15,shd10,shd12",FALSE)
   #  CALL cl_set_comp_visible("shd07",TRUE)
      CALL cl_set_comp_visible("shd07,shd16",TRUE)            #FUN-BB0084  
   ELSE
      CALL cl_set_comp_visible("shd13,shd15,shd10,shd12",TRUE)
   #  CALL cl_set_comp_visible("shd07",FALSE)
      CALL cl_set_comp_visible("shd07,shd16",FALSE)           #FUN-BB0084 
   END IF
   CALL cl_set_comp_visible("shd14,shd11",FALSE)
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("shd13",g_msg CLIPPED)   
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("shd15",g_msg CLIPPED)   
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("shd10",g_msg CLIPPED)   
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("shd12",g_msg CLIPPED)   
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("shd13",g_msg CLIPPED)   
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("shd15",g_msg CLIPPED)   
      CALL cl_getmsg('asm-404',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("shd10",g_msg CLIPPED)   
      CALL cl_getmsg('asm-405',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("shd12",g_msg CLIPPED)   
   END IF
   IF g_aza.aza115='Y' THEN CALL cl_set_comp_required("shd18",TRUE) END IF  #FUN-CB0087 add
END FUNCTION 
#-----END FUN-610006-----

#TQC-C20031 add
FUNCTION t701_chk_lotin()
DEFINE l_flag   LIKE type_file.chr1
DEFINE l_shd    RECORD LIKE shd_file.*
DEFINE l_ima918 LIKE ima_file.ima918
DEFINE l_ima921 LIKE ima_file.ima921
DEFINE l_rvbs06 LIKE rvbs_file.rvbs06

   LET l_flag = 0
   #Cehck 單身 料倉儲批是否存在 img_file
   DECLARE t701_chk_lotin CURSOR FOR SELECT * FROM shd_file
                                      WHERE shd01=g_shd01
   FOREACH t701_chk_lotin INTO l_shd.*

      SELECT ima918,ima921 INTO l_ima918,l_ima921
        FROM ima_file
       WHERE ima01 = l_shd.shd06
         AND imaacti = "Y"

      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         SELECT SUM(rvbs06) INTO l_rvbs06
           FROM rvbs_file
          WHERE rvbs00 = g_prog
            AND rvbs01 = l_shd.shd01
            AND rvbs02 = l_shd.shd02
            AND rvbs09 = 1
            AND rvbs13 = 0

         IF cl_null(l_rvbs06) THEN
            LET l_rvbs06 = 0
         END IF

         IF l_shd.shd07  <> l_rvbs06 THEN
            LET l_flag = 1
            CALL cl_err(l_shd.shd02||'-'||l_shd.shd06,"aim-011",1)
            EXIT FOREACH
         END IF
      END IF
   END FOREACH
   RETURN l_flag

END FUNCTION
#TQC-C20031 add--end

#FUN-CB0087--add--str--
FUNCTION t701_shd18_check() #TQC-D10074
DEFINE l_flag        LIKE type_file.chr1       
DEFINE l_where       STRING                    
DEFINE l_sql         STRING                    
DEFINE l_n           LIKE type_file.num5
DEFINE l_shb  RECORD LIKE shb_file.*

   LET l_flag = FALSE 
   IF cl_null(g_shd[l_ac].shd18) THEN RETURN TRUE END IF 
   SELECT * INTO l_shb.* FROM shb_file WHERE shb01 = g_shd01 
   IF g_aza.aza115='Y' THEN 
      CALL s_get_where(l_shb.shb01,l_shb.shb05,'',g_shd[l_ac].shd06,g_shd[l_ac].shd03,l_shb.shb04,'') RETURNING l_flag,l_where
   END IF 
   IF g_aza.aza115='Y' AND l_flag THEN
      LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_shd[l_ac].shd18,"' AND ",l_where
      PREPARE ggc08_pre1 FROM l_sql
      EXECUTE ggc08_pre1 INTO l_n
      IF l_n < 1 THEN
         CALL cl_err(g_shd[l_ac].shd18,'aim-425',1)
         RETURN FALSE 
      END IF
   ELSE 
      SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_shd[l_ac].shd18 AND azf02='2'
      IF l_n < 1 THEN
         CALL cl_err(g_shd[l_ac].shd18,'aim-425',1)
         RETURN FALSE
      END IF
   END IF  
   RETURN TRUE 
END FUNCTION 
#FUN-CB0087--add--end--
