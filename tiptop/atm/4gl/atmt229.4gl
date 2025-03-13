# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmt229.4gl
# Descriptions...: 合同維護作業
# Date & Author..: 06/01/06 By wujie
# Modify.........: NO.TQC-630072 06/03/07 By Melody 指定單據編號、執行功能(g_argv2)
# Modify.........: NO.FUN-610064 06/03/15 By wujie   修正稅種名稱與稅率重復
# Modify.........: NO.FUN-590083 06/03/30 By Alexstar 新增資料多語言顯示功能
# Modify.........: NO.TQC-640072 06/04/08 By wujie    單別取位不對 
# Modify.........: NO.TQC-640114 06/04/09 By wujie    增加單身客戶空白時，彈出批次產生客戶畫面
# Modify.........: No.FUN-660104 06/06/19 By cl Error Message 調整
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-690025 06/09/20 By jamie 改判斷狀況碼occ1004
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能 
# Modify.........: No.FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-710062 07/01/16 By chenl 去除空殼打印函數
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740039 07/04/10 By Ray 查詢時單號開窗查的是單別
# Modify.........: No.TQC-740338 07/04/30 By sherry “選擇客戶”按鈕，錄入完成后顯示異動更新不成功。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790064 07/09/13 By sherry  錄入單頭資料結束后，彈出“客戶資料”維護對話框，維護完資料后，確定退出程序
# Modify.........: No.TQC-810020 08/01/07 By chenl   選擇客戶后未能加入單身，修正sql錯誤！
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-820033 08/02/25 By wujie   返利功能改善
# Modify.........: No.TQC-830039 08/03/24 By dxfwo   刪除azf10的條件
# Modify.........: No.TQC-830054 08/03/27 By dxfwo   更改表結構,并修改錄入物返條件單身時候報錯的問題
#                                                    修改營運中心和門店之間的關系      
# Modify.........: No.FUN-840042 08/04/17 By TSD.liquor 自定欄位功能修改
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-920186 09/03/19 By lala 理由碼tqr10,tqs04
# Modify.........: No.TQC-940096 09/04/16 By mike 1.DISPLAY l_newno TO pmw01報錯                                                    
#                                                 2.復制時OPEN t229_b2_cl報錯-6372/OPEN t229_b3_cl報錯 -6372 
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No.FUN-9C0073 10/01/08 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40055 10/05/06 by destiny 单身显示改为dialog
# Modify.........: No.FUN-A50102 10/06/13 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No:MOD-AA0137 10/10/22 By Smapmin 修正FUN-820033
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No:MOD-AA0161 10/11/04 By Smapmin 修改SQL語法
# Modify.........: No:CHI-AB0028 10/11/18 By Summer 串到atmr229做列印
# Modify.........: No:MOD-AC0045 10/12/07 By Smapmin 物返條件頁籤,理由碼開窗請選擇碼別資料檔中"是否搭贈"欄位='Y'資料顯示
#                                                    以免使用者誤輸入
# Modify.........: No:TQC-AC0103 10/12/09 BY shenyang 調整使用系列，物返條件的輸入順序
# Modify.........: No:TQC-AC0146 10/12/15 BY suncx 輸入單身客戶資料門店代號後,程式並未抓取對應的相關資料顯示
# Modify.........: No:TQC-AC0152 10/12/15 By baogc 修改查詢時tqs04的開窗和費用明細單身的CONSTRUCT順序
# Modify.........: No:TQC-AC0392 10/12/29 By lilingyu 查詢時,狀態page中"資料建立者,資料建立部門"無法下查詢條件 
# Modify.........: No:FUN-B30064 11/03/12 By baogc 修改使用系列頁簽中的開窗為可疑批次錄入
# Modify.........: No.CHI-B40058 11/05/16 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-BB0086 11/12/22 By tanxc 增加數量欄位小數取位 
# Modify.........: No:FUN-C20068 12/02/14 By fengrui 數量欄位小數取位處理
# Modify.........: No:MOD-C30295 12/03/10 By yangxf  單次返時不可以輸入條件期間
# Modify.........: No:MOD-C30219 12/03/13 By yangxf  如該合約編號已存在與訂單中,則不可取消確認
# Modify.........: No.CHI-C30107 12/06/13 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30085 12/07/06 By lixiang 改CR報表串GR報表
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-C90096 12/09/12 By SunLM tqu13加入on row change 
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題


DATABASE ds
 
GLOBALS "../../config/top.global" 
 
#模組變數(Module Variables)
DEFINE 
    g_tqp           RECORD LIKE tqp_file.*,       
    g_tqp_t         RECORD LIKE tqp_file.*,  
    g_tqp_o         RECORD LIKE tqp_file.*,      
    g_tqp01_t   LIKE tqp_file.tqp01,      
    g_t1            LIKE oay_file.oayslip,   #TOC-640072        #No.FUN-680120 VARCHAR(05)
    g_sheet         LIKE tqp_file.tqp01,     #No.FUN-680120 VARCHAR(05)    #TOC-640072         
    g_ydate         LIKE type_file.dat,      #No.FUN-680120 DATE                   
    g_tqr           DYNAMIC ARRAY OF RECORD    
        tqr09       LIKE tqr_file.tqr09,       #項次
        tqr06       LIKE tqr_file.tqr06,       #現返類型
        tqr07       LIKE tqr_file.tqr07,       #起始日期
        tqr08       LIKE tqr_file.tqr08,       #截止日期
        tqr02       LIKE tqr_file.tqr02,       #累計區間 
        tqr03       LIKE tqr_file.tqr03,       #起始金額
        tqr04       LIKE tqr_file.tqr04,       #截止金額
        tqr05       LIKE tqr_file.tqr05,       #返利比率
        tqr10       LIKE tqr_file.tqr10,       #理由碼 
        tqr10_azf03 LIKE azf_file.azf03,       #理由碼說明
        tqrud01 LIKE tqr_file.tqrud01,
        tqrud02 LIKE tqr_file.tqrud02,
        tqrud03 LIKE tqr_file.tqrud03,
        tqrud04 LIKE tqr_file.tqrud04,
        tqrud05 LIKE tqr_file.tqrud05,
        tqrud06 LIKE tqr_file.tqrud06,
        tqrud07 LIKE tqr_file.tqrud07,
        tqrud08 LIKE tqr_file.tqrud08,
        tqrud09 LIKE tqr_file.tqrud09,
        tqrud10 LIKE tqr_file.tqrud10,
        tqrud11 LIKE tqr_file.tqrud11,
        tqrud12 LIKE tqr_file.tqrud12,
        tqrud13 LIKE tqr_file.tqrud13,
        tqrud14 LIKE tqr_file.tqrud14,
        tqrud15 LIKE tqr_file.tqrud15
                    END RECORD,                   
    g_tqr_t         RECORD                 
        tqr09       LIKE tqr_file.tqr09,       #項次
        tqr06       LIKE tqr_file.tqr06,       #現返類型
        tqr07       LIKE tqr_file.tqr07,       #起始日期
        tqr08       LIKE tqr_file.tqr08,       #截止日期
        tqr02       LIKE tqr_file.tqr02,       #累計區間 
        tqr03       LIKE tqr_file.tqr03,       #起始金額
        tqr04       LIKE tqr_file.tqr04,       #截止金額
        tqr05       LIKE tqr_file.tqr05,       #返利比率
        tqr10       LIKE tqr_file.tqr10,       #理由碼 
        tqr10_azf03 LIKE azf_file.azf03,       #理由碼說明
        tqrud01 LIKE tqr_file.tqrud01,
        tqrud02 LIKE tqr_file.tqrud02,
        tqrud03 LIKE tqr_file.tqrud03,
        tqrud04 LIKE tqr_file.tqrud04,
        tqrud05 LIKE tqr_file.tqrud05,
        tqrud06 LIKE tqr_file.tqrud06,
        tqrud07 LIKE tqr_file.tqrud07,
        tqrud08 LIKE tqr_file.tqrud08,
        tqrud09 LIKE tqr_file.tqrud09,
        tqrud10 LIKE tqr_file.tqrud10,
        tqrud11 LIKE tqr_file.tqrud11,
        tqrud12 LIKE tqr_file.tqrud12,
        tqrud13 LIKE tqr_file.tqrud13,
        tqrud14 LIKE tqr_file.tqrud14,
        tqrud15 LIKE tqr_file.tqrud15
                    END RECORD,                   
    g_tqq           DYNAMIC ARRAY OF RECORD    
        tqq02       LIKE tqq_file.tqq02,       #項次
        tqq06       LIKE tqq_file.tqq06,       #工廠別
        tqq03       LIKE tqq_file.tqq03,       #門店代碼
        tqq03_occ02 LIKE occ_file.occ02,       #門店名稱
        tqq04       LIKE tqq_file.tqq04,       #省份代碼
        tqq04_too02 LIKE too_file.too02,       #省份名稱
        tqq05       LIKE tqq_file.tqq05,       #地級市代碼
        tqq05_top02 LIKE top_file.top02,       #地級市名稱
        tqqud01 LIKE tqq_file.tqqud01,
        tqqud02 LIKE tqq_file.tqqud02,
        tqqud03 LIKE tqq_file.tqqud03,
        tqqud04 LIKE tqq_file.tqqud04,
        tqqud05 LIKE tqq_file.tqqud05,
        tqqud06 LIKE tqq_file.tqqud06,
        tqqud07 LIKE tqq_file.tqqud07,
        tqqud08 LIKE tqq_file.tqqud08,
        tqqud09 LIKE tqq_file.tqqud09,
        tqqud10 LIKE tqq_file.tqqud10,
        tqqud11 LIKE tqq_file.tqqud11,
        tqqud12 LIKE tqq_file.tqqud12,
        tqqud13 LIKE tqq_file.tqqud13,
        tqqud14 LIKE tqq_file.tqqud14,
        tqqud15 LIKE tqq_file.tqqud15
                    END RECORD,                   
    g_tqq_t         RECORD                 
        tqq02       LIKE tqq_file.tqq02,        
        tqq06       LIKE tqq_file.tqq06,        
        tqq03       LIKE tqq_file.tqq03,      
        tqq03_occ02 LIKE occ_file.occ02,      
        tqq04       LIKE tqq_file.tqq04,       #省份代碼
        tqq04_too02 LIKE too_file.too02,       #省份名稱
        tqq05       LIKE tqq_file.tqq05,       #地級市代碼
        tqq05_top02 LIKE top_file.top02,       #地級市名稱
        tqqud01 LIKE tqq_file.tqqud01,
        tqqud02 LIKE tqq_file.tqqud02,
        tqqud03 LIKE tqq_file.tqqud03,
        tqqud04 LIKE tqq_file.tqqud04,
        tqqud05 LIKE tqq_file.tqqud05,
        tqqud06 LIKE tqq_file.tqqud06,
        tqqud07 LIKE tqq_file.tqqud07,
        tqqud08 LIKE tqq_file.tqqud08,
        tqqud09 LIKE tqq_file.tqqud09,
        tqqud10 LIKE tqq_file.tqqud10,
        tqqud11 LIKE tqq_file.tqqud11,
        tqqud12 LIKE tqq_file.tqqud12,
        tqqud13 LIKE tqq_file.tqqud13,
        tqqud14 LIKE tqq_file.tqqud14,
        tqqud15 LIKE tqq_file.tqqud15
                    END RECORD,                   
    g_tqs           DYNAMIC ARRAY OF RECORD    
        tqs02       LIKE tqs_file.tqs02,       #項次
        tqs03       LIKE tqs_file.tqs03,       #費用代碼
        tqs03_oaj02 LIKE oaj_file.oaj02,              #費用名稱
        tqs06       LIKE tqs_file.tqs06,       #是否預提
        tqs05       LIKE tqs_file.tqs05,       #說明
        tqs07       LIKE tqs_file.tqs07,       #固定折扣否
        tqs08       LIKE tqs_file.tqs08,       #折扣率/現金
        tqs09       LIKE tqs_file.tqs09,       #是否參與現返
        tqs04       LIKE tqs_file.tqs04,       #理由碼  
        tqs04_azf03 LIKE azf_file.azf03,       #理由碼說明
        tqsud01 LIKE tqs_file.tqsud01,
        tqsud02 LIKE tqs_file.tqsud02,
        tqsud03 LIKE tqs_file.tqsud03,
        tqsud04 LIKE tqs_file.tqsud04,
        tqsud05 LIKE tqs_file.tqsud05,
        tqsud06 LIKE tqs_file.tqsud06,
        tqsud07 LIKE tqs_file.tqsud07,
        tqsud08 LIKE tqs_file.tqsud08,
        tqsud09 LIKE tqs_file.tqsud09,
        tqsud10 LIKE tqs_file.tqsud10,
        tqsud11 LIKE tqs_file.tqsud11,
        tqsud12 LIKE tqs_file.tqsud12,
        tqsud13 LIKE tqs_file.tqsud13,
        tqsud14 LIKE tqs_file.tqsud14,
        tqsud15 LIKE tqs_file.tqsud15
                    END RECORD,                   
    g_tqs_t         RECORD                 
        tqs02       LIKE tqs_file.tqs02,        
        tqs03       LIKE tqs_file.tqs03,      
        tqs03_oaj02 LIKE oaj_file.oaj02, 
        tqs06       LIKE tqs_file.tqs06,
        tqs05       LIKE tqs_file.tqs05, 
        tqs07       LIKE tqs_file.tqs07,
        tqs08       LIKE tqs_file.tqs08,          
        tqs09       LIKE tqs_file.tqs09,
        tqs04       LIKE tqs_file.tqs04,   
        tqs04_azf03 LIKE azf_file.azf03,    
        tqsud01 LIKE tqs_file.tqsud01,
        tqsud02 LIKE tqs_file.tqsud02,
        tqsud03 LIKE tqs_file.tqsud03,
        tqsud04 LIKE tqs_file.tqsud04,
        tqsud05 LIKE tqs_file.tqsud05,
        tqsud06 LIKE tqs_file.tqsud06,
        tqsud07 LIKE tqs_file.tqsud07,
        tqsud08 LIKE tqs_file.tqsud08,
        tqsud09 LIKE tqs_file.tqsud09,
        tqsud10 LIKE tqs_file.tqsud10,
        tqsud11 LIKE tqs_file.tqsud11,
        tqsud12 LIKE tqs_file.tqsud12,
        tqsud13 LIKE tqs_file.tqsud13,
        tqsud14 LIKE tqs_file.tqsud14,
        tqsud15 LIKE tqs_file.tqsud15
                    END RECORD,                   
    g_tqt           DYNAMIC ARRAY OF RECORD
        tqt02       LIKE tqt_file.tqt02,        
        tqt02_tqa02 LIKE tqa_file.tqa02,       
        tqtud01 LIKE tqt_file.tqtud01,
        tqtud02 LIKE tqt_file.tqtud02,
        tqtud03 LIKE tqt_file.tqtud03,
        tqtud04 LIKE tqt_file.tqtud04,
        tqtud05 LIKE tqt_file.tqtud05,
        tqtud06 LIKE tqt_file.tqtud06,
        tqtud07 LIKE tqt_file.tqtud07,
        tqtud08 LIKE tqt_file.tqtud08,
        tqtud09 LIKE tqt_file.tqtud09,
        tqtud10 LIKE tqt_file.tqtud10,
        tqtud11 LIKE tqt_file.tqtud11,
        tqtud12 LIKE tqt_file.tqtud12,
        tqtud13 LIKE tqt_file.tqtud13,
        tqtud14 LIKE tqt_file.tqtud14,
        tqtud15 LIKE tqt_file.tqtud15
                    END RECORD,                   
    g_tqt_t         RECORD                 
        tqt02       LIKE tqt_file.tqt02,        
        tqt02_tqa02 LIKE tqa_file.tqa02,
        tqtud01 LIKE tqt_file.tqtud01,
        tqtud02 LIKE tqt_file.tqtud02,
        tqtud03 LIKE tqt_file.tqtud03,
        tqtud04 LIKE tqt_file.tqtud04,
        tqtud05 LIKE tqt_file.tqtud05,
        tqtud06 LIKE tqt_file.tqtud06,
        tqtud07 LIKE tqt_file.tqtud07,
        tqtud08 LIKE tqt_file.tqtud08,
        tqtud09 LIKE tqt_file.tqtud09,
        tqtud10 LIKE tqt_file.tqtud10,
        tqtud11 LIKE tqt_file.tqtud11,
        tqtud12 LIKE tqt_file.tqtud12,
        tqtud13 LIKE tqt_file.tqtud13,
        tqtud14 LIKE tqt_file.tqtud14,
        tqtud15 LIKE tqt_file.tqtud15
                    END RECORD,                   
    g_tqu           DYNAMIC ARRAY OF RECORD
        tqu14       LIKE tqu_file.tqu14,       #項次       
        tqu02       LIKE tqu_file.tqu02,       #物返類型
        tqu03       LIKE tqu_file.tqu03,       #起始日期
        tqu04       LIKE tqu_file.tqu04,       #截止日期
        tqu05       LIKE tqu_file.tqu05,       #累計區間
        tqu07       LIKE tqu_file.tqu07,       #物返依據
        tqu06       LIKE tqu_file.tqu06,       #銷售品號
        tqu06_ima02 LIKE ima_file.ima02,       #銷售品名
        tqu08       LIKE tqu_file.tqu08,       #起始數 
        tqu09       LIKE tqu_file.tqu09,       #截止數  
        tqu10       LIKE tqu_file.tqu10,       #銷售單位
        tqu11       LIKE tqu_file.tqu11,       #物返品號
        tqu11_ima02 LIKE ima_file.ima02,       #物返品名
        tqu12       LIKE tqu_file.tqu12,       #物返數 
        tqu13       LIKE tqu_file.tqu13,       #物返單位
        tqu15       LIKE tqu_file.tqu15,       #理由碼 
        tqu15_azf03 LIKE azf_file.azf03        #理由碼說明
                    END RECORD,                   
    g_tqu_t         RECORD
        tqu14       LIKE tqu_file.tqu14,       #項次       
        tqu02       LIKE tqu_file.tqu02,       #物返類型
        tqu03       LIKE tqu_file.tqu03,       #起始日期
        tqu04       LIKE tqu_file.tqu04,       #截止日期
        tqu05       LIKE tqu_file.tqu05,       #累計區間
        tqu07       LIKE tqu_file.tqu07,       #物返依據
        tqu06       LIKE tqu_file.tqu06,       #銷售品號
        tqu06_ima02 LIKE ima_file.ima02,       #銷售品名
        tqu08       LIKE tqu_file.tqu08,       #起始數 
        tqu09       LIKE tqu_file.tqu09,       #截止數  
        tqu10       LIKE tqu_file.tqu10,       #銷售單位
        tqu11       LIKE tqu_file.tqu11,       #物返品號
        tqu11_ima02 LIKE ima_file.ima02,       #物返品名
        tqu12       LIKE tqu_file.tqu12,       #物返數 
        tqu13       LIKE tqu_file.tqu13,       #物返單位
        tqu15       LIKE tqu_file.tqu15,       #理由碼 
        tqu15_azf03 LIKE azf_file.azf03        #理由碼說明
                    END RECORD,                   
    g_wc,g_wc1,g_wc2,g_wc3,g_wc4,g_wc5,g_sql,g_sql1,g_sql2,g_sql3   LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(1000)  #No.FUN-820033 add g_wc5
    g_rec_b1,g_rec_b2,g_rec_b3,g_rec_b4,g_rec_b5      LIKE type_file.num5,                           #No.FUN-680120 SMALLINT FUN-820033 ADD g_rec_b5
    l_ac,l_ac2,l_ac3 LIKE type_file.num5,         #No.FUN-680120 SMALLINTa  FUN-820033 ADD l_ac3
    g_azp03         LIKE azp_file.azp03,
    l_action_flag   STRING
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680120 SMALLINT
#DEFINE g_azi03     SMALLINT
 
DEFINE   g_forupd_sql STRING                 
DEFINE   g_before_input_done  LIKE type_file.num5     #No.FUN-680120 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_i             LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_b_flag        STRING 
DEFINE   g_tqp01         LIKE tqp_file.tqp01          #No.FUN-680120 VARCHAR(20) 
DEFINE g_argv2           STRING               # No.TQC-630072     
DEFINE   g_multi_tqt02   STRING               #FUN-B30064 ADD
DEFINE g_tqu13_t         LIKE tqu_file.tqu13          #No.FUN-BB0086

