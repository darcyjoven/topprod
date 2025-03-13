# Prog. Version..: '5.30.06-13.03.22(00009)'     #
# Pattern name...: almt595_sub.4gl
# Descriptions...: 出貨單過帳&過帳還原&杂发过账
# Date & Author..: No:FUN-C30257 12/03/28 by pauline
# Modify.........: No.FUN-C50085 12/05/28 By pauline 多稅別設定修改
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52 
# Modify.........: No:MOD-C80258 12/08/31 By pauline 過帳完成後,g_prog值錯誤
# Modify.........: No:FUN-C80107 12/09/19 By suncx 增可按倉庫進行負庫存判斷
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modfiy.........: No.FUN-CB0087 12/12/20 By xianghui 庫存理由碼改善,xujing:inb_file
# Modify.........: No:FUN-D30024 13/03/13 By lixh1 負庫存依據imd23判斷
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 


DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_lrj           RECORD LIKE lrj_file.*
DEFINE g_oga           RECORD LIKE oga_file.*
DEFINE g_ogb           RECORD LIKE ogb_file.*
DEFINE g_ina           RECORD LIKE ina_file.*
DEFINE g_inb           RECORD LIKE inb_file.*
DEFINE g_sma           RECORD LIKE sma_file.*
DEFINE g_oaz           RECORD LIKE oaz_file.*
DEFINE g_sql           STRING
DEFINE g_forupd_sql    STRING
DEFINE g_argv0         LIKE type_file.chr1
DEFINE g_argv1         LIKE oga_file.oga01
DEFINE g_argv2         LIKE oga_file.oga01
DEFINE g_plant2        LIKE azw_file.azw01
DEFINE g_ima25         LIKE ima_file.ima25
DEFINE g_ima86         LIKE ima_file.ima86
DEFINE g_ima906        LIKE ima_file.ima906
DEFINE l_azp03         LIKE azp_file.azp03
DEFINE g_flag          LIKE type_file.chr1
DEFINE g_cnt           LIKE type_file.num5
DEFINE g_unit_arr      DYNAMIC ARRAY OF RECORD
                        unit   LIKE ima_file.ima25,
                        fac    LIKE img_file.img21,
                        qty    LIKE img_file.img10
                       END RECORD
DEFINE g_prog_o        LIKE type_file.chr20   #MOD-C80258 add
#DEFINE g_sma894       LIKE    type_file.chr1  #FUN-C80107   #FUN-D30024 mark 
DEFINE g_imd23         LIKE imd_file.imd23    #FUN-D30024

#生成出貨單
FUNCTION t595_ins_oga(p_no)
 DEFINE p_no        LIKE lrj_file.lrj01 
 DEFINE l_sql       STRING
 DEFINE l_rtz06     LIKE rtz_file.rtz06
 DEFINE l_occ02     LIKE occ_file.occ02
 DEFINE l_occ42     LIKE occ_file.occ42
 DEFINE l_occ41     LIKE occ_file.occ41
 DEFINE l_occ08     LIKE occ_file.occ08
 DEFINE l_occ44     LIKE occ_file.occ44
 DEFINE l_occ45     LIKE occ_file.occ45
 DEFINE l_occ68     LIKE occ_file.occ68
 DEFINE l_occ69     LIKE occ_file.occ69
 DEFINE l_occ67     LIKE occ_file.occ67
 DEFINE l_occ43     LIKE occ_file.occ43
 DEFINE l_occ47     LIKE occ_file.occ47
 DEFINE l_occ48     LIKE occ_file.occ48
 DEFINE l_occ49     LIKE occ_file.occ49
 DEFINE l_occ50     LIKE occ_file.occ50
 DEFINE l_occ65     LIKE occ_file.occ65
 DEFINE l_occ71     LIKE occ_file.occ71
 DEFINE l_gec04     LIKE gec_file.gec04
 DEFINE l_gec05     LIKE gec_file.gec05
 DEFINE l_gec07     LIKE gec_file.gec07
 DEFINE li_result   LIKE type_file.num5
 DEFINE l_n         LIKE type_file.num5

    IF cl_null(p_no) THEN RETURN '' END IF
    SELECT * INTO g_lrj.* FROM lrj_file WHERE lrj01=p_no
    
    SELECT rtz06 INTO l_rtz06 FROM rtz_file
     WHERE rtz01 = g_lrj.lrjplant
    IF cl_null(l_rtz06) THEN
       CALL s_errmsg('rtz06',g_lrj.lrjplant,'rtz06','',1)
       LET g_success = 'N'
       RETURN ''
    END IF
    
    SELECT occ02,occ42,occ41,occ08,occ44,occ45,occ68,occ69,occ67,occ43,occ71,occ65
      INTO l_occ02,l_occ42,l_occ41,l_occ08,l_occ44,l_occ45,l_occ68,l_occ69,l_occ67,l_occ43,l_occ71,l_occ65,l_occ65
      FROM occ_file
     WHERE occ01 = l_rtz06

    CALL t595_sys()  #取系統參數

    #產生出貨單頭
    LET g_oga.oga00   = '1'              #出貨別
    LET g_oga.oga01   = g_oga.oga01      #出貨單號
    LET g_oga.oga011  = NULL             #出貨通知單號
    LET g_oga.oga02   = g_today          #出貨日期
    LET g_oga.oga021  = NULL             #結關日期
    LET g_oga.oga022  = NULL             #裝船日期
    LET g_oga.oga03   = l_rtz06          #帳款客戶編號
    LET g_oga.oga032  = l_occ02          #帳款客戶簡稱
    LET g_oga.oga033  = NULL             #帳款客戶稅號
    LET g_oga.oga04   = l_rtz06          #送貨客戶編號
    LET g_oga.oga044  = NULL             #送貨地址碼
    LET g_oga.oga05   = l_occ08          #發票別
    LET g_oga.oga06   = 0                #更改版本
    LET g_oga.oga07   = NULL             #出貨是否計入未開發票的銷貨待驗收入
    LET g_oga.oga08   = '1'              #1.內銷 2.外銷  3.視同外銷
    LET g_oga.oga09   = '2'              #單據別
    LET g_oga.oga10   = NULL             #帳單編號
    LET g_oga.oga11   = NULL             #應收款日
    LET g_oga.oga12   = NULL             #容許票據到期日
    LET g_oga.oga13   = NULL             #科目分類碼
    LET g_oga.oga14   = g_user           #人員編號
    LET g_oga.oga15   = g_grup           #部門編號
    LET g_oga.oga16   = NULL             #訂單單號
    LET g_oga.oga161  = 0                #訂金應收比率
    LET g_oga.oga162  = 100              #出貨應收比率
    LET g_oga.oga163  = 0                #尾款應收比率
    LET g_oga.oga17   = NULL             #排貨模擬順序
    LET g_oga.oga18   = l_rtz06          #收款客戶編號
    LET g_oga.oga19   = NULL             #待抵帳款-預收單號
    LET g_oga.oga20   = 'Y'              #分錄底稿是否可重新生成
    LET g_oga.oga21   = l_occ41          #稅種
    SELECT gec04,gec05,gec07 INTO l_gec04,l_gec05,l_gec07
      FROM gec_file
     WHERE gec01 = g_oga.oga21
       AND gec011= '2'
    LET g_oga.oga211  = l_gec04          #稅率
    LET g_oga.oga212  = l_gec05          #聯數
    LET g_oga.oga213  = l_gec07          #含稅否
    LET g_oga.oga23   = l_occ42          #幣種
    LET g_oga.oga24   = 1                #匯率
    LET g_oga.oga25   = l_occ43          #銷售分類一
    LET g_oga.oga26   = NULL             #銷售分類二
    LET g_oga.oga27   = NULL             #Invoice No.
    LET g_oga.oga28   = NULL             #立帳時採用訂單匯率
    LET g_oga.oga29   = NULL             #信用額度餘額
    LET g_oga.oga30   = 'N'              #包裝單審核碼
    LET g_oga.oga31   = l_occ44          #價格條件編號
    LET g_oga.oga32   = l_occ45          #收款條件編號
    LET g_oga.oga33   = NULL             #其它條件
    LET g_oga.oga34   = NULL             #佣金率
    LET g_oga.oga35   = NULL             #外銷方式
    LET g_oga.oga36   = NULL             #非經海關証明文件名稱
    LET g_oga.oga37   = NULL             #非經海關証明文件號碼
    LET g_oga.oga38   = NULL             #出口報單類型
    LET g_oga.oga39   = NULL             #出口報單號碼
    LET g_oga.oga40   = NULL             #NOTIFY
    LET g_oga.oga41   = l_occ48          #起運地
    LET g_oga.oga42   = l_occ49          #到達地
    LET g_oga.oga43   = l_occ47          #交運方式
    LET g_oga.oga44   = NULL             #嘜頭編號
    LET g_oga.oga45   = NULL             #聯絡人
    LET g_oga.oga46   = NULL             #項目編號
    LET g_oga.oga47   = NULL             #船名/車號
    LET g_oga.oga48   = NULL             #航次
    LET g_oga.oga49   = l_occ50          #卸貨港
    LET g_oga.oga50   = 0                #原幣出貨金額
    LET g_oga.oga501  = 0                #本幣出貨金額
    LET g_oga.oga51   = 0                #原幣出貨金額
    LET g_oga.oga511  = 0                #本幣出貨金額
    LET g_oga.oga52   = 0                #原幣預收訂金轉銷貨收入金額
    LET g_oga.oga53   = 0                #原幣應開發票稅前金額
    LET g_oga.oga54   = 0                #原幣已開發票稅前金額
    LET g_oga.oga99   = NULL             #多角貿易流程序號
    LET g_oga.oga901  = ' '              #post to abx system flag
    LET g_oga.oga902  = NULL             #信用超限留置代碼
    LET g_oga.oga903  = 'Y'              #信用檢查放行否
    LET g_oga.oga904  = NULL             #No Use
    LET g_oga.oga905  = ' '              #已轉三角貿易出貨單否
    LET g_oga.oga906  = ' '              #起始出貨單否
    LET g_oga.oga907  = NULL             #憑証號碼
    LET g_oga.oga908  = NULL             #L/C NO
    LET g_oga.oga909  = 'N'              #三角貿易否
    LET g_oga.oga910  = NULL             #境外倉庫
    LET g_oga.oga911  = NULL             #境外庫位
    LET g_oga.ogaconf = 'Y'              #審核否/作廢碼
    LET g_oga.ogapost = 'N'              #出貨扣帳否
    LET g_oga.ogaprsw = 0                #打印次數
    LET g_oga.ogauser = g_user           #資料所有者
    LET g_oga.ogagrup = g_plant          #資料所有部門
    LET g_oga.ogamodu = NULL             #資料更改者
    LET g_oga.ogadate = g_today          #最近更改日
    LET g_oga.oga55   = '1'              #狀況碼
    LET g_oga.ogamksg = 'N'              #簽核
    LET g_oga.oga65   = 'N' #l_occ65          #客戶出貨簽收否
    LET g_oga.oga66   = NULL             #出貨簽收在途/驗退倉庫
    LET g_oga.oga67   = NULL             #出貨簽收在途/驗退庫位
    LET g_oga.oga1001 = NULL             #收款客戶編號
    LET g_oga.oga1002 = NULL             #債權代碼
    LET g_oga.oga1003 = NULL             #業績歸屬方
    LET g_oga.oga1004 = NULL             #調貨客戶
    LET g_oga.oga1005 = NULL             #是否計算業績
    LET g_oga.oga1006 = NULL             #折扣金額(稅前)
    LET g_oga.oga1007 = NULL             #折扣金額(含稅)
    LET g_oga.oga1008 = NULL              #出貨總含稅金額
    LET g_oga.oga1009 = NULL             #客戶所屬渠道
    LET g_oga.oga1010 = NULL             #客戶所屬方
    LET g_oga.oga1011 = NULL             #開票客戶
    LET g_oga.oga1012 = NULL             #銷退單單號
    LET g_oga.oga1013 = ' '              #已打印提單否
    LET g_oga.oga1014 = 'N'              #調貨銷退單所自動生成否
    LET g_oga.oga1015 = '0'              #導物流狀況碼
    LET g_oga.oga1016 = NULL             #代送商
    LET g_oga.oga68   = NULL             #No Use
    LET g_oga.ogaspc  = 0                #SPC拋轉碼 0/1/2
    LET g_oga.oga69   = g_today          #錄入日期
    LET g_oga.oga912  = NULL             #保稅異動原因代碼
    LET g_oga.oga913  = NULL             #保稅報單日期
    LET g_oga.oga914  = NULL             #入庫單號
    LET g_oga.oga70   = NULL             #調撥單號
    LET g_oga.ogaud01 = NULL             #自訂欄位-Textedit
    LET g_oga.ogaud02 = NULL             #自訂欄位-文字
    LET g_oga.ogaud03 = NULL             #自訂欄位-文字
    LET g_oga.ogaud04 = NULL             #自訂欄位-文字
    LET g_oga.ogaud05 = NULL             #自訂欄位-文字
    LET g_oga.ogaud06 = NULL             #自訂欄位-文字
    LET g_oga.ogaud07 = NULL             #自訂欄位-數值
    LET g_oga.ogaud08 = NULL             #自訂欄位-數值
    LET g_oga.ogaud09 = NULL             #自訂欄位-數值
    LET g_oga.ogaud10 = NULL             #自訂欄位-整數
    LET g_oga.ogaud11 = NULL             #自訂欄位-整數
    LET g_oga.ogaud12 = NULL             #自訂欄位-整數
    LET g_oga.ogaud13 = NULL             #自訂欄位-日期
    LET g_oga.ogaud14 = NULL             #自訂欄位-日期
    LET g_oga.ogaud15 = NULL             #自訂欄位-日期
    LET g_oga.ogaplant=g_plant           #所屬工廠  #出货端的工厂
    LET g_oga.ogalegal=g_legal           #所屬法人  #出货端的工厂
    LET g_oga.oga83   =g_plant           #銷貨機構
    LET g_oga.oga84   =g_plant           #取貨機構
    LET g_oga.oga85   =l_occ71           #結算方式
    LET g_oga.oga86   =NULL              #客層代碼
    LET g_oga.oga87   =NULL              #會員卡號
    LET g_oga.oga88   =NULL              #顧客姓名
    LET g_oga.oga89   =NULL              #聯系電話
    LET g_oga.oga90   =NULL              #證件類型
    LET g_oga.oga91   =NULL              #證件號碼
    LET g_oga.oga92   =NULL              #贈品發放單號
    LET g_oga.oga93   =NULL              #返券發放單號
    LET g_oga.oga94   ='N'               #POS銷售否 Y-是,N-否
    LET g_oga.oga95   =0                 #本次積分  #carrier
    LET g_oga.oga96   =NULL              #收銀機號
    LET g_oga.oga97   =NULL              #交易序號
    LET g_oga.ogacond =g_today           #審核日期
    LET g_oga.ogacont =TIME              #審核日期
    LET g_oga.ogaconu =g_user            #審核人員
    LET g_oga.ogaoriu =g_user            #資料建立者
    LET g_oga.ogaorig =g_grup            #資料建立部門
    LET g_oga.oga71   = NULL             #申報統編
    LET g_oga.oga57   = '1'              #

    CALL t595_sel_rye('1') RETURNING g_oga.oga01
    IF cl_null(g_oga.oga01) THEN
       LET g_success = 'N'
       RETURN ''
    END IF
   
    CALL s_auto_assign_no("axm",g_oga.oga01,g_oga.oga02,"","oga_file","oga01","","","")
         RETURNING li_result,g_oga.oga01
    IF (NOT li_result) THEN
       LET g_success="N"
       CALL s_errmsg('oga01',g_oga.oga01,'oga_file','asf-377',1)
       RETURN ''
    END IF

    #產生出貨單身    
    LET g_prog_o = g_prog   #MOD-C80258 add   #利用g_prog_o 紀錄原本g_prog值
    LET g_prog = 'axmt620'
    CALL t595_ins_ogb()   
   #LET g_prog = 'almt595'  #MOD-C80258 mark 
    LET g_prog = g_prog_o   #MOD-C80258 add 
    IF g_success = 'N' THEN
       RETURN ''
    END IF

    LET g_oga.oga501 = g_oga.oga50*g_oga.oga24
    LET g_oga.oga511 = g_oga.oga51*g_oga.oga24
    
    INSERT INTO oga_file VALUES(g_oga.*)
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('','',g_oga.oga01,SQLCA.sqlcode,1)
       LET g_success="N"
       RETURN ''
    END IF

   #出貨單單身若為空,則將單頭刪除不需進行剩下步驟
    SELECT COUNT(*) INTO l_n FROM ogb_file
       WHERE ogb01 = g_oga.oga01 AND ogbplant = g_lrj.lrjplant 
    IF l_n = 0 OR cl_null(l_n) THEN
       DELETE FROM oga_file 
          WHERE oga01 = g_oga.oga01 
       RETURN ' '                      
    END IF
    
    IF g_success = 'Y' THEN
       CALL t595_oga_post(g_oga.oga01,g_lrj.lrjplant)
    END IF
    RETURN g_oga.oga01
