# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi100.4gl
# Descriptions...: 工程BOM模擬維護作業
# Date & Author..: 94/05/27 By Apple
# Modify.........: 99/12/31 By Kammy 1.加版本 2.加 E-BOM複製
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.MOD-480012 04/07/29 Kammy b_fill .ora修正
# Modify.........: No.MOD-480233 04/08/10 PROMPT的寫法 改為 cl_confirm
# Modify.........: No.MOD-480362 04/08/16 abmi104於單身存檔後呼叫
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0054 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.MOD-4C0087 04/12/15 By DAY   P-BOM時INSERT出錯
# Modify.........: No.FUN-550095 05/06/02 By Mandy 特性BOM
# Modify.........: No.FUN-560027 05/06/08 By Mandy 1.特性BOM+KEY 值bmo06,bmp28
# Modify.........: No.FUN-560027 05/06/08 By Mandy 2.單身加bmp29計算方式
# Modify.........: No.MOD-550153 05/05/23 By Mandy 1.單身未執行完abmi101(維護說明),結果游標就進入下一列
# Modify.........: No.MOD-550153 05/05/23 By Mandy 2.執行修改插件位置及明細單身資料後,單身所show 的資料還是舊的
# Modify.........: No.FUN-560130 05/06/20 By pengu  功能鍵[E-BOM與P-BOM複製原主件料號開窗選擇主件料號編號後,按[確定]即跳離程式
# Modify.........: No.FUN-560115 05/06/20 By kim 在未使用特性BOM時,畫面不要出現計算方式
# Modify.........: No.FUN-580024 05/08/10 By Sarah 在複製裡增加set_entry段
# Modify.........: No.FUN-5B0068 05/11/10 By Claire 在更改項次時,也要同步修正插次時,也要同步修正插件位置的key(bmu02)
# Modify.........: No.FUN-5B0126 05/11/24 By Claire 單身的插件位置會因修改項次清空
# Modify.........: No.MOD-660016 06/06/07 By Claire 單身項次新增有問題 
# Modify.........: No.TQC-660046 06/06/23 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION i100_q() 一開始應清空g_bmo.*值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By hellen 新增單頭折疊功能
# Modify.........: No.MOD-6B0038 06/12/13 By pengu 單身輸入料件，應於料件輸入後同時帶出品名規格及單位
# Modify.........: No.MOD-6C0064 06/12/14 By Sarah 單身輸入正式料號且為消耗性料件，要將單身明細的消耗特性default為Y
# Modify.........: No.TQC-6C0060 07/01/08 By alexstar 多語言功能單純化
# Modify.........: No.TQC-710105 07/02/28 By Ray 單身"組件料件"字段錄入任何值，光標移到"作業編號"字段才報無此料件的錯誤
# Modify.........: No.TQC-720019 07/03/02 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.MOD-720079 07/03/02 By pengu 查詢若單身下條件時，查出的資料會異常
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720053 07/03/20 By ay TQC-710105不需調整
# Modify.........: No.FUN-730075 07/03/30 By kim 行業別架構
# Modify.........: No.MOD-740089 07/04/23 By Carol 在登打單身完成一筆時可開窗輸入產品結構說明資料
# Modify.........: No.TQC-740182 07/04/23 By Carol insert into bmp_file 前給 bmp04,bmp05 default = null
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.MOD-790117 07/09/21 By Carol bmp04 給預設值=0
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/16 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810058 08/03/24 By Pengu [P-BOM複製]功能之新主件料號開窗查詢資料應為bmq_file
# Modify.........: No.FUN-840042 08/04/14 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-840405 08/04/21 By Carol 料件合理性檢查add call i100_bmp03()
# Modify.........: No.MOD-850265 08/05/27 By claire 單身的測試料號查詢應排除無效及已轉正式料的測試料
# Modify.........: No.TQC-870018 08/07/11 By Jerry 修正若程式寫法為SELECT .....寫法會出現ORA-600的錯誤
# Modify.........: No.MOD-870162 08/07/14 By claire  計算bmq10_fac,bmq10_fac2的換算率
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.CHI-910021 09/01/15 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-920043 09/02/04 By jan 若項次編號有異動,則取替代檔一并更新
# Modify.........: No.MOD-920088 09/02/05 By claire bmp02加入條件
# Modify.........: No.TQC-920094 09/02/25 By chenyu 資料無效時，不可以刪除
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-980004 09/10/14 By baofei bmp04應該給NULL而不是0 
# Modify.........: No:TQC-9A0117 09/10/23 By liuxqa 替换OUTER
# Modify.........: No:MOD-990253 09/11/10 By Pengu bmp17未給值
# Modify.........: No:TQC-9B0124 09/11/18 By Carrier 恢复 TQC-980004的修改,要和abmi103的判断一起结合起来才行
# Modify.........: No:FUN-9C0077 09/12/15 By baofei 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/22 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AB0025 10/11/05 By vealxu 拿掉FUN-AA0059 料號管控，測試料件無需判斷 
# Modify.........: No.FUN-ABOO25 10/11/05 By lixh1 拿掉FUN-AA0059 系統開窗管控 
# Modify.........: No.FUN-ABOO25 10/11/11 By lixh1 还原FUN-AA0059 系統開窗管控
# Modify.........: No.TQC-AB0052 10/11/14 By destiny 查询时不能在orig,oriu下条件
# Modify.........: No.TQC-AC0183 10/12/16 By liweie  單身損耗率(bmp08)更名為變動損耗率,單身新增bmp081,bmp082字段
# Modify.........: No.TQC-AC0274 10/12/20 By destiny 元件料件栏位可以录入无效资料    
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-BB0086 11/12/08 By tanxc 增加數量欄位小數取位
# Modify.........: No.TQC-C50030 12/05/07 By lixh1 修改單身'原件料號'欄位的開窗
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C80041 12/11/29 By bart 刪除單頭時，一併刪除相關table
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bmo           RECORD LIKE bmo_file.*,  #主件料件(假單頭)
    g_bmo_t         RECORD LIKE bmo_file.*,  #主件料件(舊值)
    g_bmo_o         RECORD LIKE bmo_file.*,  #主件料件(舊值)
    g_bmo01_t       LIKE bmo_file.bmo01,     #(舊值)
    g_bmo06_t       LIKE bmo_file.bmo06,     #FUN-560027
    g_bmo011_t      LIKE bmo_file.bmo011,    #(舊值)
    g_bmp10_fac_t   LIKE bmp_file.bmp10_fac, #(舊值)
    g_ima08_h       LIKE ima_file.ima08,     #來源碼
    g_ima37_h       LIKE ima_file.ima37,     #補貨政策
    g_ima08_b       LIKE ima_file.ima08,     #來源碼
    g_ima37_b       LIKE ima_file.ima37,     #補貨政策
    g_ima25_b       LIKE ima_file.ima25,     #庫存單位
    g_ima63_b       LIKE ima_file.ima63,     #發料單位
    g_ima70_b       LIKE ima_file.ima63,     #消秏料件
    g_ima86_b       LIKE ima_file.ima86,     #成本單位
    g_bmp           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
                    bmp02    LIKE bmp_file.bmp02,    #元件項次
                    bmp03    LIKE bmp_file.bmp03,    #元件料件
                    ima02_b  LIKE ima_file.ima02,    #品名
                    ima021_b LIKE ima_file.ima021,   #規格
                    ima05_b  LIKE ima_file.ima05,    #版本
                    ima08_b  LIKE ima_file.ima08,    #來源
                    bmp09    LIKE bmp_file.bmp09,    #作業編號
                    bmp16    LIKE bmp_file.bmp16,    #取替代
                    bmp29    LIKE bmp_file.bmp29,    #FUN-560027 add
                    bmp06    LIKE bmp_file.bmp06,    #組成用量
                    bmp07    LIKE bmp_file.bmp07,    #底數
                    bmp10    LIKE bmp_file.bmp10,    #發料單位
                    bmp13    LIKE bmp_file.bmp13,    #插件位置
                    bmp08    LIKE bmp_file.bmp08,    #變動損耗率  #TQC-AC0183 
                    bmp081   LIKE bmp_file.bmp081,   #固定損耗量  #TQC-AC0183 
                    bmp082   LIKE bmp_file.bmp082,   #損耗批量    #TQC-AC0183  
                    bmpud01  LIKE bmp_file.bmpud01,
                    bmpud02  LIKE bmp_file.bmpud02,
                    bmpud03  LIKE bmp_file.bmpud03,
                    bmpud04  LIKE bmp_file.bmpud04,
                    bmpud05  LIKE bmp_file.bmpud05,
                    bmpud06  LIKE bmp_file.bmpud06,
                    bmpud07  LIKE bmp_file.bmpud07,
                    bmpud08  LIKE bmp_file.bmpud08,
                    bmpud09  LIKE bmp_file.bmpud09,
                    bmpud10  LIKE bmp_file.bmpud10,
                    bmpud11  LIKE bmp_file.bmpud11,
                    bmpud12  LIKE bmp_file.bmpud12,
                    bmpud13  LIKE bmp_file.bmpud13,
                    bmpud14  LIKE bmp_file.bmpud14,
                    bmpud15  LIKE bmp_file.bmpud15
                    END RECORD,
    g_bmp_t         RECORD                 #程式變數 (舊值)
                    bmp02    LIKE bmp_file.bmp02,    #元件項次
                    bmp03    LIKE bmp_file.bmp03,    #元件料件
                    ima02_b  LIKE ima_file.ima02,    #品名
                    ima021_b LIKE ima_file.ima021,   #規格
                    ima05_b  LIKE ima_file.ima05,    #版本
                    ima08_b  LIKE ima_file.ima08,    #來源
                    bmp09    LIKE bmp_file.bmp09,    #作業編號
                    bmp16    LIKE bmp_file.bmp16,    #取替代
                    bmp29    LIKE bmp_file.bmp29,    #FUN-560027 add
                    bmp06    LIKE bmp_file.bmp06,    #組成用量
                    bmp07    LIKE bmp_file.bmp07,    #底數
                    bmp10    LIKE bmp_file.bmp10,    #發料單位
                    bmp13    LIKE bmp_file.bmp13,    #插件位置
                    bmp08    LIKE bmp_file.bmp08,    #變動損耗率  #TQC-AC0183 
                    bmp081   LIKE bmp_file.bmp081,   #固定損耗量  #TQC-AC0183 
                    bmp082   LIKE bmp_file.bmp082,   #損耗批量    #TQC-AC0183 
                    bmpud01  LIKE bmp_file.bmpud01,
                    bmpud02  LIKE bmp_file.bmpud02,
                    bmpud03  LIKE bmp_file.bmpud03,
                    bmpud04  LIKE bmp_file.bmpud04,
                    bmpud05  LIKE bmp_file.bmpud05,
                    bmpud06  LIKE bmp_file.bmpud06,
                    bmpud07  LIKE bmp_file.bmpud07,
                    bmpud08  LIKE bmp_file.bmpud08,
                    bmpud09  LIKE bmp_file.bmpud09,
                    bmpud10  LIKE bmp_file.bmpud10,
                    bmpud11  LIKE bmp_file.bmpud11,
                    bmpud12  LIKE bmp_file.bmpud12,
                    bmpud13  LIKE bmp_file.bmpud13,
                    bmpud14  LIKE bmp_file.bmpud14,
                    bmpud15  LIKE bmp_file.bmpud15
                    END RECORD,
    g_bmp_o         RECORD                 #程式變數 (舊值)
                    bmp02    LIKE bmp_file.bmp02,    #元件項次
                    bmp03    LIKE bmp_file.bmp03,    #元件料件
                    ima02_b  LIKE ima_file.ima02,    #品名
                    ima021_b LIKE ima_file.ima021,   #規格
                    ima05_b  LIKE ima_file.ima05,    #版本
                    ima08_b  LIKE ima_file.ima08,    #來源
                    bmp09    LIKE bmp_file.bmp09,    #作業編號
                    bmp16    LIKE bmp_file.bmp16,    #取替代
                    bmp29    LIKE bmp_file.bmp29,    #FUN-560027 add
                    bmp06    LIKE bmp_file.bmp06,    #組成用量
                    bmp07    LIKE bmp_file.bmp07,    #底數
                    bmp10    LIKE bmp_file.bmp10,    #發料單位
                    bmp13    LIKE bmp_file.bmp13,    #插件位置
                    bmp08    LIKE bmp_file.bmp08,    #變動損耗率  #TQC-AC0183 
                    bmp081   LIKE bmp_file.bmp081,   #固定損耗量  #TQC-AC0183 
                    bmp082   LIKE bmp_file.bmp082,   #損耗批量    #TQC-AC0183  
                    bmpud01  LIKE bmp_file.bmpud01,
                    bmpud02  LIKE bmp_file.bmpud02,
                    bmpud03  LIKE bmp_file.bmpud03,
                    bmpud04  LIKE bmp_file.bmpud04,
                    bmpud05  LIKE bmp_file.bmpud05,
                    bmpud06  LIKE bmp_file.bmpud06,
                    bmpud07  LIKE bmp_file.bmpud07,
                    bmpud08  LIKE bmp_file.bmpud08,
                    bmpud09  LIKE bmp_file.bmpud09,
                    bmpud10  LIKE bmp_file.bmpud10,
                    bmpud11  LIKE bmp_file.bmpud11,
                    bmpud12  LIKE bmp_file.bmpud12,
                    bmpud13  LIKE bmp_file.bmpud13,
                    bmpud14  LIKE bmp_file.bmpud14,
                    bmpud15  LIKE bmp_file.bmpud15
                    END RECORD,
    g_bmp04         LIKE  bmp_file.bmp04,     #TQC-740182 add
    g_bmp05         LIKE  bmp_file.bmp05,
    g_bmp11         LIKE  bmp_file.bmp11,
    g_bmp13         LIKE  bmp_file.bmp13,
    g_bmp23         LIKE  bmp_file.bmp23,
    g_bmp10_fac     LIKE  bmp_file.bmp10_fac,
    g_bmp10_fac2    LIKE  bmp_file.bmp10_fac2,
    g_bmp15         LIKE  bmp_file.bmp15,
    g_bmp09         LIKE  bmp_file.bmp09,
    g_bmp18         LIKE  bmp_file.bmp18,
    g_bmp17         LIKE  bmp_file.bmp17,
    g_bmp27         LIKE  bmp_file.bmp27,
    g_bmp14         LIKE  bmp_file.bmp14,
    g_bmp20         LIKE  bmp_file.bmp20,
    g_bmp19         LIKE  bmp_file.bmp19,
    g_bmp21         LIKE  bmp_file.bmp21,
    g_bmp22         LIKE  bmp_file.bmp22,
    g_bmp25         LIKE  bmp_file.bmp25,
    g_bmp26         LIKE  bmp_file.bmp26,
    g_bmp11_o       LIKE  bmp_file.bmp11,
    g_bmp13_o       LIKE  bmp_file.bmp13,
    g_bmp23_o       LIKE  bmp_file.bmp23,
    g_bmp25_o       LIKE  bmp_file.bmp23,
    g_bmp26_o       LIKE  bmp_file.bmp23,
    g_bmp10_fac_o   LIKE  bmp_file.bmp10_fac,
    g_bmp10_fac2_o  LIKE  bmp_file.bmp10_fac2,
    g_bmp15_o       LIKE  bmp_file.bmp15,
    g_bmp09_o       LIKE  bmp_file.bmp09,
    g_bmp18_o       LIKE  bmp_file.bmp18,
    g_bmp17_o       LIKE  bmp_file.bmp17,
    g_bmp27_o       LIKE  bmp_file.bmp27,
    g_bmp14_o       LIKE  bmp_file.bmp14,
    g_bmp20_o       LIKE  bmp_file.bmp20,
    g_bmp19_o       LIKE  bmp_file.bmp19,
    g_bmp21_o       LIKE  bmp_file.bmp21,
    g_bmp22_o       LIKE  bmp_file.bmp22,
     g_sql               string,  #No.FUN-580092 HCN
     g_wc,g_wc2          string,  #No.FUN-580092 HCN
    g_vdate         LIKE type_file.dat,    #No.FUN-680096  DATE
    g_sw            LIKE type_file.num5,   #單位是否可轉換   #No.FUN-680096 SMALLINT
    g_factor        LIKE type_file.num20_6,#單位換算率   #No.FUN-680096 DEC(20,6)
    g_cmd           LIKE type_file.chr1000,#No.FUN-680096    VARCHAR(60)
    g_rec_b         LIKE type_file.num5,   #單身筆數     #No.FUN-680096 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT     #No.FUN-680096 SMALLINT
    l_sl            LIKE type_file.num5,   #目前處理的SCREEN LINE #No.FUN-680096 SMALLINT
    g_ima107        LIKE ima_file.ima107   #插件位置否 BugNo:6165 
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680096 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680096 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_chr           LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE g_msg           LIKE ze_file.ze03        #No.FUN-680096 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE g_no_ask       LIKE type_file.num5          #No.FUN-680096 SMALLINT
DEFINE b_bmp RECORD LIKE bmp_file.*  #FUN-730075
DEFINE g_bmp10_t       LIKE bmp_file.bmp10          #No.FUN-BB0086
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
    LET g_wc2=' 1=1'  #No.FUN-8B0123 add 
    LET g_forupd_sql =
    "SELECT * FROM bmo_file WHERE bmo01 = ? AND bmo06 = ? AND bmo011 = ? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW i100_w AT p_row,p_col WITH FORM "abm/42f/abmi100"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bmo06,bmp29",g_sma.sma118='Y') #FUN-560115
 
    LET g_bmp05 = NULL
 
    CALL i100_menu()
 
    CLOSE WINDOW i100_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION i100_curs()