#主程式開始
MAIN
DEFINE  p_tqp01       LIKE tqp_file.tqp01                     #No.FUN-680120 VARCHAR(20)
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
   
   LET g_tqp01 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   
 
   LET g_forupd_sql = "SELECT * FROM tqp_file WHERE tqp01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t229_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 9
    OPEN WINDOW t229_w AT p_row,p_col
   
        WITH FORM "atm/42f/atmt229" ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
   
 
   IF NOT cl_null(g_tqp01) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t229_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t229_a()
            END IF
         OTHERWISE
               CALL t229_q()
      END CASE
   END IF
       
   LET g_ydate = NULL
   CALL t229_menu()
   CLOSE WINDOW t229_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION t229_cs()
   CLEAR FORM                             #清除畫面
   CALL g_tqr.clear()
   CALL g_tqq.clear()
   CALL g_tqs.clear()
   CALL g_tqt.clear()
   CALL g_tqu.clear()                #No.FUN-820033
  
 
   IF NOT cl_null(g_tqp01) THEN
      LET g_wc=" tqp01='",g_tqp01 CLIPPED,"'"
      LET g_wc1=" 1=1"
      LET g_wc2=" 1=1"
      LET g_wc3=" 1=1"
      LET g_wc4=" 1=1"
      LET g_wc5=" 1=1"               #No.FUN-820033
   ELSE
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
      INITIALIZE g_tqp.* TO NULL    #No.FUN-750051
      #No.FUN-A40055--begin
      DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON tqp01,tqp02,tqp06,tqp07,
                                tqp03,tqp05,tqp22,tqp23,
                                tqp24,tqp25,tqp21,tqp04,
                                tqp12,tqp13,tqpuser,tqpgrup,
                                tqporiu,tqporig,                       #TQC-AC0392
                                tqpmodu,tqpdate,tqpacti,
                                tqpud01,tqpud02,tqpud03,tqpud04,tqpud05,
                                tqpud06,tqpud07,tqpud08,tqpud09,tqpud10,
                                tqpud11,tqpud12,tqpud13,tqpud14,tqpud15
 
      END CONSTRUCT
      CONSTRUCT g_wc1 ON tqq02,tqq06,tqq03,tqq04,tqq05
                         ,tqqud01,tqqud02,tqqud03,tqqud04,tqqud05
                         ,tqqud06,tqqud07,tqqud08,tqqud09,tqqud10
                         ,tqqud11,tqqud12,tqqud13,tqqud14,tqqud15
           FROM s_tqq[1].tqq02,s_tqq[1].tqq06,s_tqq[1].tqq03,
                s_tqq[1].tqq04,
                s_tqq[1].tqq05
                ,s_tqq[1].tqqud01,s_tqq[1].tqqud02,s_tqq[1].tqqud03,s_tqq[1].tqqud04,s_tqq[1].tqqud05
                ,s_tqq[1].tqqud06,s_tqq[1].tqqud07,s_tqq[1].tqqud08,s_tqq[1].tqqud09,s_tqq[1].tqqud10
                ,s_tqq[1].tqqud11,s_tqq[1].tqqud12,s_tqq[1].tqqud13,s_tqq[1].tqqud14,s_tqq[1].tqqud15
                
      END CONSTRUCT

      CONSTRUCT g_wc2 ON tqr02,tqr03,tqr04,tqr05,tqr10    #FUN-920186
                         ,tqrud01,tqrud02,tqrud03,tqrud04,tqrud05
                         ,tqrud06,tqrud07,tqrud08,tqrud09,tqrud10
                         ,tqrud11,tqrud12,tqrud13,tqrud14,tqrud15
           FROM s_tqr[1].tqr02,s_tqr[1].tqr03,s_tqr[1].tqr04,
                s_tqr[1].tqr05,s_tqr[1].tqr10     #FUN-920186
                ,s_tqr[1].tqrud01,s_tqr[1].tqrud02,s_tqr[1].tqrud03,s_tqr[1].tqrud04,s_tqr[1].tqrud05
                ,s_tqr[1].tqrud06,s_tqr[1].tqrud07,s_tqr[1].tqrud08,s_tqr[1].tqrud09,s_tqr[1].tqrud10
                ,s_tqr[1].tqrud11,s_tqr[1].tqrud12,s_tqr[1].tqrud13,s_tqr[1].tqrud14,s_tqr[1].tqrud15

      END CONSTRUCT

      CONSTRUCT g_wc3 ON tqs02,tqs03,tqs06,tqs05,
                         tqs07,tqs08,tqs09,tqs04
                         ,tqsud01,tqsud02,tqsud03,tqsud04,tqsud05
                         ,tqsud06,tqsud07,tqsud08,tqsud09,tqsud10
                         ,tqsud11,tqsud12,tqsud13,tqsud14,tqsud15
           FROM s_tqs[1].tqs02,s_tqs[1].tqs03,s_tqs[1].tqs06,
      #         s_tqs[1].tqs04,s_tqs[1].tqs05,s_tqs[1].tqs07,   #TQC-AC0152 MARK
                s_tqs[1].tqs05,s_tqs[1].tqs07,s_tqs[1].tqs08,   #TQC-AC0152 ADD
      #         s_tqs[1].tqs08,s_tqs[1].tqs09                   #TQC-AC0152 MARK
                s_tqs[1].tqs09,s_tqs[1].tqs04                   #TQC-AC0152 ADD
               ,s_tqs[1].tqsud01,s_tqs[1].tqsud02,s_tqs[1].tqsud03,s_tqs[1].tqsud04,s_tqs[1].tqsud05
               ,s_tqs[1].tqsud06,s_tqs[1].tqsud07,s_tqs[1].tqsud08,s_tqs[1].tqsud09,s_tqs[1].tqsud10
               ,s_tqs[1].tqsud11,s_tqs[1].tqsud12,s_tqs[1].tqsud13,s_tqs[1].tqsud14,s_tqs[1].tqsud15 
      END CONSTRUCT

      CONSTRUCT g_wc5 ON tqu14,tqu02,tqu03,tqu04,tqu05,tqu07,
                           tqu06,tqu08,tqu09,tqu10,tqu11,tqu12,tqu13,tqu15
            FROM s_tqu[1].tqu14,s_tqu[1].tqu02,s_tqu[1].tqu03,s_tqu[1].tqu04,
                 s_tqu[1].tqu05,s_tqu[1].tqu07,s_tqu[1].tqu06,s_tqu[1].tqu08,
                 s_tqu[1].tqu09,s_tqu[1].tqu10,s_tqu[1].tqu11,s_tqu[1].tqu12,
                 s_tqu[1].tqu13,s_tqu[1].tqu15
      END CONSTRUCT

      CONSTRUCT g_wc4 ON tqt02
                         ,tqtud01,tqtud02,tqtud03,tqtud04,tqtud05
                         ,tqtud06,tqtud07,tqtud08,tqtud09,tqtud10
                         ,tqtud11,tqtud12,tqtud13,tqtud14,tqtud15
           FROM s_tqt[1].tqt02
               ,s_tqt[1].tqtud01,s_tqt[1].tqtud02,s_tqt[1].tqtud03,s_tqt[1].tqtud04,s_tqt[1].tqtud05
               ,s_tqt[1].tqtud06,s_tqt[1].tqtud07,s_tqt[1].tqtud08,s_tqt[1].tqtud09,s_tqt[1].tqtud10
               ,s_tqt[1].tqtud11,s_tqt[1].tqtud12,s_tqt[1].tqtud13,s_tqt[1].tqtud14,s_tqt[1].tqtud15
                          
      END CONSTRUCT
      
      ON ACTION controlp
            CASE
               WHEN INFIELD(tqp01)      #合同編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_tqp02"      #No.TQC-740039
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tqp01
                    NEXT FIELD tqp01
               WHEN INFIELD(tqp03)       #合同類別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_tqa1"
                    LET g_qryparam.arg1 ="13"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tqp03
                    NEXT FIELD tqp03
               WHEN INFIELD(tqp05)      #債權代碼
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_tqa1"
                    LET g_qryparam.arg1 ="20"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tqp05
                    CALL t229_tqp05('d')
                    NEXT FIELD tqp05
               WHEN INFIELD(tqp21)       #幣別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_azi"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tqp21
                    NEXT FIELD tqp21
               WHEN INFIELD(tqp22)       #稅別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_gec"
                    LET g_qryparam.arg1 = "2"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tqp22
                    NEXT FIELD tqp22            
               WHEN INFIELD(tqq03)             #門店代碼
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_occ3"
                    LET g_qryparam.arg1 = g_dbs
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tqq03
                    NEXT FIELD tqq03           
               WHEN INFIELD(tqr10)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_azf01a"
                    LET g_qryparam.arg1 = '3'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tqr10
                    NEXT FIELD tqr10            
               WHEN INFIELD(tqs03)           #費用科目
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_tqs03"                                                                                     
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tqs03
                    NEXT FIELD tqs03
              WHEN INFIELD(tqs04)      
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c' 
#                 LET g_qryparam.form ="q_azf01c"   #TQC-AC0152 MARK
                 LET g_qryparam.form ="q_tqs04"     #TQC-AC0152 ADD
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                 DISPLAY g_qryparam.multiret TO tqs04
                 NEXT FIELD tqs04            
             WHEN INFIELD(tqu06)      
#FUN-AA0059---------mod------------str----------------- 
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = 'c'
#               LET g_qryparam.form ="q_ima"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                DISPLAY g_qryparam.multiret TO tqu06
                NEXT FIELD tqu06
             WHEN INFIELD(tqu11)
#FUN-AA0059---------mod------------str-----------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = 'c'
#               LET g_qryparam.form ="q_ima"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                DISPLAY g_qryparam.multiret TO tqu11
                NEXT FIELD tqu11
             WHEN INFIELD(tqu15)       
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'    #MOD-AC0045
                LET g_qryparam.form ="q_azf01a"
                LET g_qryparam.arg1 ='3'
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                DISPLAY g_qryparam.multiret TO tqu15
                NEXT FIELD tqu15         
               WHEN INFIELD(tqt02)             #門店代碼
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_tqt02"
                    LET g_qryparam.arg1 =g_tqp.tqp05
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tqt02
                    NEXT FIELD tqt02
               OTHERWISE EXIT CASE
            END CASE
      ON IDLE g_idle_seconds  #FUN-860033
          CALL cl_on_idle()
          CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION accept
#         LET g_wc = l_wc," AND ",l_wc2
         EXIT DIALOG

      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG 
          
      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG      
      END DIALOG 
      #No.FUN-A40055--end
      #資料權限的檢查
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tqpuser', 'tqpgrup')
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF  
   
   LET g_sql  = "SELECT UNIQUE tqp01 "
   LET g_sql1 = " FROM tqp_file "
   LET g_sql2 = " WHERE ", g_wc CLIPPED
   
   IF g_wc1 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",tqq_file"
      LET g_sql2= g_sql2 CLIPPED," AND tqp01 = tqq01",
                                 " AND ",g_wc1 CLIPPED
   END IF
   IF g_wc2 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",tqr_file"
      LET g_sql2= g_sql2 CLIPPED," AND tqp01 = tqr01",
                                 " AND ",g_wc2 CLIPPED
   END IF
   IF g_wc3 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",tqs_file"
      LET g_sql2= g_sql2 CLIPPED," AND tqp01 = tqs01",
                                 " AND ",g_wc3 CLIPPED
   END IF
   
   IF g_wc4 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",tqt_file"
      LET g_sql2= g_sql2 CLIPPED," AND tqp01 = tqt01",
                                 " AND ",g_wc4 CLIPPED
   END IF
   
   IF g_wc5 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",tqu_file"
      LET g_sql2= g_sql2 CLIPPED," AND tqp01 = tqu01",
                                 " AND ",g_wc5 CLIPPED
   END IF
 
   LET g_sql = g_sql  CLIPPED,' ',g_sql1 CLIPPED,' ',
               g_sql2 CLIPPED,' ORDER BY tqp01'
 
   PREPARE t229_prepare FROM g_sql
   DECLARE t229_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t229_prepare
 
   LET g_sql  = "SELECT COUNT(DISTINCT tqp01) "
   LET g_sql = g_sql  CLIPPED,' ',g_sql1 CLIPPED,' ',
               g_sql2 CLIPPED
 
   PREPARE t229_precount FROM g_sql
   DECLARE t229_count CURSOR FOR t229_precount
 
END FUNCTION
 
FUNCTION t229_menu()
   DEFINE l_wc  STRING #CHI-AB0028 add
 
   WHILE TRUE
      CALL t229_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL t229_a()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               #No.FUN-A40055--begin
               CASE g_b_flag
                   WHEN '1' CALL t229_b1()
                   WHEN '2' CALL t229_b2()
                   WHEN '3' CALL t229_b3()
                   WHEN '4' CALL t229_b4()
                   WHEN '5' CALL t229_b5()
               END CASE 
            ELSE    
               LET g_action_choice = NULL 
               #No.FUN-A40055--end  
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t229_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t229_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL t229_u()
            END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL t229_copy()
            END IF
         #選擇客戶
         WHEN "choose_cust"
            IF cl_chk_act_auth() THEN
               CALL t229_g_b1()
            ELSE
               LET g_action_choice = NULL
            END IF
         #維護客戶信息
         WHEN "customer" 
            IF cl_chk_act_auth() THEN
               CALL t229_b1()
            END IF
         #維護返利信息
         WHEN "discount" 
            IF cl_chk_act_auth() THEN
               CALL t229_b2()
            END IF
         #維護費用信息
         WHEN "expense" 
            IF cl_chk_act_auth() THEN
               CALL t229_b3()
            END IF
         #使用系列
         WHEN "Rebate" 
            IF cl_chk_act_auth() THEN
               CALL t229_b5()
            END IF
         #使用系列
         WHEN "using" 
            IF cl_chk_act_auth() THEN
               CALL t229_b4()
            END IF
 
         WHEN "first" 
            IF cl_chk_act_auth() THEN
               CALL t229_fetch('F')
            END IF
         WHEN "next" 
            IF cl_chk_act_auth() THEN
               CALL t229_fetch('N')
            END IF
         WHEN "previous" 
            IF cl_chk_act_auth() THEN
               CALL t229_fetch('P')
            END IF
         WHEN "last" 
            IF cl_chk_act_auth() THEN
               CALL t229_fetch('L')
            END IF
         WHEN "jump" 
            IF cl_chk_act_auth() THEN
               CALL t229_fetch('/')
            END IF
         #申請
         WHEN "approving" 
            IF cl_chk_act_auth() THEN
               CALL t229_approving()
            END IF
         #取消申請
         WHEN "unapproving" 
            IF cl_chk_act_auth() THEN
               CALL t229_unapproving()
            END IF
         #審核
         WHEN "confirm" 
            IF cl_chk_act_auth() THEN
               CALL t229_confirm()
            END IF
         #取消審核
         WHEN "notconfirm" 
            IF cl_chk_act_auth() THEN
               CALL t229_notconfirm()
            END IF
          #結案
         WHEN "mclose" 
            IF cl_chk_act_auth() THEN
               CALL t229_mclose()
            END IF
         #取消結案
         WHEN "notmclose" 
            IF cl_chk_act_auth() THEN
               CALL t229_notmclose()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tqq),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tqp.tqp01 IS NOT NULL THEN
                 LET g_doc.column1 = "tqp01"
                 LET g_doc.value1 = g_tqp.tqp01
                 CALL cl_doc()
               END IF
         END IF
         #CHI-AB0028 add --start--
         WHEN "output"
            IF cl_chk_act_auth() THEN
               IF g_tqp.tqp01 IS NOT NULL THEN
                  LET l_wc=cl_replace_str(g_wc, "'", "\"")
                 #LET g_msg = "atmr229",  #FUN-C30085
                  LET g_msg = "atmg229",  #FUN-C30085
                              " '",g_today CLIPPED,"' ''",
                              " '",g_lang CLIPPED,"' 'Y' '' '1'",
                              " '",l_wc CLIPPED,"' 'Y' 'Y' 'Y' 'Y'" 
                  CALL cl_cmdrun(g_msg)
               END IF
            END IF
         #CHI-AB0028 add --end--
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t229_a()
   DEFINE li_result    LIKE type_file.num5                  #No.FUN-680120 SMALLINT
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_tqq.clear()
   CALL g_tqr.clear()
   CALL g_tqs.clear()
   CALL g_tqt.clear()
   CALL g_tqu.clear()     #No.FUN-820033
   
   INITIALIZE g_tqp.* LIKE tqp_file.*             #DEFAULT 設定
   LET g_tqp01_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_tqp_t.* = g_tqp.*
   LET g_tqp_o.* = g_tqp.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_tqp.tqpuser=g_user
      LET g_tqp.tqporiu = g_user #FUN-980030
      LET g_tqp.tqporig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_tqp.tqpgrup=g_grup
      LET g_tqp.tqpdate=g_today
      LET g_tqp.tqpacti='Y'              #資料有效
      LET g_tqp.tqp04='1'                #狀態碼為開立
 
      IF NOT cl_null(g_tqp01) AND (g_argv2 = "insert") THEN
         LET g_tqp.tqp01 = g_tqp01
      END IF
 
      CALL t229_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_tqp.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         ROLLBACK WORK
         EXIT WHILE
      END IF
 
      IF cl_null(g_tqp.tqp01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入后, 若該單據需自動編號, 并且其單號為空白, 則自動賦予單號
      BEGIN WORK 
      #CALL s_auto_assign_no("axm",g_tqp.tqp01,g_today,"00","tqp_file","tqp01","","","")  #FUN-A70130                                                    
      CALL s_auto_assign_no("atm",g_tqp.tqp01,g_today,"U1","tqp_file","tqp01","","","")  #FUN-A70130
        RETURNING li_result,g_tqp.tqp01                                                                                             
      IF (NOT li_result) THEN                                                                                                       
         ROLLBACK WORK                                                                                                              
         CONTINUE WHILE                                                                                                             
      END IF   
 
      DISPLAY BY NAME g_tqp.tqp01
      LET g_tqp.tqpplant = g_plant #FUN-980009
      LET g_tqp.tqplegal = g_legal #FUN-980009
      INSERT INTO tqp_file VALUES (g_tqp.*)
 
      LET g_sheet = g_tqp.tqp01[1,g_doc_len]   #TQC-640072
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","tqp_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104         #FUN-B80061   ADD
         ROLLBACK WORK      
        # CALL cl_err3("ins","tqp_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104        #FUN-B80061   MARK
         CONTINUE WHILE
      ELSE
         COMMIT WORK        #No:7857
         CALL cl_flow_notify(g_tqp.tqp01,'I')
      END IF
 
      SELECT tqp01 INTO g_tqp.tqp01 FROM tqp_file
       WHERE tqp01 = g_tqp.tqp01
      LET g_tqp01_t = g_tqp.tqp01     
      LET g_tqp_t.* = g_tqp.*
      LET g_tqp_o.* = g_tqp.*
      
      CALL g_tqq.clear()
      LET g_rec_b1 = 0  
      CALL t229_b1() 
 
      CALL g_tqr.clear()
      LET g_rec_b2 = 0  
      CALL t229_b2()  
      
      CALL g_tqs.clear()
      LET g_rec_b3 = 0  
      CALL t229_b3() 
 
  #   CALL g_tqt.clear()    #TQC-AC0103
  #   LET g_rec_b4 = 0      #TQC-AC0103
  #   CALL t229_b4()        #TQC-AC0103 
 
      CALL g_tqu.clear()
      LET g_rec_b5 = 0  
      CALL t229_b5() 
     
      CALL g_tqt.clear()    #TQC-AC0103                                         
      LET g_rec_b4 = 0      #TQC-AC0103                                         
      CALL t229_b4()        #TQC-AC0103 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t229_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tqp.tqp01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_tqp.* FROM tqp_file
    WHERE tqp01=g_tqp.tqp01
 
   IF g_tqp.tqpacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tqp.tqp01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_tqp.tqp04 != '1' THEN   
      CALL cl_err('','atm-226',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tqp01_t = g_tqp.tqp01
   BEGIN WORK
 
   OPEN t229_cl USING g_tqp.tqp01
   IF STATUS THEN
      CALL cl_err("OPEN t229_cl:", STATUS, 1)
      CLOSE t229_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t229_cl INTO g_tqp.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_tqp.tqp01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE t229_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t229_show()
 
   WHILE TRUE
      LET g_tqp01_t = g_tqp.tqp01
      LET g_tqp_o.* = g_tqp.*
      LET g_tqp.tqpmodu=g_user
      LET g_tqp.tqpdate=g_today
 
      CALL t229_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tqp.*=g_tqp_t.*
         CALL t229_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_tqp.tqp01 != g_tqp01_t THEN            # 更改單號                                                                        
         UPDATE tqq_file SET tqq01 = g_tqp.tqp01                                                                                    
          WHERE tqq01 = g_tqp01_t                                                                                                   
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                              
            CALL cl_err3("upd","tqq_file",g_tqp01_t,"",SQLCA.sqlcode,"","tqq",1)   #No.FUN-660104
            CONTINUE WHILE                                                                                                          
         END IF                                                                                                                     
         UPDATE tqr_file SET tqr01 = g_tqp.tqp01                                                                                    
          WHERE tqr01 = g_tqp01_t                                                                                                   
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                              
            CALL cl_err3("upd","tqr_file",g_tqp01_t,"",SQLCA.sqlcode,"","tqr",1)   #No.FUN-660104
            CONTINUE WHILE                                                                                                          
         END IF                                                                                                                     
         UPDATE tqs_file SET tqs01 = g_tqp.tqp01                                                                                    
          WHERE tqs01 = g_tqp01_t                                                                                                   
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                              
            CALL cl_err3("upd","tqs_file",g_tqp01_t,"",SQLCA.sqlcode,"","tqs",1)   #No.FUN-660104
            CONTINUE WHILE                                                                                                          
         END IF                                                                                                                     
         UPDATE tqt_file SET tqt01 = g_tqp.tqp01                                                                                    
          WHERE tqt01 = g_tqp01_t                                                                                                   
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                              
            CALL cl_err3("upd","tqt_file",g_tqp01_t,"",SQLCA.sqlcode,"","tqt",1)   #No.FUN-660104
            CONTINUE WHILE                                                                                                          
         END IF  
         UPDATE tqu_file SET tqu01 = g_tqp.tqp01                                                                                    
          WHERE tqu01 = g_tqp01_t                                                                                                   
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                              
            CALL cl_err3("upd","tqu_file",g_tqp01_t,"",SQLCA.sqlcode,"","tqt",1)   #No.FUN-660104
            CONTINUE WHILE                                                                                                          
         END IF 
      END IF    
 
      UPDATE tqp_file SET tqp_file.* = g_tqp.*
       WHERE tqp01 = g_tqp01_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","tqp_file",g_tqp01_t,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t229_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tqp.tqp01,'U')
 
END FUNCTION
 
FUNCTION t229_i(p_cmd)
   DEFINE l_n            LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_chk          LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          p_cmd          LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
   DEFINE li_result      LIKE type_file.num5           #No.FUN-680120 SMALLINT
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_tqp.tqp04,g_tqp.tqpuser,g_tqp.tqpmodu,
                   g_tqp.tqpgrup,g_tqp.tqpdate,g_tqp.tqpacti 
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INPUT BY NAME g_tqp.tqp01,g_tqp.tqp02,g_tqp.tqp06, g_tqp.tqporiu,g_tqp.tqporig,
                 g_tqp.tqp07,g_tqp.tqp03,g_tqp.tqp05,
                 g_tqp.tqp22,g_tqp.tqp21,
                 g_tqp.tqp12,
                 g_tqp.tqp13,
                 g_tqp.tqpud01,g_tqp.tqpud02,g_tqp.tqpud03,g_tqp.tqpud04,
                 g_tqp.tqpud05,g_tqp.tqpud06,g_tqp.tqpud07,g_tqp.tqpud08,
                 g_tqp.tqpud09,g_tqp.tqpud10,g_tqp.tqpud11,g_tqp.tqpud12,
                 g_tqp.tqpud13,g_tqp.tqpud14,g_tqp.tqpud15 
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t229_set_entry(p_cmd)
         CALL t229_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("tqp01") 
         
 
      AFTER FIELD tqp01
         #單號處理方式:
         #在輸入單別后, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 并檢查其是否重復
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成后, 再行自動指定單號
         IF NOT cl_null(g_tqp.tqp01) THEN
            #CALL s_check_no("axm",g_tqp.tqp01,g_tqp_t.tqp01,"00","tqp_file","tqp01","")  #FUN-A70130                                                           
            CALL s_check_no("atm",g_tqp.tqp01,g_tqp_t.tqp01,"U1","tqp_file","tqp01","")  #FUN-A70130
            RETURNING li_result,g_tqp.tqp01   
            IF (NOT li_result) THEN                                                                                               
                 NEXT FIELD tqp01                                                                                                 
            END IF  
            LET g_t1=g_tqp.tqp01[1,g_doc_len]
            SELECT oayacti INTO l_chk FROM oay_file
             WHERE oayslip =g_t1
            IF l_chk != 'Y' THEN
               CALL cl_err(g_t1,9028,0)
               NEXT FIELD tqp01
            END IF
         END IF
 
      AFTER FIELD tqp03          #合同類別 
         IF NOT cl_null(g_tqp.tqp03) THEN 
            CALL t229_tqp03('a')
              IF NOT cl_null(g_errno) THEN                                                                                        
                 CALL cl_err(g_tqp.tqp03,g_errno,0)                                                                               
                 LET g_tqp.tqp03 = g_tqp_o.tqp03                                                                                  
                 DISPLAY BY NAME g_tqp.tqp03                                                                                      
                 NEXT FIELD tqp03                                                                                                 
              END IF   
         ELSE
            DISPLAY ' ' TO tqp3_tqa02
         END IF
 
      AFTER FIELD tqp05          #債權代碼
         IF NOT cl_null(g_tqp.tqp05) THEN 
            CALL t229_tqp05('a')
              IF NOT cl_null(g_errno) THEN                                                                                          
                 CALL cl_err(g_tqp.tqp05,g_errno,0)                                                                                 
                 LET g_tqp.tqp05 = g_tqp_o.tqp05                                                                                    
                 DISPLAY BY NAME g_tqp.tqp05                                                                                        
                 NEXT FIELD tqp05                                                                                                   
              END IF                                                                                                                
         ELSE                                                                                                                       
            DISPLAY ' ' TO tqp5_tqa02  
         END IF
 
      AFTER FIELD tqp06,tqp07
         IF NOT cl_null(g_tqp.tqp06) AND
            NOT cl_null(g_tqp.tqp07) AND
            g_tqp.tqp06 > g_tqp.tqp07 THEN
                CALL cl_err('','atm-367',0)
                NEXT FIELD tqp07
         END IF
 
     BEFORE FIELD tqp12
         IF g_tqp.tqp25 ='Y' THEN
            LET g_tqp.tqp12 ='1'
         END IF
         IF g_tqp.tqp25 ='N' THEN
            LET g_tqp.tqp12 ='2'
         END IF
 
     AFTER FIELD tqp12   
         IF g_tqp.tqp25 ='Y' THEN
            IF g_tqp.tqp12 ='2' THEN
               CALL cl_err('','atm-387',0)
               LET g_tqp.tqp12 ='1'
               NEXT FIELD tqp12
            END IF
         END IF
         IF g_tqp.tqp25 ='N' THEN
            IF g_tqp.tqp12 ='1' THEN
               CALL cl_err('','atm-387',0)
               LET g_tqp.tqp12 ='2'
               NEXT FIELD tqp12
            END IF
         END IF
                                                                                                                    
                      
        AFTER FIELD tqp21                       #幣別
         IF NOT cl_null(g_tqp.tqp21) THEN
             IF (g_tqp_t.tqp21 IS NULL) OR 
                (g_tqp.tqp21 != g_tqp_t.tqp21)   THEN 
                CALL t229_tqp21()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_tqp.tqp21,g_errno,0)
                   LET g_tqp.tqp21 = g_tqp_t.tqp21
                   DISPLAY BY NAME g_tqp.tqp21  
                   NEXT FIELD tqp21
                END IF
             END IF
          END IF  
          LET g_tqp_t.tqp21 = g_tqp.tqp21  
         
       AFTER FIELD tqp22                       #稅別
         IF NOT cl_null(g_tqp.tqp22) THEN
             IF (g_tqp_t.tqp22 IS NULL) OR 
                (g_tqp.tqp22 != g_tqp_t.tqp22)   THEN 
                CALL t229_tqp22()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_tqp.tqp22,g_errno,0)
                   LET g_tqp.tqp22 = g_tqp_t.tqp22
                   DISPLAY BY NAME g_tqp.tqp22  
                   NEXT FIELD tqp22
                END IF
             END IF
          END IF  
          LET g_tqp_t.tqp22 = g_tqp.tqp22
 
        AFTER FIELD tqpud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqpud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqpud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqpud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqpud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqpud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqpud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqpud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqpud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqpud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqpud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqpud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqpud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqpud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqpud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF                  #欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode())
               RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON ACTION controlp
          CASE
             WHEN INFIELD(tqp01) #合同編號
                  LET g_t1=g_tqp.tqp01[1,g_doc_len]
                  CALL q_oay(FALSE,FALSE,g_t1,'U1','ATM') RETURNING g_t1  #TQC-670008   #FUN-A70130
                  LET g_tqp.tqp01=g_t1
                  DISPLAY BY NAME g_tqp.tqp01
                  NEXT FIELD tqp01
             WHEN INFIELD(tqp03)  #合同類別
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_tqa1" #FUN-A70130 By shi
                  LET g_qryparam.form ="q_tqa"  #FUN-A70130 By shi
                  LET g_qryparam.arg1 ="13"
                  LET g_qryparam.default1 = g_tqp.tqp03
                  CALL cl_create_qry() RETURNING g_tqp.tqp03
                  DISPLAY BY NAME g_tqp.tqp03 
                  NEXT FIELD tqp03
             WHEN INFIELD(tqp05)  #債權代碼
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_tqa1" #FUN-A70130 By shi
                  LET g_qryparam.form ="q_tqa"  #FUN-A70130 By shi
                  LET g_qryparam.arg1 ="20"
                  LET g_qryparam.default1 = g_tqp.tqp05
                  CALL cl_create_qry() RETURNING g_tqp.tqp05
                  DISPLAY BY NAME g_tqp.tqp05 
                  NEXT FIELD tqp05
             WHEN INFIELD(tqp21)  #幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azi" 
                  LET g_qryparam.default1 = g_tqp.tqp21
                  CALL cl_create_qry() RETURNING g_tqp.tqp21
                  DISPLAY BY NAME g_tqp.tqp21 
                  NEXT FIELD tqp21
             WHEN INFIELD(tqp22)  #稅別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gec" 
                  LET g_qryparam.arg1='2'
                  LET g_qryparam.default1 = g_tqp.tqp22
                  CALL cl_create_qry() RETURNING g_tqp.tqp22
                  DISPLAY BY NAME g_tqp.tqp22 
                  NEXT FIELD tqp22
             OTHERWISE EXIT CASE
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #BUG-4C0121
          CALL cl_about()      #BUG-4C0121
 
       ON ACTION help          #BUG-4C0121
          CALL cl_show_help()  #BUG-4C0121
 
   END INPUT
 