END FUNCTION

#產生出貨單身
FUNCTION t595_ins_ogb()   
 DEFINE l_fac       LIKE pmn_file.pmn09
 DEFINE l_img09     LIKE img_file.img09
 DEFINE l_ogbi      RECORD LIKE ogbi_file.*      
 DEFINE l_ogb       RECORD LIKE ogb_file.*
 DEFINE l_lrf       RECORD LIKE lrf_file.*
 DEFINE l_ima25     LIKE ima_file.ima25
 DEFINE l_sql       STRING
 DEFINE l_ima02     LIKE ima_file.ima02
 DEFINE l_ima021    LIKE ima_file.ima021
 DEFINE l_ima24     LIKE ima_file.ima24
 DEFINE l_ima906    LIKE ima_file.ima906
 DEFINE l_ima907    LIKE ima_file.ima907
 DEFINE l_ima908    LIKE ima_file.ima908
 DEFINE l_lpx32     LIKE lpx_file.lpx32
 DEFINE l_rcj03     LIKE rtj_file.rtj03
 DEFINE l_rtz07     LIKE rtz_file.rtz07
 DEFINE l_rtz08     LIKE rtz_file.rtz08
 DEFINE l_warehouse LIKE rtz_file.rtz07

   DECLARE oeb_cs CURSOR FOR 
     SELECT * FROM lrf_file
      WHERE lrf01 = g_lrj.lrj01
   LET g_cnt = 1
   FOREACH oeb_cs INTO l_lrf.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('lrf01',g_lrj.lrj01,'lrf_cs',SQLCA.sqlcode,1)  
         LET g_success="N"
         RETURN
      END IF

      #券對應的產品編號為 'MISC' 開頭的資料, 不須產生出貨單
      SELECT lpx32 INTO l_lpx32 FROM lpx_file 
        WHERE lpx01 = (SELECT lqe02 FROM lqe_file WHERE lqe01 = l_lrf.lrf02) 
      IF l_lpx32[1,4]='MISC' THEN CONTINUE FOREACH END IF 

      SELECT MAX(ogb03)+1 INTO l_ogb.ogb03 FROM ogb_file
        WHERE ogb01 = g_oga.oga01
      IF cl_null(l_ogb.ogb03) OR l_ogb.ogb03 = 0 THEN
         LET l_ogb.ogb03 = 1
      END IF
      
      LET l_ogb.ogb01   = g_oga.oga01          #出貨單號
      LET l_ogb.ogb04   = l_lpx32              #產品編號
      SELECT ima25 INTO l_ogb.ogb05            #銷售單位  
         FROM ima_file
          WHERE ima01 = l_lpx32
     #LET l_ogb.ogb05   = 'PCS'                #銷售單位  #券單位
      LET l_ogb.ogb05_fac = 1                  #銷售/庫存彙總單位換算率
      SELECT ima02,ima021,ima24,ima906,ima907,ima908
        INTO l_ima02,l_ima021,l_ima24,l_ima906,l_ima907,l_ima908
        FROM ima_file
       WHERE ima01 = l_ogb.ogb04
      LET l_ogb.ogb06   = l_ima02              #品名規格
      LET l_ogb.ogb07   = l_ima021             #額外品名編號
      LET l_ogb.ogb08   = l_lrf.lrfplant       #出貨營運中心編號
      SELECT rcj03 INTO l_rcj03 FROM rcj_file
      IF cl_null(l_rcj03) THEN
         CALL cl_err('','alm1442',0)
         RETURN
      END IF

      #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file WHERE rtz01 = l_ogb.ogb08      #FUN-C90049 mark
      CALL s_get_defstore(l_ogb.ogb08,l_ogb.ogb04) RETURNING l_rtz07,l_rtz08                #FUN-C90049 add

      IF l_rcj03 = '1' AND cl_null(l_rtz07) THEN
         CALL cl_err(l_ogb.ogb08,'alm1443',0)
         RETURN
      END IF
      IF l_rcj03 = '2' AND cl_null(l_rtz08) THEN
         CALL cl_err(l_ogb.ogb08,'alm1444',0)
         RETURN
      END IF
      IF l_rcj03 = '1' THEN
         LET l_warehouse = l_rtz07
      ELSE
         LET l_warehouse = l_rtz08
      END IF
      LET l_ogb.ogb09   = l_warehouse          #出貨倉庫編號
      LET l_ogb.ogb091  = ' '                  #出貨儲位編號
      LET l_ogb.ogb092  = ' '                  #出貨批號
      LET l_ogb.ogb11   = NULL                 #客戶產品編號
      LET l_ogb.ogb12   = 1                    #實際出貨數量
      IF cl_null(l_ogb.ogb13) THEN LET l_ogb.ogb13 = 0 END IF
      IF cl_null(l_ogb.ogb37) THEN LET l_ogb.ogb37 = 0 END IF
      IF cl_null(l_ogb.ogb14)  THEN LET l_ogb.ogb14 = 0 END IF
      IF cl_null(l_ogb.ogb14t) THEN LET l_ogb.ogb14t= 0 END IF

      SELECT img09 INTO l_img09 FROM img_file
       WHERE img01 = l_lpx32 
         AND img02 = l_ogb.ogb09
         AND img03 = l_ogb.ogb091
         AND img04 = l_ogb.ogb092
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_ogb.ogb04,'/',l_ogb.ogb09,'/',
                         l_ogb.ogb091,'/',l_ogb.ogb092
         CALL s_errmsg('ogb04,ogb09,ogb091,ogb092',g_showmsg,'img_pre','axm-244',1)
         LET g_success="N"
         RETURN
      END IF
      LET l_ogb.ogb15  = l_img09               #庫存明細單位由廠/倉/儲/批自動得出
      CALL s_umfchkm(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb15,l_lrf.lrfplant)
           RETURNING g_cnt,l_fac
      IF g_cnt = 1 THEN
         LET l_fac = 1
      END IF
      LET l_ogb.ogb15_fac = l_fac              #銷售/庫存明細單位換算率
      LET l_ogb.ogb16  = l_ogb.ogb12*l_ogb.ogb15_fac        #數量
      LET l_ogb.ogb16  = s_digqty(l_ogb.ogb16,l_ogb.ogb15)    
      LET l_ogb.ogb17   = 'N'                  #多倉儲批出貨否
      LET l_ogb.ogb18   = l_ogb.ogb12          #預計出貨數量
      SELECT obk11 INTO l_ogb.ogb19
        FROM obk_file
       WHERE obk01 = l_ogb.ogb04
         AND obk02 = g_oga.oga03
         AND obk05 = g_oga.oga23 
      IF cl_null(l_ogb.ogb19) THEN LET l_ogb.ogb19 = 'N' END IF
      LET l_ogb.ogb19   = 'N'
      LET l_ogb.ogb20   = NULL                 #No Use
      LET l_ogb.ogb21   = NULL                 #No Use
      LET l_ogb.ogb22   = NULL                 #No Use
      LET l_ogb.ogb31   = NULL                 #訂單單號
      LET l_ogb.ogb32   = NULL                 #訂單項次
      LET l_ogb.ogb60   = 0                    #已開發票數量
      LET l_ogb.ogb63   = 0                    #銷退數量
      LET l_ogb.ogb64   = 0                    #銷退數量
      LET l_ogb.ogb901  = NULL                 #No Use
      LET l_ogb.ogb902  = NULL                 #No Use
      LET l_ogb.ogb903  = NULL                 #No Use
      LET l_ogb.ogb904  = NULL                 #No Use
      LET l_ogb.ogb905  = NULL                 #No Use
      LET l_ogb.ogb906  = NULL                 #No Use
      LET l_ogb.ogb907  = NULL                 #No Use
      LET l_ogb.ogb908  = NULL                 #手冊編號
      LET l_ogb.ogb909  = NULL                 #No Use
      IF g_sma.sma115 ='Y' THEN
         IF l_ima906 ='1' THEN
            LET l_ogb.ogb910 =l_ogb.ogb05      #單位一
            LET l_ogb.ogb911 ='1'              #單位一換算率(與銷售單位)
            LET l_ogb.ogb912 =l_ogb.ogb12      #單位一數量
         ELSE
            IF l_ima906 ='2' THEN
               LET l_ogb.ogb910 =l_ogb.ogb05
               LET l_ogb.ogb911 ='1'
               LET l_ogb.ogb912 =l_ogb.ogb12
               LET l_ogb.ogb913 =l_ima907      #單位二
               LET l_ogb.ogb914 =l_ogb.ogb913/l_ogb.ogb05 #單位二換算率(與銷售單位)
               LET l_ogb.ogb915 ='0'           #單位二數量
            ELSE
               IF l_ima906 ='3' THEN
                  LET l_ogb.ogb910 =l_ogb.ogb05
                  LET l_ogb.ogb911 ='1'
                  LET l_ogb.ogb912 =l_ogb.ogb12
                  LET l_ogb.ogb913 =l_ima907
                  LET l_ogb.ogb914 =l_ogb.ogb913/l_ogb.ogb05
                  LET l_ogb.ogb915 =l_ogb.ogb12/l_ogb.ogb914
                  LET l_ogb.ogb915 = s_digqty(l_ogb.ogb915,l_ogb.ogb913)    
               END IF
            END IF
         END IF
      END IF
      IF g_sma.sma116 ='Y' THEN
         LET l_ogb.ogb916 =l_ima908
         LET l_ogb.ogb917 =l_ogb.ogb12*(l_ogb.ogb05/l_ogb.ogb16)
         LET l_ogb.ogb917 = s_digqty(l_ogb.ogb917,l_ogb.ogb916)   
      ELSE
         LET l_ogb.ogb916 =l_ogb.ogb05         #計價單位
         LET l_ogb.ogb917 =l_ogb.ogb12         #計價數量
      END IF
      LET l_ogb.ogb65   = NULL                 #驗退理由碼
      LET l_ogb.ogb1001 = g_oaz.oaz91          #原因碼
      LET l_ogb.ogb1002 = NULL                 #訂價代號
      LET l_ogb.ogb1005 = '1'                  #作業方式
      LET l_ogb.ogb1007 = NULL                 #現金折扣單號
      LET l_ogb.ogb1008 = g_oga.oga21          #稅別
      LET l_ogb.ogb1009 = g_oga.oga211         #稅率
      LET l_ogb.ogb1010 = g_oga.oga213         #含稅否
      LET l_ogb.ogb1011 = NULL                 #非直營KAB
      LET l_ogb.ogb1003 = NULL                 #預計出貨日期
      LET l_ogb.ogb1004 = NULL                 #提案代號
      LET l_ogb.ogb1006 = 100                  #折扣率
      LET l_ogb.ogb1012 = 'N'                  #搭贈
      LET l_ogb.ogb930  = NULL                 #成本中心
      LET l_ogb.ogb1013 = 0                    #已開發票未稅金額
      LET l_ogb.ogb1014 = 'N'                  #保稅已放行否
      LET l_ogb.ogb41   = NULL                 #專案代號
      LET l_ogb.ogb42   = NULL                 #WBS編號
      LET l_ogb.ogb43   = NULL                 #活動代號
      LET l_ogb.ogb931  = NULL                 #包裝編號
      LET l_ogb.ogb932  = NULL                 #包裝數量
      LET l_ogb.ogbud01 = NULL                 #自訂欄位-Textedit
      LET l_ogb.ogbud02 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud03 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud04 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud05 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud06 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud07 = NULL                 #自訂欄位-數值
      LET l_ogb.ogbud08 = NULL                 #自訂欄位-數值
      LET l_ogb.ogbud09 = NULL                 #自訂欄位-數值
      LET l_ogb.ogbud10 = NULL                 #自訂欄位-整數
      LET l_ogb.ogbud11 = NULL                 #自訂欄位-整數
      LET l_ogb.ogbud12 = NULL                 #自訂欄位-整數
      LET l_ogb.ogbud13 = NULL                 #自訂欄位-日期
      LET l_ogb.ogbud14 = NULL                 #自訂欄位-日期
      LET l_ogb.ogbud15 = NULL                 #自訂欄位-日期
      LET l_ogb.ogbplant=l_lrf.lrfplant        #所屬工廠
      LET l_ogb.ogblegal=l_lrf.lrflegal        #所屬法人
      LET l_ogb.ogb44   ='1'                   #經營方式
      LET l_ogb.ogb45   =NULL                  #原扣率
      LET l_ogb.ogb46   =NULL                  #新扣率
      LET l_ogb.ogb47   =0                     #分攤折價=全部折價字段值的和
      #FUN-C50097 ADD BEGIN-----
      IF cl_null(l_ogb.ogb50) THEN 
        LET l_ogb.ogb50 = 0
      END IF 
      IF cl_null(l_ogb.ogb51) THEN 
        LET l_ogb.ogb51 = 0
      END IF 
      IF cl_null(l_ogb.ogb52) THEN 
        LET l_ogb.ogb52 = 0
      END IF 
      IF cl_null(l_ogb.ogb53) THEN 
        LET l_ogb.ogb53 = 0
      END IF 
      IF cl_null(l_ogb.ogb54) THEN 
        LET l_ogb.ogb54 = 0
      END IF 
      IF cl_null(l_ogb.ogb55) THEN 
        LET l_ogb.ogb55 = 0
      END IF                                           
      #FUN-C50097 ADD END------- 
      #FUN-CB0087--add--str--
      IF g_aza.aza115 = 'Y' THEN 
         CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,
                            g_oga.oga14,g_oga.oga15) RETURNING l_ogb.ogb1001
         IF cl_null(l_ogb.ogb1001) THEN 
            CALL cl_err(l_ogb.ogb1001,'aim-425',1)
            LET g_success="N"
            RETURN
         END IF
      END IF
      #FUN-CB0087--add--end--
      INSERT INTO ogb_file VALUES(l_ogb.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ogb01',l_ogb.ogb01,'ogb_ins',SQLCA.sqlcode,1)
         LET g_success="N"
         RETURN
      
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_ogbi.* TO NULL    
            LET l_ogbi.ogbi01 = l_ogb.ogb01
            LET l_ogbi.ogbi03 = l_ogb.ogb03
            IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      
      END IF
  
      CALL t595_ins_ogi(l_ogb.ogb01,l_ogb.ogb03,l_ogb.ogb04)                #單身稅別明細檔 
     #CALL t595_ins_ogh(l_ogb.ogb01,l_ogb.ogb03,l_ogb.ogb04)                #實際交易稅別明細檔
      CALL t595_ins_rxe(l_ogb.ogb01,l_ogb.ogb03,l_lrf.lrf02,l_lrf.lrf03)    #銷售券號      
 
      LET g_oga.oga50 = g_oga.oga50 + l_ogb.ogb14
      LET g_oga.oga51 = g_oga.oga51 + l_ogb.ogb14t
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL t595_ins_ogh(l_ogb.ogb01,l_ogb.ogb04)                #實際交易稅別明細檔
END FUNCTION

#出貨單過帳
FUNCTION t595_oga_post(p_oga01,p_plant)
 DEFINE p_plant     LIKE azw_file.azw01
 DEFINE p_oga01     LIKE oga_file.oga01

  LET g_plant2 = p_plant
  LET g_oga.oga01 = p_oga01
  SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = g_plant2
  CALL t595_s()
END FUNCTION

#出貨單過帳
FUNCTION t595_s()

   IF s_shut(0) THEN RETURN END IF

   LET g_sql ="SELECT * FROM ",cl_get_target_table(g_plant2,'oga_file'),
              " WHERE oga01 = '",g_oga.oga01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql
   PREPARE oga_1_p1 FROM g_sql
   EXECUTE oga_1_p1 INTO g_oga.*
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oga01',g_oga.oga01,'SELECT oga',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_oga.oga01 IS NULL THEN
      CALL s_errmsg('oga01',g_oga.oga01,'oga01 is null',-400,1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_oga.ogaconf <> 'Y' THEN
      CALL s_errmsg('oga01',g_oga.oga01,'ogaconf = "N"','anm-960',1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_oga.ogapost = 'Y' THEN
      CALL s_errmsg('oga01',g_oga.oga01,'ogapost = "Y"','aar-347',1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_oga.oga02 <= g_sma.sma53 THEN
      CALL s_errmsg('oga02',g_oga.oga02,'','mfg9999',1)
      LET g_success = 'N'
      RETURN
   END IF

   LET g_sql = "UPDATE ",cl_get_target_table(g_plant2,'oga_file'),
               " SET ogapost= 'Y' ",
               " WHERE oga01='",g_oga.oga01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql
   PREPARE oga_cs FROM g_sql
   EXECUTE oga_cs
   IF SQLCA.SQLCODE THEN
      LET g_success = 'N'
      CALL s_errmsg('oga01',g_oga.oga01,'UPDATE ogapost',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET g_oga.ogapost='Y'

   CALL t595_s1()

   IF g_success = 'N' THEN
      LET g_oga.ogapost='N'
      RETURN
   END IF
END FUNCTION

FUNCTION t595_s1()

   LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant2,'ogb_file'),
               " WHERE ogb01='",g_oga.oga01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql
   PREPARE t595_s2_pl FROM g_sql
   DECLARE t595_s2_c CURSOR FOR t595_s2_pl
   FOREACH t595_s2_c INTO g_ogb.*
      IF STATUS THEN
         CALL s_errmsg('ogb01',g_oga.oga01,'foreach t595_s2_c',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      MESSAGE '_s1() read no:',g_ogb.ogb03 USING '#####&',
                             '--> parts: ', g_ogb.ogb04
      IF cl_null(g_ogb.ogb04) THEN CONTINUE FOREACH END IF


      IF g_ogb.ogb04[1,4]='MISC' THEN CONTINUE FOREACH END IF

      CALL t595_update(g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,
                         g_ogb.ogb12,g_ogb.ogb05,g_ogb.ogb15_fac,g_ogb.ogb16,'','-')
      IF g_success='N' THEN RETURN END IF

      IF g_sma.sma115 = 'Y' THEN
         CALL t595_du()
      END IF
   END FOREACH
   CALL t595_upd_oea()
END FUNCTION

#更新庫存異動檔
FUNCTION t595_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,p_flag,p_type)
   DEFINE p_flag    LIKE type_file.chr1
   DEFINE p_ware    LIKE ogb_file.ogb09        ##倉庫
   DEFINE p_loca    LIKE ogb_file.ogb091       ##儲位
   DEFINE p_lot     LIKE ogb_file.ogb092       ##批號
   DEFINE p_qty     LIKE ogc_file.ogc12        ##銷售數量(銷售單位)
   DEFINE p_uom     LIKE tlf_file.tlf11        ##銷售單位
   DEFINE p_factor  LIKE ogb_file.ogb15_fac    ##轉換率
   DEFINE p_qty2    LIKE ogc_file.ogc16        ##銷售數量(img 單位)
   DEFINE p_type    LIKE type_file.chr1 
   DEFINE l_qty     LIKE ogc_file.ogc12        ##異動后數量
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_img     RECORD
                    img10   LIKE img_file.img10,
                    img16   LIKE img_file.img16,
                    img23   LIKE img_file.img23,
                    img24   LIKE img_file.img24,
                    img09   LIKE img_file.img09,
                    img18   LIKE img_file.img18,
                    img21   LIKE img_file.img21
                    END RECORD 

   IF cl_null(p_ware) THEN LET p_ware=' ' END IF
   IF cl_null(p_loca) THEN LET p_loca=' ' END IF
   IF cl_null(p_lot)  THEN LET p_lot =' ' END IF
   IF cl_null(p_qty)  THEN LET p_qty =0   END IF
   IF cl_null(p_qty2) THEN LET p_qty2=0   END IF

   IF cl_null(p_uom) THEN
      LET g_showmsg = g_ogb.ogb03,'/',g_ogb.ogb04
      CALL s_errmsg('ogb03,ogb04',g_showmsg,'p_uom null:','axm-186',1)
      LET g_success = 'N' RETURN
   END IF

   LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img18,img21 ",
                      "  FROM ",cl_get_target_table(g_plant2,'img_file'),
                      " WHERE img01= ? AND img02= ? AND img03= ? ",
                      "   AND img04= ? FOR UPDATE "
   CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql            
   CALL cl_parse_qry_sql(g_forupd_sql,g_plant2) RETURNING g_forupd_sql
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE img_lock CURSOR FROM g_forupd_sql

   OPEN img_lock USING g_ogb.ogb04,p_ware,p_loca,p_lot
   IF SQLCA.sqlcode THEN
      LET g_showmsg = g_ogb.ogb04,'/',p_ware,'/',p_loca,'/',p_lot
      CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'open img_lock',SQLCA.sqlcode,1)
      CLOSE img_lock
      LET g_success = 'N'
      RETURN
   END IF

   FETCH img_lock INTO l_img.*
   IF SQLCA.sqlcode THEN
      LET g_showmsg = g_ogb.ogb04,'/',p_ware,'/',p_loca,'/',p_lot
      CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'fetch img_lock',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   
   IF l_img.img18 < g_oga.oga02 AND p_type <> '+' THEN
      LET g_showmsg = l_img.img18,'/',g_oga.oga02
      CALL s_errmsg('img18,oga02',g_showmsg,'img18<oga02','aim-400',1)
      LET g_success='N'
      RETURN
   END IF

   IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
   LET l_qty= l_img.img10 - p_qty2

   IF p_type = '+' THEN LET l_cnt =  1 END IF
   IF p_type = '-' THEN LET l_cnt = -1 END IF

   CALL s_mupimg(l_cnt,g_ogb.ogb04,p_ware,p_loca,p_lot,p_qty2,
                 g_today,g_plant2 CLIPPED ,-1,g_ogb.ogb01,g_ogb.ogb03)

   IF g_success='N' THEN
      LET g_showmsg = g_ogb.ogb04,'/',p_ware,'/',p_loca,'/',p_lot
      CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'s_upimg()','9050',1)
   END IF

   LET g_forupd_sql = "SELECT ima25,ima86 FROM ",cl_get_target_table(g_plant2,'ima_file'),
                      " WHERE ima01= ?  FOR UPDATE "
   CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql         
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ima_lock CURSOR FROM g_forupd_sql

   OPEN ima_lock USING g_ogb.ogb04
   IF STATUS THEN
      CALL s_errmsg('ima01',g_ogb.ogb04,"OPEN ima_lock:", STATUS, 1)
      CLOSE ima_lock
      LET g_success='N'
      RETURN
   END IF

   FETCH ima_lock INTO g_ima25,g_ima86
   IF STATUS THEN
      CALL s_errmsg('ima01',g_ogb.ogb04,'lock ima fail',STATUS,1) LET g_success='N' RETURN
   END IF

   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
   CALL s_mudima(g_ogb.ogb04,g_plant2)
   IF g_success='Y' AND p_type = '-' THEN
      CALL t595_tlf(p_ware,p_loca,p_lot,g_ima25,p_qty,l_qty,p_uom,p_factor,p_flag)
   END IF

END FUNCTION

FUNCTION t595_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,p_flag)
   DEFINE p_ware     LIKE ogb_file.ogb09        ##倉庫
   DEFINE p_loca     LIKE ogb_file.ogb091       ##儲位
   DEFINE p_lot      LIKE ogb_file.ogb092       ##批號
   DEFINE p_unit     LIKE ima_file.ima25        ##單位
   DEFINE p_qty      LIKE ogc_file.ogc12        ##銷售數量(銷售單位)
   DEFINE p_img10    LIKE img_file.img10        ##異動后數量
   DEFINE p_uom      LIKE tlf_file.tlf11        ##銷售單位
   DEFINE p_factor   LIKE ogb_file.ogb15_fac    ##轉換率
   DEFINE p_flag     LIKE type_file.chr1
   DEFINE l_n1       LIKE type_file.num15_3 ###GP5.2
   DEFINE l_n2       LIKE type_file.num15_3 ###GP5.2
   DEFINE l_n3       LIKE type_file.num15_3 ###GP5.2

   #----來源----
   LET g_tlf.tlf01=g_ogb.ogb04         #異動料件編號
   LET g_tlf.tlf02=50                  #'Stock'
   LET g_tlf.tlf020=g_ogb.ogb08
   LET g_tlf.tlf021=p_ware             #倉庫
   LET g_tlf.tlf022=p_loca             #儲位
   LET g_tlf.tlf023=p_lot              #批號
   LET g_tlf.tlf024=p_img10            #異動后數量
   LET g_tlf.tlf025=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=g_ogb.ogb01        #出貨單號
   LET g_tlf.tlf027=g_ogb.ogb03        #出貨項次
   #---目的----
   LET g_tlf.tlf03=724
   LET g_tlf.tlf030=' '
   LET g_tlf.tlf031=' '                #倉庫
   LET g_tlf.tlf032=' '                #儲位
   LET g_tlf.tlf033=' '                #批號
   LET g_tlf.tlf034=' '                #異動后庫存數量
   LET g_tlf.tlf035=' '                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=g_ogb.ogb31        #訂單單號
   LET g_tlf.tlf037=g_ogb.ogb32        #訂單項次
   #-->異動數量
   LET g_tlf.tlf04= ' '                #工作站
   LET g_tlf.tlf05= ' '                #作業序號
   LET g_tlf.tlf06=g_oga.oga02         #發料日期
   LET g_tlf.tlf07=g_today             #異動資料產生日期
   LET g_tlf.tlf08=TIME                #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user              #產生人
   LET g_tlf.tlf10=p_qty               #異動數量
   LET g_tlf.tlf11=p_uom               #發料單位
   LET g_tlf.tlf12 =p_factor           #發料/庫存 換算率
   LET g_tlf.tlf13='axmt620'
   LET g_tlf.tlf14=g_ogb.ogb1001       #異動原因

   LET g_tlf.tlf17=' '                 #非庫存性料件編號

   CALL s_getstock(g_ogb.ogb04,g_plant2) RETURNING  l_n1,l_n2,l_n3 
   LET g_tlf.tlf18 = l_n2+l_n3 
   IF g_tlf.tlf18 IS NULL THEN
      LET g_tlf.tlf18=0
   END IF 
   LET g_tlf.tlf19=g_oga.oga03
   LET g_tlf.tlf20 = g_oga.oga46
   LET g_tlf.tlf61= g_ima86
   LET g_tlf.tlf62=g_ogb.ogb31        #參考單號(訂單)
   LET g_tlf.tlf63=g_ogb.ogb32        #訂單項次
   LET g_tlf.tlf64=g_ogb.ogb908       #手冊編號
   LET g_tlf.tlf66=p_flag             #for axcp500多倉出貨處理
   LET g_tlf.tlf930=g_ogb.ogb930
   LET g_tlf.tlf20 = g_ogb.ogb41                                                
   LET g_tlf.tlf41 = g_ogb.ogb42                                                
   LET g_tlf.tlf42 = g_ogb.ogb43                                                
   LET g_tlf.tlf43 = g_ogb.ogb1001  
   LET g_tlf.tlf99 = g_oga.oga99
   CALL s_tlf2(1,0,g_plant2)
END FUNCTION

FUNCTION t595_du()
  DEFINE l_last_poy02    LIKE poy_file.poy02                                 
  DEFINE l_last_poy04    LIKE poy_file.poy04

   CALL t595_sel_ima(g_ogb.ogb04)
   IF g_success = 'N' THEN RETURN END IF
   IF cl_null(g_ima906) OR g_ima906 = '1' THEN RETURN END IF

   IF g_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(g_ogb.ogb913) THEN
         CALL s_mchk_imgg(g_ogb.ogb04,g_ogb.ogb09,
                          g_ogb.ogb091,g_ogb.ogb092,g_ogb.ogb913,l_azp03)
            RETURNING g_flag
         IF g_flag = 1 THEN
            LET g_showmsg = g_ogb.ogb04,'/',g_ogb.ogb09,'/',g_ogb.ogb091,'/',g_ogb.ogb092
            CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'sel imgg:','axm-244',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL t595_upd_imgg('1',g_ogb.ogb04,g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,
                             g_ogb.ogb913,g_ogb.ogb914,g_ogb.ogb915,-1,'2')
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(g_ogb.ogb915) THEN
            CALL t595_tlff(g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,g_ima25,
                           g_ogb.ogb915,0,g_ogb.ogb913,g_ogb.ogb914,-1,'2',l_azp03)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(g_ogb.ogb910) THEN
         CALL s_mchk_imgg(g_ogb.ogb04,g_ogb.ogb09,
                          g_ogb.ogb091,g_ogb.ogb092,g_ogb.ogb910,l_azp03)
            RETURNING g_flag
         IF g_flag = 1 THEN
            LET g_showmsg = g_ogb.ogb04,'/',g_ogb.ogb09,'/',g_ogb.ogb091,'/',g_ogb.ogb092
            CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'sel imgg:','axm-244',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL t595_upd_imgg('1',g_ogb.ogb04,g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,
                             g_ogb.ogb910,g_ogb.ogb911,g_ogb.ogb912,-1,'2')
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(g_ogb.ogb912) THEN
            CALL t595_tlff(g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,g_ima25,
                           g_ogb.ogb912,0,g_ogb.ogb910,g_ogb.ogb911,-1,'1',l_azp03)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(g_ogb.ogb913) THEN
         CALL s_mchk_imgg(g_ogb.ogb04,g_ogb.ogb09,
                          g_ogb.ogb091,g_ogb.ogb092,g_ogb.ogb913,l_azp03)
            RETURNING g_flag
         IF g_flag = 1 THEN
            LET g_showmsg = g_ogb.ogb04,'/',g_ogb.ogb09,'/',g_ogb.ogb091,'/',g_ogb.ogb092
            CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'sel imgg:','axm-244',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL t595_upd_imgg('2',g_ogb.ogb04,g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,
                             g_ogb.ogb913,g_ogb.ogb914,g_ogb.ogb915,-1,'2')
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(g_ogb.ogb915) THEN 
            CALL t595_tlff(g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,g_ima25,
                           g_ogb.ogb915,0,g_ogb.ogb913,g_ogb.ogb914,-1,'2',l_azp03)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF

END FUNCTION

FUNCTION t595_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                   u_type,p_flag,p_azp03)
   DEFINE p_ware     LIKE imgg_file.imgg02               #倉庫
   DEFINE p_loca     LIKE imgg_file.imgg03               #儲位
   DEFINE p_lot      LIKE imgg_file.imgg04               #批號
   DEFINE p_unit     LIKE imgg_file.imgg09 
   DEFINE p_qty      LIKE imgg_file.imgg10               #數量
   DEFINE p_img10    LIKE imgg_file.imgg10               #異動后數量
   DEFINE p_uom      LIKE imgg_file.imgg09               #img 單位
   DEFINE p_factor   LIKE imgg_file.imgg21               #轉換率
   DEFINE l_imgg10   LIKE imgg_file.imgg10 
   DEFINE u_type     LIKE type_file.num5 
   DEFINE p_flag     LIKE type_file.chr1 
   DEFINE p_azp03    LIKE azp_file.azp03

   IF cl_null(p_ware) THEN LET p_ware=' ' END IF
   IF cl_null(p_loca) THEN LET p_loca=' ' END IF
   IF cl_null(p_lot)  THEN LET p_lot =' ' END IF
   IF cl_null(p_qty)  THEN LET p_qty =0   END IF
   LET g_sql = " SELECT imgg10 ",
               "   FROM ",cl_get_target_table(g_plant2,'imgg_file'),
               "  WHERE imgg01 = '",g_ogb.ogb04,"' ",
               "    AND imgg02 = '",p_ware,"' ",
               "    AND imgg03 = '",p_loca,"' ",
               "    AND imgg04 = '",p_lot,"' ",
               "    AND imgg09 = '",p_uom,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql
   PREPARE imgg_pre FROM g_sql
   DECLARE imgg_cur CURSOR FOR imgg_pre
   EXECUTE imgg_pre INTO l_imgg10
   IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
   INITIALIZE g_tlff.* TO NULL

   #----來源----
   LET g_tlff.tlff01=g_ogb.ogb04         #異動料件編號
   LET g_tlff.tlff02=50                  #'Stock'
   LET g_tlff.tlff020=g_ogb.ogb08
   LET g_tlff.tlff021=p_ware             #倉庫
   LET g_tlff.tlff022=p_loca             #儲位
   LET g_tlff.tlff023=p_lot              #批號
   LET g_tlff.tlff024=l_imgg10           #異動後數量
   LET g_tlff.tlff025=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlff.tlff026=g_ogb.ogb01        #出貨單號
   LET g_tlff.tlff027=g_ogb.ogb03        #出貨項次
   #---目的----
   LET g_tlff.tlff03=724
   LET g_tlff.tlff030=' '
   LET g_tlff.tlff031=' '                #倉庫
   LET g_tlff.tlff032=' '                #儲位
   LET g_tlff.tlff033=' '                #批號
   LET g_tlff.tlff034=' '                #異動後庫存數量
   LET g_tlff.tlff035=' '                #庫存單位(ima_file or img_file)
   LET g_tlff.tlff036=g_ogb.ogb31        #訂單單號
   LET g_tlff.tlff037=g_ogb.ogb32        #訂單項次

   #-->異動數量
   LET g_tlff.tlff04= ' '             #工作站
   LET g_tlff.tlff05= ' '             #作業序號
   LET g_tlff.tlff06=g_oga.oga02      #發料日期
   LET g_tlff.tlff07=g_today          #異動資料產生日期
   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user           #產生人
   LET g_tlff.tlff10=p_qty            #異動數量
   LET g_tlff.tlff11=p_uom            #發料單位
   LET g_tlff.tlff12=p_factor         #發料/庫存 換算率
   LET g_tlff.tlff13='axmt620'
   LET g_tlff.tlff14=' '              #異動原因

   LET g_tlff.tlff17=' '              #非庫存性料件編號
   LET g_tlff.tlff18 = g_tlf.tlf18
   LET g_tlff.tlff19=g_oga.oga04
   LET g_tlff.tlff20 = g_oga.oga46
   LET g_tlff.tlff61= g_ima86
   LET g_tlff.tlff62=g_ogb.ogb31    #參考單號(訂單)
   LET g_tlff.tlff63=g_ogb.ogb32    #訂單項次
   LET g_tlff.tlff64=g_ogb.ogb908   #手冊編號 no.A050
   LET g_tlff.tlff66=p_flag         #for axcp500多倉出貨處理
   LET g_tlff.tlff930=g_ogb.ogb930
   LET g_tlff.tlff99 = g_oga.oga99

   IF cl_null(g_ogb.ogb915) OR g_ogb.ogb915=0 THEN
      CALL s_tlff2(p_flag,NULL,p_azp03)
   ELSE
      CALL s_tlff2(p_flag,g_ogb.ogb913,p_azp03)
   END IF