DEFINE  lc_qbe_sn   LIKE gbm_file.gbm01     #No.FUN-580031  HCN
DEFINE  l_flag      LIKE type_file.chr1     #判斷單身是否給條件        #No.FUN-680096 VARCHAR(1)
 
    CLEAR FORM
   CALL g_bmp.clear()
	LET l_flag = 'N'
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0033
   INITIALIZE g_bmo.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON
        bmo01,bmo06,bmo011,bmo05,bmo04,bmouser,bmogrup,bmomodu,bmodate,bmoacti,  #FUN-560027 add bmo06
        bmoud01,bmoud02,bmoud03,bmoud04,bmoud05,
        bmoud06,bmoud07,bmoud08,bmoud09,bmoud10,
        bmoud11,bmoud12,bmoud13,bmoud14,bmoud15
        ,bmoorig,bmooriu                        #No.TQC-AB0052 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bmo01)
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_bmq"  #mark by guanyao160704
                  LET g_qryparam.form = "q_ima"   #add by guanyao160704 
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bmo01
                  NEXT FIELD bmo01
               #str----add by guanyao160704
               WHEN INFIELD(bmoud02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pja"    
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bmoud02
                  NEXT FIELD bmoud02
               #end----add by guanyao160704
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmouser', 'bmogrup')
 
 
    CONSTRUCT g_wc2 ON bmp02,bmp03,bmp16,bmp29,bmp06,bmp07,               #FUN-560027 add bmp29
                       bmp10, bmp13, bmp08,bmp081,bmp082                  #TQC-AC0183 add bmp081,bmp082
                       ,bmpud01,bmpud02,bmpud03,bmpud04,bmpud05
                       ,bmpud06,bmpud07,bmpud08,bmpud09,bmpud10
                       ,bmpud11,bmpud12,bmpud13,bmpud14,bmpud15
         FROM s_bmp[1].bmp02,s_bmp[1].bmp03,s_bmp[1].bmp16,s_bmp[1].bmp29,#FUN-560027 add bmp29
              s_bmp[1].bmp06,s_bmp[1].bmp07,s_bmp[1].bmp10,s_bmp[1].bmp13,
              s_bmp[1].bmp08,s_bmp[1].bmp081,s_bmp[1].bmp082,             #TQC-AC0183 add bmp081,bmp082
              s_bmp[1].bmpud01,s_bmp[1].bmpud02,s_bmp[1].bmpud03,
              s_bmp[1].bmpud04,s_bmp[1].bmpud05,s_bmp[1].bmpud06,
              s_bmp[1].bmpud07,s_bmp[1].bmpud08,s_bmp[1].bmpud09,
              s_bmp[1].bmpud10,s_bmp[1].bmpud11,s_bmp[1].bmpud12,
              s_bmp[1].bmpud13,s_bmp[1].bmpud14,s_bmp[1].bmpud15
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
     ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bmp03) #料件主檔
#FUN-AB0025 --Begin--   remark
#FUN-AA0059 --Begin--
                 #  CALL cl_init_qry_var()
                 #  LET g_qryparam.form = "q_ima"
                 #  LET g_qryparam.state = 'c'
                 #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                 # CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret  #TQC-C50030 mark
                   CALL q_bmp2(TRUE,TRUE,'','') RETURNING g_qryparam.multiret     #TQC-C50030
#FUN-AA0059 --End--
#FUN-AB0025 --End--     remark
                   DISPLAY g_qryparam.multiret TO bmp03
                   NEXT FIELD bmp03
              WHEN INFIELD(bmp09) #作業主檔
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ecd"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO bmp09
                   NEXT FIELD bmp09
              WHEN INFIELD(bmp10) #單位檔
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO bmp10
                   NEXT FIELD bmp10
              OTHERWISE EXIT CASE
           END  CASE
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
    IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
    IF INT_FLAG THEN RETURN END IF
    IF l_flag = 'N' THEN		
       LET g_sql = "SELECT  bmo01,bmo06,bmo011 FROM bmo_file ", #FUN-560027 add bmo06 #TQC-870018
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY bmo01"
     ELSE				
       LET g_sql = "SELECT UNIQUE bmo01,bmo06,bmo011 ", #FUN-560027 add bmo06 #TQC-870018
                   "  FROM bmo_file, bmp_file ",
                   " WHERE bmo01 = bmp01",
                   "   AND bmo06 = bmp28",#FUN-560027 add
                   "   AND bmo011= bmp011",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY bmo01"
    END IF
 

    PREPARE i100_prepare FROM g_sql
    DECLARE i100_curs
    SCROLL CURSOR WITH HOLD FOR i100_prepare

    IF l_flag = 'N' THEN		
        LET g_sql_tmp="SELECT UNIQUE bmo01,bmo06,bmo011 FROM bmo_file ",  #No.TQC-720019
                  " WHERE ",g_wc CLIPPED,
                  "  INTO TEMP x"
    ELSE
        LET g_sql_tmp="SELECT UNIQUE bmo01,bmo06,bmo011 ",  #No.TQC-720019
                  "FROM bmo_file,bmp_file ",
                  " WHERE bmp01=bmo01 ",
                  "   AND bmp28=bmo06 ",
                  "   AND bmp011=bmo011 AND ",
                  g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  "  INTO TEMP x"                    #No.MOD-720079 add
    END IF
    DROP TABLE x
    PREPARE i100_precount_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i100_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE i100_precount FROM g_sql
    DECLARE i100_count CURSOR FOR i100_precount
END FUNCTION
 