END FUNCTION
 
FUNCTION t229_tqp21()  #幣別
   DEFINE  l_azi02   LIKE azi_file.azi02,	         
           l_aziacti LIKE gec_file.gecacti
	  
   LET g_errno = " "
   SELECT azi02,aziacti INTO l_azi02,l_aziacti     
     FROM azi_file
    WHERE azi01 = g_tqp.tqp21 
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'afa-111'
                                  LET l_azi02 = NULL
        WHEN l_aziacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(l_azi02) THEN
      DISPLAY  l_azi02 TO FORMONLY.azi02		  
   END IF
 
END FUNCTION
 
FUNCTION t229_tqp22()  #稅別
   DEFINE  l_gec04   LIKE gec_file.gec04,
	   l_gec05   LIKE gec_file.gec05,
	   l_gec02   LIKE gec_file.gec02,
	   l_gec07   LIKE gec_file.gec07,
           l_gecacti LIKE gec_file.gecacti
	  
   LET g_errno = " "
   SELECT gec02,gec04,gec05,gec07,gecacti INTO l_gec02,l_gec04,l_gec05,l_gec07,l_gecacti      #讀取稅率
     FROM gec_file
    WHERE gec01 = g_tqp.tqp22 
          AND gec011='2'  #銷項
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                                  LET l_gec02 = ''
                                  LET l_gec04 = 0
                                  LET l_gec05 = ''
                                  LET l_gec07 = '' 
        WHEN l_gecacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   LET g_tqp.tqp23 = l_gec04
   LET g_tqp.tqp24 = l_gec05
   LET g_tqp.tqp25 = l_gec07
   DISPLAY  l_gec02 TO FORMONLY.tqp22_gec02    #No.FUN-610064
   DISPLAY  g_tqp.tqp23 TO tqp23	  
   DISPLAY  g_tqp.tqp24 TO tqp24	
   DISPLAY  g_tqp.tqp25 TO tqp25		  
	  
END FUNCTION
 