END FUNCTION

FUNCTION t595_du_2(p_item,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,p_unit1,p_fac1,p_qty1,p_flag)
  DEFINE p_item     LIKE img_file.img01
  DEFINE p_ware     LIKE img_file.img02
  DEFINE p_loc      LIKE img_file.img03
  DEFINE p_lot      LIKE img_file.img04
  DEFINE p_unit2    LIKE img_file.img09
  DEFINE p_fac2     LIKE img_file.img21
  DEFINE p_qty2     LIKE img_file.img10
  DEFINE p_unit1    LIKE img_file.img09
  DEFINE p_fac1     LIKE img_file.img21
  DEFINE p_qty1     LIKE img_file.img10
  DEFINE p_flag     LIKE type_file.chr1

  IF g_sma.sma115 = 'N' THEN RETURN END IF

  CALL t595_sel_ima(p_item)
  IF g_success = 'N' THEN RETURN END IF

  IF g_ima906 IS NULL OR g_ima906 = '1' THEN RETURN END IF
  IF g_ima906 = '2' THEN
     IF NOT cl_null(p_unit2) THEN
        CALL t595_upd_imgg('1',p_item,p_ware,p_loc,p_lot,
                           p_unit2,p_fac2,p_qty2,+1,'2')
        IF g_success='N' THEN RETURN END IF
     END IF
     IF NOT cl_null(p_unit1) THEN
        CALL t595_upd_imgg('1',p_item,p_ware,p_loc,p_lot,
                           p_unit1,p_fac1,p_qty1,+1,'1')
        IF g_success='N' THEN RETURN END IF
     END IF
     IF p_flag = '2' THEN
        CALL t595_tlff_2()
        IF g_success='N' THEN RETURN END IF
     END IF
  END IF
  IF g_ima906 = '3' THEN
     IF NOT cl_null(p_unit2) THEN
        CALL t595_upd_imgg('2',p_item,p_ware,p_loc,p_lot,
                           p_unit2,p_fac2,p_qty2,+1,'2')
        IF g_success='N' THEN RETURN END IF
     END IF
     IF p_flag = '2' THEN
        CALL t595_tlff_2()
        IF g_success='N' THEN RETURN END IF
     END IF
  END IF