FUNCTION i100_menu()
   DEFINE
      l_cmd      LIKE type_file.chr1000,       #No.FUN-680096  VARCHAR(100)
      l_bmq903   LIKE bmq_file.bmq903
 
   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i100_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i100_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i100_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i100_x()
            END IF
            DISPLAY "g_bmo.bmoacti=",g_bmo.bmoacti
             CALL cl_set_field_pic("","","","","",g_bmo.bmoacti)
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i100_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "insert_loc"
            IF cl_chk_act_auth() THEN
               LET l_cmd = "abmi101 '",g_bmo.bmo01,"' '",g_bmo.bmo011,"' ",
                           "'",g_bmo.bmo06,"'"               #FUN-560027 add
                CALL cl_cmdrun_wait(l_cmd) #FUN-560027 #MOD-550153
               CALL i100_show()
            END IF
         WHEN "brand"
            IF cl_chk_act_auth() THEN
               LET l_cmd = "abmi150 '' '",g_bmo.bmo01,"' '",g_bmo.bmo011,"'"
               CALL cl_cmdrun(l_cmd)
            END IF
         WHEN "rep_sub"
            IF cl_chk_act_auth() THEN
               LET l_cmd = "abmi104 '",g_bmo.bmo01,"' '' '' '",g_bmo.bmo011,"'"
               CALL cl_cmdrun(l_cmd)
            END IF
         WHEN "contents"
            IF NOT cl_null(g_bmo.bmo01) THEN
               LET l_cmd = "abmi102 "," '",g_bmo.bmo01,"'"," '",g_bmo.bmo011,"' ",
                           "'",g_bmo.bmo06,"'"               #FUN-560027 add
                   CALL cl_cmdrun_wait(l_cmd) #FUN-560027 #MOD-550153
                  IF g_wc2 IS NULL THEN
                     LET g_wc2 = " 1=1"
                  END IF
               CALL i100_b_fill(g_wc2)                 #單身
            ELSE
               CALL cl_err('',-400,0)
            END IF
         WHEN "e_bom_copy"
            IF cl_chk_act_auth() THEN
               CALL i100_copy2()
            END IF
         WHEN "p_bom_copy"
            IF cl_chk_act_auth() THEN
               CALL i100_copy()
            END IF
         WHEN "contact_product"
            IF NOT cl_null(g_bmo.bmo01) THEN
               LET l_bmq903 = NULL
               SELECT bmq903 INTO l_bmq903 FROM bmq_file
               WHERE bmq01 = g_bmo.bmo01
               IF cl_chk_act_auth() THEN
                  IF NOT cl_null(g_bmo.bmo01) AND (g_sma.sma104 = 'Y' AND l_bmq903 = 'Y') THEN
                     LET l_cmd = "abmi108 '",g_bmo.bmo01,"' ","'",g_bmo.bmo011,"'"
                     CALL cl_cmdrun(l_cmd)
                  ELSE
                     #此料號不可執行聯產品功能!
                     CALL cl_err(g_bmo.bmo01,'abm-600',0)
                  END IF
               END IF
            ELSE
               CALL cl_err('',-400,0)
            END IF
         WHEN "bom_description"
            IF cl_chk_act_auth() THEN
               LET l_cmd="abmi103 '",g_bmo.bmo01,"' ","'' ", "'' ","'",g_bmo.bmo011,"' ",
                                 "'",g_bmo.bmo06,"'"               #FUN-560027 add
               CALL cl_cmdrun(l_cmd)
            END IF
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bmo.bmo01 IS NOT NULL THEN
                  LET g_doc.column1 = "bmo01"
                  LET g_doc.value1 = g_bmo.bmo01
                  LET g_doc.column2 = "bmo011"
                  LET g_doc.value2 = g_bmo.bmo011
                  LET g_doc.column3 = "bmo06"      #FUN-560027 add
                  LET g_doc.value3 = g_bmo.bmo06   #FUN-560027 add
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmp),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i100_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
   CALL g_bmp.clear()
    INITIALIZE g_bmo.* LIKE bmo_file.*             #DEFAULT 設定
    LET g_bmo01_t = NULL
    LET g_bmo06_t = NULL #FUN-560027 add
    #預設值及將數值類變數清成零
    LET g_bmo_t.* = g_bmo.*
    LET g_bmo_o.* = g_bmo.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_bmo.bmouser=g_user
        LET g_bmo.bmooriu = g_user #FUN-980030
        LET g_bmo.bmoorig = g_grup #FUN-980030
        LET g_bmo.bmogrup=g_grup
        LET g_bmo.bmodate=g_today
        LET g_bmo.bmoacti='Y'              #資料有效
        CALL i100_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_bmo.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_bmo.bmo01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF cl_null(g_bmo.bmo06) THEN
            LET g_bmo.bmo06 = ' '
        END IF
        INSERT INTO bmo_file VALUES (g_bmo.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
            CALL cl_err3("ins","bmo_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
            CONTINUE WHILE
        END IF
        SELECT bmo01,bmo06,bmo011 INTO g_bmo.bmo01,g_bmo.bmo06,g_bmo.bmo011 FROM bmo_file
            WHERE bmo01 = g_bmo.bmo01
              AND bmo06 = g_bmo.bmo06 #FUN-560027 add
              AND bmo011 = g_bmo.bmo011
        LET g_bmo01_t = g_bmo.bmo01        #保留舊值
        LET g_bmo06_t = g_bmo.bmo06        #保留舊值 #FUN-560027 add
        LET g_bmo_t.* = g_bmo.*
        CALL g_bmp.clear()
        LET g_rec_b = 0
        CALL i100_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i100_u() 
    IF s_shut(0) THEN RETURN END IF 
    IF g_bmo.bmo01 IS NULL THEN 
    RETURN 
    CALL cl_err('',-400,0) 
    END IF 
    IF g_bmo.bmoacti ='N' THEN   
    CALL cl_err(g_bmo.bmo01,'mfg1000',0) 
    RETURN 
    END IF 
    IF g_bmo.bmo05 IS NOT NULL AND g_bmo.bmo05 != '' 
    THEN CALL cl_err(g_bmo.bmo01,'mfg2761',0)
    RETURN 
    END IF 
    MESSAGE "" 
    CALL cl_opmsg('u') 
    LET g_bmo01_t = g_bmo.bmo01 
    LET g_bmo06_t = g_bmo.bmo06 #FUN-560027 add 
    LET g_bmo011_t = g_bmo.bmo011 
    BEGIN WORK 
    OPEN i100_cl USING g_bmo01_t,g_bmo06_t,g_bmo011_t
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_bmo.*
    IF SQLCA.sqlcode THEN
    CALL cl_err(g_bmo.bmo01,SQLCA.sqlcode,1)  
        CLOSE i100_cl ROLLBACK WORK RETURN
    END IF
    CALL i100_show()
    WHILE TRUE
        LET g_bmo01_t = g_bmo.bmo01
        LET g_bmo06_t = g_bmo.bmo06 #FUN-560027 add
        LET g_bmo011_t = g_bmo.bmo011
        LET g_bmo.bmomodu=g_user
        LET g_bmo.bmodate=g_today
        CALL i100_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bmo.*=g_bmo_t.*
            CALL i100_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_bmo.bmo01 != g_bmo01_t OR              # 更改單號
           g_bmo.bmo011 != g_bmo011_t THEN          # 更改版本
            UPDATE bmp_file SET bmp01 = g_bmo.bmo01,
                                bmp011= g_bmo.bmo011
                          WHERE bmp01 = g_bmo01_t
                            AND bmp28 = g_bmo06_t #FUN-560027 add
                            AND bmp011 = g_bmo011_t
 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","bmp_file",g_bmo01_t,g_bmo011_t,SQLCA.sqlcode,"","bmp",1)  #No.TQC-660046
                CONTINUE WHILE
            END IF
            UPDATE bec_file SET bec01 = g_bmo.bmo01,
                                bec011= g_bmo.bmo011
                          WHERE bec01 = g_bmo01_t
                            AND bec06 = g_bmo06_t       #FUN-560027 add
                            AND bec011 = g_bmo011_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","bec_file",g_bmo01_t,g_bmo011_t,SQLCA.sqlcode,"","bec",1)  #No.TQC-660046
                CONTINUE WHILE
            END IF
            UPDATE bel_file SET bel02 = g_bmo.bmo01,
                                bel011= g_bmo.bmo011
                          WHERE bel02 = g_bmo01_t AND bel011=g_bmo011_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","bel_file",g_bmo01_t,g_bmo011_t,SQLCA.sqlcode,"","bel",1)  #No.TQC-660046
                CONTINUE WHILE
            END IF
            UPDATE bmu_file SET bmu01 = g_bmo.bmo01,
                                bmu011= g_bmo.bmo011
                          WHERE bmu01 = g_bmo01_t
                            AND bmu08 = g_bmo06_t  #FUN-560027 add
                            AND bmu011= g_bmo011_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","bmu_file",g_bmo01_t,g_bmo011_t,SQLCA.sqlcode,"","bmu",1)  #No.TQC-660046
                CONTINUE WHILE
            END IF
            UPDATE bed_file SET bed01 = g_bmo.bmo01,
                                bed011= g_bmo.bmo011
                          WHERE bed01 = g_bmo01_t AND bed011=g_bmo011_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","bed_file",g_bmo01_t,g_bmo011_t,SQLCA.sqlcode,"","bed",1)  #No.TQC-660046
                CONTINUE WHILE
            END IF
        END IF
    UPDATE bmo_file SET bmo_file.* = g_bmo.* 
    WHERE bmo01=g_bmo01_t AND bmo06=g_bmo06_t AND bmo011=g_bmo011_t 
    IF SQLCA.sqlcode THEN
    CALL cl_err3("upd","bmo_file",g_bmo01_t,g_bmo011_t,SQLCA.sqlcode,"","",1)  #No.TQC-660046
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i100_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i100_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改        #No.FUN-680096 VARCHAR(1)
    l_cmd           LIKE type_file.chr50         #No.FUN-680096 VARCHAR(40)
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT BY NAME g_bmo.bmooriu,g_bmo.bmoorig,
        g_bmo.bmo01,g_bmo.bmo06,g_bmo.bmo011,g_bmo.bmo04,  #FUN-560027 add bmo06
        g_bmo.bmouser,g_bmo.bmomodu,g_bmo.bmogrup,
        g_bmo.bmodate,g_bmo.bmoacti,
        g_bmo.bmoud01,g_bmo.bmoud02,g_bmo.bmoud03,g_bmo.bmoud04,
        g_bmo.bmoud05,g_bmo.bmoud06,g_bmo.bmoud07,g_bmo.bmoud08,
        g_bmo.bmoud09,g_bmo.bmoud10,g_bmo.bmoud11,g_bmo.bmoud12,
        g_bmo.bmoud13,g_bmo.bmoud14,g_bmo.bmoud15 
        WITHOUT DEFAULTS
 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i100_set_entry(p_cmd)
            CALL i100_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
 
        AFTER FIELD bmo01                         #主件料號
            IF NOT cl_null(g_bmo.bmo01) THEN
#FUN-AB0025 ------------mark start-------------------
#               #FUN-AA0059 -----------------------------add start-------------------------
#               IF NOT s_chk_item_no(g_bmo.bmo01,'') THEN
#                  CALL cl_err('',g_errno,1) 
#                  LET g_bmo.bmo01 = g_bmo01_t
#                  DISPLAY BY NAME g_bmo.bmo01
#                  NEXT FIELD bmo01 
#               END IF 
#               #FUN-AA0059 ----------------------------add end------------------------------
#FUN-AB0025 ------------mark end-----------------------
                IF g_bmo.bmo01 != g_bmo01_t OR g_bmo01_t IS NULL THEN
                    #str-----mark by guanyao160704
                    #SELECT count(*) INTO g_cnt FROM bma_file
                    #    WHERE bma01 = g_bmo.bmo01
                    #IF g_cnt > 0 THEN
                    #   CALL cl_err(g_bmo.bmo01,'mfg2758',0)
                    #   LET g_bmo.bmo01 = g_bmo01_t
                    #   DISPLAY BY NAME g_bmo.bmo01
                    #   NEXT FIELD bmo01
                    #END IF
                    #end-----mark by guanyao160704
                 END IF
                 CALL i100_bmo01('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_bmo.bmo01,g_errno,0)
                    LET g_bmo.bmo01 = g_bmo_o.bmo01
                    DISPLAY BY NAME g_bmo.bmo01
                    NEXT FIELD bmo01
                 END IF
                 SELECT COUNT(*) INTO g_cnt
                   FROM bmn_file
                  WHERE bmn03 = g_bmo.bmo01
                    AND bmn01 != bmn03
                 IF g_cnt >=1 THEN
                     #此料件為它料的聯產品,所以不可建立此料件的工程BOM!
                     CALL cl_err(g_bmo.bmo01,'abm-613',0)
                     LET g_bmo.bmo01 = g_bmo_o.bmo01
                     DISPLAY BY NAME g_bmo.bmo01
                     NEXT FIELD bmo01
                 END IF
             END IF
 
 
         AFTER FIELD bmo011
             IF g_sma.sma118 != 'Y' THEN #FUN-560027 add if 判斷
                 IF NOT cl_null(g_bmo.bmo011) THEN
                     IF (g_bmo.bmo011 != g_bmo011_t OR g_bmo011_t IS NULL) OR
                        (g_bmo.bmo01 != g_bmo01_t OR g_bmo01_t IS NULL) THEN
                        LET g_bmo.bmo06 = ' '       #FUN-560027 add
                        SELECT count(*) INTO g_cnt FROM bmo_file
                         WHERE bmo01 = g_bmo.bmo01
                           AND bmo06 = g_bmo.bmo06  #FUN-560027 add
                           AND bmo011= g_bmo.bmo011
                        IF g_cnt > 0 THEN   #資料重複
                           CALL cl_err(g_bmo.bmo01,-239,0)
                           LET g_bmo.bmo01 = g_bmo01_t
                           DISPLAY BY NAME g_bmo.bmo01
                           NEXT FIELD bmo01
                        END IF
                     END IF
                 END IF
             ELSE
                 IF g_bmo.bmo06 IS NULL THEN
                     LET g_bmo.bmo06 = ' '
                 END IF
                 IF NOT cl_null(g_bmo.bmo011) THEN
                     IF (g_bmo.bmo011 != g_bmo011_t OR g_bmo011_t IS NULL) OR
                        (g_bmo.bmo06 != g_bmo06_t OR g_bmo06_t IS NULL) OR
                        (g_bmo.bmo01 != g_bmo01_t OR g_bmo01_t IS NULL) THEN
                        SELECT count(*) INTO g_cnt FROM bmo_file
                         WHERE bmo01 = g_bmo.bmo01
                           AND bmo06 = g_bmo.bmo06  #FUN-560027 add
                           AND bmo011= g_bmo.bmo011
                        IF g_cnt > 0 THEN   #資料重複
                           CALL cl_err(g_bmo.bmo01,-239,0)
                           LET g_bmo.bmo01 = g_bmo01_t
                           LET g_bmo.bmo06 = g_bmo06_t
                           LET g_bmo.bmo011= g_bmo011_t
                           DISPLAY BY NAME g_bmo.bmo01
                           DISPLAY BY NAME g_bmo.bmo06
                           DISPLAY BY NAME g_bmo.bmo011
                           NEXT FIELD bmo01
                        END IF
                     END IF
                 END IF
             END IF
 
        AFTER FIELD bmoud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmoud02
           #str----add by guanyao160704
           #IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           IF NOT cl_null(g_bmo.bmoud02) THEN 
              IF g_bmo.bmoud02 != g_bmo_t.bmoud02 OR g_bmo_t.bmoud02 IS NULL THEN
                 CALL i100_bmoud02('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_bmo.bmoud02,g_errno,0)
                    LET g_bmo.bmoud02 = g_bmo_o.bmoud02
                    DISPLAY BY NAME g_bmo.bmoud02
                    NEXT FIELD bmoud02
                 END IF
              END IF 
           END IF 
           #str----add by guanyao160704
        AFTER FIELD bmoud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmoud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmoud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmoud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmoud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmoud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmoud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmoud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmoud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmoud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmoud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmoud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmoud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bmo01)
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_bmq"  #mark by guanyao160704
                  LET g_qryparam.form = "q_ima"   #add by guanyao160704
                  LET g_qryparam.default1 = g_bmo.bmo01
                  CALL cl_create_qry() RETURNING g_bmo.bmo01
                  DISPLAY BY NAME g_bmo.bmo01
                  NEXT FIELD bmo01
               #str----add by guanyao160704
               WHEN INFIELD(bmoud02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pja"
                  LET g_qryparam.default1 = g_bmo.bmoud02
                  CALL cl_create_qry() RETURNING g_bmo.bmoud02
                  DISPLAY BY NAME g_bmo.bmoud02
                  CALL i100_bmoud02('a')
                  NEXT FIELD bmoud02
               #end----add by guanyao160704
               OTHERWISE EXIT CASE
             END CASE
 
        ON ACTION mntn_test_product
                    LET l_cmd = "abmi109 '",g_bmo.bmo01,"'"
                    CALL cl_cmdrun(l_cmd)
                    NEXT FIELD bmo01
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i100_bmo01(p_cmd)  #主件料件
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima05   LIKE ima_file.ima05,
           l_ima55   LIKE ima_file.ima55,
           l_imaacti LIKE ima_file.imaacti,
           l_bmq011  LIKE bmq_file.bmq011
 
    LET g_errno = ' '
   # SELECT  bmq011,bmq02,bmq021,bmq05,bmq55,bmq08,bmqacti#mark by guanyao160704
    SELECT ima01,ima02,ima021,ima05,ima55,ima08,imaacti   #add by guanyao160704
      INTO l_bmq011,l_ima02,l_ima021,l_ima05,l_ima55,g_ima08_h,l_imaacti
      #FROM bmq_file #add by guanyao160704
      FROM ima_file  #mark by guanyao160704
      WHERE ima01 = g_bmo.bmo01  #add by guanyao160704
     #WHERE bmq01 = g_bmo.bmo01  #mark by guanyao160704
    CASE
           WHEN SQLCA.sqlcode LET g_errno = 'mfg2602'
                         LET l_ima02 = NULL LET l_ima05   = NULL
                         LET l_ima021 = NULL
                         LET l_ima55 = NULL LET g_ima08_h = NULL
                         LET l_imaacti = NULL
           WHEN l_imaacti='N' LET g_errno = '9028'
           WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
 
           OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #--->來源碼為'Z':雜項料件
    IF g_ima08_h ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02   TO FORMONLY.ima02_h
           DISPLAY l_ima021  TO FORMONLY.ima021_h
           DISPLAY l_ima05   TO FORMONLY.ima05_h
           DISPLAY g_ima08_h TO FORMONLY.ima08_h
           DISPLAY l_ima55   TO FORMONLY.ima55
    END IF
END FUNCTION
#str------add by guanyao160704
FUNCTION i100_bmoud02(p_cmd)  #主件料件
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_pja02    LIKE pja_file.pja02,
           l_pjaconf  LIKE pja_file.pjaconf,
           l_pjaclose LIKE pja_file.pjaclose
 
    LET g_errno = ' '
    SELECT  pja02,pjaconf,pjaclose
      INTO l_pja02,l_pjaconf,l_pjaclose
      FROM pja_file
     WHERE pja01 = g_bmo.bmoud02
    CASE
           WHEN SQLCA.sqlcode     LET g_errno = 'mfg2601'
                                  LET l_pja02 = NULL 
                                  LET l_pjaconf = NULL
           WHEN l_pjaconf='N'     LET g_errno = '9002'
           WHEN l_pjaclose = 'Y'  LET g_errno = '9004' 
 
           OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #--->來源碼為'Z':雜項料件
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_pja02   TO FORMONLY.pja02
    END IF
END FUNCTION
#end------add by guanyao160704
 
FUNCTION i100_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bmo.* TO NULL              #No.FUN-6A0002
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
   CALL g_bmp.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i100_curs()
    IF INT_FLAG THEN
        INITIALIZE g_bmo.* TO NULL
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i100_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bmo.* TO NULL
    ELSE
        OPEN i100_count
        FETCH i100_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE " "
END FUNCTION
 
FUNCTION i100_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i100_curs INTO g_bmo.bmo01,g_bmo.bmo06, #FUN-560027 add bmo06
                                               g_bmo.bmo011 #TQC-870018
        WHEN 'P' FETCH PREVIOUS i100_curs INTO g_bmo.bmo01,g_bmo.bmo06, #FUN-560027 add bmo06
                                               g_bmo.bmo011 #TQC-870018
        WHEN 'F' FETCH FIRST    i100_curs INTO g_bmo.bmo01,g_bmo.bmo06, #FUN-560027 add bmo06
                                               g_bmo.bmo011 #TQC-870018
        WHEN 'L' FETCH LAST     i100_curs INTO g_bmo.bmo01,g_bmo.bmo06, #FUN-560027 add bmo06
                                               g_bmo.bmo011 #TQC-870018
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i100_curs INTO g_bmo.bmo01,g_bmo.bmo06, #FUN-560027 add bmo06
                                                  g_bmo.bmo011 #TQC-870018
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmo.bmo01,SQLCA.sqlcode,0)
        INITIALIZE g_bmo.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_bmo.* FROM bmo_file WHERE bmo01 = g_bmo.bmo01 AND bmo06 = g_bmo.bmo06 AND bmo011 = g_bmo.bmo011
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","bmo_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
        INITIALIZE g_bmo.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_bmo.bmouser      #FUN-4C0054
        LET g_data_group = g_bmo.bmogrup      #FUN-4C0054
    END IF
 
    CALL i100_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i100_show()
    LET g_bmo_t.* = g_bmo.*                #保存單頭舊值
    DISPLAY BY NAME g_bmo.bmooriu,g_bmo.bmoorig,                              # 顯示單頭值
            g_bmo.bmo01,g_bmo.bmo06,g_bmo.bmo04,g_bmo.bmo011,g_bmo.bmo05, #FUN-560027 add bmo06
            g_bmo.bmouser,g_bmo.bmogrup,g_bmo.bmomodu,
            g_bmo.bmodate,g_bmo.bmoacti,
            #FUN-840042     ---start---
            g_bmo.bmoud01,g_bmo.bmoud02,g_bmo.bmoud03,g_bmo.bmoud04,
            g_bmo.bmoud05,g_bmo.bmoud06,g_bmo.bmoud07,g_bmo.bmoud08,
            g_bmo.bmoud09,g_bmo.bmoud10,g_bmo.bmoud11,g_bmo.bmoud12,
            g_bmo.bmoud13,g_bmo.bmoud14,g_bmo.bmoud15 
            #FUN-840042     ----end----
 
    CALL i100_bmo01('d')
    CALL i100_bmoud02('d')  #add by guanyao160704
    CALL cl_set_field_pic("","","","","",g_bmo.bmoacti)
    CALL i100_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i100_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_bmo.bmo01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i100_cl USING g_bmo.bmo01,g_bmo.bmo06,g_bmo.bmo011
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_bmo.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmo.bmo01,SQLCA.sqlcode,0)          #資料被他人LOCK
        RETURN
    END IF
    CALL i100_show()
    IF cl_exp(0,0,g_bmo.bmoacti) THEN
        LET g_chr=g_bmo.bmoacti
        IF g_bmo.bmoacti='Y' THEN
            LET g_bmo.bmoacti='N'
        ELSE
            LET g_bmo.bmoacti='Y'
        END IF
        UPDATE bmo_file                    #更改有效碼
            SET bmoacti=g_bmo.bmoacti
            WHERE bmo01=g_bmo.bmo01
              AND bmo06=g_bmo.bmo06 #FUN-560027 add bmo06
              AND bmo011=g_bmo.bmo011
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","bmo_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
            LET g_bmo.bmoacti=g_chr
        END IF
        DISPLAY BY NAME g_bmo.bmoacti
    END IF
    CLOSE i100_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i100_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_bmo.bmo01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i100_cl USING g_bmo.bmo01,g_bmo.bmo06,g_bmo.bmo011
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_bmo.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bmo.bmo01,SQLCA.sqlcode,0) RETURN
    END IF
    IF g_bmo.bmoacti = 'N' THEN
       CALL cl_err('','abm-950',0)
       RETURN
    END IF
    CALL i100_show()
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bmo01"            #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bmo.bmo01         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bmo011"           #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_bmo.bmo011        #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bmo06"            #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_bmo.bmo06         #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                               #No.FUN-9B0098 10/02/24
        DELETE FROM bmo_file WHERE bmo01 = g_bmo.bmo01 AND bmo06 = g_bmo.bmo06 AND bmo011 = g_bmo.bmo011
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                CALL cl_err3("del","bmo_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.SQLCODE,"","del bmo:",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF
        DELETE FROM bmp_file WHERE bmp01 =g_bmo.bmo01
                               AND bmp28 =g_bmo.bmo06  #FUN-560027 add
                               AND bmp011=g_bmo.bmo011
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bmp_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.SQLCODE,"","del bmp:",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF
        DELETE FROM bec_file WHERE bec01=g_bmo.bmo01
                               AND bec06=g_bmo.bmo06  #FUN-560027 add
                               AND bec011=g_bmo.bmo011
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bec_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.SQLCODE,"","del bec:",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF
        DELETE FROM bel_file WHERE bel02=g_bmo.bmo01 AND bel011=g_bmo.bmo011
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bel_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.SQLCODE,"","del bel:",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF
        DELETE FROM bmu_file WHERE bmu01=g_bmo.bmo01
                               AND bmu08=g_bmo.bmo06  #FUN-560027 add
                               AND bmu011=g_bmo.bmo011
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bmu_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.SQLCODE,"","del bmu:",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF
        DELETE FROM bed_file WHERE bed01=g_bmo.bmo01 AND bed011=g_bmo.bmo011
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bed_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.SQLCODE,"","del bed:",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF
        DELETE FROM bmn_file WHERE bmn01=g_bmo.bmo01 AND bmn011=g_bmo.bmo011 #刪除聯產品資料
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bmn_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.SQLCODE,"","del bmn:",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF
 
        CLEAR FORM
        CALL g_bmp.clear()
        INITIALIZE g_bmo.* TO NULL
        DROP TABLE x  #No.TQC-720019
        PREPARE i100_precount_x2 FROM g_sql_tmp  #No.TQC-720019
        EXECUTE i100_precount_x2                 #No.TQC-720019
        OPEN i100_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE i100_curs
           CLOSE i100_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH i100_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i100_curs
           CLOSE i100_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i100_curs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i100_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE
           CALL i100_fetch('/')
        END IF
    END IF
    CLOSE i100_cl
    COMMIT WORK
END FUNCTION
#單身
FUNCTION i100_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT        #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態        #No.FUN-680096 VARCHAR(1)
    l_buf           LIKE type_file.chr50,     #No.FUN-680096   VARCHAR(40)
    l_cmd           LIKE type_file.chr1000,   #No.FUN-680096   VARCHAR(200)
    l_qpa           LIKE bmp_file.bmp06,
    l_uflag,l_chr   LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
    l_ima08         LIKE ima_file.ima08,
    l_bmp01         LIKE ima_file.ima01,
    l_allow_insert  LIKE type_file.num5,      #可新增否        #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5       #可刪除否        #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bmo.bmo01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_bmo.bmoacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_bmo.bmo01,'mfg1000',0)
        RETURN
    END IF
    #-->已轉成正式BOM 無法修改
    IF g_bmo.bmo05 IS NOT NULL AND g_bmo.bmo05 != ' '
    THEN CALL cl_err(g_bmo.bmo01,'mfg2761',0)
         RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT * ",
       "FROM bmp_file ",
       " WHERE bmp01 = ? ",
       "  AND bmp28= ? ", #FUN-560027 add
       "  AND bmp011= ? ",
       "  AND bmp02 = ? ",
       "  AND bmp03 = ? ",
       "FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bmp
              WITHOUT DEFAULTS
              FROM s_bmp.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
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
            BEGIN WORK
            OPEN i100_cl USING g_bmo.bmo01,g_bmo.bmo06,g_bmo.bmo011
            IF STATUS THEN
               CALL cl_err("OPEN i100_cl:", STATUS, 1)
               CLOSE i100_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i100_cl INTO g_bmo.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_bmo.bmo01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i100_cl ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_bmp_t.* = g_bmp[l_ac].*  #BACKUP
               LET g_bmp_o.* = g_bmp[l_ac].*
               LET g_bmp10_t = g_bmp[l_ac].bmp10  #No.FUN-BB0086
 
                OPEN i100_bcl USING g_bmo.bmo01,g_bmo.bmo06,g_bmo.bmo011, #FUN-560027 add
                                    g_bmp_t.bmp02,g_bmp_t.bmp03
                IF STATUS THEN
                    CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE                    
                    FETCH i100_bcl INTO b_bmp.* #FUN-730075
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bmp_t.bmp02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        CALL i100_b_move_to() #FUN-730075
                    END IF
                    CALL i100_bmp03(' ')           #for referenced field
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF

             CALL i100_b_move_back()
             INSERT INTO bmp_file VALUES (b_bmp.*)
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","bmp_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                ROLLBACK WORK
                CANCEL INSERT
            ELSE
                UPDATE bmo_file SET bmodate = g_today
                 WHERE bmo01 = g_bmo.bmo01 AND bmo06 = g_bmo.bmo06 AND bmo011 = g_bmo.bmo011
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            CALL i100_remark()
             IF g_bmp[l_ac].bmp16 != '0' AND        #詢問是否輸入取代或替代料件
                (g_bmp[l_ac].bmp16 != g_bmp_t.bmp16)
                 THEN CALL i1002_prompt()
             END IF
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_bmp[l_ac].* TO NULL
            LET g_bmp10_t = NULL   #No.FUN-BB0086
	    LET g_bmp04 = ''     #TQC-740182 add
            LET g_bmp05 = ''     #TQC-740182 add
            LET g_bmp09 = ''     LET g_bmp15 ='N'
            LET g_bmp19 ='1'     LET g_bmp21 ='Y'
            LET g_bmp22 ='Y'     LET g_bmp23 = 100
            LET g_bmp11 = NULL   LET g_bmp13 = NULL
            LET g_bmp25 = NULL   LET g_bmp26 = NULL
            LET g_bmp18 = 0      LET g_bmp17 = 'N'
            LET g_bmp14 = '0'              
            LET g_bmp20 = NULL
            LET g_bmp10_fac = 1  LET g_bmp10_fac2 = 1
            LET g_bmp[l_ac].bmp10 = NULL      #NO:8555
            LET g_bmp[l_ac].bmp06 = 1
            LET g_bmp[l_ac].bmp16 = '0'       #Body default
            IF g_sma.sma118 != 'Y' THEN
                LET g_bmp[l_ac].bmp29 = ' '
            ELSE
                LET g_bmp[l_ac].bmp29 = '1'
            END IF
            LET g_bmp[l_ac].bmp07 = 1
            LET g_bmp[l_ac].bmp08 = 0
            LET g_bmp[l_ac].bmp081= 0          #No.TQC-AC0183 add
            LET g_bmp[l_ac].bmp082= 1          #No.TQC-AC0183 add
            LET g_bmp_t.* = g_bmp[l_ac].*         #新輸入資料
            LET g_bmp_o.* = g_bmp[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmp02
 
        BEFORE FIELD bmp02                        #default 項次
            IF g_bmp[l_ac].bmp02 IS NULL OR
               g_bmp[l_ac].bmp02 = 0 THEN
                SELECT max(bmp02)
                   INTO g_bmp[l_ac].bmp02
                   FROM bmp_file
                   WHERE bmp01 = g_bmo.bmo01
                     AND bmp011= g_bmo.bmo011
                IF g_bmp[l_ac].bmp02 IS NULL
                   THEN LET g_bmp[l_ac].bmp02 = 0
                END IF
                LET g_bmp[l_ac].bmp02 = g_bmp[l_ac].bmp02 + g_sma.sma19
            END IF
            IF p_cmd = 'a'
              THEN LET g_bmp20 = g_bmp[l_ac].bmp02
            END IF
        #因為更動項次(key值),影響相關的插件位置檔bmu_file也要重新輸入,
        #所以先將原先在bmu_file的資料刪除
        AFTER FIELD bmp02
            IF p_cmd = 'u' AND (g_bmp[l_ac].bmp02 != g_bmp_t.bmp02) THEN
                   UPDATE bmu_file
                      SET bmu02 = g_bmp[l_ac].bmp02
                    WHERE bmu01 = g_bmo.bmo01
                      AND bmu08 = g_bmo.bmo06
                      AND bmu011= g_bmo.bmo011
                      AND bmu02 = g_bmp_t.bmp02
            END IF
 
        AFTER FIELD bmp03
#FUN-AB0025 ------------mark start----------------
#           #FUN-AA0059 -------------------------add start-------------------------
#           IF NOT cl_null(g_bmp[l_ac].bmp03) THEN
#              IF NOT s_chk_item_no(g_bmp[l_ac].bmp03,'') THEN
#                 CALL cl_err('',g_errno,1)
#                 LET g_bmp[l_ac].bmp03 = g_bmp_t.bmp03
#                 DISPLAY g_bmp[l_ac].bmp03 TO s_bmp[l_sl].bmp03
#                 NEXT FIELD bmp03
#              END IF 
#           END IF 
#           #FUN-AA0059 -------------------------add end-------------------------  
#FUN-AB0025 ------------mark end-------------
            IF p_cmd = 'a' OR ( p_cmd = 'u' AND g_bmp[l_ac].bmp03 IS NOT NULL AND
               (g_bmp[l_ac].bmp03 != g_bmp_t.bmp03 OR
                g_bmp_t.bmp03 IS NULL OR
                g_bmp[l_ac].bmp02 != g_bmp_t.bmp02 OR
                g_bmp_t.bmp02 IS NULL)) THEN    ##MOD-840405-modify
                 LET l_n = 0
                 SELECT count(*) INTO l_n FROM bmp_file
                         WHERE bmp01 = g_bmo.bmo01
                           AND bmp28 = g_bmo.bmo06  #FUN-560027 add
                           AND bmp011= g_bmo.bmo011
                           AND bmp02 = g_bmp[l_ac].bmp02
                           AND bmp03 = g_bmp[l_ac].bmp03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_bmp[l_ac].bmp02 = g_bmp_t.bmp02
                    LET g_bmp[l_ac].bmp03 = g_bmp_t.bmp03
                    DISPLAY g_bmp[l_ac].bmp02 TO s_bmp[l_sl].bmp02
                    DISPLAY g_bmp[l_ac].bmp03 TO s_bmp[l_sl].bmp03
                    NEXT FIELD bmp02
                 END IF
                 IF g_bmo.bmo01=g_bmp[l_ac].bmp03 THEN
                    CALL cl_err(g_bmp[l_ac].bmp03,'mfg2633',0)
                    NEXT FIELD bmp03
                 END IF
                 SELECT COUNT(*) INTO l_n FROM bmp_file
                  WHERE bmp01=g_bmo.bmo01
                    AND bmp28= g_bmo.bmo06  #FUN-560027 add
                    AND bmp011= g_bmo.bmo011
                    AND bmp03=g_bmp[l_ac].bmp03
                 IF l_n > 0 THEN
                    IF NOT cl_confirm('abm-728') THEN NEXT FIELD bmp03 END IF
                 END IF
                 SELECT ima70 INTO g_bmp15 FROM ima_file
                  WHERE ima01=g_bmp[l_ac].bmp03
                 IF g_bmp15 IS NULL OR g_bmp15=' ' THEN LET g_bmp15='N' END IF
            END IF
            IF p_cmd = 'u' AND (g_bmp[l_ac].bmp03 != g_bmp_t.bmp03) THEN
                DELETE FROM bmu_file
                 WHERE bmu01 = g_bmo.bmo01
                   AND bmu08 = g_bmo.bmo06  #FUN-560027 add
                   AND bmu011= g_bmo.bmo011
                   AND bmu02 = g_bmp[l_ac].bmp02
                   AND bmu03 = g_bmp_t.bmp03
                LET g_bmp[l_ac].bmp13= NULL
                DISPLAY g_bmp[l_ac].bmp13 TO bmp13 #FUN-560027
            END IF
            CALL i100_bmp03(p_cmd)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,1)
               NEXT FIELD bmp03
            END IF 
            IF g_bmp[l_ac].bmp10 != g_ima25_b THEN
               CALL s_umfchk(g_bmp[l_ac].bmp03,g_bmp[l_ac].bmp10,g_ima25_b)
                    RETURNING g_sw,b_bmp.bmp10_fac #發料/庫存單位
               IF g_sw = '1' THEN
                   CALL cl_err(g_bmp[l_ac].bmp10,'mfg2721',0)
                   LET g_bmp[l_ac].bmp10 = g_bmp_o.bmp10
                   DISPLAY BY NAME g_bmp[l_ac].bmp10
                   NEXT FIELD bmp10
               END IF
            ELSE 
               LET b_bmp.bmp10_fac  = 1
            END IF
            IF g_bmp[l_ac].bmp10 != g_ima86_b THEN #發料/成本單位
               CALL s_umfchk(g_bmp[l_ac].bmp03,g_bmp[l_ac].bmp10,g_ima86_b)
                    RETURNING g_sw,b_bmp.bmp10_fac2
               IF g_sw = '1' THEN
                  CALL cl_err(g_bmp[l_ac].bmp03,'mfg2722',0)
                  LET g_bmp[l_ac].bmp10 = g_bmp_o.bmp10
                  LET g_bmp[l_ac].bmp081=s_digqty(g_bmp[l_ac].bmp081, g_bmp[l_ac].bmp10)   #No.FUN-BB0086
                  DISPLAY BY NAME g_bmp[l_ac].bmp10
                  NEXT FIELD bmp10
               END IF
            ELSE
               LET b_bmp.bmp10_fac2 = 1
            END IF
            DISPLAY g_bmp[l_ac].ima02_b TO ima02_b
            DISPLAY g_bmp[l_ac].ima021_b TO ima021_b
            DISPLAY g_bmp[l_ac].ima08_b TO ima08_b
            DISPLAY g_bmp[l_ac].ima05_b TO ima05_b
            DISPLAY g_bmp[l_ac].bmp10    TO nmp10    #No.MOD-6B0038 add
 
        AFTER FIELD bmp09    #作業編號
            IF NOT cl_null(g_bmp[l_ac].bmp09)
               THEN
               SELECT COUNT(*) INTO g_cnt FROM ecd_file
                WHERE ecd01=g_bmp[l_ac].bmp09
               IF g_cnt=0
                  THEN
                  CALL cl_err('sel ecd_file',100,0)
                  NEXT FIELD bmp09
               END IF
            END IF
 
        BEFORE FIELD bmp16
            IF cl_null(g_bmp[l_ac].bmp03)
            THEN LET g_bmp[l_ac].bmp03=g_bmp_t.bmp03
            ELSE CALL i100_bmp03('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_bmp[l_ac].bmp03=g_bmp_t.bmp03
                    DISPLAY BY NAME g_bmp[l_ac].bmp03
                    NEXT FIELD bmp03
                 END IF
            END IF
            IF g_ima08_b = 'D' THEN
               LET g_bmp17 = 'Y'
            ELSE
               LET g_bmp17 = 'N'
            END IF
 
        AFTER FIELD bmp16  #替代特性
           IF NOT cl_null(g_bmp[l_ac].bmp16) THEN
               IF g_bmp[l_ac].bmp16 NOT MATCHES'[012]' THEN
                    LET g_bmp[l_ac].bmp16 = g_bmp_o.bmp16
                    DISPLAY BY NAME g_bmp[l_ac].bmp16
                    NEXT FIELD bmp16
               END IF

               LET g_bmp_o.bmp16 = g_bmp[l_ac].bmp16
           END IF
 
 
        AFTER FIELD bmp06    #組成用量不可小於零
          IF NOT cl_null(g_bmp[l_ac].bmp06) THEN
              IF g_bmp[l_ac].bmp06 <= 0 THEN
                  CALL cl_err(g_bmp[l_ac].bmp06,'mfg2614',0)
                  LET g_bmp[l_ac].bmp06 = g_bmp_o.bmp06
                  DISPLAY BY NAME g_bmp[l_ac].bmp06
                  NEXT FIELD bmp06
              END IF
              LET g_bmp_o.bmp06 = g_bmp[l_ac].bmp06
          END IF
 
        AFTER FIELD bmp07    #底數不可小於等於零
          IF NOT cl_null(g_bmp[l_ac].bmp07) THEN
              IF g_bmp[l_ac].bmp07 <= 0
               THEN CALL cl_err(g_bmp[l_ac].bmp07,'mfg2615',0)
                    LET g_bmp[l_ac].bmp07 = g_bmp_o.bmp07
                    DISPLAY g_bmp[l_ac].bmp07 TO s_bmp[l_sl].bmp07
                    NEXT FIELD bmp07
              LET g_bmp_o.bmp07 = g_bmp[l_ac].bmp07
              END IF
          END IF
 
        BEFORE FIELD bmp08
            IF g_ima107 = 'Y' THEN
                CALL i100_ins_bmu()
            END IF
 
        AFTER FIELD bmp08    #損耗率
          IF NOT cl_null(g_bmp[l_ac].bmp08) THEN
              IF g_bmp[l_ac].bmp08 < 0 OR g_bmp[l_ac].bmp08 > 100
               THEN CALL cl_err(g_bmp[l_ac].bmp08,'mfg4063',0)
                    LET g_bmp[l_ac].bmp08 = g_bmp_o.bmp08
                    DISPLAY g_bmp[l_ac].bmp08 TO s_bmp[l_sl].bmp08
                    NEXT FIELD bmp08
              END IF
              LET g_bmp_o.bmp08 = g_bmp[l_ac].bmp08
          END IF
          
        #No.TQC-AC0183--begin
        AFTER FIELD bmp081    #固定損耗量
           IF NOT i100_bmp081_check() THEN NEXT FIELD bmp081 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--start---
            #IF NOT cl_null(g_bmp[l_ac].bmp081) THEN
            #    IF g_bmp[l_ac].bmp081 < 0 THEN 
            #       CALL cl_err(g_bmp[l_ac].bmp081,'aec-020',0)
            #       LET g_bmp[l_ac].bmp081 = g_bmp_o.bmp081
            #       NEXT FIELD bmp081
            #    END IF
            #    LET g_bmp_o.bmp081 = g_bmp[l_ac].bmp081
            #END IF
            #IF cl_null(g_bmp[l_ac].bmp081) THEN
            #    LET g_bmp[l_ac].bmp081 = 0
            #END IF
            #DISPLAY BY NAME g_bmp[l_ac].bmp081
            #No.FUN-BB0086--mark--end---
            
        AFTER FIELD bmp082    #損耗批量
            IF NOT cl_null(g_bmp[l_ac].bmp082) THEN
                IF g_bmp[l_ac].bmp082 <= 0 THEN 
                   CALL cl_err(g_bmp[l_ac].bmp082,'alm-808',0)
                   LET g_bmp[l_ac].bmp082 = g_bmp_o.bmp082
                   NEXT FIELD bmp082
                END IF
                LET g_bmp_o.bmp082 = g_bmp[l_ac].bmp082
            END IF
            IF cl_null(g_bmp[l_ac].bmp082) THEN
                LET g_bmp[l_ac].bmp082 = 1
            END IF
            DISPLAY BY NAME g_bmp[l_ac].bmp082
        #No.TQC-AC0183--end 
 
        AFTER FIELD bmp10   #發料單位
           IF cl_null(g_bmp[l_ac].bmp10) THEN
               LET g_bmp[l_ac].bmp10 = g_bmp_o.bmp10
               DISPLAY BY NAME g_bmp[l_ac].bmp10
           ELSE
               IF (g_bmp_o.bmp10 IS NULL) OR (g_bmp_t.bmp10 IS NULL)
                    OR (g_bmp[l_ac].bmp10 != g_bmp_o.bmp10)
                THEN CALL i100_bmp10()
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_bmp[l_ac].bmp10,g_errno,0)
                        LET g_bmp[l_ac].bmp10 = g_bmp_o.bmp10
                        DISPLAY g_bmp[l_ac].bmp10 TO s_bmp[l_sl].bmp10
                        NEXT FIELD bmp10
                     END IF
                     IF g_bmp[l_ac].bmp10 != g_ima25_b THEN
                        CALL s_umfchk(g_bmp[l_ac].bmp03,g_bmp[l_ac].bmp10,g_ima25_b)
                             RETURNING g_sw,b_bmp.bmp10_fac #發料/庫存單位
                        IF g_sw = '1' THEN
                            CALL cl_err(g_bmp[l_ac].bmp10,'mfg2721',0)
                            LET g_bmp[l_ac].bmp10 = g_bmp_o.bmp10
                            DISPLAY BY NAME g_bmp[l_ac].bmp10
                            NEXT FIELD bmp10
                        END IF
                     ELSE 
                        LET b_bmp.bmp10_fac  = 1
                     END IF
                     IF g_bmp[l_ac].bmp10 != g_ima86_b THEN #發料/成本單位
                        CALL s_umfchk(g_bmp[l_ac].bmp03,g_bmp[l_ac].bmp10,g_ima86_b)
                             RETURNING g_sw,b_bmp.bmp10_fac2
                        IF g_sw = '1' THEN
                           CALL cl_err(g_bmp[l_ac].bmp03,'mfg2722',0)
                           LET g_bmp[l_ac].bmp10 = g_bmp_o.bmp10
                           DISPLAY BY NAME g_bmp[l_ac].bmp10
                           NEXT FIELD bmp10
                        END IF
                     ELSE
                        LET b_bmp.bmp10_fac2 = 1
                     END IF
                END IF
                #No.FUN-BB0086--add--start---
                IF NOT i100_bmp081_check() THEN 
                   LET g_bmp10_t = g_bmp[l_ac].bmp10
                   LET g_bmp_o.bmp10 = g_bmp[l_ac].bmp10
                   NEXT FIELD bmp081
                END IF 
                LET g_bmp10_t = g_bmp[l_ac].bmp10
                #No.FUN-BB0086--add--end---
          END IF
          LET g_bmp_o.bmp10 = g_bmp[l_ac].bmp10
 
        AFTER FIELD bmpud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmpud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmpud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmpud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmpud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmpud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmpud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmpud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmpud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmpud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmpud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmpud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmpud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmpud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmpud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bmp_t.bmp02 > 0 AND
               g_bmp_t.bmp02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM bmp_file
                    WHERE bmp01 = g_bmo.bmo01
                      AND bmp28 = g_bmo.bmo06  #FUN-560027 add
                      AND bmp011= g_bmo.bmo011
                      AND bmp02 = g_bmp_t.bmp02
                      AND bmp03 = g_bmp_t.bmp03
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    LET l_buf = g_bmp_t.bmp02 clipped,'+',
                                g_bmp_t.bmp03 clipped
                    CALL cl_err3("del","bmp_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                DELETE FROM bmu_file
                 WHERE bmu01 = g_bmo.bmo01
                   AND bmu08 = g_bmo.bmo06  #FUN-560027 add
                   AND bmu011= g_bmo.bmo011
                   AND bmu02 = g_bmp_t.bmp02
                   AND bmu03 = g_bmp_t.bmp03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","bmu_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    CANCEL DELETE
                END IF
                DELETE FROM bel_file
                 WHERE bel01 = g_bmp_t.bmp03 AND bel02 = g_bmo.bmo01
                   AND bel011= g_bmo.bmo011
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","bel_file",g_bmp_t.bmp03,g_bmo.bmo011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                DELETE FROM bec_file
                 WHERE bec01 =g_bmo.bmo01
                   AND bec06 =g_bmo.bmo06   #FUN-560027 add
                   AND bec011=g_bmo.bmo011
                   AND bec02 = g_bmp_t.bmp02
                   AND bec021 = g_bmp_t.bmp03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","bec_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                DELETE FROM bed_file
                 WHERE bed01=g_bmo.bmo01 AND bed011=g_bmo.bmo011
                   AND bed012 = g_bmp_t.bmp02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","bed_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmp[l_ac].* = g_bmp_t.*
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bmp[l_ac].bmp02,-263,1)
                LET g_bmp[l_ac].* = g_bmp_t.*
            ELSE
               #若項次編號有異動,則取替代檔一并更新 
               IF p_cmd = 'u' AND (g_bmp[l_ac].bmp02 != g_bmp_t.bmp02) THEN
                  UPDATE bed_file
                     SET bed012 = g_bmp[l_ac].bmp02
                    WHERE bed01 = g_bmo.bmo01
                      AND bed011= g_bmo.bmo011
                      AND bed012 = g_bmp_t.bmp02
                  IF sqlca.sqlcode THEN
                     CALL cl_err3("upd","bed_file",'','',SQLCA.sqlcode,"","",1)
                     LET g_bmp[l_ac].* = g_bmp_t.*
                     DISPLAY g_bmp[l_ac].* TO s_bmp[l_sl].*
                     ROLLBACK WORK
                     NEXT FIELD bmp02
                  END IF
               END IF
              
               CALL i100_b_move_back()

                UPDATE bmp_file SET * = b_bmp.* 
                 WHERE bmp01 =g_bmo.bmo01
                   AND bmp28 =g_bmo.bmo06   #FUN-560027 add
                   AND bmp011=g_bmo.bmo011
                   AND bmp02 =g_bmp_t.bmp02
                   AND bmp03 =g_bmp_t.bmp03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","bmp_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    LET g_bmp[l_ac].* = g_bmp_t.*
                    DISPLAY g_bmp[l_ac].* TO s_bmp[l_sl].*
                ELSE
                    UPDATE bmo_file SET bmodate = g_today
                                    WHERE bmo01 = g_bmo.bmo01 AND bmo06 = g_bmo.bmo06 AND bmo011 = g_bmo.bmo011
                    MESSAGE 'UPDATE O.K'
    		    COMMIT WORK
                END IF
             IF g_bmp[l_ac].bmp16 != '0' AND        #詢問是否輸入取代或替代料件
                (g_bmp[l_ac].bmp16 != g_bmp_t.bmp16)
                 THEN CALL i1002_prompt()
             END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_bmp[l_ac].* = g_bmp_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmp.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
 
            CLOSE i100_bcl
            COMMIT WORK
 
        ON ACTION mntn_unit       #建立單位資料
                    CALL cl_cmdrun('aooi101 ')
 
        ON ACTION mntn_unit_conv       #建立單位換算資料
                    CALL cl_cmdrun("aooi102 ")
 
        ON ACTION mntn_item_unit_conv       #
                    CALL cl_cmdrun("aooi103 ")
 
 
        ON ACTION insert_loc #輸入插件位置
                     CALL i100_ins_bmu()
 
        ON ACTION bom_description    #建立元件說明資料(更新才call)
                IF g_bmp_t.bmp02 IS NOT NULL AND g_bmp_t.bmp03 IS NOT NULL
                   THEN LET l_cmd = "abmi103 '",g_bmo.bmo01,"' '",g_bmp[l_ac].bmp02,"' '",g_bmp[l_ac].bmp03,"' '",g_bmo.bmo011,"' ",
                                 "'",g_bmo.bmo06,"'"               #FUN-560027 add
                        CALL cl_cmdrun(l_cmd)
                END IF
 
        ON ACTION qry_test_item
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_bmq1"       #MOD-850265 modify
               LET g_qryparam.default1 = g_bmp[l_ac].bmp03
               CALL cl_create_qry() RETURNING g_bmp[l_ac].bmp03
               DISPLAY g_bmp[l_ac].bmp03 TO bmp03
               NEXT FIELD bmp03
 
        ON ACTION mntn_test_item    #建立測試料件
                    LET l_cmd = "abmi109 '",g_bmp[l_ac].bmp03,"'"
                    CALL cl_cmdrun(l_cmd)
                    NEXT FIELD bmp03
 
 
        ON ACTION mntn_rep_sub #取/替代維護
                IF g_bmp[l_ac].bmp16 matches'[12]' THEN
                   LET l_cmd = "abmi104 '",g_bmo.bmo01,"' ",
                                       "'",g_bmp[l_ac].bmp02,"' ",
                                       "'",g_bmp[l_ac].bmp16,"' ",
                                       "'",g_bmo.bmo011,"' "
                   CALL cl_cmdrun(l_cmd)
                   NEXT FIELD bmp02
                END IF
 
        ON ACTION mntn_item_brand                 #建立元件廠牌
              LET l_cmd="abmi150 '",g_bmp[l_ac].bmp03,"' '",g_bmo.bmo01,"'",
                        " '",g_bmo.bmo011,"'"
              CALL cl_cmdrun(l_cmd)
              NEXT FIELD bmp03
 
 
     ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bmp03) #料件主檔
#FUN-AB0025--Begin--  remark
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.form = "q_ima"
                #   LET g_qryparam.default1 = g_bmp[l_ac].bmp03
                #   CALL cl_create_qry() RETURNING g_bmp[l_ac].bmp03
                #  CALL q_sel_ima(FALSE, "q_ima", "", g_bmp[l_ac].bmp03 , "", "", "", "" ,"",'' )  RETURNING g_bmp[l_ac].bmp03 #TQC-C50030 mark
                   CALL q_bmp2(FALSE,TRUE,g_bmp[l_ac].bmp03,'') RETURNING g_bmp[l_ac].bmp03     #TQC-C50030
#FUN-AA0059 --END--
#FUN-AB0025 --End--  remark 
                   DISPLAY g_bmp[l_ac].bmp03 TO bmp03
                   NEXT FIELD bmp03
              WHEN INFIELD(bmp09) #作業主檔
                   CALL q_ecd(FALSE,TRUE,g_bmp[l_ac].bmp09) RETURNING g_bmp[l_ac].bmp09
                   DISPLAY g_bmp[l_ac].bmp09 TO bmp09
                   NEXT FIELD bmp09
              WHEN INFIELD(bmp10) #單位檔
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.default1 = g_bmp[l_ac].bmp10
                   CALL cl_create_qry() RETURNING g_bmp[l_ac].bmp10
                   DISPLAY g_bmp[l_ac].bmp10 TO bmp10
                   NEXT FIELD bmp10
              OTHERWISE EXIT CASE
           END  CASE

        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(bmp02) AND l_ac > 1 THEN
               LET g_bmp[l_ac].* = g_bmp[l_ac-1].*
               NEXT FIELD bmp02
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
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033  
 
        END INPUT
           UPDATE bmo_file SET bmomodu = g_user,bmodate = g_today
                WHERE bmo01 = g_bmo.bmo01 AND bmo06 = g_bmo.bmo06 AND bmo011 = g_bmo.bmo011
 
    CLOSE i100_bcl
    COMMIT WORK
#   CALL i100_delall() #CHI-C30002 mark
    CALL i100_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i100_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM bmn_file WHERE bmn01=g_bmo.bmo01 AND bmn011=g_bmo.bmo011  #CHI-C80041
         DELETE FROM bmo_file WHERE bmo01 = g_bmo.bmo01
                                AND bmo06 =g_bmo.bmo06
                                AND bmo011=g_bmo.bmo011
         INITIALIZE g_bmo.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i100_delall()
#   SELECT COUNT(*) INTO g_cnt FROM bmp_file
#       WHERE bmp01 =g_bmo.bmo01
#         AND bmp28 =g_bmo.bmo06   #FUN-560027 add
#         AND bmp011=g_bmo.bmo011
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM bmo_file WHERE bmo01 = g_bmo.bmo01
#                             AND bmo06 =g_bmo.bmo06    #FUN-560027 add
#                             AND bmo011=g_bmo.bmo011
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i1002_prompt()
    DEFINE l_cmd    LIKE type_file.chr1000,     #No.FUN-680096 VARCHAR(200)
           l_chr    LIKE type_file.chr1         #No.FUN-680096 VARCHAR(1)
 
  IF NOT cl_confirm('mfg2629') THEN RETURN END IF
  LET l_cmd = "abmi104 '",g_bmo.bmo01,"' ",
                    "'",g_bmp[l_ac].bmp02,"' ",
                    "'",g_bmp[l_ac].bmp16,"' ",
                    "'",g_bmo.bmo011,"' "
  CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION i100_remark()
  DEFINE   l_cmd   LIKE type_file.chr1000,      #No.FUN-680096 VARCHAR(200)
           l_chr   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
    IF cl_confirm('mfg2622') THEN  #No.MOD-480233
      LET l_cmd = "abmi103 '",g_bmo.bmo01,"' '",
                   g_bmp[l_ac].bmp02,"' '",
                   g_bmp[l_ac].bmp03,"' '",
                   g_bmo.bmo011,"' ",
                  "'",g_bmo.bmo06,"'"               #FUN-560027 add
       CALL cl_cmdrun_wait(l_cmd) #MOD-550153
   END IF
END FUNCTION
 
FUNCTION i100_bmp03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
    l_bmq011        LIKE bmq_file.bmq011,
    l_imaacti       LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima05,ima08,ima37,ima25,ima63,ima70,ima105,imaacti,ima107,ima86  #MOD-870162 add ima86
        INTO g_bmp[l_ac].ima02_b,g_bmp[l_ac].ima021_b,g_bmp[l_ac].ima05_b,
             g_ima08_b,g_ima37_b,g_ima25_b,g_ima63_b,
             g_ima70_b,g_bmp27,l_imaacti,g_ima107,g_ima86_b  #BugNo:6165  #MOD-870162 add ima86
        FROM ima_file
        WHERE ima01 = g_bmp[l_ac].bmp03
 
   #CASE WHEN SQLCA.SQLCODE = 100      #TQC-AC0274
        IF SQLCA.SQLCODE = 100 THEN    #TQC-AC0274
           SELECT bmq011,bmq02,bmq021,bmq05,bmq08,bmq37,bmq63,bmq105,bmqacti,bmq107,bmq25,bmq25 #BugNo:6165  #MOD-870162 add bmq25
               INTO l_bmq011,g_bmp[l_ac].ima02_b,g_bmp[l_ac].ima021_b,
                    g_bmp[l_ac].ima05_b,
                    g_ima08_b,g_ima37_b,g_ima63_b,g_bmp27,
                    l_imaacti,g_ima107,g_ima86_b,g_ima25_b #BugNo:6165  #MOD-870162 add ima86,ima25
               FROM bmq_file
               WHERE bmq01 = g_bmp[l_ac].bmp03
            IF SQLCA.sqlcode THEN
                LET g_errno = 'mfg2772'
                LET g_bmp[l_ac].ima02_b = NULL
                LET g_bmp[l_ac].ima021_b = NULL
                LET g_bmp[l_ac].ima05_b = NULL
                LET g_ima63_b = NULL    #NO:8555
                LET l_imaacti = NULL
            END IF
         END IF 
    CASE    
         WHEN l_imaacti='N' LET g_errno = '9028'
         
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_ima70_b IS NULL OR g_ima70_b = ' ' THEN
       LET g_ima70_b = 'N'
    END IF
    IF g_bmp27 IS NULL OR g_bmp27 = ' ' THEN LET g_bmp27= 'N' END IF
    #-->來源碼為'Z':雜項料件
    IF g_ima08_b ='Z' THEN LET g_errno = 'mfg2752' RETURN END IF
    #-->預設發料單位
     LET g_bmp[l_ac].bmp10 = g_ima63_b
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY g_bmp[l_ac].ima02_b TO s_bmp[l_sl].ima02_b
        DISPLAY g_bmp[l_ac].ima021_b TO s_bmp[l_sl].ima021_b
        DISPLAY g_bmp[l_ac].ima05_b TO s_bmp[l_sl].ima05_b
        LET g_bmp[l_ac].ima08_b = g_ima08_b
        DISPLAY g_bmp[l_ac].ima08_b TO s_bmp[l_sl].ima08_b
        DISPLAY g_bmp[l_ac].bmp10   TO s_bmp[l_sl].bmp10
    END IF
END FUNCTION
 
FUNCTION  i100_bmp10()
DEFINE l_gfeacti       LIKE gfe_file.gfeacti
 
LET g_errno = ' '
 
     SELECT gfeacti INTO l_gfeacti FROM gfe_file
       WHERE gfe01 = g_bmp[l_ac].bmp10
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
         WHEN l_gfeacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i100_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680096 VARCHAR(200)
 
    CLEAR ima02_b,ima021_b,ima05_b,ima08_b
    CONSTRUCT l_wc2 ON bmp02,bmp03,bmp06,bmp07,bmp10,bmp13
                       ,bmpud01,bmpud02,bmpud03,bmpud04,bmpud05
                       ,bmpud06,bmpud07,bmpud08,bmpud09,bmpud10
                       ,bmpud11,bmpud12,bmpud13,bmpud14,bmpud15
         FROM s_bmp[1].bmp02,s_bmp[1].bmp03,s_bmp[1].bmp06,
              s_bmp[1].bmp07,s_bmp[1].bmp10,s_bmp[1].bmp13,
              s_bmp[1].bmpud01,s_bmp[1].bmpud02,s_bmp[1].bmpud03,
              s_bmp[1].bmpud04,s_bmp[1].bmpud05,s_bmp[1].bmpud06,
              s_bmp[1].bmpud07,s_bmp[1].bmpud08,s_bmp[1].bmpud09,
              s_bmp[1].bmpud10,s_bmp[1].bmpud11,s_bmp[1].bmpud12,
              s_bmp[1].bmpud13,s_bmp[1].bmpud14,s_bmp[1].bmpud15
 
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i100_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i100_b_fill(p_wc2)
DEFINE   p_wc2       LIKE type_file.chr1000,  #No.FUN-680096  VARCHAR(300)
         l_bmq02     LIKE bmq_file.bmq02,
         l_bmq021    LIKE bmq_file.bmq021,
         l_bmq05     LIKE bmq_file.bmq05,
         l_bmq08     LIKE bmq_file.bmq08
 
    LET g_sql =
        "SELECT bmp02,bmp03,ima02,ima021,ima05,ima08,",
        "       bmp09,bmp16,bmp29,bmp06,bmp07,bmp10,bmp13,bmp08,bmp081,bmp082, ", #FUN-560027 add   #TQC-AC0183 add bmp081,bmp082
        "       bmpud01,bmpud02,bmpud03,bmpud04,bmpud05,",
        "       bmpud06,bmpud07,bmpud08,bmpud09,bmpud10,",
        "       bmpud11,bmpud12,bmpud13,bmpud14,bmpud15,",
        "       bmq02,bmq021,bmq05,bmq08  ",
        " FROM bmp_file LEFT OUTER JOIN ima_file ON (bmp_file.bmp03=ima_file.ima01) LEFT OUTER JOIN bmq_file ON (bmp_file.bmp03 = bmq_file.bmq01)",  #No.TQC-9A0117 mod
        " WHERE bmp01 ='",g_bmo.bmo01,"' AND",
        "       bmp011='",g_bmo.bmo011,"' AND",
        "       bmp28 ='",g_bmo.bmo06,"' AND ",p_wc2 CLIPPED  #FUN-560027 add  #No.TQC-9A0117 mod
 
    CASE g_sma.sma65
      WHEN '1'  LET g_sql = g_sql CLIPPED, " ORDER BY 1,2,4"
      WHEN '2'  LET g_sql = g_sql CLIPPED, " ORDER BY 2,1,4"
      WHEN '3'  LET g_sql = g_sql CLIPPED, " ORDER BY 7,1,4"
      OTHERWISE LET g_sql = g_sql CLIPPED, " ORDER BY 1,2,4"
    END CASE
 
    PREPARE i100_pb FROM g_sql
    DECLARE bmp_curs                       #CURSOR
        CURSOR WITH HOLD FOR i100_pb
 
    CALL g_bmp.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH bmp_curs INTO g_bmp[g_cnt].*,l_bmq02,l_bmq021,l_bmq05,l_bmq08
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_bmp[g_cnt].ima02_b IS NULL OR g_bmp[g_cnt].ima02_b = ' '
        THEN LET g_bmp[g_cnt].ima02_b = l_bmq02
        END IF
        IF g_bmp[g_cnt].ima021_b IS NULL OR g_bmp[g_cnt].ima021_b = ' '
        THEN LET g_bmp[g_cnt].ima021_b = l_bmq021
        END IF
        IF g_bmp[g_cnt].ima05_b IS NULL OR g_bmp[g_cnt].ima05_b = ' '
        THEN LET g_bmp[g_cnt].ima05_b = l_bmq05
        END IF
        IF g_bmp[g_cnt].ima08_b IS NULL OR g_bmp[g_cnt].ima08_b = ' '
        THEN LET g_bmp[g_cnt].ima08_b = l_bmq08
        END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_bmp.deleteElement(g_cnt)
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmp TO s_bmp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
   BEFORE DISPLAY
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      IF g_sma.sma104 != 'Y' THEN
          CALL cl_set_act_visible("contract_product",FALSE)
      END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i100_fetch('L')
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
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_field_pic("","","","","",g_bmo.bmoacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION insert_loc
         LET g_action_choice="insert_loc"
         EXIT DISPLAY
      ON ACTION brand
         LET g_action_choice="brand"
         EXIT DISPLAY
      ON ACTION rep_sub
         LET g_action_choice="rep_sub"
         EXIT DISPLAY
      ON ACTION contents
         LET g_action_choice="contents"
         EXIT DISPLAY
      ON ACTION e_bom_copy
         LET g_action_choice="e_bom_copy"
         EXIT DISPLAY
      ON ACTION p_bom_copy
         LET g_action_choice="p_bom_copy"
         EXIT DISPLAY
      ON ACTION contact_product
         LET g_action_choice="contact_product"
         EXIT DISPLAY
      ON ACTION bom_description
         LET g_action_choice="bom_description"
         EXIT DISPLAY
      ON ACTION related_document
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
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i100_copy()
   DEFINE new_no,old_no LIKE bmo_file.bmo01,
          old_bma06     LIKE bma_file.bma06, #FUN-550095 add
          new_bmo06     LIKE bmo_file.bmo06, #FUN-560027 add
          verno         LIKE bmo_file.bmo011,
          l_bmt         RECORD LIKE bmt_file.*,
          l_bmc         RECORD LIKE bmc_file.*,
          l_bml         RECORD LIKE bml_file.*,
          l_bmd         RECORD LIKE bmd_file.*,
          l_bmb         RECORD LIKE bmb_file.*,
          l_bma         RECORD LIKE bma_file.*,
          l_ima         RECORD LIKE ima_file.*,
          l_bmb02       LIKE bmb_file.bmb02,
          ans_2,ans_3   LIKE type_file.chr1,         #No.FUN-680096 VARCHAR(1)
          ans_4,ans_5,ans_6   LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          l_dir         LIKE type_file.chr1,         #No.FUN-680096 VARCHAR(1)
          l_cmd         LIKE type_file.chr1000,      #No.FUN-680096 VARCHAR(400)
          l_sql         LIKE type_file.chr1000       #No.FUN-680096 VARCHAR(400)
 
   IF s_shut(0) THEN RETURN END IF
   LET p_row = 12 LET p_col = 24
   OPEN WINDOW i100_s_w AT p_row,p_col WITH FORM "abm/42f/abmi100_s"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abmi100_s")
 
   CALL cl_set_comp_visible("new_bmo06,old_bma06",g_sma.sma118='Y')
 
   LET old_no = NULL
   LET old_bma06 = NULL  #FUN-550095 add
   LET new_no = NULL
   LET new_bmo06 = NULL  #FUN-560027 add
   LET verno  = NULL
   IF g_sma.sma118='Y' THEN
       CALL cl_set_comp_entry("ans_2,ans_4,ans_6",FALSE)
       LET ans_2 = 'N'
       LET ans_3 = 'Y'
       LET ans_4 = 'N'
       LET ans_5 = 'Y'
       LET ans_6 = 'N'
   ELSE
       LET ans_2 = 'Y'
       LET ans_3 = 'Y'
       LET ans_4 = 'Y'
       LET ans_5 = 'Y'
       LET ans_6 = 'Y'
   END IF
   LET g_before_input_done = FALSE   #FUN-580024
   CALL i100_set_entry('a')          #FUN-580024
   LET g_before_input_done = TRUE    #FUN-580024
   INPUT BY NAME old_no,old_bma06,new_no,new_bmo06,verno,ans_2,ans_3,ans_4,ans_5,ans_6 #FUN-550095 add old_bma06 #FUN-560027 add new_bmo06
               WITHOUT DEFAULTS
      AFTER FIELD old_no
        IF NOT cl_null(old_no) THEN
            IF g_sma.sma118 <> 'Y' THEN
                SELECT count(*) INTO g_cnt
                  FROM bma_file
                 WHERE bma01 = old_no
                IF g_cnt=0 THEN
                   CALL cl_err('bma_file',100,0)
                   NEXT FIELD old_no
                END IF
            END IF
        END IF
      AFTER FIELD old_bma06
        IF old_bma06 IS NULL THEN
            LET old_bma06 = ' '
        END IF
        IF NOT cl_null(old_no) THEN
            IF g_sma.sma118 <> 'Y' THEN
                SELECT count(*) INTO g_cnt
                  FROM bma_file
                 WHERE bma01 = old_no
                   AND bma06 = old_bma06
                IF g_cnt=0 THEN
                   CALL cl_err('bma_file',100,0)
                   NEXT FIELD old_no
                END IF
            END IF
        END IF
      AFTER FIELD new_no
        IF NOT cl_null(new_no) THEN
            SELECT count(*) INTO g_cnt FROM ima_file WHERE ima01 = new_no
            IF g_cnt=0 THEN
               SELECT count(*) INTO g_cnt FROM bmq_file
                               WHERE bmq01 = new_no
               IF g_cnt= 0 THEN
                  CALL cl_err('bmq_file',100,0)
                  NEXT FIELD new_no
               END IF
            END IF
        END IF
      AFTER FIELD verno
          IF g_sma.sma118 != 'Y' THEN #FUN-560027 add if 判斷
              LET new_bmo06 = ' '
          ELSE
              IF new_bmo06 IS NULL THEN
                  LET new_bmo06 = ' '
              END IF
          END IF
          SELECT count(*) INTO g_cnt FROM bmo_file
           WHERE bmo01 = new_no
             AND bmo06 = new_bmo06
             AND bmo011= verno
          IF g_cnt > 0 THEN   #資料重複
             CALL cl_err(new_no,-239,0)
             NEXT FIELD new_no
          END IF
 
      AFTER FIELD ans_2
        IF NOT cl_null(ans_2) THEN
            IF ans_2 NOT MATCHES "[YN]" THEN NEXT FIELD ans_2 END IF
        END IF
 
      AFTER FIELD ans_3
        IF NOT cl_null(ans_3) THEN
            IF ans_3 NOT MATCHES "[YN]" THEN NEXT FIELD ans_3 END IF
        END IF
 
      AFTER FIELD ans_4
        IF NOT cl_null(ans_4) THEN
            IF ans_4 NOT MATCHES "[YN]" THEN NEXT FIELD ans_4 END IF
        END IF
      AFTER FIELD ans_5
        IF NOT cl_null(ans_5) THEN
            IF ans_5 NOT MATCHES "[YN]" THEN NEXT FIELD ans_5 END IF
        END IF
       ON ACTION CONTROLP
            CASE
               WHEN INFIELD(old_no)
                    CALL cl_init_qry_var()
                    IF g_sma.sma118 != 'Y' THEN         #FUN-560027 add if 判斷
                        LET g_qryparam.form = "q_bma"
                        LET g_qryparam.default1 = old_no
                        CALL cl_create_qry() RETURNING old_no #FUN-560027 add bma06
                        DISPLAY BY NAME old_no                #FUN-560027 add bma06
                    ELSE
                        LET g_qryparam.form = "q_bma6"
                        LET g_qryparam.default1 = old_no
                        CALL cl_create_qry() RETURNING old_no,old_bma06 #FUN-560027 add bma06
                        DISPLAY BY NAME old_no,old_bma06                #FUN-560027 add bma06
                    END IF
                    NEXT FIELD old_no
 
               WHEN INFIELD(new_no)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_bmq"           #No.MOD-810058 modify
                    LET g_qryparam.default1 = new_no
                    CALL cl_create_qry() RETURNING new_no
                    DISPLAY BY NAME new_no
                    NEXT FIELD new_no
               OTHERWISE EXIT CASE
             END CASE
 
        ON ACTION mntn_test_item
                    LET l_cmd = "abmi109 '",new_no,"'"
                    CALL cl_cmdrun(l_cmd)
                    NEXT FIELD bmo01
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   CLOSE WINDOW i100_s_w
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
   END IF
   MESSAGE ' COPY.... '
   BEGIN WORK
   IF old_bma06 IS NULL THEN LET old_bma06 = ' ' END IF #FUN-550095 add
   IF new_bmo06 IS NULL THEN LET new_bmo06 = ' ' END IF #FUN-560027 add
#----- COPY BODY FROM (bmc_file) TO (bec_file) 複製說明檔---------------------
   LET g_cnt = 0
   IF ans_3 = 'Y' THEN
      LET l_sql = " SELECT bmc_file.* FROM bmc_file,bmb_file ",
                  " WHERE bmb01 = bmc01 ",
                  "   AND bmb02 = bmc02   ",
                  "   AND bmb03 = bmc021  ",
                  "   AND bmb04 = bmc03   ",
                  "   AND bmb29 = bmc06   ",       #FUN-550095 add
                  "   AND bmb01=  '",old_no,"'",
                  "   AND bmb29=  '",old_bma06,"'" #FUN-550095 add
      IF ans_2 = 'N' THEN
         LET l_sql = l_sql CLIPPED,
                     " AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
                     " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"
      END IF
      PREPARE i100_pbmc FROM l_sql
      DECLARE i100_bmc_cs CURSOR FOR i100_pbmc
      FOREACH i100_bmc_cs INTO l_bmc.*
         LET l_bmc.bmc01 = new_no
         LET l_bmc.bmc03 = NULL
          INSERT INTO bec_file (bec01,bec011,bec02,bec021,bec03,bec04,bec05,bec06)  #No.MOD-470041 #FUN-560027 add bec06
              VALUES(new_no,verno,l_bmc.bmc02,l_bmc.bmc021,                                     #FUN-560027
                     l_bmc.bmc03,l_bmc.bmc04,l_bmc.bmc05,new_bmo06)                             #FUN-560027 add l_bmc.bmc06
        IF STATUS THEN
         CALL cl_err3("ins","bec_file",new_no,l_bmc.bmc02,STATUS,"","ins bec:",1)  #No.TQC-660046
         RETURN END IF
        IF SQLCA.SQLCODE OR STATUS THEN
           CALL cl_err3("ins","bec_file",new_no,l_bmc.bmc02,SQLCA.sqlcode,"","ins bec:",1)  #No.TQC-660046
           ROLLBACK WORK  #FUN-560027 add
           RETURN
        END IF
        LET g_cnt = g_cnt + 1
      END FOREACH
      MESSAGE '(',g_cnt USING '##&',') ROW of ( bmc:',new_no,') O.K'
   END IF
#--- COPY BODY FROM (bml_file) TO (bel_file) 複製元件廠牌檔 -----------------
   LET g_cnt = 0
   IF ans_4 = 'Y' THEN
      LET l_sql = " SELECT bml_file.* FROM bml_file,bmb_file ",
                  " WHERE bmb01 = bml02 ",
                  "   AND bmb03 = bml01 ",
                  "   AND bmb01= '",old_no,"'"
      IF ans_2 = 'N' THEN
         LET l_sql = l_sql CLIPPED,
                     " AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
                     " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"
      END IF
      PREPARE i100_pbml FROM l_sql
      DECLARE i100_bml_cs CURSOR FOR i100_pbml
      FOREACH i100_bml_cs INTO l_bml.*
          LET l_bml.bml02 = new_no
           INSERT INTO bel_file (bel01,bel011,bel02,bel03,bel04,bel05,bel06) #No.MOD-470041
               VALUES(l_bml.bml01,verno,l_bml.bml02,l_bml.bml03,l_bml.bml04,
                      l_bml.bml05,l_bml.bml06)
         IF STATUS THEN 
           CALL cl_err3("ins","bel_file",l_bml.bml01,l_bml.bml02,STATUS,"","ins bel:",1)  #No.TQC-660046
           RETURN END IF
         IF SQLCA.SQLCODE OR STATUS THEN
           CALL cl_err3("ins","bel_file",l_bml.bml01,l_bml.bml02,SQLCA.SQLCODE,"","ins bel:",1)  #No.TQC-660046
           ROLLBACK WORK  #FUN-560027 add
           RETURN
          END IF
          LET g_cnt = g_cnt + 1
      END FOREACH
      MESSAGE '(',g_cnt USING '##&',') ROW of (bel:',new_no,') O.K'
   END IF
#--- COPY BODY FROM (bmt_file) TO (bmu_file) 複製插件位置檔 -----------------
   LET g_cnt = 0
   IF ans_5 = 'Y' THEN
      LET l_sql = " SELECT bmt_file.* FROM bmt_file,bmb_file ",
                  " WHERE bmb01 = bmt01 ",
                  "   AND bmb02 = bmt02 ",
                  "   AND bmb03 = bmt03 ",
                  "   AND bmb04 = bmt04 ",
                  "   AND bmb29 = bmt08 ", #FUN-550095 add
                  "   AND bmb01= '",old_no,"'",
                  "   AND bmb29= '",old_bma06,"'" #FUN-550095 add
      IF ans_2 = 'N' THEN
         LET l_sql = l_sql CLIPPED,
                     " AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
                     " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"
      END IF
      PREPARE i100_pbmt FROM l_sql
      DECLARE i100_bmt_cs CURSOR FOR i100_pbmt
      FOREACH i100_bmt_cs INTO l_bmt.*
           INSERT INTO bmu_file (bmu01,bmu011,bmu02,bmu03,bmu04,bmu05,bmu06,bmu07,bmu08)  #No.MOD-470041  #FUN-560027 add bmu08
               VALUES(new_no,verno,l_bmt.bmt02,l_bmt.bmt03,l_bmt.bmt04,
                      l_bmt.bmt05,l_bmt.bmt06,l_bmt.bmt07,new_bmo06)                                   #FUN-560027 add l_bmt.bmt08
          IF STATUS THEN
             CALL cl_err3("ins","bmu_file",new_no,l_bmt.bmt02,STATUS,"","ins bmu:",1)  #No.TQC-660046
             RETURN END IF
          IF SQLCA.SQLCODE OR STATUS THEN
             CALL cl_err3("ins","bmu_file",new_no,l_bmt.bmt02,SQLCA.SQLCODE,"","ins bmu:",1)  #No.TQC-660046
             ROLLBACK WORK  #FUN-560027 add
             RETURN
          END IF
         #No.+037..end
          LET g_cnt = g_cnt + 1
      END FOREACH
      MESSAGE '(',g_cnt USING '##&',') ROW of (bmu:',new_no,') O.K'
   END IF
#--- COPY BODY FROM (bmd_file) TO (bed_file) 複製取替代檔 -----------------
   LET g_cnt = 0
   IF ans_6 = 'Y' THEN
      LET l_sql = " SELECT UNIQUE bmd_file.*,bmb02 FROM bmd_file,bmb_file ", #FUN-550095 add UNIQUE
                  " WHERE bmd01 = bmb03 ",
                  "   AND bmd08 = bmb01 ",
                  "   AND bmd08= '",old_no,"'",
                  "   AND bmdacti = 'Y'"                                           #CHI-910021
      IF ans_2 = 'N' THEN
         LET l_sql = l_sql CLIPPED,
                     " AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
                     " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"
      END IF
      PREPARE i100_pbmd FROM l_sql
      DECLARE i100_bmd_cs CURSOR FOR i100_pbmd
      FOREACH i100_bmd_cs INTO l_bmd.*,l_bmb02
           INSERT INTO bed_file (bed01,bed011,bed012,bed02,bed03,bed04,bed05,  #No.MOD-470041
                                bed06,bed07,bed09)
               VALUES(new_no,verno,l_bmb02,l_bmd.bmd02,l_bmd.bmd03,l_bmd.bmd04,
                      l_bmd.bmd05,l_bmd.bmd06,l_bmd.bmd07,l_bmd.bmd09)
          IF STATUS THEN 
              CALL cl_err3("ins","bed_file",new_no,l_bmb02,STATUS,"","ins bed:",1)  #No.TQC-660046
              RETURN END IF
          IF SQLCA.SQLCODE OR STATUS THEN
             CALL cl_err3("ins","bed_file",new_no,l_bmb02,SQLCA.SQLCODE,"","ins bed:",1)  #No.TQC-660046
             ROLLBACK WORK  #FUN-560027 add
             RETURN
          END IF
          LET g_cnt = g_cnt + 1
      END FOREACH
      MESSAGE '(',g_cnt USING '##&',') ROW of (bmd:',new_no,') O.K'
   END IF
#--------------- COPY HEAD From(bma_file) TO (bmo_file) ------------------
   SELECT bma_file.* INTO l_bma.* FROM bma_file WHERE bma01=old_no
                                                  AND bma06=old_bma06 #FUN-550095 add
    INSERT INTO bmo_file(bmo01,bmo011,bmo02,bmo03,bmo04,bmo05,bmouser,  #No.MOD-470041
                        bmogrup,bmomodu,bmodate,bmoacti,bmo06,bmooriu,bmoorig)        #FUN-560027 add bmo06
        VALUES(new_no,verno,l_bma.bma02,l_bma.bma03,l_bma.bma04,NULL,
               g_user,g_grup,' ',g_today,'Y',new_bmo06, g_user, g_grup)               #FUN-560027 add new_bmo06      #No.FUN-980030 10/01/04  insert columns oriu, orig
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('ins bmo: ',SQLCA.SQLCODE,1)
      ROLLBACK WORK  #FUN-560027 add
      RETURN
   END IF
#--------------- COPY HEAD From(bmb_file) TO (bmp_file) ------------------
   LET g_cnt = 0
   LET l_sql = " SELECT * FROM bmb_file WHERE bmb01= '",old_no ,"'",
                                        " AND bmb29= '",old_bma06,"'" #FUN-550095 add
   IF ans_2 = 'N' THEN
         LET l_sql = l_sql CLIPPED,
                     " AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
                     " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"
   END IF
   PREPARE i100_pbmb FROM l_sql
   DECLARE i100_bmb_cs CURSOR FOR i100_pbmb
   FOREACH i100_bmb_cs INTO l_bmb.*
       LET l_bmb.bmb01 = new_no
       LET l_bmb.bmb04 = NULL
       LET l_bmb.bmb05 = NULL
       IF ans_5='N' THEN LET l_bmb.bmb13 = NULL END IF #no.6542
       IF cl_null(l_bmb.bmb04) THEN
          LET l_bmb.bmb04=0
       END IF
        INSERT INTO bmp_file (bmp01,bmp011,bmp02,bmp03,bmp04,bmp05,bmp06,bmp07,  #No.MOD-470041
                             bmp08,bmp081,bmp082,bmp09,bmp10,bmp10_fac,bmp10_fac2,bmp11,  #TQC-AC0183 add bmp081,bmp082
                             bmp13,bmp14,bmp15,bmp16,bmp17,bmp18,bmp19,bmp20,
                              bmp21,bmp22,bmp23,bmp24,bmp25,bmp26,bmp27,bmpmodu,#MOD-4C0087
                             bmpdate,bmpcomm,bmp28,bmp29) #FUN-560027 add bmp28,bmp29
            VALUES(new_no     ,verno,l_bmb.bmb02,l_bmb.bmb03,l_bmb.bmb04,          #FUN-560027
                   l_bmb.bmb05,l_bmb.bmb06,l_bmb.bmb07,l_bmb.bmb08,l_bmb.bmb081,l_bmb.bmb082, #TQC-AC0183 add bmb081,bmb082
                   l_bmb.bmb09,l_bmb.bmb10,l_bmb.bmb10_fac,l_bmb.bmb10_fac2,l_bmb.bmb11,
                   l_bmb.bmb13,l_bmb.bmb14,l_bmb.bmb15,l_bmb.bmb16,l_bmb.bmb17,
                   l_bmb.bmb18,l_bmb.bmb19,l_bmb.bmb20,l_bmb.bmb21,l_bmb.bmb22,
                   l_bmb.bmb23,l_bmb.bmb24,l_bmb.bmb25,l_bmb.bmb26,l_bmb.bmb27,
                   g_user,g_today,'',new_bmo06,l_bmb.bmb30) #FUN-560027 add bmb29,bmb30
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('ins bmp: ',SQLCA.SQLCODE,1)
           ROLLBACK WORK  #FUN-560027 add
           RETURN
        END IF
       LET g_cnt = g_cnt + 1
   END FOREACH
   MESSAGE '(',g_cnt USING '##&',') ROW of (bmp:',new_no,') O.K'
   COMMIT WORK
END FUNCTION
 
FUNCTION i100_copy2()
   DEFINE new_bmo06,old_bmo06 LIKE bmo_file.bmo06 #FUN-560027 add
   DEFINE new_no,old_no LIKE bmo_file.bmo01,
          verno1,verno2 LIKE bmo_file.bmo011,
          l_bmp         RECORD LIKE bmp_file.*,
          l_bmo         RECORD LIKE bmo_file.*,
          l_ima         RECORD LIKE ima_file.*,
          l_bmq011      LIKE bmq_file.bmq011,
          ans_2,ans_3   LIKE type_file.chr1,         #No.FUN-680096 VARCHAR(1)
          ans_4,ans_5,ans_6   LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          l_dir         LIKE type_file.chr1,         #No.FUN-680096 VARCHAR(1)
          l_cmd         LIKE type_file.chr1000,      #No.FUN-680096 VARCHAR(400)
          l_sql         LIKE type_file.chr1000       #No.FUN-680096 VARCHAR(400)
 
   IF s_shut(0) THEN RETURN END IF
   LET p_row = 12 LET p_col = 24
   OPEN WINDOW i100_c_w AT p_row,p_col WITH FORM "abm/42f/abmi100_c"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abmi100_c")
 
   CALL cl_set_comp_visible("new_bmo06,old_bmo06",g_sma.sma118='Y')
 
   LET old_no = NULL
   LET verno1 = NULL
   LET new_no = NULL
   LET verno2 = NULL
   IF g_sma.sma118='Y' THEN
       CALL cl_set_comp_entry("ans_4,ans_6",FALSE) #FUN-560027 add bmo06
       LET ans_3  = 'Y'    LET ans_4  = 'N'   LET ans_5 = 'Y'  LET ans_6 = 'N'
   ELSE
       LET ans_3  = 'Y'    LET ans_4  = 'Y'   LET ans_5 = 'Y'  LET ans_6 = 'Y'
   END IF
   LET g_before_input_done = FALSE   #FUN-580024
   CALL i100_set_entry('a')          #FUN-580024
   LET g_before_input_done = TRUE    #FUN-580024
   INPUT BY NAME old_no,old_bmo06,verno1,new_no,new_bmo06,verno2,ans_3,ans_4,ans_5,ans_6 #FUN-560027 add old_bmo06,new_bmo06
               WITHOUT DEFAULTS
 
      AFTER FIELD old_no
        IF NOT cl_null(old_no) THEN
            SELECT count(*) INTO g_cnt FROM bmo_file
                                      WHERE bmo01 = old_no
            IF g_cnt=0 THEN
               CALL cl_err('bmo_file',100,0)
               NEXT FIELD old_no
            END IF

        END IF
      AFTER FIELD verno1
        IF NOT cl_null(verno1) THEN
            SELECT count(*) INTO g_cnt FROM bmo_file
                                      WHERE bmo01 = old_no AND bmo011 = verno1
            IF g_cnt=0 THEN
               CALL cl_err('bmo01+bmo011',100,0)
               NEXT FIELD verno1
            END IF
        END IF
 
      AFTER FIELD verno2
        #-->check bom 是否存在
        IF NOT cl_null(verno2) THEN
            IF new_bmo06 IS NULL THEN LET new_bmo06 = ' ' END IF
            SELECT count(*) INTO g_cnt FROM bmo_file
                                      WHERE bmo01 = new_no AND bmo011 = verno2
                                        AND bmo06 = new_bmo06 #FUN-560027 add
            IF g_cnt>0 THEN
               CALL cl_err('bmo_file',-239,0)
               NEXT FIELD new_no
            END IF
            #-->check ima_file
            SELECT count(*) INTO g_cnt FROM ima_file WHERE ima01 = new_no
            IF g_cnt=0 THEN
               SELECT count(*) INTO g_cnt FROM bmq_file
                               WHERE bmq01 = new_no
               IF g_cnt= 0 THEN
                  CALL cl_err('bmq_file',100,0)
                  NEXT FIELD new_no
               END IF
            END IF
        END IF
 
      AFTER FIELD ans_3
        IF NOT cl_null(ans_3) THEN
            IF ans_3 NOT MATCHES "[YN]" THEN NEXT FIELD ans_3 END IF
        END IF
 
      AFTER FIELD ans_4
        IF NOT cl_null(ans_4) THEN
            IF ans_4 NOT MATCHES "[YN]" THEN NEXT FIELD ans_4 END IF
        END IF
 
      AFTER FIELD ans_5
        IF NOT cl_null(ans_5) THEN
            IF ans_5 NOT MATCHES "[YN]" THEN NEXT FIELD ans_5 END IF
        END IF
 
      AFTER FIELD ans_6
        IF NOT cl_null(ans_6) THEN
            IF ans_6 NOT MATCHES "[YN]" THEN NEXT FIELD ans_6 END IF
        END IF
 
       ON ACTION CONTROLP
            CASE
               WHEN INFIELD(old_no)
                    CALL cl_init_qry_var()
                    IF g_sma.sma118 != 'Y' THEN         #FUN-560027 add if 判斷
                        LET g_qryparam.form = "q_bmo"
                        LET g_qryparam.default1 = old_no
                        CALL cl_create_qry() RETURNING old_no,verno1
                        DISPLAY BY NAME old_no,verno1
                    ELSE
                        LET g_qryparam.form = "q_bmo2"
                        LET g_qryparam.default1 = old_no
                        CALL cl_create_qry() RETURNING old_no,verno1,old_bmo06 #FUN-560027 add bmo06
                        DISPLAY BY NAME old_no,verno1,old_bmo06                #FUN-560027 add bmo06
                    END IF
                    NEXT FIELD old_no
               WHEN INFIELD(new_no)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_bmq"           #FUN-560027
                    LET g_qryparam.default1 = new_no
                    CALL cl_create_qry() RETURNING new_no   #FUN-560027
                    DISPLAY BY NAME new_no
                    NEXT FIELD new_no
               OTHERWISE EXIT CASE
             END CASE
 
        ON ACTION mntn_test_item
                    LET l_cmd = "abmi109 '",new_no,"'"
                    CALL cl_cmdrun(l_cmd)
                    NEXT FIELD bmo01
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   CLOSE WINDOW i100_c_w
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
   END IF
   MESSAGE ' COPY.... '
   BEGIN WORK
   IF old_bmo06 IS NULL THEN LET old_bmo06 = ' ' END IF #FUN-560027 add
   IF new_bmo06 IS NULL THEN LET new_bmo06 = ' ' END IF #FUN-560027 add
#-------------------- COPY BODY (bec_file) ------------------------------
   IF ans_3 = 'Y' THEN
      DROP TABLE w
      LET l_sql = " SELECT bec_file.* FROM bec_file,bmp_file ",
                  " WHERE bmp01 = bec01 ",
                  "   AND bmp28 = bec06 ", #FUN-560027 add
                  "   AND bmp011= bec011",
                  "   AND bmp02 = bec02  ",
                  "   AND bmp03 = bec021 ",
                  "   AND bmp01 =  '",old_no,"'",
                  "   AND bmp28 =  '",old_bmo06,"'", #FUN-560027 add
                  "   AND bmp011=  '",verno1,"'"
      LET l_sql = l_sql clipped," INTO TEMP w "
      PREPARE i100_pbec FROM l_sql
      EXECUTE i100_pbec
      IF SQLCA.sqlcode THEN
         CALL cl_err('i100_pbec',SQLCA.sqlcode,0)
         ROLLBACK WORK #FUN-560027 add
         RETURN
      END IF
      UPDATE w SET bec01=new_no,
                   bec06=new_bmo06, #FUN-560027 add
                   bec011=verno2,
                   bec03=NULL
      INSERT INTO bec_file SELECT * FROM w
      IF SQLCA.SQLCODE OR STATUS THEN
         CALL cl_err('ins bec: ',SQLCA.SQLCODE,1)
         ROLLBACK WORK #FUN-560027 add
         RETURN
      END IF
      LET g_cnt=SQLCA.SQLERRD[3]
      MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'
   END IF
#-------------------- COPY BODY (bel_file) ------------------------------
   IF ans_4 = 'Y' THEN
      DROP TABLE z
      LET l_sql = " SELECT bel_file.* FROM bel_file,bmp_file ",
                  " WHERE bmp01 = bel02 ",
                  "   AND bmp011= bel011",
                  "   AND bmp03 = bel01 ",
                  "   AND bmp01 = '",old_no,"'",
                  "   AND bmp011= '",verno1,"'"
      LET l_sql = l_sql clipped," INTO TEMP z "
      PREPARE i100_pbel FROM l_sql
      EXECUTE i100_pbel
      IF SQLCA.sqlcode THEN
         CALL cl_err('i100_pbml',SQLCA.sqlcode,0)
         ROLLBACK WORK #FUN-560027 add
         RETURN
      END IF
 
      UPDATE z SET bel02=new_no,bel011=verno2
      INSERT INTO bel_file SELECT * FROM z
      IF SQLCA.SQLCODE OR STATUS THEN
         CALL cl_err('ins bel: ',SQLCA.SQLCODE,1)
         ROLLBACK WORK #FUN-560027 add
         RETURN
      END IF
      LET g_cnt=SQLCA.SQLERRD[3]
      MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'
   END IF
#-------------------- COPY BODY (bmu_file) ------------------------------
   IF ans_5 = 'Y' THEN
      DROP TABLE u
      LET l_sql = " SELECT bmu_file.* FROM bmu_file,bmp_file ",
                  " WHERE bmp01 = bmu01 ",
                  "   AND bmp011= bmu011",
                  "   AND bmp28 = bmu08",     #FUN-560027 add
                  "   AND bmp03 = bmu03 ",
                  "   AND bmp02 = bmu02 ",    #MOD-920088 add
                  "   AND bmp01 = '",old_no,"'",
                  "   AND bmp28 = '",old_bmo06,"'", #FUN-560027 add
                  "   AND bmp011= '",verno1,"'"
      LET l_sql = l_sql clipped," INTO TEMP u "
      PREPARE i100_pbmu FROM l_sql
      EXECUTE i100_pbmu
      IF SQLCA.sqlcode THEN
         CALL cl_err('i100_pbmu',SQLCA.sqlcode,0)
         ROLLBACK WORK #FUN-560027 add
         RETURN
      END IF
 
      UPDATE u SET bmu01=new_no,bmu08=new_bmo06,bmu011=verno2 #FUN-560027 add
      INSERT INTO bmu_file SELECT * FROM u
      IF SQLCA.SQLCODE OR STATUS THEN
         CALL cl_err('ins bmu: ',SQLCA.SQLCODE,1)
         ROLLBACK WORK #FUN-560027 add
         RETURN
      END IF
      LET g_cnt=SQLCA.SQLERRD[3]
      MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'
   END IF
#-------------------- COPY BODY (bed_file) ------------------------------
   IF ans_6 = 'Y' THEN   #FUN-560027
      DROP TABLE v
      LET l_sql = " SELECT bed_file.* FROM bed_file,bmp_file ",
                  " WHERE bmp01 = bed01  ",
                  "   AND bmp011= bed011",
                  "   AND bmp02 = bed012 ",
                  "   AND bmp01 = '",old_no,"'",
                  "   AND bmp011= '",verno1,"'"
      LET l_sql = l_sql clipped," INTO TEMP v "
      PREPARE i100_pbed FROM l_sql
      EXECUTE i100_pbed
      IF SQLCA.sqlcode THEN
         CALL cl_err('i100_pbed',SQLCA.sqlcode,0)
         ROLLBACK WORK #FUN-560027 add
         RETURN
      END IF
 
      UPDATE v SET bed01=new_no,bed011=verno2
      INSERT INTO bed_file SELECT * FROM v
      IF SQLCA.SQLCODE THEN
         CALL cl_err('ins bed: ',SQLCA.SQLCODE,1)
         ROLLBACK WORK #FUN-560027 add
         RETURN
      END IF
      LET g_cnt=SQLCA.SQLERRD[3]
      MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'
   END IF
#--------------- COPY HEAD  (bmo_file) --------------------------------------
   SELECT bmo_file.* INTO l_bmo.* FROM bmo_file
                     WHERE bmo01=old_no
                       AND bmo06=old_bmo06 #FUN-560027 add
                       AND bmo011=verno1
    INSERT INTO bmo_file (bmo01,bmo011,bmo02,bmo03,bmo04,bmo05,bmouser,  #No.MOD-470041
                         bmogrup,bmomodu,bmodate,bmoacti,bmo06,bmooriu,bmoorig) #FUN-560027 add bmo06
        VALUES(new_no,verno2,l_bmo.bmo02,l_bmo.bmo03,l_bmo.bmo04,NULL,
               g_user,g_grup,' ',g_today,'Y',new_bmo06, g_user, g_grup) #FUN-560027 add bmo06      #No.FUN-980030 10/01/04  insert columns oriu, orig
   IF SQLCA.SQLCODE OR STATUS THEN
      CALL cl_err('ins bmo: ',SQLCA.SQLCODE,1)
      ROLLBACK WORK #FUN-560027 add
      RETURN
   END IF
#--------------- COPY BODY (bmp_file) ---------------------------------------
   DROP TABLE x
   SELECT * FROM bmp_file WHERE bmp01=old_no AND bmp28=old_bmo06 AND bmp011=verno1 INTO TEMP x #FUN-560027 add bmp28
   IF STATUS THEN
       CALL cl_err3("sel","bmp_file",old_no,old_bmo06,STATUS,"","sel bmp",1)  #No.TQC-660046
       ROLLBACK WORK #FUN-560027 add
       RETURN
   END IF
   UPDATE x SET bmp01=new_no,
                bmp28=new_bmo06, #FUN-560027 add
                bmp011=verno2,
                bmp05= NULL
   IF ans_5='N' THEN UPDATE x SET bmp13=NULL END IF
   INSERT INTO bmp_file SELECT * FROM x
   IF SQLCA.SQLCODE OR STATUS THEN
      CALL cl_err('ins bmp: ',SQLCA.SQLCODE,1)
      ROLLBACK WORK #FUN-560027 add
      RETURN
   END IF
   #FUN-C30027---begin
   SELECT * 
     INTO g_bmo.*
     FROM bmo_file
    WHERE bmo01 = new_no
      AND bmo011 = verno2
      AND bmo06 = new_bmo06
   CALL i100_show()
   #FUN-C30027---end
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'
   COMMIT WORK
END FUNCTION
 
#輸入插件位置bmu_file
FUNCTION i100_ins_bmu()
DEFINE   l_qpa     LIKE bmp_file.bmp06,
         l_tot     LIKE bmp_file.bmp06
 
    IF cl_null(g_bmp[l_ac].bmp02) OR
       cl_null(g_bmp[l_ac].bmp03) THEN
        RETURN
    END IF
 
    #如果bmp_file的unique KEY 有做變動,則影嚮bmu_file
    IF g_bmp[l_ac].bmp02 != g_bmp_t.bmp02 OR
       g_bmp[l_ac].bmp03 != g_bmp_t.bmp03 THEN
         DELETE FROM bmu_file
          WHERE bmu01 =g_bmo.bmo01
            AND bmu011=g_bmo.bmo011
            AND bmu02 =g_bmp_t.bmp02
            AND bmu03 =g_bmp_t.bmp03
            AND bmu08 =g_bmo.bmo06 #FUN-560027 add
    END IF
    LET l_qpa = g_bmp[l_ac].bmp06 / g_bmp[l_ac].bmp07
    SELECT SUM(bmu07)
      INTO l_tot
      FROM bmu_file
     WHERE bmu01 =g_bmo.bmo01
       AND bmu011=g_bmo.bmo011
       AND bmu02 =g_bmp[l_ac].bmp02
       AND bmu03 =g_bmp[l_ac].bmp03
       AND bmu08 =g_bmo.bmo06 #FUN-560027 add
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    IF l_tot > 0  THEN
        CALL i300(g_bmo.bmo01,g_bmp[l_ac].bmp02, g_bmp[l_ac].bmp03,'9999/12/30','u',l_qpa,g_bmo.bmo011,g_bmo.bmo06) #修改 #FUN-550027 add bmo06
    ELSE
        CALL i300(g_bmo.bmo01,g_bmp[l_ac].bmp02, g_bmp[l_ac].bmp03,'9999/12/30','a',l_qpa,g_bmo.bmo011,g_bmo.bmo06) #新增 #FUN-550027 add bmo06
    END IF
 
    CALL i100_up_bmp13() RETURNING g_bmp[l_ac].bmp13
   #CALL FGL_DIALOG_SETBUFFER(g_bmp[l_ac].bmp13)
    DISPLAY g_bmp[l_ac].bmp13 TO bmp13 #FUN-560027 add
 
END FUNCTION
 
FUNCTION i100_up_bmp13()
 DEFINE l_bmu06   LIKE bmu_file.bmu06,
        l_bmu05   LIKE bmu_file.bmu05, #FUN-560027 add
        l_bmp13   LIKE bmp_file.bmp13,
        l_i       LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
    LET l_bmp13=' '
    DECLARE up_bmp13_cs CURSOR FOR
     SELECT bmu06,bmu05 FROM bmu_file
      WHERE bmu01 =g_bmo.bmo01
        AND bmu011=g_bmo.bmo011
        AND bmu02 =g_bmp[l_ac].bmp02
        AND bmu03 =g_bmp[l_ac].bmp03
        AND bmu08 =g_bmo.bmo06 #FUN-560027 add
       ORDER BY bmu05          #FUN-560027 add
    LET l_bmp13=' '
    LET l_i = 1
    FOREACH up_bmp13_cs INTO l_bmu06,l_bmu05 #FUN-560027 add bmu05
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        IF l_i = 1 THEN
            LET l_bmp13=l_bmu06
        ELSE
            LET l_bmp13= l_bmp13 CLIPPED , ',', l_bmu06
        END IF
        LET l_i = l_i + 1
    END FOREACH
    RETURN l_bmp13
END FUNCTION
 
#單頭
FUNCTION i100_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("bmo01,bmo011,bmo06,bmoud02",TRUE) #FUN-560027 add bmo06  #add bmoud02 by guanyao160704
   END IF
 
END FUNCTION
 
FUNCTION i100_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   LET g_chkey = 'N'
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("bmo01,bmo011,bmo06,bmoud02",FALSE) #FUN-560027 add bmo06   #add bmoud02 by guanyao160704
       END IF
   END IF
 
END FUNCTION
 
#FUN-730075............begin 
FUNCTION i100_b_move_to()
   LET g_bmp04   = b_bmp.bmp04       #TQC-740182 add
   LET g_bmp05   = b_bmp.bmp05       #TQC-740182 add
 
   LET g_bmp[l_ac].bmp02 = b_bmp.bmp02
   LET g_bmp[l_ac].bmp03 = b_bmp.bmp03
   LET g_bmp[l_ac].bmp09 = b_bmp.bmp09
   LET g_bmp[l_ac].bmp16 = b_bmp.bmp16
   LET g_bmp[l_ac].bmp29 = b_bmp.bmp29
   LET g_bmp[l_ac].bmp06 = b_bmp.bmp06
   LET g_bmp[l_ac].bmp07 = b_bmp.bmp07
   LET g_bmp[l_ac].bmp10 = b_bmp.bmp10
   LET g_bmp[l_ac].bmp13 = b_bmp.bmp13
   LET g_bmp[l_ac].bmp08 = b_bmp.bmp08
   LET g_bmp[l_ac].bmp081 = b_bmp.bmp081   #TQC-AC0183 add
   LET g_bmp[l_ac].bmp082 = b_bmp.bmp082   #TQC-AC0183 add
   LET g_bmp[l_ac].bmpud01 = b_bmp.bmpud01
   LET g_bmp[l_ac].bmpud02 = b_bmp.bmpud02
   LET g_bmp[l_ac].bmpud03 = b_bmp.bmpud03
   LET g_bmp[l_ac].bmpud04 = b_bmp.bmpud04
   LET g_bmp[l_ac].bmpud05 = b_bmp.bmpud05
   LET g_bmp[l_ac].bmpud06 = b_bmp.bmpud06
   LET g_bmp[l_ac].bmpud07 = b_bmp.bmpud07
   LET g_bmp[l_ac].bmpud08 = b_bmp.bmpud08
   LET g_bmp[l_ac].bmpud09 = b_bmp.bmpud09
   LET g_bmp[l_ac].bmpud10 = b_bmp.bmpud10
   LET g_bmp[l_ac].bmpud11 = b_bmp.bmpud11
   LET g_bmp[l_ac].bmpud12 = b_bmp.bmpud12
   LET g_bmp[l_ac].bmpud13 = b_bmp.bmpud13
   LET g_bmp[l_ac].bmpud14 = b_bmp.bmpud14
   LET g_bmp[l_ac].bmpud15 = b_bmp.bmpud15
END FUNCTION
 
FUNCTION i100_b_move_back()
   #Key 值
   LET b_bmp.bmp01  = g_bmo.bmo01
   LET b_bmp.bmp28  = g_bmo.bmo06
   LET b_bmp.bmp011 = g_bmo.bmo011
 
   LET b_bmp.bmp04 = g_bmp04        #TQC-740182 add
   IF cl_null(b_bmp.bmp04) THEN                                                 
      LET b_bmp.bmp04 = 0                                                       
   END IF                                                                       
   LET b_bmp.bmp05 = g_bmp05        #TQC-740182 add
   LET b_bmp.bmpdate = g_today      #TQC-740182 add
   LET b_bmp.bmpmodu = g_user       #TQC-740182 add
 
   LET b_bmp.bmp02 = g_bmp[l_ac].bmp02
   LET b_bmp.bmp03 = g_bmp[l_ac].bmp03
   LET b_bmp.bmp09 = g_bmp[l_ac].bmp09
   LET b_bmp.bmp16 = g_bmp[l_ac].bmp16
   LET b_bmp.bmp29 = g_bmp[l_ac].bmp29
   LET b_bmp.bmp06 = g_bmp[l_ac].bmp06
   LET b_bmp.bmp07 = g_bmp[l_ac].bmp07
   LET b_bmp.bmp10 = g_bmp[l_ac].bmp10
   LET b_bmp.bmp13 = g_bmp[l_ac].bmp13
   LET b_bmp.bmp08 = g_bmp[l_ac].bmp08
   LET b_bmp.bmp081 = g_bmp[l_ac].bmp081   #TQC-AC0183 add
   LET b_bmp.bmp082 = g_bmp[l_ac].bmp082   #TQC-AC0183 add
   LET b_bmp.bmp17 = g_bmp17     #No:MOD-990253 add
   LET b_bmp.bmpud01 = g_bmp[l_ac].bmpud01
   LET b_bmp.bmpud02 = g_bmp[l_ac].bmpud02
   LET b_bmp.bmpud03 = g_bmp[l_ac].bmpud03
   LET b_bmp.bmpud04 = g_bmp[l_ac].bmpud04
   LET b_bmp.bmpud05 = g_bmp[l_ac].bmpud05
   LET b_bmp.bmpud06 = g_bmp[l_ac].bmpud06
   LET b_bmp.bmpud07 = g_bmp[l_ac].bmpud07
   LET b_bmp.bmpud08 = g_bmp[l_ac].bmpud08
   LET b_bmp.bmpud09 = g_bmp[l_ac].bmpud09
   LET b_bmp.bmpud10 = g_bmp[l_ac].bmpud10
   LET b_bmp.bmpud11 = g_bmp[l_ac].bmpud11
   LET b_bmp.bmpud12 = g_bmp[l_ac].bmpud12
   LET b_bmp.bmpud13 = g_bmp[l_ac].bmpud13
   LET b_bmp.bmpud14 = g_bmp[l_ac].bmpud14
   LET b_bmp.bmpud15 = g_bmp[l_ac].bmpud15
   
END FUNCTION
#No:FUN-9C0077

#No.FUN-BB0086---start---add---
FUNCTION i100_bmp081_check()
   
   IF NOT cl_null(g_bmp[l_ac].bmp081) AND NOT cl_null(g_bmp[l_ac].bmp10) THEN
      IF cl_null(g_bmp_t.bmp081) OR cl_null(g_bmp10_t) OR g_bmp10_t != g_bmp[l_ac].bmp10 OR g_bmp_t.bmp081 != g_bmp[l_ac].bmp081 THEN
         LET g_bmp[l_ac].bmp081=s_digqty(g_bmp[l_ac].bmp081, g_bmp[l_ac].bmp10)
         DISPLAY BY NAME g_bmp[l_ac].bmp081
      END IF
   END IF

   IF NOT cl_null(g_bmp[l_ac].bmp081) THEN
       IF g_bmp[l_ac].bmp081 < 0 THEN 
          CALL cl_err(g_bmp[l_ac].bmp081,'aec-020',0)
          LET g_bmp[l_ac].bmp081 = g_bmp_o.bmp081
          RETURN FALSE 
       END IF
       LET g_bmp_o.bmp081 = g_bmp[l_ac].bmp081
   END IF
   IF cl_null(g_bmp[l_ac].bmp081) THEN
       LET g_bmp[l_ac].bmp081 = 0
   END IF
   DISPLAY BY NAME g_bmp[l_ac].bmp081
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086---end---add---