FUNCTION t229_tqp03(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_tqa02 LIKE tqa_file.tqa02,
          l_tqaacti LIKE tqa_file.tqaacti
 
   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti FROM tqa_file
    WHERE  tqa01= g_tqp.tqp03
      AND  tqa03 ='13'
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-382'                                                                           
                                  LET l_tqa02 = ''                                                                                  
        WHEN l_tqaacti='N' LET g_errno = '9028'                                                                                     
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
   END CASE   
   DISPLAY l_tqa02 TO FORMONLY.tqp3_tqa02
 
END FUNCTION
 
FUNCTION t229_tqp05(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_tqa02 LIKE tqa_file.tqa02,
          l_tqaacti LIKE tqa_file.tqaacti
 
   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti FROM tqa_file
    WHERE  tqa01= g_tqp.tqp05
      AND  tqa03 ='20'
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-375'                                                                           
                                  LET l_tqa02 = ''                                                                                  
        WHEN l_tqaacti='N' LET g_errno = '9028'                                                                                     
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
   END CASE   
   DISPLAY l_tqa02 TO FORMONLY.tqp5_tqa02
 
END FUNCTION
 
FUNCTION t229_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_tqp.* TO NULL               #No.FUN-6B0043
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tqr.clear()
   CALL g_tqq.clear()
   CALL g_tqs.clear()
   CALL g_tqt.clear()
   
   DISPLAY ' ' TO FORMONLY.cnt  
 
   CALL t229_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_tqp.* TO NULL
      RETURN
   END IF
 
   OPEN t229_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tqp.* TO NULL
   ELSE
      OPEN t229_count
      FETCH t229_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL t229_fetch('F')                  # 讀出TEMP第一筆并顯示
   END IF
 
END FUNCTION
 
FUNCTION t229_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680120 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t229_cs INTO g_tqp.tqp01
      WHEN 'P' FETCH PREVIOUS t229_cs INTO g_tqp.tqp01
      WHEN 'F' FETCH FIRST    t229_cs INTO g_tqp.tqp01
      WHEN 'L' FETCH LAST     t229_cs INTO g_tqp.tqp01
      WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION controlg      #BUG-4C0121
        CALL cl_cmdask()     #BUG-4C0121
 
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t229_cs INTO g_tqp.tqp01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tqp.tqp01,SQLCA.sqlcode,0)
      INITIALIZE g_tqp.* TO NULL  #TQC-6B0105
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
      #DISPLAY g_curs_index TO FORMONLY.idx                    #No.FUN-4A0089
   END IF
 
   SELECT * INTO g_tqp.* FROM tqp_file WHERE tqp01 = g_tqp.tqp01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","tqp_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
      INITIALIZE g_tqp.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_tqp.tqpuser      #FUN-4C0056 add
   LET g_data_group = g_tqp.tqpgrup      #FUN-4C0056 add
   LET g_data_plant = g_tqp.tqpplant #FUN-980030
 
   CALL t229_show()
 
END FUNCTION
 
FUNCTION t229_show()
DEFINE  g_chr1    LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE  g_chr2    LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE  g_chr3    LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   LET g_tqp_t.* = g_tqp.* 
   LET g_tqp_o.* = g_tqp.*     
   DISPLAY BY NAME g_tqp.tqp01,g_tqp.tqp02,g_tqp.tqp03, g_tqp.tqporiu,g_tqp.tqporig,
                   g_tqp.tqp04,g_tqp.tqp05,g_tqp.tqp06,
                   g_tqp.tqp07,g_tqp.tqp12,g_tqp.tqp13,
                   g_tqp.tqp21,g_tqp.tqp22,g_tqp.tqp23,
                   g_tqp.tqp24,g_tqp.tqp25,
                   g_tqp.tqpuser,g_tqp.tqpgrup,g_tqp.tqpmodu,
                   g_tqp.tqpdate,g_tqp.tqpacti,
                   g_tqp.tqpud01,g_tqp.tqpud02,g_tqp.tqpud03,g_tqp.tqpud04,
                   g_tqp.tqpud05,g_tqp.tqpud06,g_tqp.tqpud07,g_tqp.tqpud08,
                   g_tqp.tqpud09,g_tqp.tqpud10,g_tqp.tqpud11,g_tqp.tqpud12,
                   g_tqp.tqpud13,g_tqp.tqpud14,g_tqp.tqpud15 
   
   CALL t229_tqp03('d')  
   CALL t229_tqp05('d')  
   CALL t229_tqp21()  
   CALL t229_tqp22()  
 
   CALL t229_b1_fill(g_wc1) 
   CALL t229_b2_fill(g_wc2)
   CALL t229_b3_fill(g_wc3)
   CALL t229_b4_fill(g_wc4)
   #CALL t229_b4_fill(g_wc5)            #No.FUN-820033   #MOD-AA0137
   CALL t229_b5_fill(g_wc5)             #MOD-AA0137
   IF g_tqp.tqp04 = '2' THEN
      LET g_chr1 = 'Y' 
   END IF
   IF g_tqp.tqp04 = '3' THEN
      LET g_chr2 = 'Y' 
   END IF
   IF g_tqp.tqp04 = '4' THEN
      LET g_chr3 = 'Y' 
   END IF
   CALL cl_set_field_pic1(g_chr2,"","",g_chr3,"",g_tqp.tqpacti,g_chr1,"")
   CALL cl_show_fld_cont()               #No.FUN-590083
END FUNCTION
 
 
FUNCTION t229_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tqp.tqp01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_tqp.tqp04 != '1' THEN
      CALL cl_err('','atm-046',0)  
      RETURN
   END IF
 
   SELECT * INTO g_tqp.* FROM tqp_file
    WHERE tqp01=g_tqp.tqp01
   IF g_tqp.tqpacti = 'N' THEN  
      CALL cl_err(g_tqp.tqp01,'mfg1000',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t229_cl USING g_tqp.tqp01
   IF STATUS THEN
      CALL cl_err("OPEN t229_cl:", STATUS, 1)
      CLOSE t229_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t229_cl INTO g_tqp.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tqp.tqp01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t229_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "tqp01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_tqp.tqp01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM tqp_file WHERE tqp01 = g_tqp.tqp01
      DELETE FROM tqr_file WHERE tqr01 = g_tqp.tqp01
      DELETE FROM tqq_file WHERE tqq01 = g_tqp.tqp01
      DELETE FROM tqs_file WHERE tqs01 = g_tqp.tqp01
      DELETE FROM tqt_file WHERE tqt01 = g_tqp.tqp01
      DELETE FROM tqu_file WHERE tqu01 = g_tqp.tqp01               #No.FUN-820033
      CLEAR FORM
      CALL g_tqr.clear()
      CALL g_tqq.clear()
      CALL g_tqs.clear()
      CALL g_tqt.clear()
      CALL g_tqu.clear()                                           #No.FUN-820033
      OPEN t229_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t229_cs
         CLOSE t229_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t229_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t229_cs
         CLOSE t229_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t229_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t229_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t229_fetch('/')
      END IF
   END IF
 
   CLOSE t229_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tqp.tqp01,'D')
END FUNCTION
 
FUNCTION t229_b2()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
          l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
          l_cnt           LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
          l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
          l_allow_delete  LIKE type_file.num5,                #可刪除否          #No.FUN-680120 SMALLINT
          l_result        LIKE type_file.num5                 #No.FUN-680120 SMALLINT
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN 
      RETURN
   END IF
 
   IF g_tqp.tqp01 IS NULL THEN
      RETURN
   END IF
 
   SELECT * INTO g_tqp.* FROM tqp_file
    WHERE tqp01=g_tqp.tqp01
 
   IF g_tqp.tqpacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tqp.tqp01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_tqp.tqp04 != '1' THEN   
      CALL cl_err('','atm-361',0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tqr09,tqr06,tqr07,tqr08,tqr02,tqr03,tqr04,tqr05,tqr10,''",  #TQC-940096   
                       "  FROM tqr_file",                                                                #TQC-940096  
                       "  WHERE tqr01=? ",                                                       #No.FUN-820033
                       "   AND tqr06=? AND tqr07 =? AND tqr08 =?",                              #No.FUN-820033
                       "   AND tqr03=? AND tqr04=? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t229_b2_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_tqr WITHOUT DEFAULTS FROM s_tqr.*
         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         DISPLAY "BEFORE INPUT!"
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         DISPLAY "BEFORE ROW!"
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         BEGIN WORK
 
         OPEN t229_cl USING g_tqp.tqp01
         IF STATUS THEN
            CALL cl_err("OPEN t229_cl:", STATUS, 1)
            CLOSE t229_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH t229_cl INTO g_tqp.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_tqp.tqp01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE t229_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         IF g_rec_b2 >= l_ac THEN
            LET p_cmd='u'
            LET g_tqr_t.* = g_tqr[l_ac].*  #BACKUP
           OPEN t229_b2_cl USING g_tqp.tqp01,g_tqr_t.tqr06,g_tqr_t.tqr07,g_tqr_t.tqr08,                 #No.FUN-820033
                                  g_tqr_t.tqr03,g_tqr_t.tqr04
            IF STATUS THEN
               CALL cl_err("OPEN t229_b2_cl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t229_b2_cl INTO g_tqr[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  LET l_lock_sw = "Y"
               END IF
               SELECT azf03 INTO g_tqr[l_ac].tqr10_azf03 FROM azf_file #TQC-940096   
                WHERE azf01=g_tqr[l_ac].tqr10 AND azf02='2'            #TQC-940096 
            END IF 
              CALL t229_set_entry_b2(p_cmd)
              CALL t229_set_no_entry_b2(p_cmd)
         CALL cl_show_fld_cont()               #No.FUN-590083
         END IF
 
      BEFORE INSERT
         DISPLAY "BEFORE INSERT!"
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_tqr[l_ac].* TO NULL      #900423
         LET g_tqr_t.* = g_tqr[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()               #No.FUN-590083
         NEXT FIELD tqr09
 
      AFTER INSERT
         DISPLAY "AFTER INSERT!"
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_tqr[l_ac].tqr02) THEN 
            LET  g_tqr[l_ac].tqr02 = ' '
         END IF   
         INSERT INTO tqr_file (tqr01,tqr09,tqr06,tqr07,tqr08,tqr02,tqr03,tqr04,tqr05,tqr10,         #No.TQC-830054
                               tqrud01,tqrud02,tqrud03,
                               tqrud04,tqrud05,tqrud06,
                               tqrud07,tqrud08,tqrud09,
                               tqrud10,tqrud11,tqrud12,
                               tqrud13,tqrud14,tqrud15, 
                               tqrplant,tqrlegal) #FUN-980009
                               
         VALUES(g_tqp.tqp01,g_tqr[l_ac].tqr09,g_tqr[l_ac].tqr06,g_tqr[l_ac].tqr07,g_tqr[l_ac].tqr08,#No.TQC-830054
                g_tqr[l_ac].tqr02,g_tqr[l_ac].tqr03,g_tqr[l_ac].tqr04,g_tqr[l_ac].tqr05,            #No.TQC-830054
                g_tqr[l_ac].tqr10,
                g_tqr[l_ac].tqrud01,
                g_tqr[l_ac].tqrud02,
                g_tqr[l_ac].tqrud03,
                g_tqr[l_ac].tqrud04,
                g_tqr[l_ac].tqrud05,
                g_tqr[l_ac].tqrud06,
                g_tqr[l_ac].tqrud07,
                g_tqr[l_ac].tqrud08,
                g_tqr[l_ac].tqrud09,
                g_tqr[l_ac].tqrud10,
                g_tqr[l_ac].tqrud11,
                g_tqr[l_ac].tqrud12,
                g_tqr[l_ac].tqrud13,
                g_tqr[l_ac].tqrud14,
                g_tqr[l_ac].tqrud15,
                g_plant,g_legal      #FUN-980009
               )                                                                 #No.TQC-830054
                 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tqr_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK 
            LET g_rec_b2=g_rec_b2+1
         END IF
 
      BEFORE FIELD tqr09                        #default 序號
         IF g_tqr[l_ac].tqr09 IS NULL OR g_tqr[l_ac].tqr09 = 0 THEN
            SELECT max(tqr09)+1 INTO g_tqr[l_ac].tqr09
              FROM tqr_file
             WHERE tqr01 = g_tqp.tqp01
            IF g_tqr[l_ac].tqr09 IS NULL THEN
               LET g_tqr[l_ac].tqr09 = 1
            END IF
         END IF
 
      AFTER FIELD tqr09                        #check 序號是否重復
         IF NOT cl_null(g_tqr[l_ac].tqr09) THEN
            IF g_tqr[l_ac].tqr09 != g_tqr_t.tqr09 
               OR g_tqr_t.tqr09 IS NULL THEN
               SELECT count(*) INTO l_n FROM tqr_file
                WHERE tqr01 = g_tqp.tqp01 
                      AND tqr09 = g_tqr[l_ac].tqr09
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_tqr[l_ac].tqr09 = g_tqr_t.tqr09
                  NEXT FIELD tqr09
               END IF
            END IF
         END IF  
         
      BEFORE FIELD tqr06
            CALL t229_set_entry_b2(p_cmd)
            
      AFTER FIELD tqr06
         IF NOT cl_null(g_tqr[l_ac].tqr06) THEN
#           IF g_tqr[l_ac].tqr06 != g_tqr_t.tqr06       #MOD-C30295 mark 
#              OR g_tqr_t.tqr06 IS NULL THEN            #MOD-C30295 mark
                  CALL t229_set_no_entry_b2(p_cmd)
#           END IF                                      #MOD-C30295 mark
         END IF
               
      AFTER FIELD tqr07
         IF NOT cl_null(g_tqr[l_ac].tqr07) THEN
            IF g_tqr[l_ac].tqr07 != g_tqr_t.tqr07 
               OR g_tqr_t.tqr07 IS NULL THEN
               IF g_tqr[l_ac].tqr06 ='1' THEN
                  CALL t229_tqr07()
                  IF g_errno THEN
                     CALL cl_err('',g_errno,1)
                     LET g_tqr[l_ac].tqr07 =NULL
                     NEXT FIELD tqr07
                  END IF
               END IF
            END IF
         END IF 
      
      AFTER FIELD tqr08
         IF NOT cl_null(g_tqr[l_ac].tqr08) THEN
            IF g_tqr[l_ac].tqr08 != g_tqr_t.tqr08 
               OR g_tqr_t.tqr08 IS NULL THEN
               IF g_tqr[l_ac].tqr06 ='1' THEN
                  CALL t229_tqr07()
                  IF g_errno THEN
                     CALL cl_err('',g_errno,1)
                     LET g_tqr[l_ac].tqr08 =NULL
                     NEXT FIELD tqr08
                  END IF
               END IF
            END IF
         END IF 
 
       AFTER FIELD tqr10
         IF NOT cl_null(g_tqr[l_ac].tqr10) THEN
            IF g_tqr[l_ac].tqr10 != g_tqr_t.tqr10 
               OR g_tqr_t.tqr10 IS NULL THEN
               SELECT azf03 INTO g_tqr[l_ac].tqr10_azf03 FROM azf_file
                WHERE azf01 = g_tqr[l_ac].tqr10 
                  AND azfacti ='Y'
                  AND azf02 = '2'   #FUN-920186
               IF SQLCA.sqlcode THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  LET g_tqr[l_ac].tqr10 = g_tqr_t.tqr10
                  NEXT FIELD tqr10
               END IF
            END IF
         END IF  
 
      AFTER FIELD tqr02           #條件期間：年返、月返、季返 
         IF g_tqr[l_ac].tqr02 != g_tqr_t.tqr02 THEN 
            CALL t229_chkt(g_tqp.tqp01,g_tqr[l_ac].tqr02,
                           g_tqr[l_ac].tqr03)
                 RETURNING l_result
            IF l_result THEN 
               CALL cl_err('','atm-368',0)
               NEXT FIELD tqr02 
            END IF
            CALL t229_chkt(g_tqp.tqp01,g_tqr[l_ac].tqr02,
                           g_tqr[l_ac].tqr04)
                 RETURNING l_result
            IF l_result THEN 
               CALL cl_err('','atm-368',0)
               NEXT FIELD tqr02 
            END IF
         END IF
 
      BEFORE FIELD tqr03,tqr04
         IF cl_null(g_tqr[l_ac].tqr02) AND g_tqr[l_ac].tqr06 ='2' THEN   #No.FUN-820033
            CALL cl_err('','atm-369',0)
            NEXT FIELD tqr02
         END IF
     
      AFTER FIELD tqr03            
         IF NOT cl_null(g_tqr[l_ac].tqr03) THEN
            IF g_tqr[l_ac].tqr03 < 0 THEN 
               CALL cl_err('','atm-370',0)
               NEXT FIELD tqr03
            END IF
	    IF NOT cl_null(g_tqr[l_ac].tqr04) AND
               g_tqr[l_ac].tqr03 >= g_tqr[l_ac].tqr04  THEN
               CALL cl_err('','atm-371',0)
               NEXT FIELD tqr03
            END IF
	    IF g_tqr[l_ac].tqr03 != g_tqr_t.tqr03 OR
               g_tqr_t.tqr03 IS NULL THEN 
               CALL t229_chkt(g_tqp.tqp01,g_tqr[l_ac].tqr02,
                              g_tqr[l_ac].tqr03)
                     RETURNING l_result
               IF l_result THEN 
                  CALL cl_err('','atm-368',0)
                  NEXT FIELD tqr03 
               END IF
	    END IF
         END IF
 
      AFTER FIELD tqr04            
         IF NOT cl_null(g_tqr[l_ac].tqr04) THEN
            IF g_tqr[l_ac].tqr04 <= 0 THEN 
               CALL cl_err('','atm-370',0)
               NEXT FIELD tqr04
            END IF
            IF NOT cl_null(g_tqr[l_ac].tqr03) AND
               g_tqr[l_ac].tqr03 >= g_tqr[l_ac].tqr04  THEN
               CALL cl_err('','atm-371',0)
               NEXT FIELD tqr04
            END IF
	    IF g_tqr[l_ac].tqr04 != g_tqr_t.tqr04 OR 
               g_tqr_t.tqr04 IS NULL THEN 
               CALL t229_chkt(g_tqp.tqp01,g_tqr[l_ac].tqr02,
                              g_tqr[l_ac].tqr04)
                    RETURNING l_result
               IF l_result THEN 
                  CALL cl_err('','atm-368',0)
                  NEXT FIELD tqr04 
               END IF
	    END IF
         END IF
 
      AFTER FIELD tqr05            
         IF NOT cl_null(g_tqr[l_ac].tqr05) THEN
            IF g_tqr[l_ac].tqr05 < 0 THEN 
               CALL cl_err('','atm-372',0)
               NEXT FIELD tqr05
            END IF
            IF g_tqr[l_ac].tqr05 > 100 THEN 
               CALL cl_err('',47104,0)
               NEXT FIELD tqr05
            END IF
         END IF
 
      AFTER FIELD tqrud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tqrud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tqrud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tqrud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tqrud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tqrud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tqrud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tqrud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tqrud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tqrud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tqrud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tqrud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tqrud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tqrud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tqrud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
      BEFORE DELETE                      #是否取消單身
         DISPLAY "BEFORE DELETE" 
         IF g_tqr_t.tqr02 IS NOT NULL AND
            g_tqr_t.tqr03 IS NOT NULL AND
	      g_tqr_t.tqr04 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM tqr_file
               WHERE tqr01 = g_tqp.tqp01
                 AND tqr02 = g_tqr_t.tqr02
                 AND tqr03 = g_tqr_t.tqr03
                 AND tqr04 = g_tqr_t.tqr04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tqr_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                 ROLLBACK WORK
                 CANCEL DELETE 
              END IF
              LET g_rec_b2=g_rec_b2-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_tqr[l_ac].* = g_tqr_t.*
              CLOSE t229_b2_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err('',-263,0)
              LET g_tqr[l_ac].* = g_tqr_t.*
           ELSE
              #MOD-C30295 add begin ---
              IF g_tqr[l_ac].tqr06 = '1' THEN
                 LET g_tqr[l_ac].tqr02 = ' '
              END IF 
              #MOD-C30295 add end -----
              UPDATE tqr_file SET tqr02=g_tqr[l_ac].tqr02,
                                     tqr09=g_tqr[l_ac].tqr09,
                                     tqr06=g_tqr[l_ac].tqr06,
                                     tqr07=g_tqr[l_ac].tqr07,
                                     tqr08=g_tqr[l_ac].tqr08,
                                     tqr10=g_tqr[l_ac].tqr10,
                                     tqr03=g_tqr[l_ac].tqr03,
                                     tqr04=g_tqr[l_ac].tqr04,
                                     tqr05=g_tqr[l_ac].tqr05,
                                     tqrud01 = g_tqr[l_ac].tqrud01,
                                     tqrud02 = g_tqr[l_ac].tqrud02,
                                     tqrud03 = g_tqr[l_ac].tqrud03,
                                     tqrud04 = g_tqr[l_ac].tqrud04,
                                     tqrud05 = g_tqr[l_ac].tqrud05,
                                     tqrud06 = g_tqr[l_ac].tqrud06,
                                     tqrud07 = g_tqr[l_ac].tqrud07,
                                     tqrud08 = g_tqr[l_ac].tqrud08,
                                     tqrud09 = g_tqr[l_ac].tqrud09,
                                     tqrud10 = g_tqr[l_ac].tqrud10,
                                     tqrud11 = g_tqr[l_ac].tqrud11,
                                     tqrud12 = g_tqr[l_ac].tqrud12,
                                     tqrud13 = g_tqr[l_ac].tqrud13,
                                     tqrud14 = g_tqr[l_ac].tqrud14,
                                     tqrud15 = g_tqr[l_ac].tqrud15
               WHERE tqr01=g_tqp.tqp01
                 AND tqr02=g_tqr_t.tqr02
                 AND tqr03=g_tqr_t.tqr03
                 AND tqr04=g_tqr_t.tqr04
                 AND tqr06=g_tqr_t.tqr06        #MOD-C30295 add
                 AND tqr07=g_tqr_t.tqr07        #MOD-C30295 add
                 AND tqr08=g_tqr_t.tqr08        #MOD-C30295 add
 
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","tqr_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                 LET g_tqr[l_ac].* = g_tqr_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK 
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN 
                 LET g_tqr[l_ac].* = g_tqr_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_tqr.deleteElement(l_ac)
                 IF g_rec_b2 != 0 THEN
                    LET g_action_choice = "detail"
                    LET g_b_flag = '2'
                    LET l_ac = l_ac_t
                 END IF 
              #FUN-D30033--add--end----
              END IF 
              CLOSE t229_b2_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE t229_b2_cl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF l_ac > 1 THEN
              LET g_tqr[l_ac].* = g_tqr[l_ac-1].*
           END IF
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
           
        ON ACTION controlp
           CASE
              WHEN INFIELD(tqr10)       
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azf01a"
                 LET g_qryparam.arg1 ='3'
                 LET g_qryparam.default1 = g_tqr[l_ac].tqr10
                 CALL cl_create_qry() RETURNING g_tqr[l_ac].tqr10
                 DISPLAY BY NAME g_tqr[l_ac].tqr10
                 NEXT FIELD tqr10
              OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
    END INPUT
 
    CLOSE t229_b2_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t229_chkt(p_k1,p_k2,p_k3) 
DEFINE p_k1 LIKE tqr_file.tqr01,
       p_k2 LIKE tqr_file.tqr02,
       p_k3 LIKE tqr_file.tqr03,
       l_tqr03  LIKE tqr_file.tqr03,
       l_tqr04  LIKE tqr_file.tqr04,
       l_result  LIKE type_file.num5             #No.FUN-680120 SMALLINT
 
   LET l_result = 0
   LET g_sql = "SELECT tqr03,tqr04 FROM tqr_file",
               " WHERE tqr01=? AND tqr02=?"
   DECLARE t229_tqr34c CURSOR FROM g_sql
   FOREACH t229_tqr34c USING p_k1,p_k2 INTO l_tqr03,l_tqr04
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
       IF l_tqr03 <= p_k3 AND p_k3 <= l_tqr04 THEN
          LET l_result = 1
          EXIT FOREACH
       END IF 
   END FOREACH
   RETURN l_result
END FUNCTION
 
FUNCTION t229_b1()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
          l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
          l_cnt           LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680120 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680120 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680120 SMALLINT
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN 
      RETURN
   END IF
 
   IF g_tqp.tqp01 IS NULL THEN
      RETURN
   END IF
 
   SELECT * INTO g_tqp.* FROM tqp_file
    WHERE tqp01=g_tqp.tqp01
 
   IF g_tqp.tqpacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tqp.tqp01,'mfg1000',0)
      RETURN
   END IF
   IF g_tqp.tqp04 != '1' THEN   
      CALL cl_err('','atm-361',0)
      RETURN
   END IF
 
   SELECT tqq01 FROM tqq_file
    WHERE tqq01 =g_tqp.tqp01
 
   IF SQLCA.sqlcode =100 THEN
      CALL t229_g_b1()
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT tqq02,tqq06,tqq03,'',tqq04,'',",
                      "       tqq05,'',",
                      "       tqqud01,tqqud02,tqqud03,tqqud04,tqqud05,",
                      "       tqqud06,tqqud07,tqqud08,tqqud09,tqqud10,",
                      "       tqqud11,tqqud12,tqqud13,tqqud14,tqqud15", 
                      "  FROM tqq_file",
                      " WHERE tqq01=? AND tqq03=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t229_b1_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_tqq WITHOUT DEFAULTS FROM s_tqq.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         DISPLAY "BEFORE INPUT!"
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         DISPLAY "BEFORE ROW!"
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         BEGIN WORK
 
         OPEN t229_cl USING g_tqp.tqp01
         IF STATUS THEN
            CALL cl_err("OPEN t229_cl:", STATUS, 1)
            CLOSE t229_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH t229_cl INTO g_tqp.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_tqp.tqp01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE t229_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         IF g_rec_b1 >= l_ac THEN
            LET p_cmd='u'
            LET g_tqq_t.* = g_tqq[l_ac].*  #BACKUP
            OPEN t229_b1_cl USING g_tqp.tqp01,g_tqq_t.tqq03
            IF STATUS THEN
               CALL cl_err("OPEN t229_b1_cl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t229_b1_cl INTO g_tqq[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_tqq_t.tqq03,SQLCA.sqlcode,0)
                  LET l_lock_sw = "Y"
               END IF
               CALL t229_tqq03(l_ac,g_tqq[l_ac].tqq03,'d')
            END IF
            CALL cl_show_fld_cont()               #No.FUN-590083
         END IF
 
      BEFORE INSERT
         DISPLAY "BEFORE INSERT!"
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_tqq[l_ac].* TO NULL      #900423
         LET g_tqq_t.* = g_tqq[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()               #No.FUN-590083
         NEXT FIELD tqq02
 
      AFTER INSERT
         DISPLAY "AFTER INSERT!"
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO tqq_file(tqq01,tqq02,tqq03,tqq04,
                                 tqq05,tqq06,
                              tqqud01,tqqud02,tqqud03,
                              tqqud04,tqqud05,tqqud06,
                              tqqud07,tqqud08,tqqud09,
                              tqqud10,tqqud11,tqqud12,
                              tqqud13,tqqud14,tqqud15,
                              tqqplant,tqqlegal  #FUN-980009
                             )
         VALUES(g_tqp.tqp01,g_tqq[l_ac].tqq02,g_tqq[l_ac].tqq03,
                g_tqq[l_ac].tqq04,g_tqq[l_ac].tqq05,
                g_tqq[l_ac].tqq06,
                g_tqq[l_ac].tqqud01,
                g_tqq[l_ac].tqqud02,
                g_tqq[l_ac].tqqud03,
                g_tqq[l_ac].tqqud04,
                g_tqq[l_ac].tqqud05,
                g_tqq[l_ac].tqqud06,
                g_tqq[l_ac].tqqud07,
                g_tqq[l_ac].tqqud08,
                g_tqq[l_ac].tqqud09,
                g_tqq[l_ac].tqqud10,
                g_tqq[l_ac].tqqud11,
                g_tqq[l_ac].tqqud12,
                g_tqq[l_ac].tqqud13,
                g_tqq[l_ac].tqqud14,
                g_tqq[l_ac].tqqud15,
                g_plant,g_legal            #FUN-980009
               )
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tqq_file",g_tqq[l_ac].tqq03,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK 
            LET g_rec_b1=g_rec_b1+1
            DISPLAY g_rec_b1 TO FORMONLY.cn1  
         END IF
 
      BEFORE FIELD tqq02                        #default 序號
         IF g_tqq[l_ac].tqq02 IS NULL OR g_tqq[l_ac].tqq02 = 0 THEN
            SELECT max(tqq02)+1 INTO g_tqq[l_ac].tqq02
              FROM tqq_file
             WHERE tqq01 = g_tqp.tqp01
            IF g_tqq[l_ac].tqq02 IS NULL THEN
               LET g_tqq[l_ac].tqq02 = 1
            END IF
         END IF
 
      AFTER FIELD tqq02                        #check 序號是否重復
         IF NOT cl_null(g_tqq[l_ac].tqq02) THEN
            IF g_tqq[l_ac].tqq02 != g_tqq_t.tqq02 
               OR g_tqq_t.tqq02 IS NULL THEN
               SELECT count(*) INTO l_n FROM tqq_file
                WHERE tqq01 = g_tqp.tqp01 
                      AND tqq02 = g_tqq[l_ac].tqq02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_tqq[l_ac].tqq02 = g_tqq_t.tqq02
                  NEXT FIELD tqq02
               END IF
            END IF
         END IF
              
      BEFORE FIELD tqq06              #工廠別
         IF cl_null(g_tqq[l_ac].tqq06) THEN
            LET g_tqq[l_ac].tqq06=g_plant
         END IF
 
      AFTER FIELD tqq06               #工廠別
         IF NOT cl_null(g_tqq[l_ac].tqq06) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01=g_tqq[l_ac].tqq06
            IF g_cnt<=0 THEN
               ERROR 'WRONG database!'
               NEXT FIELD tqq06
            ELSE
               LET g_plant_new = g_tqq[l_ac].tqq06
            END IF
         ELSE
            NEXT FIELD tqq06
         END IF
 
      AFTER FIELD tqq03               #門店代碼
         IF NOT cl_null(g_tqq[l_ac].tqq03) THEN
            IF g_tqq[l_ac].tqq03 != g_tqq_t.tqq03 
               OR g_tqq_t.tqq03 IS NULL THEN
               SELECT count(*) INTO l_n FROM tqq_file
                WHERE tqq01 = g_tqp.tqp01 
                      AND tqq03 = g_tqq[l_ac].tqq03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_tqq[l_ac].tqq03 = g_tqq_t.tqq03
                  NEXT FIELD tqq03
               END IF
               CALL t229_tqq03(l_ac,g_tqq[l_ac].tqq03,'a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tqq[l_ac].tqq03,g_errno,0)
                  NEXT FIELD tqq03
               END IF
            END IF
         END IF
 
        AFTER FIELD tqqud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqqud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqqud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqqud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqqud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqqud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqqud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqqud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqqud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqqud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqqud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqqud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqqud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqqud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqqud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
      BEFORE DELETE                      #是否取消單身
         DISPLAY "BEFORE DELETE" 
         IF g_tqq_t.tqq02 > 0 AND g_tqq_t.tqq02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM tqq_file
             WHERE tqq01 = g_tqp.tqp01
                   AND tqq03 = g_tqq_t.tqq03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tqq_file",g_tqq_t.tqq03,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b1=g_rec_b1-1
            DISPLAY g_rec_b1 TO FORMONLY.cn1  
         END IF
           COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_tqq[l_ac].* = g_tqq_t.*
            CLOSE t229_b1_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_tqq[l_ac].tqq02,-263,0)
            LET g_tqq[l_ac].* = g_tqq_t.*
         ELSE
            UPDATE tqq_file SET tqq02=g_tqq[l_ac].tqq02,
                                   tqq03=g_tqq[l_ac].tqq03,
                                   tqq04=g_tqq[l_ac].tqq04,
                                   tqq05=g_tqq[l_ac].tqq05,
                                   tqq06=g_tqq[l_ac].tqq06,
                                   tqqud01 = g_tqq[l_ac].tqqud01,
                                   tqqud02 = g_tqq[l_ac].tqqud02,
                                   tqqud03 = g_tqq[l_ac].tqqud03,
                                   tqqud04 = g_tqq[l_ac].tqqud04,
                                   tqqud05 = g_tqq[l_ac].tqqud05,
                                   tqqud06 = g_tqq[l_ac].tqqud06,
                                   tqqud07 = g_tqq[l_ac].tqqud07,
                                   tqqud08 = g_tqq[l_ac].tqqud08,
                                   tqqud09 = g_tqq[l_ac].tqqud09,
                                   tqqud10 = g_tqq[l_ac].tqqud10,
                                   tqqud11 = g_tqq[l_ac].tqqud11,
                                   tqqud12 = g_tqq[l_ac].tqqud12,
                                   tqqud13 = g_tqq[l_ac].tqqud13,
                                   tqqud14 = g_tqq[l_ac].tqqud14,
                                   tqqud15 = g_tqq[l_ac].tqqud15
             WHERE tqq01=g_tqp.tqp01
                   AND tqq03=g_tqq_t.tqq03
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","tqq_file",g_tqq[l_ac].tqq03,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
               LET g_tqq[l_ac].* = g_tqq_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK 
            END IF
         END IF
 
      AFTER ROW
         DISPLAY  "AFTER ROW!!"
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30033  mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN 
               LET g_tqq[l_ac].* = g_tqq_t.*
            #FUN-D30033--add--begin--
            ELSE
               CALL g_tqq.deleteElement(l_ac)
               IF g_rec_b1 != 0 THEN
                  LET g_action_choice = "detail"
                  LET g_b_flag = '1'
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30033--add--end----
            END IF 
            CLOSE t229_b1_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30033  add
         CLOSE t229_b1_cl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tqq02) AND l_ac > 1 THEN
            LET g_tqq[l_ac].* = g_tqq[l_ac-1].*
            NEXT FIELD tqq02
         END IF
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(tqq06)          #工廠別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azp"
                 LET g_qryparam.default1 = g_tqq[l_ac].tqq06
                 CALL cl_create_qry() RETURNING g_tqq[l_ac].tqq06
                 DISPLAY BY NAME g_tqq[l_ac].tqq06
                 NEXT FIELD tqq06
            WHEN INFIELD(tqq03)        #門店代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_occ27"    #No.TQC-830054                                                                             
                 LET g_qryparam.default1 = g_tqq[l_ac].tqq03
                 SELECT azp03 INTO g_azp03 FROM azp_file
                  WHERE azp01=g_tqq[l_ac].tqq06
                 IF cl_null(g_azp03) THEN LET g_azp03=g_dbs  END IF
                 LET g_qryparam.arg1 = g_azp03
                 CALL cl_create_qry() RETURNING g_tqq[l_ac].tqq03
                 DISPLAY BY NAME g_tqq[l_ac].tqq03
                 NEXT FIELD tqq03
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
 
      ON ACTION help          #BUG-4C0121
         CALL cl_show_help()  #BUG-4C0121
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
   END INPUT
 
    CLOSE t229_b1_cl
    COMMIT WORK
 
END FUNCTION
 
#門店代碼
FUNCTION t229_tqq03(p_ac,p_key,p_cmd)
   DEFINE p_ac     LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          p_key    LIKE occ_file.occ01,
          p_cmd    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
          l_occ02  LIKE occ_file.occ02,
          l_occ1009  LIKE occ_file.occ1009,
          l_occacti  LIKE occ_file.occacti,
          l_too02  LIKE too_file.too02,
          l_occ1010  LIKE occ_file.occ1010,
          l_top02  LIKE top_file.top02
       
   LET g_errno =''
   LET g_plant_new = g_tqq[p_ac].tqq06
   CALL s_getdbs()
  
   #-----MOD-AA0161---------
   #LET g_sql=" SELECT occ02,occ1009,too02,occ1010,top02,occacti ",
   #          #"   FROM ",g_dbs_new,"occ_file,",
   #          #"  OUTER ",g_dbs_new,"too_file,",
   #          #"  OUTER ",g_dbs_new,"top_file ",
   #          #"  WHERE ",g_dbs_new,"occ_file.occ01 = '",p_key,"' ",
   #          #"    AND ",g_dbs_new,"occ_file.occ1004 = '1'",   #No.FUN-690025
   #          #"    AND ",g_dbs_new,"occ_file.occ06 = '1'",
   #          #"    AND ",g_dbs_new,"occ_file.occ1009 = ",g_dbs_new,"too_file.too01",
   #          #"    AND ",g_dbs_new,"occ_file.occ1010 = ",g_dbs_new,"top_file.top01"
   #          "   FROM ",cl_get_target_table(g_plant_new,'occ_file'),",",   #FUN-A50102
   #          "  OUTER ",cl_get_target_table(g_plant_new,'too_file'),",",   #FUN-A50102
   #          "  OUTER ",cl_get_target_table(g_plant_new,'top_file'),       #FUN-A50102
   #          "  WHERE ",cl_get_target_table(g_plant_new,'occ_file'),".occ01 = '",p_key,"' ", #FUN-A50102
   #          "    AND ",cl_get_target_table(g_plant_new,'occ_file'),".occ1004 = '1'",        #FUN-A50102  
   #          "    AND ",cl_get_target_table(g_plant_new,'occ_file'),".occ06 = '1'",          #FUN-A50102
   #          "    AND ",cl_get_target_table(g_plant_new,'occ_file'),".occ1009 = ",           #FUN-A50102
   #                     cl_get_target_table(g_plant_new,'too_file'),".too01",                #FUN-A50102
   #          "    AND ",cl_get_target_table(g_plant_new,'occ_file'),".occ1010 = ",           #FUN-A50102
   #                     cl_get_target_table(g_plant_new,'top_file'),".top01"                 #FUN-A50102
   LET g_sql=" SELECT occ02,occ1009,occ1010,occacti ",
             "   FROM ",cl_get_target_table(g_plant_new,'occ_file'),   
             "  WHERE ",cl_get_target_table(g_plant_new,'occ_file'),".occ01 = '",p_key,"' ", 
             "    AND ",cl_get_target_table(g_plant_new,'occ_file'),".occ1004 = '1'",         
             "    AND ",cl_get_target_table(g_plant_new,'occ_file'),".occ06 = '1'"          
   #-----END MOD-AA0161-----
	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE tqq03_pre FROM g_sql
   DECLARE tqq03_cur CURSOR FOR tqq03_pre 
   OPEN tqq03_cur
   #FETCH tqq03_cur INTO l_occ02,l_occ1009,l_too02,l_occ1010,l_top02,l_occacti   #MOD-AA0161
   FETCH tqq03_cur INTO l_occ02,l_occ1009,l_occ1010,l_occacti   #MOD-AA0161
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-383'                                                                           
                                  LET l_occ02 = NULL                                                                                
                                  LET l_occ1009 = NULL                                                                                
                                  LET l_too02 = NULL                                                                                
                                  LET l_occ1010 = NULL                                                                                
                                  LET l_top02 = NULL                                                                                
        WHEN l_occacti='N'            LET g_errno = '9028'
        WHEN l_occacti MATCHES '[PH]' LET g_errno = '9038'  #No.FUN-690023 add
        OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
   END CASE  
   #-----MOD-AA0161---------
   #IF NOT SQLCA.sqlcode THEN     #TQC-AC0146 mark
   IF cl_null(g_errno) THEN       #TQC-AC0146 add
      LET g_sql=" SELECT too02 ",
                "   FROM ",cl_get_target_table(g_plant_new,'too_file'),   
                "  WHERE ",cl_get_target_table(g_plant_new,'too_file'),".too01 = '",l_occ1009,"' " 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE too_p FROM g_sql
      DECLARE too_c CURSOR FOR too_p
      OPEN too_c
      LET l_too02 = NULL
      FETCH too_c INTO l_too02
      
      LET g_sql=" SELECT top02 ",
                "   FROM ",cl_get_target_table(g_plant_new,'top_file'),   
                "  WHERE ",cl_get_target_table(g_plant_new,'top_file'),".top01 = '",l_occ1010,"' " 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE top_p FROM g_sql
      DECLARE top_c CURSOR FOR top_p
      OPEN top_c
      LET l_top02 = NULL
      FETCH top_c INTO l_top02
   END IF 
   #-----END MOD-AA0161-----
 
   #IF NOT SQLCA.sqlcode THEN     #TQC-AC0146 mark
   IF cl_null(g_errno) THEN       #TQC-AC0146 add
      LET g_tqq[p_ac].tqq03_occ02 = l_occ02 
      LET g_tqq[p_ac].tqq04_too02  = l_too02  
      LET g_tqq[p_ac].tqq05_top02  = l_top02
   END IF
   #IF NOT SQLCA.sqlcode AND p_cmd ='a' THEN     #TQC-AC0146 mark
   IF cl_null(g_errno) AND p_cmd ='a' THEN       #TQC-AC0146 add
      LET g_tqq[p_ac].tqq05  = l_occ1010
      LET g_tqq[p_ac].tqq04  = l_occ1009
   END IF
   CLOSE tqq03_cur
 
END FUNCTION
 
 
FUNCTION t229_b3()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否          #No.FUN-680120 SMALLINT
    l_azf09         LIKE azf_file.azf09,                 #FUN-920186
    l_azf10         LIKE azf_file.azf10                 #FUN-920186
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN 
       RETURN
    END IF
 
    IF g_tqp.tqp01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_tqp.* FROM tqp_file
     WHERE tqp01=g_tqp.tqp01
 
    IF g_tqp.tqpacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_tqp.tqp01,'mfg1000',0)
       RETURN
    END IF
 
    IF g_tqp.tqp04 != '1' THEN   
       CALL cl_err('','atm-361',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tqs02,tqs03,'',tqs06,tqs05,tqs07,tqs08,tqs09,tqs04,''",
                       "  FROM tqs_file",   
                       " WHERE tqs01=? AND tqs03=? FOR UPDATE "   
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t229_b3_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tqs WITHOUT DEFAULTS FROM s_tqs.*
          ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b3 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t229_cl USING g_tqp.tqp01
           IF STATUS THEN
              CALL cl_err("OPEN t229_cl:", STATUS, 1)
              CLOSE t229_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t229_cl INTO g_tqp.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_tqp.tqp01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t229_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b3 >= l_ac THEN
              LET p_cmd='u'
              LET g_tqs_t.* = g_tqs[l_ac].*  #BACKUP
              OPEN t229_b3_cl USING g_tqp.tqp01,g_tqs_t.tqs03
              IF STATUS THEN
                 CALL cl_err("OPEN t229_b3_cl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t229_b3_cl INTO g_tqs[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tqs_t.tqs02,SQLCA.sqlcode,0)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT azf03 INTO g_tqs[l_ac].tqs04_azf03 FROM azf_file #TQC-940096 
                  WHERE azf01=g_tqp.tqp01 AND azf02='2'                  #TQC-940096  
                 CALL t229_tqs03(l_ac,g_tqs[l_ac].tqs03)
              END IF
              CALL t229_set_entry_b3(p_cmd)
              CALL t229_set_no_entry_b3(p_cmd)
              CALL cl_show_fld_cont()               #No.FUN-590083
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tqs[l_ac].* TO NULL      #900423
           LET g_tqs[l_ac].tqs06 = 'N'
           LET g_tqs[l_ac].tqs07 = 'N'
           LET g_tqs[l_ac].tqs09 = 'N'
           LET g_tqs_t.* = g_tqs[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()               #No.FUN-590083
           NEXT FIELD tqs02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO tqs_file (tqs01,tqs02,tqs03,tqs04,tqs05,tqs06,tqs07,tqs08,tqs09,
                                  tqsud01,tqsud02,tqsud03,
                                  tqsud04,tqsud05,tqsud06,
                                  tqsud07,tqsud08,tqsud09,
                                  tqsud10,tqsud11,tqsud12,
                                  tqsud13,tqsud14,tqsud15,
                                  tqsplant,tqslegal  #FUN-980009
                                )
           VALUES(g_tqp.tqp01,
                  g_tqs[l_ac].tqs02,g_tqs[l_ac].tqs03,
                  g_tqs[l_ac].tqs04,g_tqs[l_ac].tqs05,g_tqs[l_ac].tqs06,
                  g_tqs[l_ac].tqs07,g_tqs[l_ac].tqs08,
                  g_tqs[l_ac].tqs09,
                  g_tqs[l_ac].tqsud01,
                  g_tqs[l_ac].tqsud02,
                  g_tqs[l_ac].tqsud03,
                  g_tqs[l_ac].tqsud04,
                  g_tqs[l_ac].tqsud05,
                  g_tqs[l_ac].tqsud06,
                  g_tqs[l_ac].tqsud07,
                  g_tqs[l_ac].tqsud08,
                  g_tqs[l_ac].tqsud09,
                  g_tqs[l_ac].tqsud10,
                  g_tqs[l_ac].tqsud11,
                  g_tqs[l_ac].tqsud12,
                  g_tqs[l_ac].tqsud13,
                  g_tqs[l_ac].tqsud14,
                  g_tqs[l_ac].tqsud15,
                  g_plant,g_legal         #FUN-980009
                 )
          
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tqs_file",g_tqs[l_ac].tqs02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK 
              LET g_rec_b3=g_rec_b3+1
              DISPLAY g_rec_b3 TO FORMONLY.cn3  
           END IF
 
        BEFORE FIELD tqs02                        #default 序號
           IF g_tqs[l_ac].tqs02 IS NULL OR g_tqs[l_ac].tqs02 = 0 THEN
              SELECT max(tqs02)+1 INTO g_tqs[l_ac].tqs02
                FROM tqs_file
               WHERE tqs01 = g_tqp.tqp01
              IF g_tqs[l_ac].tqs02 IS NULL THEN
                 LET g_tqs[l_ac].tqs02 = 1
              END IF
           END IF
 
        AFTER FIELD tqs02                        #check 序號是否重復
           IF NOT cl_null(g_tqs[l_ac].tqs02) THEN
              IF g_tqs[l_ac].tqs02 != g_tqs_t.tqs02 
                 OR g_tqs_t.tqs02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM tqs_file
                  WHERE tqs01 = g_tqp.tqp01 
                    AND tqs02 = g_tqs[l_ac].tqs02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tqs[l_ac].tqs02 = g_tqs_t.tqs02
                    NEXT FIELD tqs02
                 END IF
              END IF
           END IF
  
        AFTER FIELD tqs03            
           IF NOT cl_null(g_tqs[l_ac].tqs03) THEN
              SELECT count(*) INTO l_n FROM oaj_file
               WHERE oaj01 = g_tqs[l_ac].tqs03
              IF l_n = 0 THEN
                 CALL cl_err('','atm-386',0) 
                 NEXT FIELD tqs03
              END IF
              IF g_tqs[l_ac].tqs03 != g_tqs_t.tqs03 
                 OR g_tqs_t.tqs03 IS NULL THEN
                 SELECT count(*) INTO l_n FROM tqs_file
                  WHERE tqs03 = g_tqs[l_ac].tqs03
                    AND tqs01 = g_tqp.tqp01
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tqs[l_ac].tqs03 = g_tqs_t.tqs03
                    NEXT FIELD tqs03
                 END IF
              END IF
               
              CALL t229_tqs03(l_ac,g_tqs[l_ac].tqs03)
           END IF
           DISPLAY BY NAME g_tqs[l_ac].tqs03
           
       AFTER FIELD tqs04
         IF NOT cl_null(g_tqs[l_ac].tqs04) THEN
            IF g_tqs[l_ac].tqs04 != g_tqs_t.tqs04 
               OR g_tqs_t.tqs04 IS NULL THEN
               SELECT azf09,azf10 INTO l_azf09,l_azf10 FROM azf_file
                WHERE azf01 = g_tqs[l_ac].tqs04
                  AND azf02 = '2' 
                  AND azfacti ='Y'
               IF g_tqs[l_ac].tqs09 ='Y' THEN
                  IF l_azf09 != '3' THEN
                     CALL cl_err('','aoo-402',0)
                     NEXT FIELD tqs04
                  END IF
               ELSE
                  IF NOT (l_azf09 = '7' AND l_azf10 = 'Y') THEN
               	     CALL cl_err('','aoo-406',0)
                     NEXT FIELD tqs04
                  END IF
               END IF
               SELECT azf03 INTO g_tqs[l_ac].tqs04_azf03 FROM azf_file
                WHERE azf01 = g_tqs[l_ac].tqs04
                      AND azf02 = '2'   #FUN-920186 
                  AND azfacti ='Y'
               IF SQLCA.sqlcode THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  LET g_tqs[l_ac].tqs04 = g_tqs_t.tqs04
                  NEXT FIELD tqs04
               END IF
            END IF
         END IF 
 
        BEFORE FIELD tqs07 
          CALL t229_set_entry_b3(p_cmd)
         
        AFTER FIELD tqs07 
          DISPLAY BY NAME g_tqs[l_ac].tqs07
          CALL t229_set_no_entry_b3(p_cmd) 
        
        AFTER FIELD tqs08 
          IF NOT cl_null(g_tqs[l_ac].tqs08) THEN
            
            IF g_tqs[l_ac].tqs07 <> '3' THEN   #TQC-AC0146 add
               IF (g_tqs[l_ac].tqs08<0) OR (g_tqs[l_ac].tqs08>100) THEN 
                  CALL cl_err('','aec-002',0)
                  NEXT FIELD tqs08
               END IF
            ELSE
               #TQC-AC0146 add begin--------------
               IF (g_tqs[l_ac].tqs08<0) THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD tqs08
               END IF
               #TQC-AC0146 add -end---------------
            END IF 
          END IF 
          IF (g_tqs[l_ac].tqs07 ='2' OR g_tqs[l_ac].tqs07 ='3')  AND cl_null(g_tqs[l_ac].tqs08) THEN
             NEXT FIELD tqs08
          END IF
          DISPLAY BY NAME g_tqs[l_ac].tqs08
          
        AFTER FIELD tqs09 
          IF g_tqs[l_ac].tqs07 ='1' AND g_tqs[l_ac].tqs09 != 'N' THEN
             LET g_tqs[l_ac].tqs09 =NULL 
             NEXT FIELD tqs09
          END IF
 
        AFTER FIELD tqsud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqsud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqsud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqsud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqsud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqsud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqsud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqsud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqsud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqsud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqsud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqsud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqsud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqsud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqsud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE" 
           IF g_tqs_t.tqs02 > 0 AND g_tqs_t.tqs02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM tqs_file
               WHERE tqs01 = g_tqp.tqp01
                 AND tqs03 = g_tqs_t.tqs03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tqs_file",g_tqs_t.tqs03,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                 ROLLBACK WORK
                 CANCEL DELETE 
              END IF
              LET g_rec_b3=g_rec_b3-1
              DISPLAY g_rec_b3 TO FORMONLY.cn3  
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_tqs[l_ac].* = g_tqs_t.*
              CLOSE t229_b3_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tqs[l_ac].tqs02,-263,0)
              LET g_tqs[l_ac].* = g_tqs_t.*
           ELSE
              UPDATE tqs_file SET tqs02=g_tqs[l_ac].tqs02,
                                  tqs03=g_tqs[l_ac].tqs03,
                                  tqs04=g_tqs[l_ac].tqs04,
                                  tqs05=g_tqs[l_ac].tqs05,
                                  tqs06=g_tqs[l_ac].tqs06,
                                  tqs07=g_tqs[l_ac].tqs07,
                                  tqs08=g_tqs[l_ac].tqs08,
                                  tqs09=g_tqs[l_ac].tqs09,
                                  tqsud01 = g_tqs[l_ac].tqsud01,
                                  tqsud02 = g_tqs[l_ac].tqsud02,
                                  tqsud03 = g_tqs[l_ac].tqsud03,
                                  tqsud04 = g_tqs[l_ac].tqsud04,
                                  tqsud05 = g_tqs[l_ac].tqsud05,
                                  tqsud06 = g_tqs[l_ac].tqsud06,
                                  tqsud07 = g_tqs[l_ac].tqsud07,
                                  tqsud08 = g_tqs[l_ac].tqsud08,
                                  tqsud09 = g_tqs[l_ac].tqsud09,
                                  tqsud10 = g_tqs[l_ac].tqsud10,
                                  tqsud11 = g_tqs[l_ac].tqsud11,
                                  tqsud12 = g_tqs[l_ac].tqsud12,
                                  tqsud13 = g_tqs[l_ac].tqsud13,
                                  tqsud14 = g_tqs[l_ac].tqsud14,
                                  tqsud15 = g_tqs[l_ac].tqsud15
               WHERE tqs01=g_tqp.tqp01
                 AND tqs03=g_tqs_t.tqs03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("udp","tqs_file",g_tqs[l_ac].tqs03,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                 LET g_tqs[l_ac].* = g_tqs_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK 
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac   #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN 
                 LET g_tqs[l_ac].* = g_tqs_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_tqs.deleteElement(l_ac)
                 IF g_rec_b3 != 0 THEN
                    LET g_action_choice = "detail"
                    LET g_b_flag = '3'
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF 
              CLOSE t229_b3_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE t229_b3_cl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF l_ac > 1 THEN
              LET g_tqs[l_ac].* = g_tqs[l_ac-1].*
              NEXT FIELD tqs02
           END IF
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(tqs03)       #料件編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_tqs03"
                 LET g_qryparam.default1 = g_tqs[l_ac].tqs03
                 CALL cl_create_qry() RETURNING g_tqs[l_ac].tqs03
                 DISPLAY BY NAME g_tqs[l_ac].tqs03
                 NEXT FIELD tqs03
              WHEN INFIELD(tqs04)      
                 CALL cl_init_qry_var()
                 IF g_tqs[l_ac].tqs09 ='Y' THEN
                    LET g_qryparam.form ="q_azf01a"
                    LET g_qryparam.arg1 ='3'
                 ELSE
                    LET g_qryparam.form ="q_azf01a"            #FUN-920186
                    LET g_qryparam.arg1 = '7'                  #FUN-920186
                    LET g_qryparam.where=" azf10='Y' "         #FUN-920186
                 END IF
                 LET g_qryparam.default1 = g_tqs[l_ac].tqs04
                 CALL cl_create_qry() RETURNING g_tqs[l_ac].tqs04
                 DISPLAY BY NAME g_tqs[l_ac].tqs04
                 NEXT FIELD tqs04
              OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
    END INPUT
 
    CLOSE t229_b3_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t229_b4()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680120 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN 
       RETURN
    END IF
 
    IF g_tqp.tqp01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_tqp.* FROM tqp_file
     WHERE tqp01=g_tqp.tqp01
 
    IF g_tqp.tqpacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_tqp.tqp01,'mfg1000',0)
       RETURN
    END IF
 
    IF g_tqp.tqp04 != '1' THEN   
       CALL cl_err('','atm-361',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tqt02,''",
                       "  FROM tqt_file",
                       " WHERE tqt01=? AND tqt02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t229_b4_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tqt WITHOUT DEFAULTS FROM s_tqt.*
          ATTRIBUTE(COUNT=g_rec_b4,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b4 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t229_cl USING g_tqp.tqp01
           IF STATUS THEN
              CALL cl_err("OPEN t229_cl:", STATUS, 1)
              CLOSE t229_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t229_cl INTO g_tqp.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_tqp.tqp01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t229_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b4 >= l_ac THEN
              LET p_cmd='u'
              LET g_tqt_t.* = g_tqt[l_ac].*  #BACKUP
              OPEN t229_b4_cl USING g_tqp.tqp01,g_tqt_t.tqt02
              IF STATUS THEN
                 CALL cl_err("OPEN t229_b4_cl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t229_b4_cl INTO g_tqt[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tqt_t.tqt02,SQLCA.sqlcode,0)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t229_tqt02(l_ac,g_tqt[l_ac].tqt02)
              END IF
              CALL cl_show_fld_cont()               #No.FUN-590083
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tqt[l_ac].* TO NULL      #900423
           LET g_tqt_t.* = g_tqt[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()               #No.FUN-590083
           NEXT FIELD tqt02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO tqt_file (tqt01,tqt02,
                                 tqtud01,tqtud02,tqtud03,
                                 tqtud04,tqtud05,tqtud06,
                                 tqtud07,tqtud08,tqtud09,
                                 tqtud10,tqtud11,tqtud12,
                                 tqtud13,tqtud14,tqtud15,
                                 tqtplant,tqtlegal #FUN-980009
                                )
           VALUES(g_tqp.tqp01,
                  g_tqt[l_ac].tqt02,
                  g_tqt[l_ac].tqtud01,
                  g_tqt[l_ac].tqtud02,
                  g_tqt[l_ac].tqtud03,
                  g_tqt[l_ac].tqtud04,
                  g_tqt[l_ac].tqtud05,
                  g_tqt[l_ac].tqtud06,
                  g_tqt[l_ac].tqtud07,
                  g_tqt[l_ac].tqtud08,
                  g_tqt[l_ac].tqtud09,
                  g_tqt[l_ac].tqtud10,
                  g_tqt[l_ac].tqtud11,
                  g_tqt[l_ac].tqtud12,
                  g_tqt[l_ac].tqtud13,
                  g_tqt[l_ac].tqtud14,
                  g_tqt[l_ac].tqtud15,
                  g_plant,g_legal          #FUN-980009
                 )
          
           IF SQLCA.sqlcode THEN
           #  CALL cl_err(g_tqt[l_ac].tqt02,SQLCA.sqlcode,0)   #No.FUN-660104
              CALL cl_err3("ins","tqt_file",g_tqt[l_ac].tqt02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK 
              LET g_rec_b4=g_rec_b4+1
              DISPLAY g_rec_b4 TO FORMONLY.cn4  
           END IF
 
 
        AFTER FIELD tqt02                        #check 代碼是否重復
           IF NOT cl_null(g_tqt[l_ac].tqt02) THEN
              IF g_tqt[l_ac].tqt02 != g_tqt_t.tqt02 
                 OR g_tqt_t.tqt02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM tqt_file
                  WHERE tqt01 = g_tqp.tqp01 
                    AND tqt02 = g_tqt[l_ac].tqt02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tqt[l_ac].tqt02 = g_tqt_t.tqt02
                    NEXT FIELD tqt02
                 END IF
                 LET SQLCA.sqlcode = '0'
                 CALL t229_tqt02(l_ac,g_tqt[l_ac].tqt02)
                 IF SQLCA.sqlcode OR g_errno THEN
                    LET g_tqt[l_ac].tqt02 = g_tqt_t.tqt02
                    CALL t229_tqt02(l_ac,g_tqt_t.tqt02)
                    NEXT FIELD tqt02
                 END IF
              END IF
           END IF
 
        AFTER FIELD tqtud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqtud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqtud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqtud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqtud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqtud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqtud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqtud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqtud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqtud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqtud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqtud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqtud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqtud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqtud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE" 
           IF g_tqt_t.tqt02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM tqt_file
               WHERE tqt01 = g_tqp.tqp01
                 AND tqt02 = g_tqt_t.tqt02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tqt_file",g_tqt_t.tqt02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                 ROLLBACK WORK
                 CANCEL DELETE 
              END IF
              LET g_rec_b4=g_rec_b4-1
              DISPLAY g_rec_b4 TO FORMONLY.cn4  
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_tqt[l_ac].* = g_tqt_t.*
              CLOSE t229_b4_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tqt[l_ac].tqt02,-263,0)
              LET g_tqt[l_ac].* = g_tqt_t.*
           ELSE
              UPDATE tqt_file SET tqt02=g_tqt[l_ac].tqt02,
                                  tqtud01 = g_tqt[l_ac].tqtud01,
                                  tqtud02 = g_tqt[l_ac].tqtud02,
                                  tqtud03 = g_tqt[l_ac].tqtud03,
                                  tqtud04 = g_tqt[l_ac].tqtud04,
                                  tqtud05 = g_tqt[l_ac].tqtud05,
                                  tqtud06 = g_tqt[l_ac].tqtud06,
                                  tqtud07 = g_tqt[l_ac].tqtud07,
                                  tqtud08 = g_tqt[l_ac].tqtud08,
                                  tqtud09 = g_tqt[l_ac].tqtud09,
                                  tqtud10 = g_tqt[l_ac].tqtud10,
                                  tqtud11 = g_tqt[l_ac].tqtud11,
                                  tqtud12 = g_tqt[l_ac].tqtud12,
                                  tqtud13 = g_tqt[l_ac].tqtud13,
                                  tqtud14 = g_tqt[l_ac].tqtud14,
                                  tqtud15 = g_tqt[l_ac].tqtud15
               WHERE tqt01=g_tqp.tqp01
                 AND tqt02=g_tqt_t.tqt02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","tqt_file",g_tqt[l_ac].tqt02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                 LET g_tqt[l_ac].* = g_tqt_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK 
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN 
                 LET g_tqt[l_ac].* = g_tqt_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_tqt.deleteElement(l_ac)
                 IF g_rec_b4 != 0 THEN
                    LET g_action_choice = "detail"
                    LET g_b_flag = '4'
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF 
              CLOSE t229_b4_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE t229_b4_cl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF l_ac > 1 THEN
              LET g_tqt[l_ac].* = g_tqt[l_ac-1].*
              NEXT FIELD tqt02
           END IF
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(tqt02)       #系列代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_tqt02"
           #     LET g_qryparam.arg1 =g_tqp.tqp05    #FUN-B30064-MARK
                 LET g_qryparam.default1 = g_tqt[l_ac].tqt02
###--FUN-B30064-MARK --BEGIN------
#                CALL cl_create_qry() RETURNING g_tqt[l_ac].tqt02
#                DISPLAY BY NAME g_tqt[l_ac].tqt02
#                NEXT FIELD tqt02
###--FUN-B30064-MARK ---END-------
###--FUN-B30064-ADD  --BEGIN------
                 IF p_cmd = 'a' THEN
                    LET g_qryparam.where = " tqaacti='Y' AND tqa01 =tqh02 AND tqh01 ='",g_tqp.tqp05,"'"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_multi_tqt02
                    IF NOT cl_null(g_multi_tqt02) THEN
                       CALL t229_multi_tqt02()
                       CALL t229_b4_fill(g_wc4)
                       CALL t229_b4()
                       EXIT INPUT
                    ELSE
                       NEXT FIELD tqt02
                    END IF
                 ELSE
                    LET g_qryparam.arg1 =g_tqp.tqp05
                    CALL cl_create_qry() RETURNING g_tqt[l_ac].tqt02
                    DISPLAY BY NAME g_tqt[l_ac].tqt02
                    NEXT FIELD tqt02
                 END IF
###--FUN-B30064-ADD  ---END-------
              OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
    END INPUT
 
    CLOSE t229_b4_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t229_b5()
DEFINE
    l_ac3_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680120 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN 
       RETURN
    END IF
 
    IF g_tqp.tqp01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_tqp.* FROM tqp_file
     WHERE tqp01=g_tqp.tqp01
 
    IF g_tqp.tqpacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_tqp.tqp01,'mfg1000',0)
       RETURN
    END IF
 
    IF g_tqp.tqp04 != '1' THEN   
       CALL cl_err('','atm-361',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tqu14,tqu02,tqu03,tqu04,tqu05,tqu07,",
                       "tqu06,'',tqu08,tqu09,tqu10,tqu11,'',tqu12,tqu13,tqu15,'' ",              #TQC-940096   
                       "  FROM tqu_file",                                                        #TQC-940096   
                       "  WHERE tqu01=? AND tqu14=? ",
                       " FOR UPDATE "  #TQC-940096  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t229_b5_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tqu WITHOUT DEFAULTS FROM s_tqu.*
          ATTRIBUTE(COUNT=g_rec_b5,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b5 != 0 THEN
              CALL fgl_set_arr_curr(l_ac3)
           END IF
           LET g_tqu13_t = NULL   #No.FUN-BB0086
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac3 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t229_cl USING g_tqp.tqp01
           IF STATUS THEN
              CALL cl_err("OPEN t229_cl:", STATUS, 1)
              CLOSE t229_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t229_cl INTO g_tqp.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_tqp.tqp01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t229_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b5 >= l_ac3 THEN
              LET p_cmd='u'
              LET g_tqu_t.* = g_tqu[l_ac3].*  #BACKUP
              LET g_tqu13_t = g_tqu[l_ac3].tqu13   #No.FUN-BB0086
              OPEN t229_b5_cl   USING g_tqp.tqp01,g_tqu_t.tqu14
              IF STATUS THEN
                 CALL cl_err("OPEN t229_b5_cl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t229_b5_cl INTO g_tqu[l_ac3].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tqu_t.tqu14,SQLCA.sqlcode,0)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT A.ima02,B.ima02,azf03   
                   INTO g_tqu[l_ac3].tqu06_ima02,g_tqu[l_ac3].tqu11_ima02,g_tqu[l_ac3].tqu15_azf03 
                   FROM ima_file A,ima_file B,azf_file 
                  WHERE A.ima01=g_tqu[l_ac3].tqu06  
                    AND B.ima01=g_tqu[l_ac3].tqu11  
                    AND azf01  =g_tqu[l_ac3].tqu15 
                    AND azf02  ='2'
              END IF
              CALL t229_set_entry_b5(p_cmd)
              CALL t229_set_no_entry_b5(p_cmd)
              CALL cl_show_fld_cont()               #No.FUN-590083
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tqu[l_ac3].* TO NULL      #900423
           LET g_tqu[l_ac3].tqu02 ='1'
           LET g_tqu[l_ac3].tqu07 ='1'
           LET g_tqu_t.* = g_tqu[l_ac3].*         #新輸入資料
           CALL cl_show_fld_cont()               #No.FUN-590083
           NEXT FIELD tqu14
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           #-----MOD-AA0137---------
           #INSERT INTO tqu_file (tqu01,tqu14,
           #                      tquplant,tqulegal) #FUN-980009
           #VALUES(g_tqp.tqp01,
           #       g_tqu[l_ac3].tqu14,
           #       g_plant,g_legal)         #FUN-980009
           INSERT INTO tqu_file (tqu01,tqu02,tqu03,tqu04,tqu05,tqu06,
                                 tqu07,tqu08,tqu09,tqu10,tqu11,tqu12,
                                 tqu13,tqu14,tqu15,tquplant,tqulegal)
            VALUES(g_tqp.tqp01,g_tqu[l_ac3].tqu02,g_tqu[l_ac3].tqu03,
                   g_tqu[l_ac3].tqu04,g_tqu[l_ac3].tqu05,g_tqu[l_ac3].tqu06,
                   g_tqu[l_ac3].tqu07,g_tqu[l_ac3].tqu08,g_tqu[l_ac3].tqu09,
                   g_tqu[l_ac3].tqu10,g_tqu[l_ac3].tqu11,g_tqu[l_ac3].tqu12,
                   g_tqu[l_ac3].tqu13,g_tqu[l_ac3].tqu14,g_tqu[l_ac3].tqu15,
                   g_plant,g_legal)
           #-----END MOD-AA0137-----
          
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tqu_file",g_tqu[l_ac3].tqu14,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK 
              LET g_rec_b5=g_rec_b5+1
              DISPLAY g_rec_b5 TO FORMONLY.cn5  
           END IF
      BEFORE FIELD tqu02
            CALL t229_set_entry_b5(p_cmd)
            
      AFTER FIELD tqu02
         IF NOT cl_null(g_tqu[l_ac3].tqu02) THEN
#           IF g_tqu[l_ac3].tqu02 != g_tqu_t.tqu02       #MOD-C30295 MARK 
#              OR g_tqu_t.tqu02 IS NULL THEN             #MOD-C30295 MARK
                  CALL t229_set_no_entry_b5(p_cmd)
#           END IF                                       #MOD-C30295 MARK
         END IF
               
      AFTER FIELD tqu03
         IF NOT cl_null(g_tqu[l_ac3].tqu03) THEN
            IF g_tqu[l_ac3].tqu03 != g_tqu_t.tqu03 
               OR g_tqu_t.tqu03 IS NULL THEN
               IF g_tqu[l_ac3].tqu02 ='1' THEN
                  CALL t229_tqu03()
                  IF g_errno THEN
                     CALL cl_err('',g_errno,1)
                     LET g_tqu[l_ac3].tqu03 =NULL
                     NEXT FIELD tqu03
                  END IF
               END IF
            END IF
         END IF 
      
      AFTER FIELD tqu04
         IF NOT cl_null(g_tqu[l_ac3].tqu04) THEN
            IF g_tqu[l_ac3].tqu04 != g_tqu_t.tqu04 
               OR g_tqu_t.tqu04 IS NULL THEN
               IF g_tqu[l_ac3].tqu02 ='1' THEN
                  CALL t229_tqu03()
                  IF g_errno THEN
                     CALL cl_err('',g_errno,1)
                     LET g_tqu[l_ac3].tqu04 =NULL
                     NEXT FIELD tqu04
                  END IF
               END IF
            END IF
         END IF 
         
      BEFORE FIELD tqu14                        #default 序號
         IF g_tqu[l_ac3].tqu14 IS NULL OR g_tqu[l_ac3].tqu14 = 0 THEN
            SELECT max(tqu14)+1 INTO g_tqu[l_ac3].tqu14
              FROM tqu_file
             WHERE tqu01 = g_tqp.tqp01
            IF g_tqu[l_ac3].tqu14 IS NULL THEN
               LET g_tqu[l_ac3].tqu14 = 1
            END IF
         END IF
 
      AFTER FIELD tqu14                        #check 序號是否重復
         IF NOT cl_null(g_tqu[l_ac3].tqu14) THEN
            IF g_tqu[l_ac3].tqu14 != g_tqu_t.tqu14 
               OR g_tqu_t.tqu14 IS NULL THEN
               SELECT count(*) INTO l_n FROM tqu_file
                WHERE tqu01 = g_tqp.tqp01 
                      AND tqu14 = g_tqu[l_ac3].tqu14
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_tqu[l_ac3].tqu14 = g_tqu_t.tqu14
                  NEXT FIELD tqu14
               END IF
            END IF
         END IF  
    
       AFTER FIELD tqu06
         IF NOT cl_null(g_tqu[l_ac3].tqu06) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_tqu[l_ac3].tqu06,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_tqu[l_ac3].tqu06= g_tqu_t.tqu06
               NEXT FIELD tqu06
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_tqu[l_ac3].tqu06 != g_tqu_t.tqu06 
               OR g_tqu_t.tqu06 IS NULL THEN
               SELECT ima02,ima31 INTO g_tqu[l_ac3].tqu06_ima02,g_tqu[l_ac3].tqu10 FROM ima_file
                WHERE ima01 = g_tqu[l_ac3].tqu06 
                  AND imaacti ='Y'
               IF SQLCA.sqlcode THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  LET g_tqu[l_ac3].tqu06 = g_tqu_t.tqu06
                  NEXT FIELD tqu06
               END IF
            END IF
         END IF         
 
      AFTER FIELD tqu08
         IF NOT cl_null(g_tqu[l_ac3].tqu08) THEN
            IF g_tqu[l_ac3].tqu08 != g_tqu_t.tqu08 
               OR g_tqu_t.tqu08 IS NULL THEN
               IF g_tqu[l_ac3].tqu08 <=0 THEN
                  CALL cl_err(g_tqu[l_ac3].tqu08,'afa-949',1)
                  LET g_tqu[l_ac3].tqu08 =NULL 
               END IF
               IF NOT cl_null(g_tqu[l_ac3].tqu09) THEN
                  IF g_tqu[l_ac3].tqu08 >=g_tqu[l_ac3].tqu09 THEN
                     CALL cl_err(g_tqu[l_ac3].tqu08,'aim-919',1)
                     LET g_tqu[l_ac3].tqu08 =NULL 
                     NEXT FIELD tqu08
                  END IF
               END IF
               CALL t229_tqu08()
               IF g_errno THEN
                  CALL cl_err('',g_errno,1)
                  LET g_tqu[l_ac3].tqu08 =NULL
                  NEXT FIELD tqu08
               END IF
            END IF
         END IF 
 
      AFTER FIELD tqu09
         IF NOT cl_null(g_tqu[l_ac3].tqu09) THEN
            IF g_tqu[l_ac3].tqu09 != g_tqu_t.tqu09 
               OR g_tqu_t.tqu09 IS NULL THEN
               IF g_tqu[l_ac3].tqu09 <=0 THEN
                  CALL cl_err(g_tqu[l_ac3].tqu09,'afa-949',1)
                  LET g_tqu[l_ac3].tqu09 =NULL 
               END IF
               IF NOT cl_null(g_tqu[l_ac3].tqu08) THEN
                  IF g_tqu[l_ac3].tqu08 >=g_tqu[l_ac3].tqu09 THEN
                     CALL cl_err(g_tqu[l_ac3].tqu09,'aim-919',1)
                     LET g_tqu[l_ac3].tqu09 =NULL 
                     NEXT FIELD tqu09
                  END IF
               END IF
               CALL t229_tqu08()
               IF g_errno THEN
                  CALL cl_err('',g_errno,1)
                  LET g_tqu[l_ac3].tqu09 =NULL
                  NEXT FIELD tqu09
               END IF
            END IF
         END IF 
 
       AFTER FIELD tqu11
         IF NOT cl_null(g_tqu[l_ac3].tqu11) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_tqu[l_ac3].tqu11,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_tqu[l_ac3].tqu11= g_tqu_t.tqu11
               NEXT FIELD tqu11
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_tqu[l_ac3].tqu11 != g_tqu_t.tqu11 
               OR g_tqu_t.tqu11 IS NULL THEN
               SELECT ima02,ima31 INTO g_tqu[l_ac3].tqu11_ima02,g_tqu[l_ac3].tqu13 FROM ima_file
                WHERE ima01 = g_tqu[l_ac3].tqu11 
                  AND imaacti ='Y'
               IF SQLCA.sqlcode THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  LET g_tqu[l_ac3].tqu11 = g_tqu_t.tqu11
                  NEXT FIELD tqu11
               END IF
               #No.FUN-BB0086--add--begin--
               IF NOT cl_null(g_tqu[l_ac].tqu12) AND g_tqu[l_ac].tqu12<>0 THEN  #FUN-C20068 
                  IF NOT t229_tqu12_check() THEN 
                     LET g_tqu13_t = g_tqu[l_ac].tqu13
                     NEXT FIELD tqu12
                  END IF 
               END IF                                                           #FUN-C20068
               LET g_tqu13_t = g_tqu[l_ac].tqu13
               #No.FUN-BB0086--add--end--
            END IF
         END IF   
 
       AFTER FIELD tqu12
          IF NOT t229_tqu12_check() THEN NEXT FIELD tqu12 END IF   #No.FUN-BB0086
          #No.FUN-BB0086--mark--begin--
          #IF NOT cl_null(g_tqu[l_ac3].tqu12) THEN
          #  IF g_tqu[l_ac3].tqu12 <=0 THEN
          #     CALL cl_err(g_tqu[l_ac3].tqu12,'apj-036',1)
          #     LET g_tqu[l_ac3].tqu12 =null
          #     NEXT FIELD tqu12
          #  END IF
          #END IF
          #No.FUN-BB0086--mark--end--
 
       AFTER FIELD tqu15
         IF NOT cl_null(g_tqu[l_ac3].tqu15) THEN
            IF g_tqu[l_ac3].tqu15 != g_tqu_t.tqu15 
               OR g_tqu_t.tqu15 IS NULL THEN
               SELECT azf03 INTO g_tqu[l_ac3].tqu15_azf03 FROM azf_file
                WHERE azf01 = g_tqu[l_ac3].tqu15
                  AND azf02 = '2'   #FUN-920186 
                  AND azfacti ='Y'
                  AND azf10 ='Y'
               IF SQLCA.sqlcode THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  LET g_tqu[l_ac3].tqu15 = g_tqu_t.tqu15
                  NEXT FIELD tqu15
               END IF
            END IF
         END IF   
                         
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE" 
           IF g_tqu_t.tqu14 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM tqu_file
               WHERE tqu01 = g_tqp.tqp01
                 AND tqu14 = g_tqu_t.tqu14
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tqu_file",g_tqu_t.tqu14,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                 ROLLBACK WORK
                 CANCEL DELETE 
              END IF
              LET g_rec_b5=g_rec_b5-1
              DISPLAY g_rec_b5 TO FORMONLY.cn5  
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_tqu[l_ac3].* = g_tqu_t.*
              CLOSE t229_b5_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tqu[l_ac3].tqu14,-263,0)
              LET g_tqu[l_ac3].* = g_tqu_t.*
           ELSE
              UPDATE tqu_file SET tqu14 =g_tqu[l_ac3].tqu14,tqu02=g_tqu[l_ac3].tqu02,tqu03=g_tqu[l_ac3].tqu03,
                                  tqu04 =g_tqu[l_ac3].tqu04,tqu05=g_tqu[l_ac3].tqu05,tqu07=g_tqu[l_ac3].tqu07,
                                  tqu06 =g_tqu[l_ac3].tqu06,tqu08=g_tqu[l_ac3].tqu08,tqu09=g_tqu[l_ac3].tqu09,
                                  tqu11 =g_tqu[l_ac3].tqu11,tqu12=g_tqu[l_ac3].tqu12,tqu15=g_tqu[l_ac3].tqu15,tqu13=g_tqu[l_ac3].tqu13 #MOD-C90096 add tqu13
               WHERE tqu01=g_tqp.tqp01
                 AND tqu14=g_tqu_t.tqu14
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","tqu_file",g_tqu[l_ac3].tqu14,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                 LET g_tqu[l_ac3].* = g_tqu_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK 
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac3 = ARR_CURR()
          #LET l_ac3_t = l_ac3  #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN 
                 LET g_tqu[l_ac3].* = g_tqu_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_tqu.deleteElement(l_ac3)
                 IF g_rec_b5 != 0 THEN
                    LET g_action_choice = "detail"
                    LET g_b_flag = '5'
                    LET l_ac3 = l_ac3_t
                 END IF
              #FUN-D30033--add--end----
              END IF 
              CLOSE t229_b5_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac3_t = l_ac3 #FUN-D30033 add
           CLOSE t229_b5_cl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF l_ac3 > 1 THEN
              LET g_tqu[l_ac3].* = g_tqu[l_ac3-1].*
              NEXT FIELD tqu14
           END IF
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(tqu06)      
#FUN-AA0059---------mod------------str----------------- 
#                CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_ima"
#                LET g_qryparam.default1 = g_tqu[l_ac3].tqu06
#                CALL cl_create_qry() RETURNING g_tqu[l_ac3].tqu06
                 CALL q_sel_ima(FALSE, "q_ima","",g_tqu[l_ac3].tqu06,"","","","","",'' ) 
                        RETURNING   g_tqu[l_ac3].tqu06
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_tqu[l_ac3].tqu06
                 NEXT FIELD tqu06
              WHEN INFIELD(tqu11)    
#FUN-AA0059---------mod------------str-----------------   
#                CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_ima"
#                LET g_qryparam.default1 = g_tqu[l_ac3].tqu11
#                CALL cl_create_qry() RETURNING g_tqu[l_ac3].tqu11
                 CALL q_sel_ima(FALSE, "q_ima","",g_tqu[l_ac3].tqu11,"","","","","",'' ) 
                        RETURNING   g_tqu[l_ac3].tqu11
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_tqu[l_ac3].tqu11
                 NEXT FIELD tqu11
              WHEN INFIELD(tqu15)       
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azf01a"
                 LET g_qryparam.arg1 ='3'
                 LET g_qryparam.where=" azf10='Y' "  #MOD-AC0045 
                 LET g_qryparam.default1 = g_tqu[l_ac3].tqu15
                 CALL cl_create_qry() RETURNING g_tqu[l_ac3].tqu15
                 DISPLAY BY NAME g_tqu[l_ac3].tqu15
                 NEXT FIELD tqu15
              OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
    END INPUT
 
    CLOSE t229_b5_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t229_tqt02(p_ac,p_key)
DEFINE p_ac    LIKE type_file.num5,          #No.FUN-680120 SMALLINT
       p_key   LIKE tqa_file.tqa01,
       l_tqa02 LIKE tqa_file.tqa02
DEFINE l_n     LIKE type_file.num5           #No.FUN-680120 SMALLINT
 
    LET g_errno =''
    SELECT count(*) INTO l_n FROM tqa_file
     WHERE tqa01 = p_key
       AND tqa03 = '3'
       AND tqaacti ='Y'
   
    IF l_n = 0 THEN
       CALL cl_err(p_key,'atm-374',0)
     END IF
 
 
    SELECT DISTINCT(tqa02) INTO l_tqa02 FROM tqa_file
     WHERE tqa01 = p_key
       AND tqa03 = '3'
       AND tqaacti ='Y'
 
 
    SELECT count(*) INTO l_n FROM tqh_file
     WHERE tqh01 =g_tqp.tqp05
       AND tqh02 =p_key
       AND tqhacti = 'Y'
 
    IF l_n = 0 THEN
       CALL cl_err(p_key,'atm-375',0)
       LET g_errno = '-100'
       LET l_tqa02 = NULL 
       RETURN
     END IF
 
    IF NOT SQLCA.sqlcode  THEN
       LET g_tqt[p_ac].tqt02_tqa02 = l_tqa02
    END IF
 
END FUNCTION
 
FUNCTION t229_tqs03(p_ac,p_key)
DEFINE p_ac    LIKE type_file.num5,             #No.FUN-680120 SMALLINT
       p_key   LIKE oaj_file.oaj01,
       l_oaj02 LIKE oaj_file.oaj02
 
    SELECT DISTINCT(oaj02) INTO l_oaj02 FROM oaj_file
     WHERE oaj01 = p_key
    IF NOT SQLCA.sqlcode THEN
       LET g_tqs[p_ac].tqs03_oaj02 = l_oaj02
    END IF
END FUNCTION
 
FUNCTION t229_b1_askkey()
DEFINE
    l_wc1           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc1 ON tqr02,tqr03,tqr04,tqr05
            FROM s_tqr[1].tqr02,s_tqr[1].tqr03,s_tqr[1].tqr04,
                 s_tqr[1].tqr05
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION controlg      #BUG-4C0121
        CALL cl_cmdask()     #BUG-4C0121
 
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL t229_b1_fill(l_wc1)
 
END FUNCTION
 
FUNCTION t229_b2_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON tqq02,tqq03,tqq04,tqq05
            FROM s_tqq[1].tqq02,s_tqq[1].tqq03,s_tqq[1].tqq04,
                 s_tqq[1].tqq05
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
                 
     ON ACTION controlp
         CASE
            WHEN INFIELD(tqq03) 
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.state = 'c'                                                                                      
                    LET g_qryparam.form ="q_occ3"
                    LET g_qryparam.arg1 = g_dbs                                                                                     
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                    DISPLAY g_qryparam.multiret TO tqq03                                                                            
                    NEXT FIELD tqq03  
            OTHERWISE EXIT CASE
          END CASE
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION controlg      #BUG-4C0121
        CALL cl_cmdask()     #BUG-4C0121
 
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL t229_b2_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t229_b3_askkey()
DEFINE
    l_wc3           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc3 ON tqs02,tqs03,tqs04,tqs05,tqs07,tqs08,tqs09
            FROM s_tqs[1].tqs02,s_tqs[1].tqs03,s_tqs[1].tqs04,
                 s_tqs[1].tqs05,s_tqs[1].tqs07,s_tqs[1].tqs08,s_tqs[1].tqs09
               
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
    ON ACTION controlp
         CASE
            WHEN INFIELD(tqs03) 
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.state = 'c'                                                                                      
                    LET g_qryparam.form ="q_tqs03"                                                                                  
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                    DISPLAY g_qryparam.multiret TO tqs03                                                                            
                    NEXT FIELD tqs03  
              WHEN INFIELD(tqs04)      
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c' 
                 LET g_qryparam.form ="q_azf01c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                 DISPLAY g_qryparam.multiret TO tqs04
                 NEXT FIELD tqs04
            OTHERWISE EXIT CASE
          END CASE
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION controlg      #BUG-4C0121
        CALL cl_cmdask()     #BUG-4C0121
 
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL t229_b3_fill(l_wc3)
 
END FUNCTION
 
FUNCTION t229_b4_askkey()
DEFINE
    l_wc4           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc4 ON tqt02
            FROM s_tqt[1].tqt02
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
               
    ON ACTION controlp
         CASE
           WHEN INFIELD(tqt02)             #門店代碼                                                                            
                CALL cl_init_qry_var()                                                                                          
                LET g_qryparam.state = 'c'                                                                                      
                LET g_qryparam.form ="q_tqt02"                                                                                  
                 LET g_qryparam.arg1 =g_tqp.tqp05
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                DISPLAY g_qryparam.multiret TO tqt02                                                                            
                NEXT FIELD tqt02 
            OTHERWISE EXIT CASE
          END CASE
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION controlg      #BUG-4C0121
        CALL cl_cmdask()     #BUG-4C0121
 
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL t229_b4_fill(l_wc4)
 
END FUNCTION
 
FUNCTION t229_b5_askkey()
DEFINE
    l_wc5           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc5 ON tqu14,tqu02,tqu03,tqu04,tqu05,tqu07,
                       tqu06,tqu08,tqu09,tqu10,tqu11,tqu12,tqu13,tqu15
            FROM s_tqu[1].tqu14,s_tqu[1].tqu02,s_tqu[1].tqu03,s_tqu[1].tqu04,
                 s_tqu[1].tqu05,s_tqu[1].tqu07,s_tqu[1].tqu06,s_tqu[1].tqu08,
                 s_tqu[1].tqu09,s_tqu[1].tqu10,s_tqu[1].tqu11,s_tqu[1].tqu12,
                 s_tqu[1].tqu13,s_tqu[1].tqu15
               
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(tqu06)      
#FUN-AA0059---------mod------------str----------------- 
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = 'c'
#               LET g_qryparam.form ="q_ima"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                DISPLAY g_qryparam.multiret TO tqu06
                DISPLAY BY NAME g_tqu[l_ac3].tqu06
                NEXT FIELD tqu06
             WHEN INFIELD(tqu11) 
#FUN-AA0059---------mod------------str-----------------      
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = 'c'
#               LET g_qryparam.form ="q_ima"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                DISPLAY g_qryparam.multiret TO tqu11
                NEXT FIELD tqu11
             WHEN INFIELD(tqu15)       
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azf01a"
                LET g_qryparam.arg1 ='3'
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                DISPLAY g_qryparam.multiret TO tqu15
                NEXT FIELD tqu15
             OTHERWISE EXIT CASE
           END CASE  
                   
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION controlg      #BUG-4C0121
        CALL cl_cmdask()     #BUG-4C0121
 
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL t229_b5_fill(l_wc5)
 
END FUNCTION
 
FUNCTION t229_b2_fill(p_wc2)    
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
    
    LET g_sql = "SELECT tqr09,tqr06,tqr07,tqr08,tqr02,tqr03,tqr04,tqr05,tqr10,azf03,",                  #No.FUN-820033
                "       tqrud01,tqrud02,tqrud03,tqrud04,tqrud05,",
                "       tqrud06,tqrud07,tqrud08,tqrud09,tqrud10,",
                "       tqrud11,tqrud12,tqrud13,tqrud14,tqrud15", 
                "  FROM tqr_file,azf_file ",                                            #No.FUN-820033
                " WHERE tqr01 ='",g_tqp.tqp01 CLIPPED,"' ",
                "   AND tqr10=azf_file.azf01",                                          #No.FUN-820033 #TQC-830054
                "   AND azf_file.azf02 ='2'"                                            #No.FUN-820033 #TQC-830054 
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY tqr02,tqr03,tqr04,tqr05 "
 
    PREPARE t229_pb2 FROM g_sql
    DECLARE tqr_cs CURSOR FOR t229_pb2
 
    CALL g_tqr.clear()
    LET g_cnt = 1
 
    FOREACH tqr_cs INTO g_tqr[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF 
    END FOREACH
    CALL g_tqr.deleteElement(g_cnt)
  
    LET g_rec_b2=g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t229_b1_fill(p_wc1)              #BODY FILL UP
   DEFINE p_wc1  LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
   LET g_sql = "SELECT tqq02,tqq06,tqq03,'',tqq04,'',",
               "       tqq05,'',",
               "       tqqud01,tqqud02,tqqud03,tqqud04,tqqud05,",
               "       tqqud06,tqqud07,tqqud08,tqqud09,tqqud10,",
               "       tqqud11,tqqud12,tqqud13,tqqud14,tqqud15", 
               "  FROM tqq_file",
               " WHERE tqq01 ='",g_tqp.tqp01 CLIPPED,"' "  
 
   IF NOT cl_null(p_wc1) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY tqq02 "
 
   PREPARE t229_pb1 FROM g_sql
   DECLARE tqq_cs CURSOR FOR t229_pb1
 
   CALL g_tqq.clear()
   LET g_cnt = 1
 
   FOREACH tqq_cs INTO g_tqq[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      CALL t229_tqq03(g_cnt,g_tqq[g_cnt].tqq03,'d')
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF 
   END FOREACH
   CALL g_tqq.deleteElement(g_cnt)
  
   LET g_rec_b1=g_cnt-1
   DISPLAY g_rec_b1 TO FORMONLY.cn1  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t229_b3_fill(p_wc3)              #BODY FILL UP
DEFINE
    p_wc3           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
    
    LET g_sql = "SELECT tqs02,tqs03,'',tqs06,tqs05,tqs07,tqs08,tqs09,tqs04,'', ",                  #No.FUN-820033
                "       tqsud01,tqsud02,tqsud03,tqsud04,tqsud05,",
                "       tqsud06,tqsud07,tqsud08,tqsud09,tqsud10,",
                "       tqsud11,tqsud12,tqsud13,tqsud14,tqsud15", 
                "  FROM tqs_file",
                " WHERE tqs01 ='",g_tqp.tqp01 CLIPPED,"' "  
 
    IF NOT cl_null(p_wc3) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc3 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY tqs02 "
 
    PREPARE t229_pb3 FROM g_sql
    DECLARE tqs_cs CURSOR FOR t229_pb3
 
    CALL g_tqs.clear()
    LET g_cnt = 1
 
    FOREACH tqs_cs INTO g_tqs[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      CALL t229_tqs03(g_cnt,g_tqs[g_cnt].tqs03)
      SELECT azf03 INTO g_tqs[g_cnt].tqs04_azf03 FROM azf_file
       WHERE azf01 =g_tqs[g_cnt].tqs04 AND azf02 ='2'
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF 
    END FOREACH
    CALL g_tqs.deleteElement(g_cnt)
  
    LET g_rec_b3=g_cnt-1
    DISPLAY g_rec_b3 TO FORMONLY.cn3  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t229_b4_fill(p_wc4)              #BODY FILL UP
DEFINE
    p_wc4           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
    
    LET g_sql = "SELECT tqt02,''",
                "       tqtud01,tqtud02,tqtud03,tqtud04,tqtud05,",
                "       tqtud06,tqtud07,tqtud08,tqtud09,tqtud10,",
                "       tqtud11,tqtud12,tqtud13,tqtud14,tqtud15", 
                "  FROM tqt_file",
                " WHERE tqt01 ='",g_tqp.tqp01 CLIPPED,"' "  
 
    IF NOT cl_null(p_wc4) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc4 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY tqt02 "
 
    PREPARE t229_pb4 FROM g_sql
    DECLARE tqt_cs CURSOR FOR t229_pb4
 
    CALL g_tqt.clear()
    LET g_cnt = 1
 
    FOREACH tqt_cs INTO g_tqt[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      CALL t229_tqt02(g_cnt,g_tqt[g_cnt].tqt02)
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF 
    END FOREACH
    CALL g_tqt.deleteElement(g_cnt)
  
    LET g_rec_b4=g_cnt-1
    DISPLAY g_rec_b4 TO FORMONLY.cn4  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t229_b5_fill(p_wc5)              #BODY FILL UP
DEFINE
    p_wc5           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
    
    LET g_sql = "SELECT tqu14,tqu02,tqu03,tqu04,tqu05,tqu07,",
                "tqu06,A.ima02,tqu08,tqu09,tqu10,tqu11,B.ima02,tqu12,tqu13,tqu15,azf03 ",
                "  FROM tqu_file,OUTER ima_file A,OUTER ima_file B,OUTER azf_file",
                " WHERE tqu01='",g_tqp.tqp01,"'",
                "   AND tqu_file.tqu06 = A.ima01 AND tqu_file.tqu11= B.ima01 AND tqu_file.tqu15 =azf_file.azf01 AND azf02 ='2'" 
 
    IF NOT cl_null(p_wc5) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc5 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY tqu14 "
 
    PREPARE t229_pb5 FROM g_sql
    DECLARE tqu_cs CURSOR FOR t229_pb5
 
    CALL g_tqu.clear()
    LET g_cnt = 1
 
    FOREACH tqu_cs INTO g_tqu[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF 
    END FOREACH
    CALL g_tqu.deleteElement(g_cnt)
  
    LET g_rec_b5=g_cnt-1
    DISPLAY g_rec_b5 TO FORMONLY.cn5  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t229_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #No.FUN-A40055--begin
   DIALOG ATTRIBUTES(UNBUFFERED)             
   DISPLAY ARRAY g_tqq TO s_tqq.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='1'
      BEFORE ROW
         #LET l_ac = ARR_CURR()
         LET l_ac = DIALOG.getCurrentRow("s_tqq")
         CALL cl_show_fld_cont()           
   END DISPLAY     
    
   DISPLAY ARRAY g_tqr TO s_tqr.* ATTRIBUTE(COUNT=g_rec_b2)
                                                                                 
      BEFORE DISPLAY     
          CALL cl_navigator_setting( g_curs_index, g_row_count )
          LET g_b_flag='2'  
#         EXIT DISPLAY   
      BEFORE ROW
         LET l_ac = DIALOG.getCurrentRow("s_tqr")
         CALL cl_show_fld_cont()   
   END DISPLAY     
   
   DISPLAY ARRAY g_tqs TO s_tqs.* ATTRIBUTE(COUNT=g_rec_b3)
 
      BEFORE DISPLAY       
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#         EXIT DISPLAY   
         LET g_b_flag='3'
      BEFORE ROW
         LET l_ac = DIALOG.getCurrentRow("s_tqs")
         CALL cl_show_fld_cont()   
   END DISPLAY       
     
   DISPLAY ARRAY g_tqu TO s_tqu.* ATTRIBUTE(COUNT=g_rec_b5)
 
      BEFORE DISPLAY   
         CALL cl_navigator_setting( g_curs_index, g_row_count )    
#         EXIT DISPLAY     
         LET g_b_flag='5'                                                                                         
      BEFORE ROW
         LET l_ac = DIALOG.getCurrentRow("s_tqu")
         CALL cl_show_fld_cont()   
   END DISPLAY        
       
   DISPLAY ARRAY g_tqt TO s_tqt.* ATTRIBUTE(COUNT=g_rec_b4)
      BEFORE DISPLAY       
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='4' 
      BEFORE ROW
         LET l_ac = DIALOG.getCurrentRow("s_tqt")
         CALL cl_show_fld_cont()             
   END DISPLAY     
 
      ##################################################################
      # Standard 4ad ACTION
      ##################################################################

      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
      ON ACTION first
         LET g_action_choice="first"
         EXIT DIALOG
      ON ACTION previous
         LET g_action_choice="previous"
         EXIT DIALOG
      ON ACTION jump
         LET g_action_choice="jump"
         EXIT DIALOG
      ON ACTION next
         LET g_action_choice="next"
         EXIT DIALOG
      ON ACTION last
         LET g_action_choice="last"
         EXIT DIALOG
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
      # 選擇客戶
      ON ACTION choose_cust
         LET g_action_choice="choose_cust"
         EXIT DIALOG
 
      #客戶
      ON ACTION Customer 
         LET g_action_choice="customer"
         LET l_ac = 1
         EXIT DIALOG
      #返利
      ON ACTION Discount
         LET g_action_choice="discount"
         LET l_ac = 1
         EXIT DIALOG
      #費用
      ON ACTION Expense
         LET g_action_choice="expense"
         LET l_ac = 1
         EXIT DIALOG
      ON ACTION Rebate
         LET g_action_choice="Rebate"
         LET l_ac = 1
         EXIT DIALOG
      #使用
      ON ACTION Using  
         LET g_action_choice="using"
         LET l_ac = 1
         EXIT DIALOG
      ON ACTION detail
         #LET g_action_choice="customer"
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()               #No.FUN-590083
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DIALOG
      #申請
      ON ACTION approving
         LET g_action_choice="approving"
         EXIT DIALOG
      #取消申請
      ON ACTION unapproving
         LET g_action_choice="unapproving"
         EXIT DIALOG
      #審核
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
      #取消審核
      ON ACTION notconfirm
         LET g_action_choice="notconfirm"
         EXIT DIALOG
       #結案
      ON ACTION mclose
         LET g_action_choice="mclose"
         EXIT DIALOG
      #取消結案
      ON ACTION notmclose
         LET g_action_choice="notmclose"
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON ACTION related_document               
         LET g_action_choice="related_document"          
         EXIT DIALOG

      #CHI-AB0028 add --start--
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
      #CHI-AB0028 add --end--
 
   END DIALOG 
   #No.FUN-A40055--begin
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t229_copy()
DEFINE
    l_newno         LIKE tqp_file.tqp01,
    l_oldno         LIKE tqp_file.tqp01
DEFINE li_result    LIKE type_file.num5                  #No.FUN-680120 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tqp.tqp01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE                                        
    CALL t229_set_entry('a')
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT l_newno FROM tqp01
    
      BEFORE INPUT
        CALL cl_set_docno_format("tqp01")
 
        AFTER FIELD tqp01
            #CALL s_check_no("axm",l_newno,"","00","tqp_file","tqp01","")  #FUN-A70130
            CALL s_check_no("atm",l_newno,"","U1","tqp_file","tqp01","")  #FUN-A70130
            RETURNING  li_result,l_newno                                                        
            DISPLAY l_newno TO tqp01  #TQC-940096                                                                                                 
            IF (NOT li_result) THEN                                                                                                 
               LET l_newno =NULL
               NEXT FIELD tqp01                                                                                                     
            END IF    
            
            BEGIN WORK 
            #CALL s_auto_assign_no("axm",l_newno,g_today,"00","tqp_file","tqp01","","","")  #FUN-A70130                                                    
            CALL s_auto_assign_no("atm",l_newno,g_today,"U1","tqp_file","tqp01","","","")  #FUN-A70130
              RETURNING li_result,l_newno
            IF (NOT li_result) THEN                                                                                                       
               ROLLBACK WORK              
               NEXT FIELD tqp01                                                                                                
            END IF   
 
            DISPLAY l_newno TO tqp01   
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(tqp01) #單據編號
                 LET g_t1=l_newno[1,g_doc_len]
                 CALL q_oay(FALSE,FALSE,g_t1,'U1','ATM') RETURNING g_t1  #TQC-670008   #FUN-A70130
                 LET l_newno=g_t1
                 DISPLAY BY NAME l_newno
                 NEXT FIELD tqp01
               OTHERWISE EXIT CASE
            END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION controlg      #BUG-4C0121
        CALL cl_cmdask()     #BUG-4C0121
 
    
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_tqp.tqp01 
       RETURN
    END IF
 
    DROP TABLE y
 
    SELECT * FROM tqp_file         #單頭復制
        WHERE tqp01=g_tqp.tqp01
        INTO TEMP y
 
    UPDATE y
        SET tqp01 =l_newno,    #新的鍵值
            tqpuser=g_user,   #資料所有者
            tqpgrup=g_grup,   #資料所有者所屬群
            tqpmodu=NULL,     #資料修改日期
            tqpdate=g_today,  #資料建立日期
            tqpacti='Y',      #有效資料
            tqp04 ='1'        #改為開立狀態
 
    INSERT INTO tqp_file
        SELECT * FROM y
 
    DROP TABLE x
 
    SELECT * FROM tqr_file         #單身復制
        WHERE tqr01=g_tqp.tqp01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","tqr_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
        RETURN
    END IF
 
    UPDATE x SET tqr01=l_newno
 
    INSERT INTO tqr_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tqr_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104         #FUN-B80061    ADD
        ROLLBACK WORK 
       # CALL cl_err3("ins","tqr_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104        #FUN-B80061    MARK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
        
    DROP TABLE x
 
    SELECT * FROM tqq_file         #單身復制
        WHERE tqq01=g_tqp.tqp01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","tqq_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
        RETURN
    END IF
 
    UPDATE x SET tqq01=l_newno
 
    INSERT INTO tqq_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
       
        CALL cl_err3("ins","tqq_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104          #FUN-B80061    ADD
        ROLLBACK WORK 
       # CALL cl_err3("ins","tqq_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104         #FUN-B80061    MARK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
   
    DROP TABLE x
 
    SELECT * FROM tqs_file         #單身復制
        WHERE tqs01=g_tqp.tqp01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","tqs_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
        RETURN
    END IF
 
    UPDATE x SET tqs01=l_newno
 
    INSERT INTO tqs_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tqs_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104          #FUN-B80061    ADD
        ROLLBACK WORK 
       # CALL cl_err3("ins","tqs_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104         #FUN-B80061    MARK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
    
    DROP TABLE x
 
    SELECT * FROM tqt_file         #單身復制
        WHERE tqt01=g_tqp.tqp01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","x",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
        RETURN
    END IF
 
    UPDATE x SET tqt01=l_newno
 
    INSERT INTO tqt_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tqt_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104         #FUN-B80061    ADD
        ROLLBACK WORK 
       # CALL cl_err3("ins","tqt_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104        #FUN-B80061    MARK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
    
    DROP TABLE x
 
    SELECT * FROM tqu_file         #單身復制
        WHERE tqu01=g_tqp.tqp01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","x",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
        RETURN
    END IF
 
    UPDATE x SET tqu01=l_newno
 
    INSERT INTO tqu_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tqu_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104            #FUN-B80061   ADD
        ROLLBACK WORK 
       # CALL cl_err3("ins","tqu_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104           #FUN-B80061   MARK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
    
   
     LET l_oldno = g_tqp.tqp01
     SELECT tqp_file.* INTO g_tqp.* FROM tqp_file WHERE tqp01 = l_newno
     CALL t229_u()
     CALL t229_b1()
     CALL t229_b2()
     CALL t229_b3()
     CALL t229_b4()
     CALL t229_b5()         #No.FUN-820033
     #SELECT tqp_file.* INTO g_tqp.* FROM tqp_file WHERE tqp01 = l_oldno  #FUN-C80046
     #CALL t229_show()  #FUN-C80046
 
END FUNCTION
 
 
FUNCTION t229_approving()
   IF g_tqp.tqp01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_tqp.tqpacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tqp.tqp01,'mfg1000',0)
      RETURN
   END IF
   IF g_tqp.tqp04 != '1' THEN
      CALL cl_err('','atm-221',0)  
      RETURN
   END IF
   IF NOT (cl_confirm('atm-232')) THEN
      RETURN
   END IF
   BEGIN WORK
   UPDATE tqp_file set tqp04 = '2'
    WHERE tqp01 = g_tqp.tqp01
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("upd","tqp_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","tqp04",1)   #No.FUN-660104
      ROLLBACK WORK
   ELSE
     COMMIT WORK
     LET g_tqp.tqp04 = '2'
     DISPLAY BY NAME g_tqp.tqp04
   END IF
   CALL t229_show()
END FUNCTION
 
FUNCTION t229_confirm()
   IF g_tqp.tqp01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
#CHI-C30107 -------------- add ------------- begin
   IF g_tqp.tqpacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tqp.tqp01,'mfg1000',0)
      RETURN
   END IF
   IF g_tqp.tqp04 != '2' THEN
      CALL cl_err('','atm-227',0)
      RETURN
   END IF
   IF NOT cl_confirm('aap-017') THEN
     RETURN
   END IF
   SELECT * INTO g_tqp.* FROM tqp_file WHERE tqp01 =  g_tqp.tqp01
#CHI-C30107 -------------- add ------------- end
   IF g_tqp.tqpacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tqp.tqp01,'mfg1000',0)
      RETURN
   END IF
   IF g_tqp.tqp04 != '2' THEN
      CALL cl_err('','atm-227',0)  
      RETURN
   END IF
#CHI-C30107 ------------- mark ----------- begin
#  IF NOT cl_confirm('aap-017') THEN
#    RETURN
#  END IF
#CHI-C30107 ------------- mark ----------- end
   BEGIN WORK
   UPDATE tqp_file set tqp04 = '3'
    WHERE tqp01 = g_tqp.tqp01
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("upd","tqp_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","tqp04",1)   #No.FUN-660104
      ROLLBACK WORK
   ELSE
     COMMIT WORK
     LET g_tqp.tqp04 = '3'
     DISPLAY BY NAME g_tqp.tqp04
   END IF
   CALL t229_show()
END FUNCTION
 
FUNCTION t229_notconfirm()
   DEFINE l_cnt  LIKE type_file.num5    #MOD-C30219 add
   IF g_tqp.tqp01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_tqp.tqpacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tqp.tqp01,'mfg1000',0)
      RETURN
   END IF
   IF g_tqp.tqp04 != '3' THEN
      CALL cl_err('','9025',0)  
      RETURN
   END IF
   #MOD-C30219 add begin ---
   SELECT COUNT(*) INTO l_cnt
     FROM oea_file 
    WHERE oea12 = g_tqp.tqp01
      AND oea11 = '3'
      AND oeaconf <> 'X'
   IF l_cnt > 0 THEN 
      CALL cl_err('','atm-907',0)
      RETURN
   END IF 
   #MOD-C30219 add end -----
   IF NOT (cl_confirm('aap-018')) THEN
      RETURN
   END IF
   BEGIN WORK
   UPDATE tqp_file set tqp04 = '2'
    WHERE tqp01 = g_tqp.tqp01
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("upd","tqp_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","tqp04",1)   #No.FUN-660104
      ROLLBACK WORK
   ELSE
     COMMIT WORK
     LET g_tqp.tqp04 = '2'
     DISPLAY BY NAME g_tqp.tqp04
   END IF
   CALL t229_show()
END FUNCTION
 
FUNCTION t229_unapproving()
   IF g_tqp.tqp01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_tqp.tqpacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tqp.tqp01,'mfg1000',0)
      RETURN
   END IF
   IF g_tqp.tqp04 != '2' THEN
      CALL cl_err('','atm-363',0)  
      RETURN
   END IF
   IF NOT (cl_confirm('atm-233')) THEN
      RETURN
   END IF
   BEGIN WORK
   UPDATE tqp_file set tqp04 = '1'
    WHERE tqp01 = g_tqp.tqp01
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("upd","tqp_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","tqp04",1)   #No.FUN-660104
      ROLLBACK WORK
   ELSE
     COMMIT WORK
     LET g_tqp.tqp04 = '1'
     DISPLAY BY NAME g_tqp.tqp04
   END IF
   CALL t229_show()
END FUNCTION
 
 
FUNCTION t229_mclose()
   IF g_tqp.tqp01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_tqp.tqpacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tqp.tqp01,'mfg1000',0)
      RETURN
   END IF
   IF g_tqp.tqp04 != '3' THEN
      CALL cl_err('','9026',0)  
      RETURN
   END IF
   IF NOT cl_confirm('amm-049') THEN
      RETURN
   END IF
   BEGIN WORK
   UPDATE tqp_file set tqp04 = '4'
    WHERE tqp01 = g_tqp.tqp01
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("upd","tqp_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","tqp04",1)   #No.FUN-660104
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      LET g_tqp.tqp04 = '4'
      DISPLAY BY NAME g_tqp.tqp04
   END IF
   CALL t229_show()
END FUNCTION
 
FUNCTION t229_notmclose()
   IF g_tqp.tqp01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_tqp.tqpacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tqp.tqp01,'mfg1000',0)
      RETURN
   END IF
   IF g_tqp.tqp04 != '4' THEN
      CALL cl_err('','atm-300',0)  
      RETURN
   END IF
   IF NOT cl_confirm('amm-050') THEN
      RETURN
   END IF
   BEGIN WORK
   UPDATE tqp_file set tqp04 = '3'
    WHERE tqp01 = g_tqp.tqp01
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("upd","tqp_file",g_tqp.tqp01,"",SQLCA.sqlcode,"","tqp04",1)   #No.FUN-660104
      ROLLBACK WORK
   ELSE
     COMMIT WORK
     LET g_tqp.tqp04 = '3'
     DISPLAY BY NAME g_tqp.tqp04
   END IF
   CALL t229_show()
END FUNCTION
 
FUNCTION t229_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("tqp01",TRUE)
    END IF 
 
END FUNCTION
 
FUNCTION t229_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("tqp01",FALSE) 
    END IF 
 
END FUNCTION
 
FUNCTION t229_set_entry_b3(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    CALL cl_set_comp_entry("tqs08,tqs09",TRUE) 
 
END FUNCTION
 
FUNCTION t229_set_no_entry_b3(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
     IF g_tqs[l_ac].tqs07 = '1'  THEN      #No.FUN-820033
         CALL cl_set_comp_entry("tqs08,tqs09",FALSE) 
         LET g_tqs[l_ac].tqs08 =NULL       #No.FUN-820033
     END IF 
 
END FUNCTION
 
FUNCTION t229_set_entry_b5(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    CALL cl_set_comp_entry("tqu05",TRUE) 
 
END FUNCTION
 
FUNCTION t229_set_no_entry_b5(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
     IF g_tqu[l_ac3].tqu02 = '1' THEN 
         CALL cl_set_comp_entry("tqu05",FALSE) 
         LET g_tqu[l_ac3].tqu05 =NULL
     END IF 
 
END FUNCTION
 
FUNCTION t229_set_entry_b2(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
  CALL cl_set_comp_entry("tqr02",TRUE)    
END FUNCTION
 
FUNCTION t229_set_no_entry_b2(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
     IF g_tqr[l_ac].tqr06 = '1' THEN 
         CALL cl_set_comp_entry("tqr02",FALSE) 
         LET g_tqr[l_ac].tqr02 =NULL   
     END IF 
 
END FUNCTION
 
FUNCTION t229_g_b1()
DEFINE l_occ         RECORD LIKE occ_file.*
DEFINE l_wc          LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(1000)
       l_plant       LIKE tqq_file.tqq03,          #No.FUN-680120 VARCHAR(10)
       l_dbs_new     LIKE type_file.chr21,         #No.FUN-680120 VARCHAR(21) 
       i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
       l_n           LIKE type_file.num5,          #No.FUN-680120 SMALLINT
       l_dbs         STRING  
DEFINE l_tqq      RECORD LIKE tqq_file.*
   IF cl_null(g_tqp.tqp01) THEN RETURN END IF
 
   SELECT * INTO g_tqp.* FROM tqp_file
    WHERE tqp01=g_tqp.tqp01
 
   IF g_tqp.tqp04 != '1' THEN
      CALL cl_err(g_tqp.tqp01,'atm-376',0)
      RETURN
   END IF
 
   LET l_plant = g_plant
 
   # QBE 查詢客戶編號
   OPEN WINDOW t229_g_b_w AT 4,24 WITH FORM "atm/42f/atmt229_1"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_locale("atmt229_1")
 
   INPUT l_plant WITHOUT DEFAULTS FROM azp01
 
      AFTER FIELD azp01
         IF NOT cl_null(l_plant) THEN
            SELECT azp03 INTO l_dbs_new
              FROM azp_file
             WHERE azp01=l_plant
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("sel","azp_file",l_plant,"","atm-377","","",1)   #No.FUN-660104
               NEXT FIELD azp01
            END IF
         END IF
 
      ON ACTION controlp
         CASE WHEN INFIELD(azp01)             #工廠別
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_azp"
              LET g_qryparam.default1 = l_plant
              CALL cl_create_qry() RETURNING l_plant
              DISPLAY l_plant TO azp01
              NEXT FIELD azp01
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION controlg      
         CALL cl_cmdask()     
      
      ON ACTION help          
         CALL cl_show_help()  
 
   END INPUT
 
   IF cl_null(l_plant) THEN
      LET l_plant = g_plant
   END IF
   SELECT azp03 INTO l_dbs_new FROM azp_file WHERE azp01=l_plant
   IF SQLCA.SQLCODE THEN
      LET l_dbs_new=g_dbs
   END IF
 
   CONSTRUCT BY NAME l_wc ON occ01,occ1007,occ1008
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
              WHEN INFIELD(occ01)  # 門店代碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_occ3"
                  LET g_qryparam.state = 'c'            #No.FUN-830054
                  LET g_qryparam.arg1 =l_dbs_new
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ01
              WHEN INFIELD(occ1007)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa1"
                  LET g_qryparam.state = 'c'            #No.FUN-830054
                  LET g_qryparam.arg1 ="10"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1007
                  NEXT FIELD occ1007
              WHEN INFIELD(occ1008)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa1"
                  LET g_qryparam.state = 'c'            #No.FUN-830054
                  LET g_qryparam.arg1 ="11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1008
                  NEXT FIELD occ1008
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
 
      ON ACTION help          #BUG-4C0121
         CALL cl_show_help()  #BUG-4C0121
 
      ON ACTION controlg      #BUG-4C0121
         CALL cl_cmdask()     #BUG-4C0121
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t229_g_b_w
      RETURN
   END IF
   IF cl_null(l_wc) THEN LET l_wc = " 1=1" END IF
 
 
   CLOSE WINDOW t229_g_b_w
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t229_cl USING g_tqp.tqp01
   IF STATUS THEN
      CALL cl_err("OPEN t229_cl.", STATUS, 1)
      CLOSE t229_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t229_cl INTO g_tqp.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tqp.tqp01,SQLCA.sqlcode,0)
      CLOSE t229_cl
      ROLLBACK WORK RETURN
   END IF
 
   CALL g_tqq.clear()
   LET l_dbs = l_dbs_new
   LET l_dbs=l_dbs.trimRight()                                                                                                    
   LET l_dbs = s_dbstring(l_dbs CLIPPED)   #FUN-9B0106
   #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"occ_file ",
   #            " WHERE ",l_dbs CLIPPED,"occ_file.occ1004='1'",  #No.TQC-810020
   #            "   AND ",l_dbs CLIPPED,"occ_file.occacti='Y'", 
   LET g_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'occ_file'),          #FUN-A50102
               " WHERE ",cl_get_target_table(l_plant,'occ_file'),".occ1004='1'",  #FUN-A50102
               "   AND ",cl_get_target_table(l_plant,'occ_file'),".occacti='Y'",  #FUN-A50102
               "   AND ",l_wc CLIPPED
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
   PREPARE occ_pre FROM g_sql
   DECLARE occ_curs CURSOR FOR occ_pre
 
   INITIALIZE l_occ.* TO NULL
   INITIALIZE l_tqq.* TO NULL
   LET l_tqq.tqq01 = g_tqp.tqp01
 
    FOREACH occ_curs INTO l_occ.*
      IF STATUS THEN CALL cl_err('occ_curs',SQLCA.sqlcode,0) EXIT FOREACH END IF
 
      LET l_tqq.tqq03 = l_occ.occ01 CLIPPED
      IF cl_null(l_tqq.tqq03) THEN
         CONTINUE FOREACH
      END IF
      SELECT COUNT(*) INTO l_n from tqq_file
       WHERE tqq01 =g_tqp.tqp01
         AND tqq03 =l_tqq.tqq03
      IF l_n > 0 THEN
         CONTINUE FOREACH
      END IF
         
 
      # 獲取序號
      SELECT MAX(tqq02)+1 INTO l_tqq.tqq02
        FROM tqq_file
       WHERE tqq01 = g_tqp.tqp01
      IF cl_null(l_tqq.tqq02) THEN
         LET l_tqq.tqq02 = 1
      END IF
      INSERT INTO tqq_file(tqq01,tqq02,tqq03,
                              tqq04,tqq05,tqq06,
                              tqqplant,tqqlegal)   #FUN-980009
                       VALUES(g_tqp.tqp01,l_tqq.tqq02,
                              l_tqq.tqq03,l_occ.occ1009,
                              l_occ.occ1010,l_plant,
                              g_plant,g_legal)     #FUN-980009
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","tqq_file",l_tqq.tqq02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         LET g_success='N'
         EXIT FOREACH
      END IF
   END FOREACH
 
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
   CALL t229_show()
 
END FUNCTION
 
FUNCTION t229_tqu03()
DEFINE  #l_sql           LIKE  type_file.chr1000
        l_sql           STRING     #NO.FUN-910082
DEFINE  l_tqu03_min     LIKE  tqu_file.tqu03
DEFINE  l_tqu04_max     LIKE  tqu_file.tqu04
DEFINE  l_tqu03         LIKE  tqu_file.tqu03
DEFINE  l_tqu04         LIKE  tqu_file.tqu04
DEFINE  l_n             LIKE  type_file.num5          #No.FUN-820033
 
        LET g_errno =NULL
        IF cl_null(g_tqu[l_ac3].tqu03) OR cl_null(g_tqu[l_ac3].tqu04) THEN
           RETURN 
        END IF
        IF g_tqu[l_ac3].tqu03 > g_tqu[l_ac3].tqu04 THEN
           LET g_errno ='aap-100'
           RETURN
        END IF
        LET l_sql = " SELECT tqu03,tqu04 FROM tqu_file ",     
                    "  WHERE tqu01 = '",g_tqp.tqp01,"'",
                    "    AND tqu02 = '1'",
                    "    AND tqu14 !='",g_tqu[l_ac3].tqu14,"'",
                    "  GROUP BY tqu03,tqu04  "
        PREPARE i229_precount1 FROM l_sql
        IF SQLCA.sqlcode THEN
           LET g_errno = SQLCA.sqlcode USING '-------' RETURN
        END IF
        DECLARE i229_count1 CURSOR FOR i229_precount1
 
        SELECT MIN(tqu03),MAX(tqu04) INTO l_tqu03_min,l_tqu04_max FROM tqu_file
         WHERE tqu01 = g_tqp.tqp01
           AND tqu02 = '1'
           AND tqu14<> g_tqu[l_ac3].tqu14
 
        IF cl_null(l_tqu03_min) AND cl_null(l_tqu04_max) THEN     #沒有日期邊界限制，就沒有必要再判斷了
           LET g_errno=NULL
           RETURN
        END IF
        IF cl_null(g_tqu[l_ac3].tqu04) THEN
           IF cl_null(l_tqu04_max) THEN
              SELECT COUNT(*) INTO l_n FROM tqu_file WHERE tqu03 =g_tqu[l_ac3].tqu03
              IF l_n >0  THEN   #單身第一筆資料無需做此判斷
#                 LET g_errno='apy-569'      #CHI-B40058
                 LET g_errno='atm-268'       #CHI-B40058
                 RETURN
              END IF
           ELSE
              IF g_tqu[l_ac3].tqu03 <=l_tqu04_max THEN             
#                 LET g_errno='apy-569'      #CHI-B40058
                 LET g_errno='atm-268'       #CHI-B40058
                 RETURN
              END IF                                          
           END IF
        ELSE
           FOREACH i229_count1 INTO l_tqu03,l_tqu04
             IF g_tqu[l_ac3].tqu04 < l_tqu03_min THEN
                  LET g_errno=null
                  RETURN
             END IF
             IF cl_null(l_tqu04) THEN
                LET l_tqu04 ='9999/12/30'
             END IF
             IF NOT(g_tqu[l_ac3].tqu04 < l_tqu03 OR g_tqu[l_ac3].tqu03 > l_tqu04) THEN
#                  LET g_errno='apy-569'     #CHI-B40058
                  LET g_errno='atm-268'      #CHI-B40058
                  RETURN
             END IF
           END FOREACH
        END IF
END FUNCTION
 
FUNCTION t229_tqu08()
DEFINE  #l_sql           LIKE  type_file.chr1000
        l_sql           STRING     #NO.FUN-910082
DEFINE  l_tqu08_min     LIKE  tqu_file.tqu08
DEFINE  l_tqu09_max     LIKE  tqu_file.tqu09
DEFINE  l_tqu08         LIKE  tqu_file.tqu08
DEFINE  l_tqu09         LIKE  tqu_file.tqu09
DEFINE  l_n             LIKE  type_file.num5          #No.FUN-820033
 
        LET g_errno =NULL
        IF cl_null(g_tqu[l_ac3].tqu08) OR cl_null(g_tqu[l_ac3].tqu09) THEN
           RETURN 
        END IF
        IF g_tqu[l_ac3].tqu08 > g_tqu[l_ac3].tqu09 THEN
           LET g_errno ='aim-919'
           RETURN
        END IF
        LET l_sql = " SELECT tqu08,tqu09 FROM tqu_file ",     
                    "  WHERE tqu01 = '",g_tqp.tqp01,"'",
                    "    AND tqu14 !='",g_tqu[l_ac3].tqu14,"'",
                    "  GROUP BY tqu08,tqu09  "
        PREPARE i229_precount2 FROM l_sql
        IF SQLCA.sqlcode THEN
           LET g_errno = SQLCA.sqlcode USING '-------' RETURN
        END IF
        DECLARE i229_count2 CURSOR FOR i229_precount2
 
        SELECT MIN(tqu08),MAX(tqu09) INTO l_tqu08_min,l_tqu09_max FROM tqu_file
         WHERE tqu01 = g_tqp.tqp01
           AND tqu14<> g_tqu[l_ac3].tqu14
 
        IF cl_null(l_tqu08_min) AND cl_null(l_tqu09_max) THEN     #沒有日期邊界限制，就沒有必要再判斷了
           LET g_errno=NULL
           RETURN
        END IF
        IF cl_null(g_tqu[l_ac3].tqu09) THEN
           IF cl_null(l_tqu09_max) THEN
              SELECT COUNT(*) INTO l_n FROM tqu_file WHERE tqu08 =g_tqu[l_ac3].tqu08
              IF l_n >0  THEN   #單身第一筆資料無需做此判斷
                 LET g_errno='axm-362'
                 RETURN
              END IF
           ELSE
              IF g_tqu[l_ac3].tqu08 <=l_tqu09_max THEN             
                 LET g_errno='axm-362'
                 RETURN
              END IF                                          
           END IF
        ELSE
           FOREACH i229_count2 INTO l_tqu08,l_tqu09
             IF g_tqu[l_ac3].tqu09 < l_tqu08_min THEN
                  LET g_errno=null
                  RETURN
             END IF
             IF cl_null(l_tqu09) THEN
                LET l_tqu09 ='99999999999999999999'
             END IF
             IF NOT(g_tqu[l_ac3].tqu09 < l_tqu08 OR g_tqu[l_ac3].tqu08 > l_tqu09) THEN
                  LET g_errno='axm-362'
                  RETURN
             END IF
           END FOREACH
        END IF
END FUNCTION
 
FUNCTION t229_tqr07()
DEFINE  #l_sql           LIKE  type_file.chr1000
        l_sql    STRING     #NO.FUN-910082
DEFINE  l_tqr07_min     LIKE  tqr_file.tqr07
DEFINE  l_tqr08_max     LIKE  tqr_file.tqr08
DEFINE  l_tqr07         LIKE  tqr_file.tqr07
DEFINE  l_tqr08         LIKE  tqr_file.tqr08
DEFINE  l_n             LIKE  type_file.num5          #No.FUN-820033
 
        LET g_errno =NULL
        IF cl_null(g_tqr[l_ac].tqr07) OR cl_null(g_tqr[l_ac].tqr08) THEN
           RETURN 
        END IF
        IF g_tqr[l_ac].tqr07 > g_tqr[l_ac].tqr08 THEN
           LET g_errno ='aap-100'
           RETURN
        END IF
        LET l_sql = " SELECT tqr07,tqr08 FROM tqr_file ",     
                    "  WHERE tqr01 = '",g_tqp.tqp01,"'",
                    "    AND tqr06 = '1'",
                    "    AND tqr09 !='",g_tqr[l_ac].tqr09,"'",
                    "  GROUP BY tqr07,tqr08  "
        PREPARE i229_precount3 FROM l_sql
        IF SQLCA.sqlcode THEN
           LET g_errno = SQLCA.sqlcode USING '-------' RETURN
        END IF
        DECLARE i229_count3 CURSOR FOR i229_precount3
 
        SELECT MIN(tqr07),MAX(tqr08) INTO l_tqr07_min,l_tqr08_max FROM tqr_file
         WHERE tqr01 = g_tqp.tqp01
           AND tqr06 = '1'
           AND tqr09<> g_tqr[l_ac].tqr09
 
        IF cl_null(l_tqr07_min) AND cl_null(l_tqr08_max) THEN     #沒有日期邊界限制，就沒有必要再判斷了
           LET g_errno=NULL
           RETURN
        END IF
        IF cl_null(g_tqr[l_ac].tqr08) THEN
           IF cl_null(l_tqr08_max) THEN
              SELECT COUNT(*) INTO l_n FROM tqr_file WHERE tqr07 =g_tqr[l_ac].tqr07
              IF l_n >0  THEN   #單身第一筆資料無需做此判斷
#                 LET g_errno='apy-569'    #CHI-B40058
                 LET g_errno='atm-268'     #CHI-B40058
                 RETURN
              END IF
           ELSE
              IF g_tqr[l_ac].tqr07 <=l_tqr08_max THEN             
#                 LET g_errno='apy-569'    #CHI-B40058
                 LET g_errno='atm-268'     #CHI-B40058
                 RETURN
              END IF                                          
           END IF
        ELSE
           FOREACH i229_count3 INTO l_tqr07,l_tqr08
             IF g_tqr[l_ac].tqr08 < l_tqr07_min THEN
                  LET g_errno=null
                  RETURN
             END IF
             IF cl_null(l_tqr08) THEN
                LET l_tqr08 ='9999/12/30'
             END IF
             IF NOT(g_tqr[l_ac].tqr08 < l_tqr07 OR g_tqr[l_ac].tqr07 > l_tqr08) THEN
#                  LET g_errno='apy-569'    #CHI-B40058
                  LET g_errno='atm-268'     #CHI-B40058
                  RETURN
             END IF
           END FOREACH
        END IF
END FUNCTION
##--FUN-B30064-- -ADD ---BEGIN-----------------------------------
###批次錄入###
FUNCTION t229_multi_tqt02()
DEFINE   tok         base.StringTokenizer
DEFINE   l_sql       STRING
DEFINE   l_n         LIKE type_file.num5
DEFINE   l_tqt       RECORD LIKE tqt_file.*
DEFINE   l_success   LIKE type_file.chr1

   BEGIN WORK
   LET l_success = 'Y'
   LET l_n = 0
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_tqt02,"|")
   WHILE tok.hasMoreTokens()
      INITIALIZE l_tqt.* TO NULL
      LET l_tqt.tqt02 = tok.nextToken()
      SELECT count(*) INTO l_n FROM tqt_file
       WHERE tqt01 = g_tqp.tqp01
         AND tqt02 = l_tqt.tqt02
      IF l_n > 0 THEN
         CONTINUE WHILE
      ELSE
         SELECT DISTINCT(tqa02) FROM tqa_file
          WHERE tqa01 = l_tqt.tqt02
            AND tqa03 = '3'
            AND tqaacti ='Y'
         IF SQLCA.sqlcode = 100 THEN
            CALL s_errmsg('',l_tqt.tqt02,'tqa_file','atm-374',1)
            LET l_success = 'N'
            CONTINUE WHILE
         END IF 
         SELECT count(*) INTO l_n FROM tqh_file
          WHERE tqh01 = g_tqp.tqp05
            AND tqh02 = l_tqt.tqt02
            AND tqhacti = 'Y'
         IF l_n = 0 THEN
            CALL s_errmsg('',l_tqt.tqt02,'tqh_file','atm-375',1)
            LET l_success = 'N'
            CONTINUE WHILE
         END IF
         LET l_tqt.tqt01 = g_tqp.tqp01
         LET l_tqt.tqtplant = g_plant
         LET l_tqt.tqtlegal = g_legal
         INSERT INTO tqt_file VALUES(l_tqt.*)
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('',l_tqt.tqt02,'Ins tqt_file',SQLCA.sqlcode,1)
            LET l_success = 'N'
            CONTINUE WHILE
         END IF
      END IF
   END WHILE
   IF l_success <> 'Y' THEN 
      CALL s_showmsg()
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
END FUNCTION
##--FUN-B30064-- -ADD ----END------------------------------------
# No.FUN-9C0073 -----------------By chenls 10/01/08

#No.FUN-BB0086---add---begin---
FUNCTION t229_tqu12_check()
   IF NOT cl_null(g_tqu[l_ac].tqu12) AND NOT cl_null(g_tqu[l_ac].tqu13) THEN
      IF cl_null(g_tqu[l_ac].tqu12) OR cl_null(g_tqu13_t) OR g_tqu_t.tqu12 != g_tqu[l_ac].tqu12 OR g_tqu13_t != g_tqu[l_ac].tqu13 THEN
         LET g_tqu[l_ac].tqu12=s_digqty(g_tqu[l_ac].tqu12,g_tqu[l_ac].tqu13)
         DISPLAY BY NAME g_tqu[l_ac].tqu12
      END IF
   END IF
   IF NOT cl_null(g_tqu[l_ac3].tqu12) THEN
      IF g_tqu[l_ac3].tqu12 <=0 THEN
         CALL cl_err(g_tqu[l_ac3].tqu12,'apj-036',1)
         LET g_tqu[l_ac3].tqu12 =NULL 
         RETURN FALSE 
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086---add---end---