END FUNCTION


FUNCTION t595_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no)
  DEFINE p_imgg00   LIKE imgg_file.imgg00
  DEFINE p_imgg01   LIKE imgg_file.imgg01
  DEFINE p_imgg02   LIKE imgg_file.imgg02
  DEFINE p_imgg03   LIKE imgg_file.imgg03
  DEFINE p_imgg04   LIKE imgg_file.imgg04
  DEFINE p_imgg09   LIKE imgg_file.imgg09
  DEFINE p_imgg211  LIKE imgg_file.imgg211
  DEFINE p_imgg10   LIKE imgg_file.imgg10
  DEFINE p_type     LIKE type_file.num10
  DEFINE p_no       LIKE type_file.chr1 
  DEFINE l_imgg21   LIKE imgg_file.imgg21 
  DEFINE l_imgg00   LIKE imgg_file.imgg00
  DEFINE l_cnt      LIKE type_file.num5

  IF cl_null(p_imgg03) THEN LET p_imgg03 = ' ' END IF
  IF cl_null(p_imgg04) THEN LET p_imgg04 = ' ' END IF
  LET g_forupd_sql =
      "SELECT imgg00 FROM ",cl_get_target_table(g_plant2,'imgg_file'),
      " WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
      "   AND imgg09= ? FOR UPDATE "

  CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql           
  CALL cl_parse_qry_sql(g_forupd_sql,g_plant2) RETURNING g_forupd_sql
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE imgg_lock CURSOR FROM g_forupd_sql

  OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
  IF STATUS THEN
     LET g_showmsg = p_imgg01,'/',p_imgg02,'/',p_imgg03,'/',p_imgg04,'/',p_imgg09
     CALL s_errmsg('imgg01,imgg02,imgg03,imgg04,imgg09',g_showmsg,'OPEN imgg_lock',SQLCA.sqlcode,1)
     LET g_success='N'
     CLOSE imgg_lock
     RETURN
  END IF
  FETCH imgg_lock INTO l_imgg00
  IF STATUS THEN
     LET g_showmsg = p_imgg01,'/',p_imgg02,'/',p_imgg03,'/',p_imgg04,'/',p_imgg09
     CALL s_errmsg('imgg01,imgg02,imgg03,imgg04,imgg09',g_showmsg,'FETCH imgg_lock',SQLCA.sqlcode,1)
     LET g_success='N'
     CLOSE imgg_lock
     RETURN
  END IF

  CALL t595_sel_ima(p_imgg01)
  IF g_success = 'N' THEN RETURN END IF

  CALL s_umfchkm(p_imgg01,p_imgg09,g_ima25,g_plant2)
       RETURNING l_cnt,l_imgg21
  IF l_cnt = 1 AND NOT (g_ima906='3' AND p_no='2') THEN
     LET g_showmsg = p_imgg01,'/',p_imgg09,'/',g_ima25
     CALL s_errmsg('imgg01,imgg09,ima25',g_showmsg,'s_umfchkm','mfg3075',1)
     LET g_success = 'N' 
     RETURN
  END IF

  CALL s_mupimgg(p_type,p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_imgg10,g_oga.oga02,g_plant2)
  IF g_success='N' THEN RETURN END IF

END FUNCTION

FUNCTION t595_sys()
  #SELECT 系統參數
  LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant2,'sma_file'),
              " WHERE sma00 = '0'"
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql
  PREPARE sma_p1 FROM g_sql
  EXECUTE sma_p1 INTO g_sma.*
  IF SQLCA.sqlcode THEN
     CALL s_errmsg('sma00','0','select sma fail',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF

  LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant2,'oaz_file'),
              " WHERE oaz00 = '0'"
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql  
  PREPARE oaz_p1 FROM g_sql
  EXECUTE oaz_p1 INTO g_oaz.*
  IF SQLCA.sqlcode THEN
     CALL s_errmsg('oaz00','0','select oaz fail',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF

END FUNCTION

FUNCTION t595_sel_ima(p_ima01)
   DEFINE p_ima01     LIKE ima_file.ima01

   LET g_ima906 = NULL
   LET g_ima25  = NULL
   LET g_sql = " SELECT ima906,ima25 ",
               "  FROM ",cl_get_target_table(g_plant2,'ima_file'),
               " WHERE ima01 = '",p_ima01,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
   CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql
   PREPARE ima_sel FROM g_sql
   EXECUTE ima_sel INTO g_ima906,g_ima25
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ima01',p_ima01,'ima_sel',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN
   END IF

END FUNCTION

FUNCTION t595_chk_avl_stk(p_qty2)
   DEFINE p_qty2    LIKE ogc_file.ogc16    ##銷售數量(img 單位)
   DEFINE l_oeb19   LIKE oeb_file.oeb19
   DEFINE l_avl_stk LIKE type_file.num15_3    ###GP5.2
   DEFINE l_oeb12   LIKE oeb_file.oeb12
   DEFINE l_qoh     LIKE oeb_file.oeb12
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_fac     LIKE ogb_file.ogb15_fac
   DEFINE l_n1      LIKE type_file.num15_3 ###GP5.2
   DEFINE l_n2      LIKE type_file.num15_3 ###GP5.2
   DEFINE l_n3      LIKE type_file.num15_3 ###GP5.2

   #--訂單備置為'N',須check(庫存量ima262-sum(備置量oeb12-oeb24))>出貨量
    IF NOT cl_null(g_ogb.ogb31) AND NOT cl_null(g_ogb.ogb32) THEN  
       CALL t595_sel_ima(g_ogb.ogb04)
       IF g_success = 'N' THEN RETURN END IF

       LET g_sql =  "SELECT oeb19 FROM ",cl_get_target_table(g_plant2,'oeb_file'),
                    " WHERE oeb01 = '",g_ogb.ogb31,"'",
                    "   AND oeb03 = '",g_ogb.ogb32,"'"          
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql
       PREPARE oeb19_pl1 FROM g_sql 
       DECLARE oeb19_cs1 CURSOR FOR oeb19_pl1
       OPEN oeb19_cs1
       FETCH oeb19_cs1 INTO l_oeb19
       IF STATUS THEN
          LET g_showmsg = g_ogb.ogb31,'/',g_ogb.ogb32
          CALL s_errmsg('ogb31,ogb32',g_showmsg,'fetch oeb19',SQLCA.sqlcode,1)
          LET g_success='N' 
          RETURN
       END IF
       IF l_oeb19 = 'N' THEN
          CALL s_getstock(g_ogb.ogb04,g_plant2) RETURNING  l_n1,l_n2,l_n3
          LET l_avl_stk = l_n3
          IF l_avl_stk IS NULL THEN
             LET l_avl_stk = 0
          END IF 
          LET g_sql =  "SELECT SUM(oeb905*oeb05_fac) FROM ",cl_get_target_table(g_plant2,'oeb_file'),
                       " WHERE oeb04 = '",g_ogb.ogb04,"'",  
                       "   AND oeb19= 'Y' AND oeb70= 'N'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql
          CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql
          PREPARE oeb12_pl FROM g_sql 
          DECLARE oeb12_cs CURSOR FOR oeb12_pl
          OPEN oeb12_cs
          FETCH oeb12_cs INTO l_oeb12 
          IF STATUS THEN
             CALL s_errmsg('oeb04',g_ogb.ogb04,'fetch oeb12_cs',SQLCA.sqlcode,1)
             LET g_success='N' 
             RETURN
          END IF 
          IF l_oeb12 IS NULL THEN 
             LET l_oeb12 = 0 
          END IF
          LET l_qoh = l_avl_stk - l_oeb12

          CALL s_umfchkm(g_ogb.ogb04,g_ogb.ogb15,g_ima25,g_plant2)
               RETURNING l_cnt,l_fac
          IF l_cnt = 1 THEN
             LET g_showmsg = g_ogb.ogb04,'/',g_ogb.ogb15,'/',g_ima25
             CALL s_errmsg('ima01,img09,ima25',g_showmsg,'s_umfchkm','mfg3075',1)
             LET g_success = 'N' 
             RETURN
          END IF
          LET p_qty2 = p_qty2 * l_fac

        #FUN-D30024 ----------Begin--------
       #  INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
       #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],g_ogb.ogb09) RETURNING g_sma894            #FUN-C80107  #FUN-D30024 mark
       # #IF l_qoh < p_qty2 AND g_sma.sma894[2,2]='N' THEN  #量不足時,Fail                          #FUN-C80107 mark
       #  IF l_qoh < p_qty2 AND g_sma894 = 'N' THEN  #量不足時,Fail                                 #FUN-C80107
          INITIALIZE g_imd23 TO NULL  
          CALL s_inv_shrt_by_warehouse(g_ogb.ogb09,g_plant2) RETURNING g_imd23                              #FUN-D30024  #TQC-D40078 g_plant2
          IF l_qoh < p_qty2 AND g_imd23 = 'N' THEN 
        #FUN-D30024 ----------End----------
             LET g_showmsg = l_qoh,'/',p_qty2
             CALL s_errmsg('oeb905,l_avl_stk',g_showmsg,'QOH<0','mfg-026',1)
             LET g_success='N' 
             RETURN
          END IF
       END IF
    END IF
END FUNCTION

FUNCTION t595_upd_oeb(p_type)                  #更新訂單已出貨量
   DEFINE p_type      LIKE type_file.num5
   DEFINE p_qty       LIKE oeb_file.oeb24

   IF cl_null(g_ogb.ogb31) OR cl_null(g_ogb.ogb32) THEN
      RETURN
   END IF
   
   IF p_type = 1 THEN
      LET p_qty = g_ogb.ogb12 #出貨
   ELSE
      LET p_qty = g_ogb.ogb12 * -1
   END IF
   
   IF NOT cl_null(g_ogb.ogb31) AND g_ogb.ogb31[1,4] !='MISC' THEN
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant2,'oeb_file'),
                  "   SET oeb24= oeb24 + ? ", 
                  " WHERE oeb01 = '",g_ogb.ogb31,"'",
                  "   AND oeb03 = '",g_ogb.ogb32,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
      CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql
      PREPARE oeb24_cs FROM g_sql
      EXECUTE oeb24_cs USING p_qty
      IF STATUS THEN
         LET g_showmsg = g_ogb.ogb31,'/',g_ogb.ogb32
         CALL s_errmsg('ogb31,ogb32',g_showmsg,'upd oeb24',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = g_ogb.ogb31,'/',g_ogb.ogb32
         CALL s_errmsg('ogb31,ogb32',g_showmsg,'upd oeb24','axm-134',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
END FUNCTION

FUNCTION t595_upd_oea()                 #更新訂單出貨金額
   DEFINE l_amount     LIKE oea_file.oea62

   IF cl_null(g_ogb.ogb31) THEN RETURN END IF
   LET g_sql = "SELECT SUM(oeb24*oeb13) FROM ",cl_get_target_table(g_plant2,'oeb_file'),
               " WHERE oeb01='",g_ogb.ogb31,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql
   PREPARE oeb24_pl1 FROM g_sql
   DECLARE oeb24_cs1 CURSOR FOR oeb24_pl1
   OPEN oeb24_cs1
   FETCH oeb24_cs1 INTO l_amount
   IF cl_null(l_amount) THEN LET l_amount=0 END IF

   LET g_sql = "UPDATE ",cl_get_target_table(g_plant2,'oea_file'),
               "   SET oea62= ? ",
               " WHERE oea01 = '",g_ogb.ogb31,"'"

   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql
   PREPARE oea62_cs FROM g_sql
   EXECUTE oea62_cs USING l_amount

   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('oea01',g_ogb.ogb31,'upd oea62',status,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION

FUNCTION t595_u_tlf()#------------------------------------------ Update tlf_file
   DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*
   DEFINE l_sql   STRING
   DEFINE l_i     LIKE type_file.num5
   
   LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant2,'tlf_file'),
               " WHERE tlf01 ='",g_ogb.ogb04,"' ",
               "   AND tlf02 = 50 ",
               "   AND tlf026='",g_oga.oga01,"' ", 
               "   AND tlf027= ",g_ogb.ogb03,      
               "   AND tlf036='",g_ogb.ogb31,"' ", 
               "   AND tlf037= ",g_ogb.ogb32,      
               "   AND tlf06 ='",g_oga.oga02,"' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql  
    DECLARE t595_u_tlf_c CURSOR FROM g_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH t595_u_tlf_c INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     

   LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant2,'tlf_file'),
               " WHERE tlf01 ='",g_ogb.ogb04,"' ",
               "   AND tlf02 = 50 ",
               "   AND tlf026='",g_oga.oga01,"' ", #出貨單號
               "   AND tlf027= ",g_ogb.ogb03,      #出貨項次
               "   AND tlf036='",g_ogb.ogb31,"' ", #訂單單號
               "   AND tlf037= ",g_ogb.ogb32,      #訂單項次
               "   AND tlf06 ='",g_oga.oga02,"' "  #出貨日期

   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql
   PREPARE tlf_4_del FROM g_sql
   EXECUTE tlf_4_del
   IF SQLCA.SQLCODE THEN
      LET g_showmsg = g_ogb.ogb01,'/',g_ogb.ogb03
      CALL s_errmsg('ogb01,ogb03',g_showmsg,'del tlf:',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      LET g_showmsg = g_ogb.ogb01,'/',g_ogb.ogb03
      CALL s_errmsg('ogb01,ogb03',g_showmsg,'del tlf:','axm-176',1)
      LET g_success='N' 
      RETURN
   END IF
    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
       IF NOT s_untlf1('') THEN 
          LET g_success='N' RETURN
       END IF 
    END FOR 
END FUNCTION

FUNCTION t595_tlff_2()#------------------------------------------ Update tlf_file

   LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant2,'tlff_file'),
               " WHERE tlff01 ='",g_ogb.ogb04,"'",
               "   AND tlff02 =50 ",
               "   AND tlff026='",g_oga.oga01,"' ", #出貨單號
               "   AND tlff027= ",g_ogb.ogb03,      #出貨項次
               "   AND tlff036='",g_ogb.ogb31,"' ", #訂單單號
               "   AND tlff037= ",g_ogb.ogb32,      #訂單項次
               "   AND tlff06 ='",g_oga.oga02,"' " #出貨日期
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,g_plant2) RETURNING g_sql   #carrier  check
   PREPARE tlff_2_del FROM g_sql
   EXECUTE tlff_2_del
   IF SQLCA.sqlcode THEN
      LET g_showmsg = g_oga.oga01,'/',g_ogb.ogb03
      CALL s_errmsg('ogb01,ogb03',g_showmsg,'del tlff:',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      LET g_showmsg = g_oga.oga01,'/',g_ogb.ogb03
      CALL s_errmsg('ogb01,ogb03',g_showmsg,'del tlff:','axm-176',1)
      LET g_success='N'
      RETURN
   END IF
END FUNCTION

#-------------- INSERT INTO ina_file ------------------------------------------

FUNCTION t595_ins_ina(p_no)
 DEFINE l_lrf       RECORD LIKE lrf_file.*
 DEFINE l_inb       RECORD LIKE inb_file.*
 DEFINE l_cnt       LIKE type_file.num5
 DEFINE l_sno       LIKE inb_file.inb03
 DEFINE li_result   LIKE type_file.num5
 DEFINE l_unit1     LIKE img_file.img09
 DEFINE p_no        LIKE ina_file.ina01
 DEFINE l_inbi      RECORD LIKE inbi_file.*  
 DEFINE l_lpx32     LIKE lpx_file.lpx32
 DEFINE l_rcj03     LIKE rtj_file.rtj03
 DEFINE l_rtz07     LIKE rtz_file.rtz07
 DEFINE l_rtz08     LIKE rtz_file.rtz08
 DEFINE l_warehouse LIKE rtz_file.rtz07
   
   IF cl_null(p_no) THEN RETURN '' END IF
   SELECT * INTO g_lrj.* FROM lrj_file WHERE lrj01=p_no

   CALL t595_sys()  #取系統參數
   
   INITIALIZE g_ina.* TO NULL
   LET g_ina.ina00   = '1'
   LET g_ina.ina02   = g_today
   LET g_ina.ina03   = g_today
   LET g_ina.ina04   = g_grup
   LET g_ina.ina10   = p_no
   LET g_ina.ina11   = g_user
   LET g_ina.ina08   = '1'
   LET g_ina.ina11   = g_user           
   LET g_ina.inaprsw = 0
   LET g_ina.inapost = 'N'
   LET g_ina.inaconf = 'Y'
   LET g_ina.inacond = g_today
   LET g_ina.inaconu = g_user
   LET g_ina.inacont = TIME
   LET g_ina.inauser = g_user           
   LET g_ina.inagrup = g_grup
   LET g_ina.inamodu = ''
   LET g_ina.inadate = g_today
   LET g_ina.inamksg = 'N'
   LET g_ina.inaplant = g_plant
   LET g_ina.inalegal = g_legal
   LET g_ina.ina12 = 'N'
   LET g_ina.inapos = 'N'
   LET g_ina.inaoriu = g_user
   LET g_ina.inaorig = g_grup
   
   CALL t595_sel_rye('2') RETURNING g_ina.ina01
   IF cl_null(g_ina.ina01) THEN
      LET g_success = 'N'
      RETURN ''
   END IF
   
   CALL s_auto_assign_no("aim",g_ina.ina01,g_ina.ina03,'1',"ina_file","ina01","","","")
       RETURNING li_result,g_ina.ina01

   INSERT INTO ina_file VALUES(g_ina.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ina01',g_ina.ina01,'ina_ins',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN ''
   END IF
   
   LET l_sno = 1
   DECLARE lrf_curs2 CURSOR FOR
    SELECT * FROM lrf_file
     WHERE lrf01 = g_lrj.lrj01
   FOREACH lrf_curs2 INTO l_lrf.*
      LET l_cnt = 0

      SELECT lpx32 INTO l_lpx32 FROM lpx_file
        WHERE lpx01 = (SELECT lqe02 FROM lqe_file WHERE lqe01 = l_lrf.lrf02)
      
      LET l_inb.inb01  = g_ina.ina01
      LET l_inb.inb03 = l_sno
      LET l_inb.inb04 = l_lpx32
      SELECT COUNT(*) INTO l_cnt FROM ima_file
       WHERE ima01 = l_inb.inb04
         AND imaacti ='Y'
      IF l_cnt = 0 THEN
         CONTINUE FOREACH
      END IF
      LET l_sno = l_sno + 1
      SELECT rcj03 INTO l_rcj03 FROM rcj_file
      IF cl_null(l_rcj03) THEN
         CALL cl_err('','alm1442',0)
         RETURN
      END IF

      #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file WHERE rtz01 = g_plant     #FUN-C90049 mark
      CALL s_get_defstore(g_plant,l_inb.inb04) RETURNING l_rtz07,l_rtz08               #FUN-C90049 add

      IF l_rcj03 = '1' AND cl_null(l_rtz07) THEN
         CALL cl_err(g_plant,'alm1443',0)
         RETURN
      END IF
      IF l_rcj03 = '2' AND cl_null(l_rtz08) THEN
         CALL cl_err(g_plant,'alm1444',0)
         RETURN
      END IF
      IF l_rcj03 = '1' THEN
         LET l_warehouse = l_rtz07
      ELSE
         LET l_warehouse = l_rtz08
      END IF
      LET l_inb.inb05 = l_warehouse
      LET l_inb.inb06 = ' '
      LET l_inb.inb07 = ' '
      SELECT ima25 INTO l_inb.inb08            #單位
         FROM ima_file
          WHERE ima01 = l_lpx32      
     #LET l_inb.inb08 = 'PCS'   #單位
      LET l_inb.inb09 = 1       #數量
      LET l_unit1 = NULL
      SELECT img09 INTO l_unit1 FROM img_file
       WHERE img01 = l_inb.inb04 AND img02 = l_inb.inb05
         AND img03 = l_inb.inb06 AND img04 = l_inb.inb07
      
      #異動(inb08)/庫存單位(img09)
      CALL  s_umfchk(l_inb.inb04,l_inb.inb08,l_unit1)
         RETURNING l_cnt,l_inb.inb08_fac
      IF l_cnt = 1 THEN
         CALL cl_err('','mfg3075',0)
         LET l_inb.inb08_fac = 0
      END IF
      
      LET l_inb.inb10  = 'N' 
      LET l_inb.inb11  = ''
      LET l_inb.inb12  = ''
      LET l_inb.inb13  = 0
      LET l_inb.inb132 = 0
      LET l_inb.inb133 = 0
      LET l_inb.inb134 = 0
      LET l_inb.inb135 = 0
      LET l_inb.inb136 = 0
      LET l_inb.inb137 = 0
      LET l_inb.inb138 = 0
      LET l_inb.inb14  = 0
      LET l_inb.inb15  = g_oaz.oaz91
      LET l_inb.inb901 = ''
      LET l_inb.inb902 = l_inb.inb08
      LET l_inb.inb903 = l_inb.inb08_fac
      LET l_inb.inb904 = l_inb.inb09
      LET l_inb.inb905 = ''
      LET l_inb.inb906 = ''
      LET l_inb.inb907 = ''
      LET l_inb.inb930 = s_costcenter(g_ina.ina04)
      LET l_inb.inb41 = ''   #專案
      LET l_inb.inb42 = ''  #WBS
      LET l_inb.inb43 = ''   #活動
      LET l_inb.inb16 = l_inb.inb09
      LET l_inb.inbplant = g_plant
      LET l_inb.inblegal = g_legal
     
     #FUN-CB0087-xj---add---str
      IF g_aza.aza115 = 'Y' THEN
        CALL s_reason_code(g_ina.ina01,g_ina.ina10,'',l_inb.inb04,l_inb.inb05,g_ina.ina04,g_ina.ina11) RETURNING l_inb.inb15
        IF cl_null(l_inb.inb15) THEN
           CALL cl_err('','aim-425',1)
           LET g_success = 'N'
           RETURN ''
        END IF
      END IF
     #FUN-CB0087-xj---add---end 
      INSERT INTO inb_file VALUES(l_inb.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ina01',g_ina.ina01,'inb_ins',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN ''
     ELSE
        IF NOT s_industry('std') THEN
           INITIALIZE l_inbi.* TO NULL
           LET l_inbi.inbi01 = l_inb.inb01
           LET l_inbi.inbi03 = l_inb.inb03
           IF NOT s_ins_inbi(l_inbi.*,l_inb.inbplant ) THEN
              LET g_success = 'N'
              RETURN ''
        END IF
     END IF 
      END IF
   END FOREACH
  
   IF g_success = 'Y' THEN
      CALL t595_s_chk(g_ina.ina01)
      IF g_success = 'Y' THEN
         CALL t595_s_upd(g_ina.ina01)
      END IF
   END IF
   RETURN g_ina.ina01
END FUNCTION

FUNCTION t595_s_chk(l_ina01)
DEFINE l_ina01   LIKE ina_file.ina01
DEFINE l_yy,l_mm LIKE type_file.num5
DEFINE l_inb05   LIKE inb_file.inb05
DEFINE l_inb06   LIKE inb_file.inb06
DEFINE l_inb03   LIKE inb_file.inb03
DEFINE l_flag1   LIKE type_file.chr1
 
   DECLARE t370_s_chk1 CURSOR FOR SELECT inb03,inb05,inb06 FROM inb_file 
                                   WHERE inb01=l_ina01
   FOREACH t370_s_chk1 INTO l_inb03,l_inb05,l_inb06                              
      CALL s_incchk(l_inb05,l_inb06,g_user) 
           RETURNING l_flag1
      IF l_flag1 = FALSE THEN
         LET g_success='N'
         LET g_showmsg=l_inb03,"/",l_inb05,"/",l_inb06,"/",g_user
         CALL s_errmsg('inb03,inb05,inb06,inc03',g_showmsg,'','asf-888',1)
      END IF
   END FOREACH
   IF g_success='N' THEN
      RETURN
   END IF

   LET g_ina.ina02 = g_today
   IF g_sma.sma53 IS NOT NULL AND g_ina.ina02 <= g_sma.sma53 THEN
      CALL s_errmsg('ina01',l_ina01,'ina02','mfg9999',1)
      LET g_success = 'N'
      RETURN   
   END IF
 
   CALL s_yp(g_ina.ina02) RETURNING l_yy,l_mm
 
   IF l_yy > g_sma.sma51 THEN      # 與目前會計年度,期間比較
      CALL s_errmsg('ina01',l_yy,'ina02','mfg6090',1)
      LET g_success = 'N'
      RETURN
   ELSE
      IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN
         CALL s_errmsg('ina01',l_mm,'ina02','mfg6091',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
END FUNCTION

FUNCTION t595_s_upd(p_ina01)
  DEFINE l_ina02   LIKE ina_file.ina02
  DEFINE l_ima906  LIKE ima_file.ima906
  DEFINE l_yy,l_mm LIKE type_file.num5
  DEFINE g_imm01   LIKE imm_file.imm01
  DEFINE p_ina01   LIKE ina_file.ina01
  
   LET g_ina.ina01 = p_ina01
   SELECT * INTO g_ina.* FROM ina_file WHERE ina01 = g_ina.ina01
   LET g_ina.ina02=g_today
   LET g_prog_o = g_prog   #MOD-C80258 add   #利用g_prog_o 紀錄原本g_prog值 
   LET g_prog = 'aimt301'
   CALL t595_s2()
  #LET g_prog = 'almt595'  #MOD-C80258 mark 
   LET g_prog = g_prog_o   #MOD-C80258 add
 
   IF g_success = 'Y' THEN
      UPDATE ina_file SET inapost = 'Y',ina02=g_ina.ina02
       WHERE ina01=g_ina.ina01 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"","upd inapost",1)
         LET g_success = 'N'
         LET g_ina.inapost = 'N'
         RETURN
      ELSE
         LET g_ina.inapost = 'Y'
      END IF
   END IF
 
   IF (g_ina.inapost = "N") THEN
      DECLARE t370_s1_c3 CURSOR FOR SELECT * FROM inb_file
                                     WHERE inb01 = g_ina.ina01 
 
      LET g_imm01 = ""
      LET g_success = "Y"
 
      FOREACH t370_s1_c3 INTO g_inb.*
         IF STATUS THEN
            EXIT FOREACH
         END IF
         SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_inb.inb04
         IF g_sma.sma115 = 'Y' THEN
            IF l_ima906 = '2' THEN  #子母單位
 
               LET g_unit_arr[1].unit= g_inb.inb902
               LET g_unit_arr[1].fac = g_inb.inb903
               LET g_unit_arr[1].qty = g_inb.inb904
               LET g_unit_arr[2].unit= g_inb.inb905
               LET g_unit_arr[2].fac = g_inb.inb906
               LET g_unit_arr[2].qty = g_inb.inb907
               IF g_ina.ina00 MATCHES '[1256]' THEN
                  CALL s_dismantle(g_ina.ina01,g_inb.inb03,g_ina.ina02,
                                   g_inb.inb04,g_inb.inb05,g_inb.inb06,
                                   g_inb.inb07,g_unit_arr,g_imm01)
                         RETURNING g_imm01
                  IF g_success='N' THEN
                     LET g_totsuccess='N'
                     LET g_success="Y"
                     CONTINUE FOREACH
                  END IF
               END IF
            END IF
         END IF
      END FOREACH
   END IF
 
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
END FUNCTION

FUNCTION t595_s2()
   DEFINE l_dt     LIKE type_file.dat
   DEFINE l_smg    STRING

   CALL s_showmsg_init()
 
   DECLARE t370_s1_c CURSOR FOR
    SELECT * FROM inb_file
     WHERE inb01=g_ina.ina01
   FOREACH t370_s1_c INTO g_inb.*
      IF STATUS THEN
         EXIT FOREACH
      END IF
 
      IF cl_null(g_inb.inb04) THEN
         CONTINUE FOREACH
      END IF
      
      IF g_argv1 MATCHES '[1256]' THEN
         LET l_dt = g_ina.ina02
         IF l_dt IS NULL THEN
            LET l_dt = g_ina.ina03
         END IF
      #FUN-D30024 ---------Begin------------
      #  IF NOT s_stkminus(g_inb.inb04,g_inb.inb05,g_inb.inb06,g_inb.inb07,
      #                    g_inb.inb09,g_inb.inb08_fac,l_dt,g_sma.sma894[1,1]) THEN
         IF NOT s_stkminus(g_inb.inb04,g_inb.inb05,g_inb.inb06,g_inb.inb07,
                           g_inb.inb09,g_inb.inb08_fac,l_dt) THEN
      #FUN-D30024 ---------End-------------
            LET g_totsuccess="N"
            CONTINUE FOREACH
         END IF
      END IF

      IF g_sma.sma115 = 'Y' THEN
         CALL t370_update_du()
      END IF
      
      IF g_argv1 MATCHES '[12]' THEN
         CALL s_updsie_sie(g_inb.inb01,g_inb.inb03,'3')
      END IF

      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF
 
      CALL t370_update(g_inb.inb05,g_inb.inb06,g_inb.inb07,
                       g_inb.inb09,g_inb.inb08,g_inb.inb08_fac)
 
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF
   END FOREACH
 
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
END FUNCTION

FUNCTION t370_update_du()
   DEFINE l_ima25   LIKE ima_file.ima25
   DEFINE u_type    LIKE type_file.num5 
 
   SELECT ima906 INTO g_ima906 FROM ima_file
    WHERE ima01 = g_inb.inb04
   IF g_ima906 = '1' OR g_ima906 IS NULL THEN
      RETURN
   END IF
 
   CASE WHEN g_ina.ina00 MATCHES "[12]" LET u_type=-1
	      WHEN g_ina.ina00 MATCHES "[34]" LET u_type=+1
	      WHEN g_ina.ina00 MATCHES "[56]" LET u_type=0
   END CASE
 
   SELECT ima25 INTO l_ima25 FROM ima_file
    WHERE ima01=g_inb.inb04
   IF SQLCA.sqlcode THEN
         CALL s_errmsg('inb04',g_inb.inb04,'Select ima25:',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN
   END IF
 
   IF g_ima906 = '2' THEN  #子母單位
      LET g_unit_arr[1].unit=g_inb.inb902
      LET g_unit_arr[1].fac =g_inb.inb903
      LET g_unit_arr[1].qty =g_inb.inb904
      LET g_unit_arr[2].unit=g_inb.inb905
      LET g_unit_arr[2].fac =g_inb.inb906
      LET g_unit_arr[2].qty =g_inb.inb907
      IF NOT cl_null(g_inb.inb905) THEN
         CALL t370_upd_imgg('1',g_inb.inb04,g_inb.inb05,g_inb.inb06,
                         g_inb.inb07,g_inb.inb905,g_inb.inb906,g_inb.inb907,u_type,'2')
         IF g_success='N' THEN
            RETURN
         END IF
         IF NOT cl_null(g_inb.inb907) THEN
 
            CALL t370_tlff(g_inb.inb05,g_inb.inb06,g_inb.inb07,l_ima25,
                           g_inb.inb907,0,g_inb.inb905,g_inb.inb906,u_type,'2')
            IF g_success='N' THEN
               RETURN
            END IF
         END IF
      END IF
      IF NOT cl_null(g_inb.inb902) THEN
         CALL t370_upd_imgg('1',g_inb.inb04,g_inb.inb05,g_inb.inb06,
                            g_inb.inb07,g_inb.inb902,g_inb.inb903,g_inb.inb904,u_type,'1')
         IF g_success='N' THEN
            RETURN
         END IF
         IF NOT cl_null(g_inb.inb904) THEN
            CALL t370_tlff(g_inb.inb05,g_inb.inb06,g_inb.inb07,l_ima25,
                           g_inb.inb904,0,g_inb.inb902,g_inb.inb903,u_type,'1')
            IF g_success='N' THEN
               RETURN
            END IF
         END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(g_inb.inb905) THEN
         CALL t370_upd_imgg('2',g_inb.inb04,g_inb.inb05,g_inb.inb06,
                            g_inb.inb07,g_inb.inb905,g_inb.inb906,g_inb.inb907,u_type,'2')
         IF g_success = 'N' THEN
            RETURN
         END IF
         IF NOT cl_null(g_inb.inb907) THEN
            CALL t370_tlff(g_inb.inb05,g_inb.inb06,g_inb.inb07,l_ima25,
                           g_inb.inb907,0,g_inb.inb905,g_inb.inb906,u_type,'2')
            IF g_success='N' THEN
               RETURN
            END IF
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t370_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no)
  DEFINE p_imgg00   LIKE imgg_file.imgg00,
         p_imgg01   LIKE imgg_file.imgg01,
         p_imgg02   LIKE imgg_file.imgg02,
         p_imgg03   LIKE imgg_file.imgg03,
         p_imgg04   LIKE imgg_file.imgg04,
         p_imgg09   LIKE imgg_file.imgg09,
         p_imgg10   LIKE imgg_file.imgg10,
         p_imgg211  LIKE imgg_file.imgg211,
         l_ima25    LIKE ima_file.ima25,
         l_ima906   LIKE ima_file.ima906,
         l_imgg21   LIKE imgg_file.imgg21,
         p_no       LIKE type_file.chr1,
         p_type     LIKE type_file.num10
 
    LET g_forupd_sql =
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
        "   WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "   AND imgg09= ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE imgg_lock1 CURSOR FROM g_forupd_sql
 
    OPEN imgg_lock1 USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg('imgg01',p_imgg01,'OPEN imgg_lock:',STATUS,1)
       ELSE
          CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       END IF
       LET g_success='N'
       CLOSE imgg_lock1
       RETURN
    END IF
    FETCH imgg_lock1 INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg('imgg01',p_imgg01,'lock imgg fail',STATUS,1)
       ELSE
          CALL cl_err('lock imgg fail',STATUS,1)
       END IF
       LET g_success='N'
       CLOSE imgg_lock1
       RETURN
    END IF
 
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       IF g_bgerr THEN
          CALL s_errmsg('ima01',p_imgg01,'ima25 null',SQLCA.sqlcode,0)
       ELSE
          CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"",
                       "sel",1)
       END IF
       LET g_success = 'N'
       RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       IF g_bgerr THEN
          LET g_showmsg = p_imgg01,"/",p_imgg09,"/",l_ima25
          CALL s_errmsg('imgg01,imgg09,ima25',g_showmsg,'','mfg3075',0)
       ELSE
          CALL cl_err('imgg01','mfg3075',0)
       END IF
       LET g_success = 'N'
       RETURN
    END IF
 
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_ina.ina02, 
          p_imgg01,p_imgg02,p_imgg03,p_imgg04,'',g_ina.ina01,g_inb.inb03,'',p_imgg09,'',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION t370_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                   u_type,p_flag)
DEFINE
    p_ware     LIKE img_file.img02,       ##倉庫
    p_loca     LIKE img_file.img03,       ##儲位
    p_lot      LIKE img_file.img04,       ##批號
    p_unit     LIKE img_file.img09,
    p_qty      LIKE img_file.img10,       ##數量
    p_img10    LIKE img_file.img10,       ##異動後數量
    p_uom      LIKE img_file.img09,       ##img 單位
    p_factor   LIKE img_file.img21,       ##轉換率
    l_imgg10   LIKE imgg_file.imgg10,
    u_type     LIKE type_file.num5,       ##+1:雜收 -1:雜發  0:報廢
    p_flag     LIKE type_file.chr1,
    g_cnt      LIKE type_file.num5
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
    IF cl_null(p_qty)  THEN LET p_qty=0    END IF
 
    IF p_uom IS NULL THEN
       IF g_bgerr THEN
          CALL s_errmsg('img09',p_uom,'p_uom null','asf-031',1)
       ELSE
          CALL cl_err('p_uom null:','asf-031',1)
       END IF
       LET g_success = 'N'
       RETURN
    END IF
 
    SELECT imgg10 INTO l_imgg10 FROM imgg_file
     WHERE imgg01=g_inb.inb04 AND imgg02=p_ware
       AND imgg03=p_loca      AND imgg04=p_lot
       AND imgg09=p_uom
    IF cl_null(l_imgg10) THEN
       LET l_imgg10 = 0
    END IF
 
    INITIALIZE g_tlff.* TO NULL
    LET g_tlff.tlff01=g_inb.inb04         #異動料件編號
    IF g_ina.ina00 MATCHES "[34]" THEN
       #----來源----
       LET g_tlff.tlff02=90
       LET g_tlff.tlff026=g_inb.inb11        #來源單號
       #---目的----
       LET g_tlff.tlff03=50                  #'Stock'
       LET g_tlff.tlff030=g_plant
       LET g_tlff.tlff031=p_ware             #倉庫
       LET g_tlff.tlff032=p_loca             #儲位
       LET g_tlff.tlff033=p_lot              #批號
       #**該數量錯誤*****
       LET g_tlff.tlff034=l_imgg10           #異動後數量
       LET g_tlff.tlff035=p_unit             #庫存單位(ima_file or img_file)
       LET g_tlff.tlff036=g_inb.inb01        #雜收單號
       LET g_tlff.tlff037=g_inb.inb03        #雜收項次
    END IF
    IF g_ina.ina00 MATCHES "[1256]" THEN
       #----來源----
       LET g_tlff.tlff02=50                  #'Stock'
       LET g_tlff.tlff020=g_plant
       LET g_tlff.tlff021=p_ware             #倉庫
       LET g_tlff.tlff022=p_loca             #儲位
       LET g_tlff.tlff023=p_lot              #批號
       LET g_tlff.tlff024=l_imgg10           #異動後數量
       LET g_tlff.tlff025=p_unit             #庫存單位(ima_file or img_file)
       LET g_tlff.tlff026=g_inb.inb01        #雜發/報廢單號
       LET g_tlff.tlff027=g_inb.inb03        #雜發/報廢項次
       #---目的----
       IF g_ina.ina00 MATCHES "[12]"
          THEN LET g_tlff.tlff03=90
          ELSE LET g_tlff.tlff03=40
       END IF
       LET g_tlff.tlff036=g_inb.inb11        #目的單號
    END IF
    LET g_tlff.tlff04= ' '             #工作站
    LET g_tlff.tlff05= ' '             #作業序號
    LET g_tlff.tlff06=g_ina.ina02      #發料日期
    LET g_tlff.tlff07=g_today          #異動資料產生日期
    LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user           #產生人
    LET g_tlff.tlff10=p_qty            #異動數量
    LET g_tlff.tlff11=p_uom	       #發料單位
    LET g_tlff.tlff12=p_factor         #發料/庫存 換算率
    CASE WHEN g_ina.ina00 = '1' LET g_tlff.tlff13='aimt301'
         WHEN g_ina.ina00 = '2' LET g_tlff.tlff13='aimt311'
         WHEN g_ina.ina00 = '3' LET g_tlff.tlff13='aimt302'
         WHEN g_ina.ina00 = '4' LET g_tlff.tlff13='aimt312'
         WHEN g_ina.ina00 = '5' LET g_tlff.tlff13='aimt303'
         WHEN g_ina.ina00 = '6' LET g_tlff.tlff13='aimt313'
    END CASE
    LET g_tlff.tlff14=g_inb.inb15              #異動原因
    LET g_tlff.tlff17=g_ina.ina07              #Remark
    LET g_tlff.tlff19=g_ina.ina04
    LET g_tlff.tlff20=g_ina.ina06              #Project code
 
    LET g_tlff.tlff62=g_inb.inb12    #參考單號
    LET g_tlff.tlff64=g_inb.inb901   #手冊編號
    LET g_tlff.tlff930=g_inb.inb930
    IF cl_null(g_inb.inb907) OR g_inb.inb907=0 THEN
       CALL s_tlff(p_flag,NULL)
    ELSE
       CALL s_tlff(p_flag,g_inb.inb905)
    END IF
END FUNCTION

FUNCTION t370_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor)
  DEFINE p_ware     LIKE img_file.img02,   #倉庫
         p_loca     LIKE img_file.img03,   #儲位
         p_lot      LIKE img_file.img04,   #批號
         p_qty      LIKE tlf_file.tlf10,   #數量
         p_uom      LIKE img_file.img09,   ##img 單位
         p_factor   LIKE ima_file.ima31_fac,   #轉換率
         u_type     LIKE type_file.num5,       # +1:雜收 -1:雜發  0:報廢  
         l_qty      LIKE img_file.img10,
         l_ima01    LIKE ima_file.ima01,
         l_ima25    LIKE ima_file.ima25,
         l_imaqty   LIKE type_file.num15_3,
         l_imafac   LIKE img_file.img21,
         l_img      RECORD
           img10    LIKE img_file.img10,
           img16    LIKE img_file.img16,
           img23    LIKE img_file.img23,
           img24    LIKE img_file.img24,
           img09    LIKE img_file.img09,
           img21    LIKE img_file.img21
                   END RECORD,
         l_cnt     LIKE type_file.num5
  DEFINE l_newerr  LIKE type_file.num5
  DEFINE l_msg     STRING
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot =' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty =0   END IF
 
    IF p_uom IS NULL THEN
       CALL s_errmsg('img09',p_uom,'p_uom null:','asf-031',1)
       LET g_success = 'N'
       RETURN
    END IF
    CALL cl_msg("update img_file ...")
 
    LET g_forupd_sql =
        "SELECT img10,img16,img23,img24,img09,img21 FROM img_file ",
        " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ?  FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock2 CURSOR FROM g_forupd_sql
 
    OPEN img_lock2 USING g_inb.inb04,p_ware,p_loca,p_lot
    IF STATUS THEN
       CALL s_errmsg('img01',g_inb.inb04,'OPEN img_lock:',STATUS,1)
       LET g_success='N'
       CLOSE img_lock2
       RETURN
    END IF
    FETCH img_lock2 INTO l_img.*
    IF STATUS THEN
       CALL s_errmsg('img01',g_inb.inb04,'lock img fail',STATUS,1)
       LET g_success='N'
       CLOSE img_lock2
       RETURN
    END IF
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF

    CASE WHEN g_ina.ina00 MATCHES "[12]" LET u_type=-1
            LET l_qty= l_img.img10 - p_qty*p_factor
	       WHEN g_ina.ina00 MATCHES "[34]" LET u_type=+1
            LET l_qty= l_img.img10 + p_qty*p_factor
	       WHEN g_ina.ina00 MATCHES "[56]" LET u_type=0
            LET l_qty= l_img.img10 - p_qty*p_factor
    END CASE
    CALL s_upimg(g_inb.inb04,p_ware,p_loca,p_lot,u_type,p_qty*p_factor,g_ina.ina02,
          '','','','',g_inb.inb01,g_inb.inb03,
          '','','','','','','','','','','','')
    IF g_success='N' THEN
       RETURN
    END IF
 
    LET g_forupd_sql =
        "SELECT ima25 FROM ima_file WHERE ima01= ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock2 CURSOR FROM g_forupd_sql
 
    OPEN ima_lock2 USING g_inb.inb04
    IF STATUS THEN
       CALL s_errmsg('ima01',g_inb.inb04,'OPEN ima_lock',STATUS,1)
       LET g_success = 'N'
       CLOSE ima_lock2
       RETURN
    END IF
 
    FETCH ima_lock2 INTO l_ima25  
    IF STATUS THEN
       CALL s_errmsg('ima01',g_inb.inb04,'lock ima fail',STATUS,1)
       LET g_success = 'N'
       CLOSE ima_lock2
       RETURN
    END IF
 
    IF g_inb.inb08=l_ima25 THEN
       LET l_imafac = 1
    ELSE
       CALL s_umfchk(g_inb.inb04,g_inb.inb08,l_ima25)
                RETURNING g_cnt,l_imafac
       IF g_cnt = 1 THEN
          LET g_showmsg = g_inb.inb04,"/",g_inb.inb08,"/",l_ima25
          CALL s_errmsg('inb04,inb08,ima25',g_showmsg,'','abm-731',1)
          LET g_success ='N'
       END IF
    END IF
 
    IF cl_null(l_imafac) THEN
       LET l_imafac = 1
    END IF
    LET l_imaqty = p_qty * l_imafac
    CALL s_udima(g_inb.inb04,l_img.img23,l_img.img24,l_imaqty,
                    g_ina.ina02,u_type)  RETURNING l_cnt
    IF g_success='N' THEN
       RETURN
    END IF

    IF g_success='Y' THEN
       CALL t370_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,
                     u_type)
    END IF
END FUNCTION
 
FUNCTION t370_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,u_type)
   DEFINE
      p_ware   LIKE img_file.img02,  #倉庫
      p_loca   LIKE img_file.img03,  #儲位
      p_lot    LIKE img_file.img04,  #批號
      p_qty    LIKE tlf_file.tlf10,
      p_uom    LIKE img_file.img09,       ##img 單位
      p_factor LIKE ima_file.ima31_fac,   ##轉換率
      p_unit   LIKE ima_file.ima25,       ##單位
      p_img10  LIKE img_file.img10,       #異動後數量
      u_type   LIKE type_file.num5,  	  # +1:雜收 -1:雜發  0:報廢
      l_sfb02  LIKE sfb_file.sfb02,
      l_sfb03  LIKE sfb_file.sfb03,
      l_sfb04  LIKE sfb_file.sfb04,
      l_sfb22  LIKE sfb_file.sfb22,
      l_sfb27  LIKE sfb_file.sfb27,
      l_sta    LIKE type_file.num5,
      g_cnt    LIKE type_file.num5
 
   INITIALIZE g_tlf.* TO NULL
   LET g_tlf.tlf01=g_inb.inb04         #異動料件編號
   IF g_ina.ina00 MATCHES "[34]" THEN
      #----來源----
      LET g_tlf.tlf02=90
      LET g_tlf.tlf026=g_inb.inb11        #來源單號
      #---目的----
      LET g_tlf.tlf03=50                  #'Stock'
      LET g_tlf.tlf030=g_plant
      LET g_tlf.tlf031=p_ware             #倉庫
      LET g_tlf.tlf032=p_loca             #儲位
      LET g_tlf.tlf033=p_lot              #批號
      LET g_tlf.tlf034=p_img10            #異動後數量
      LET g_tlf.tlf035=p_unit             #庫存單位(ima_file or img_file)
      LET g_tlf.tlf036=g_inb.inb01        #雜收單號
      LET g_tlf.tlf037=g_inb.inb03        #雜收項次
   END IF
   IF g_ina.ina00 MATCHES "[1256]" THEN
      #----來源----
      LET g_tlf.tlf02=50                  #'Stock'
      LET g_tlf.tlf020=g_plant
      LET g_tlf.tlf021=p_ware             #倉庫
      LET g_tlf.tlf022=p_loca             #儲位
      LET g_tlf.tlf023=p_lot              #批號
      LET g_tlf.tlf024=p_img10            #異動後數量
      LET g_tlf.tlf025=p_unit             #庫存單位(ima_file or img_file)
      LET g_tlf.tlf026=g_inb.inb01        #雜發/報廢單號
      LET g_tlf.tlf027=g_inb.inb03        #雜發/報廢項次
      #---目的----
      IF g_ina.ina00 MATCHES "[12]"
         THEN LET g_tlf.tlf03=90
         ELSE LET g_tlf.tlf03=40
      END IF
      LET g_tlf.tlf036=g_inb.inb11        #目的單號
   END IF
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=g_ina.ina02      #發料日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=p_qty            #異動數量
   LET g_tlf.tlf11=p_uom	          #發料單位
   LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
	CASE WHEN g_ina.ina00 = '1' LET g_tlf.tlf13='aimt301'
	     WHEN g_ina.ina00 = '2' LET g_tlf.tlf13='aimt311'
	     WHEN g_ina.ina00 = '3' LET g_tlf.tlf13='aimt302'
	     WHEN g_ina.ina00 = '4' LET g_tlf.tlf13='aimt312'
	     WHEN g_ina.ina00 = '5' LET g_tlf.tlf13='aimt303'
	     WHEN g_ina.ina00 = '6' LET g_tlf.tlf13='aimt313'
	END CASE
   LET g_tlf.tlf14=g_inb.inb15              #異動原因
   LET g_tlf.tlf17=g_ina.ina07              #Remark
   LET g_tlf.tlf19=g_ina.ina04
   LET g_tlf.tlf20=g_inb.inb41
   LET g_tlf.tlf41=g_inb.inb42
   LET g_tlf.tlf42=g_inb.inb43
   LET g_tlf.tlf43=g_inb.inb15
 
   LET g_tlf.tlf62=g_inb.inb12    #參考單號
   LET g_tlf.tlf64=g_inb.inb901   #手冊編號
   LET g_tlf.tlf930=g_inb.inb930
   CALL s_tlf(1,0)
END FUNCTION

#開窗選取單別
FUNCTION t595_sel_rye(p_cmd)
 DEFINE p_cmd       LIKE type_file.chr1
 DEFINE l_oga01     LIKE oga_file.oga01
 DEFINE l_ina01     LIKE ina_file.ina01
 DEFINE li_result   LIKE type_file.num5

   OPEN WINDOW t5951_w WITH FORM "alm/42f/almt6051"
     ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("almt6051")

   #FUN-C90050 mark beign---
   #IF p_cmd = '1' THEN
   #   CALL cl_set_comp_visible("ina01",FALSE)
   #   SELECT rye03 INTO l_oga01 FROM rye_file
   #    WHERE rye01 = 'axm' AND rye02 = '50'
   #ELSE
   #   CALL cl_set_comp_visible("oga01",FALSE)
   #   SELECT rye03 INTO l_ina01 FROM rye_file
   #    WHERE rye01 = 'aim' AND rye02 = '1'
   #END IF
   #FUN-C90050 mark end-----
   
   #FUN-C90050 add begin---
   IF p_cmd = '1' THEN
      CALL cl_set_comp_visible("ina01",FALSE)
      CALL s_get_defslip('axm','50',g_plant,'N') RETURNING l_oga01
   ELSE
      CALL cl_set_comp_visible("oga01",FALSE)
      CALL s_get_defslip('aim','1',g_plant,'N') RETURNING l_ina01
   END IF
   #FUN-C90050 add end-----

   IF p_cmd = '1' THEN
      DISPLAY l_oga01 TO oga01
   ELSE
      DISPLAY l_ina01 TO ina01
   END IF
   INPUT l_oga01,l_ina01 WITHOUT DEFAULTS FROM oga01,ina01
      BEFORE INPUT

      AFTER FIELD oga01
         IF NOT cl_null(l_oga01) THEN
            CALL s_check_no("axm",l_oga01,"",'50',"oga_file","oga01","")
               RETURNING li_result,l_oga01
            IF NOT li_result THEN
               NEXT FIELD oga01
            END IF
         END IF

      AFTER FIELD ina01
         IF NOT cl_null(l_ina01) THEN
            CALL s_check_no("aim",l_ina01,"",'1',"ina_file","ina01","")
               RETURNING li_result,l_ina01
            IF NOT li_result THEN
               NEXT FIELD oga01
            END IF
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON ACTION controlp
         CASE
            WHEN INFIELD(oga01)
               CALL q_oay(FALSE,FALSE,l_oga01,'50','axm') RETURNING l_oga01
               DISPLAY l_oga01 TO oga01
               NEXT FIELD oga01
            WHEN INFIELD(ina01)
               CALL q_smy(FALSE,FALSE,l_ina01,'AIM','1') RETURNING l_ina01
               DISPLAY l_ina01 TO ina01
               NEXT FIELD ina01
            OTHERWISE EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CALL cl_err('',9001,0)
      CLOSE WINDOW t5951_w
      RETURN ''
   END IF
   CLOSE WINDOW t5951_w
   IF p_cmd = '1' THEN
      RETURN l_oga01
   ELSE
      RETURN l_ina01
   END IF
END FUNCTION

FUNCTION t595_ins_ogi(p_ogi01,p_ogi02,p_ogb04)
DEFINE p_ogi01             LIKE ogi_file.ogi01
DEFINE p_ogi02             LIKE ogi_file.ogi02
DEFINE p_ogb04             LIKE ogb_file.ogb04
DEFINE l_ogi    RECORD     LIKE ogi_file.*
DEFINE l_sql               STRING
DEFINE l_rte08             LIKE rte_file.rte08
DEFINE l_rtz04             LIKE rtz_file.rtz04
DEFINE l_rvy05             LIKE rvy_file.rvy05
DEFINE l_rvy04             LIKE rvy_file.rvy04    #FUN-C50085

   SELECT rtz04 INTO l_rtz04
     FROM rtz_file WHERE rtz01 = g_plant

  #FUN-C50085 add START
   LET l_sql = " SELECT rvy04,rvy05 ",
               "   FROM rvy_file ,rte_file ",
               "     WHERE rte03 = '",p_ogb04,"' AND rvy01 = '",l_rtz04,"' ",
               "       AND rte01 = rvy01 AND rte02 = rvy02 "
   PREPARE rvy_pre FROM l_sql
   DECLARE rvy_cs CURSOR FOR rvy_pre
   FOREACH rvy_cs INTO l_ogi.ogi04,l_rvy05
  #FUN-C50085 add END
   
      LET l_ogi.ogi01 = p_ogi01
      LET l_ogi.ogi02 = p_ogi02
 
      SELECT MAX(ogi03) INTO l_ogi.ogi03 FROM ogi_file
         WHERE ogi01 = l_ogi.ogi01  
      IF cl_null(l_ogi.ogi03) OR l_ogi.ogi03 = 0 THEN
         LET l_ogi.ogi03 = 1
      ELSE
         LET l_ogi.ogi03 = l_ogi.ogi03 + 1 
      END IF
     #FUN-C50085 mark START
     #SELECT rvy04,rvy05 INTO l_ogi.ogi04,l_rvy05 
     #   FROM rvy_file ,rte_file
     #   WHERE rte03 = p_ogb04 
     #     AND rvy01 = l_rtz04 
     #     AND rte01 = rvy01
     #     AND rte02 = rvy02
     #FUN-C50085 mark END
                         
         SELECT gec04 INTO l_ogi.ogi05 FROM gec_file
         WHERE gec01 = l_ogi.ogi04  
           AND gec011 = l_rvy05
     
      LET l_ogi.ogi06 = 0
      LET l_ogi.ogi07 = 'Y'
      LET l_ogi.ogi08 = 0
      LET l_ogi.ogi08t = 0
      LET l_ogi.ogi09 = 0
      LET l_ogi.ogidate = g_today
      LET l_ogi.ogigrup = g_grup
      LET l_ogi.ogimodu = g_user
      LET l_ogi.ogiuser = g_user
      LET l_ogi.ogioriu = g_user 
      LET l_ogi.ogiorig = g_grup 
      LET l_ogi.ogiplant = g_plant
      LET l_ogi.ogilegal = g_legal
      INSERT INTO ogi_file VALUES(l_ogi.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','',g_oga.oga01,SQLCA.sqlcode,1)
         LET g_success="N"
      END IF
   END FOREACH   #FUN-C50085 add
END FUNCTION

FUNCTION t595_ins_ogh(p_ogh01,p_ogb04)
DEFINE p_ogh01             LIKE ogh_file.ogh01
DEFINE p_ogh02             LIKE ogh_file.ogh02
DEFINE p_ogb04             LIKE ogb_file.ogb04
DEFINE l_ogh    RECORD     LIKE ogh_file.*
DEFINE l_sql               STRING
DEFINE l_rte08             LIKE rte_file.rte08
DEFINE l_rtz04             LIKE rtz_file.rtz04
DEFINE l_rvy05             LIKE rvy_file.rvy05
DEFINE l_ogi04             LIKE ogi_file.ogi04 
DEFINE l_ogi05             LIKE ogi_file.ogi05
DEFINE l_ogi06             LIKE ogi_file.ogi06
DEFINE l_ogi07             LIKE ogi_file.ogi07
DEFINE l_ogi08             LIKE ogi_file.ogi08
DEFINE l_ogi08t            LIKE ogi_file.ogi08t
DEFINE l_ogi09             LIKE ogi_file.ogi09

  #SELECT rtz04 INTO l_rtz04
  #  FROM rtz_file WHERE rtz01 = g_plant


  #SELECT rtz04 INTO l_rtz04
  #  FROM rtz_file WHERE rtz01 = g_plant

  #SELECT rvy04,rvy05 INTO l_ogh.ogh03,l_rvy05
  #   FROM rvy_file, rte_file
  #   WHERE rte03 = p_ogb04
  #     AND rvy01 = l_rtz04                    
  #     AND rte01 = rvy01
  #     AND rte02 = rvy02

  #SELECT gec04 INTO l_ogh.ogh04 FROM gec_file
  #   WHERE gec01 = l_ogh.ogh03
  #     AND gec011 = l_rvy05

   LET l_sql = " SELECT ogi04,ogi05,ogi06,ogi07,SUM(ogi08),SUM(ogi08t),SUM(ogi09)",
               "   FROM ogi_file",
               "  WHERE ogi01 = '",p_ogh01,"'",
               "    AND ogiplant = '",g_plant,"'",
               "  GROUP BY ogi04,ogi05,ogi06,ogi07",
               "  ORDER BY ogi05 asc,ogi06 desc"
   PREPARE t620_sel_ogi FROM l_sql
   DECLARE t620_sel_ogi_cs CURSOR FOR t620_sel_ogi
   FOREACH t620_sel_ogi_cs INTO l_ogi04,l_ogi05,l_ogi06,l_ogi07,l_ogi08,l_ogi08t,l_ogi09

      LET l_ogh.ogh01 = p_ogh01              #單號
      SELECT MAX(ogh02) INTO l_ogh.ogh02 FROM ogh_file WHERE ogh01 = p_ogh01
      IF cl_null(l_ogh.ogh02) OR l_ogh.ogh02 = 0  THEN
         LET l_ogh.ogh02 = 0
      END IF
      LET l_ogh.ogh02 = l_ogh.ogh02 + 1      #序號
      LET l_ogh.ogh03 = l_ogi04              #稅別
      LET l_ogh.ogh04 = l_ogi05              #稅率
      LET l_ogh.ogh05 = l_ogi06              #固定稅額 
      LET l_ogh.ogh06 = l_ogi07              #含稅否
      LET l_ogh.ogh07 = l_ogi08              #未稅金額
      LET l_ogh.ogh07t = l_ogi08t            #含稅金額
      LET l_ogh.ogh08 = l_ogi09              #稅額
      LET l_ogh.ogh09 = 0                    #留抵稅額
      LET l_ogh.oghdate = g_today            #修改日
      LET l_ogh.oghgrup = g_grup             #資料所有部門
      LET l_ogh.oghmodu = g_user             #修改者
      LET l_ogh.oghuser = g_user             #所有者
      LET l_ogh.oghoriu = g_user             #建立者 
      LET l_ogh.oghorig = g_grup             #建立部門
      LET l_ogh.oghplant = g_plant           #所屬營運中心
      LET l_ogh.oghlegal = g_legal           #所屬法人
      INSERT INTO ogh_file VALUES(l_ogh.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','',g_oga.oga01,SQLCA.sqlcode,1)
         LET g_success="N"
      END IF
   END FOREACH
END FUNCTION

FUNCTION t595_ins_rxe(p_ogb01,p_ogb03,p_lrf02,p_lrf03)    #銷售券號 
DEFINE l_rxe    RECORD     LIKE rxe_file.* 
DEFINE p_ogb01             LIKE ogb_file.ogb01  #單號
DEFINE p_ogb03             LIKE ogb_file.ogb03  #項次
DEFINE p_lrf02             LIKE lrf_file.lrf02  #券起始編號
DEFINE p_lrf03             LIKE lrf_file.lrf03  #券金額 
    
   LET l_rxe.rxe00  = '02'       #單據別 
   LET l_rxe.rxe01  = p_ogb01    #單號
   LET l_rxe.rxe02  = p_ogb03    #項次
   SELECT MAX(rxe03) INTO l_rxe.rxe03
      FROM rxe_file WHERE rxe00 = '02' AND rxe01 = p_ogb01
   IF cl_null(l_rxe.rxe03) OR l_rxe.rxe03 = 0 THEN
      LET l_rxe.rxe03 = 1
   END IF 
   LET l_rxe.rxe03  = l_rxe.rxe03 + 1         #序號 
   LET l_rxe.rxe04  = p_lrf02                 #券起始編號
   LET l_rxe.rxe05  = p_lrf02                 #券結束編號
   SELECT lqe02,lqe03 
     INTO l_rxe.rxe06,l_rxe.rxe07             #券類型編號  #券面額編號
         FROM lqe_file WHERE lqe01 = p_lrf02  
   LET l_rxe.rxe08  = 1                       #券張數 
   LET l_rxe.rxe09  = l_rxe.rxe08 * p_lrf03   #總金額
   LET l_rxe.rxeplant = g_plant               #所屬營運中心
   LET l_rxe.rxelegal = g_legal               #所屬法人

   INSERT INTO rxe_file VALUES(l_rxe.*)
END FUNCTION
#FUN-C30257 add
