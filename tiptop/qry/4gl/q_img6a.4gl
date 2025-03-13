# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name   : q_img6a.4gl
# Program ver.   : 1.0
# Program Author : jan
# Description    : DL_MF045 單身內新增多倉儲批挑選ACTION 可以依料件編號+倉庫+儲位+批號下查詢條件
# Input parameter: pi_multi_sel:是否需要複選資料(TRUE/FALSE)
#                  pi_need_cons:是否需要CONSTRUCT(TRUE/FALSE)
#                  ps_default1: 預設1
#                  ps_default2: 預設2
#                  ps_default3: 預設3
#                  p_sfp01: 發料單單號
#                  p_sfp06: 發料單型態
#                  p_sfs02: 發料單身項次
#                  p_sfs03: 發料單身工單單號
#                  p_sfs04: 發料單身下階料號
#                  p_sfs06: 發料單身發料單位
#                  p_sfs07: 發料單身倉庫
#                  p_sfs10: 發料單身作業編號
#                  p_sfs26: 發料單身替代碼
#                  p_sfa05: 發料單身應發量
#Modify...................: No.FUN-8A0140 By jan
#Modify...................: No.FUN-940008 By hongmei發料改善
#Modify...................: No.FUN-980012 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定
# Modify.........: No.MOD-9A0039 09/10/13 By Pengu 點選畫面上的x後沒有關閉，反而游標進入到單身
# Modify.........: No:MOD-9B0148 09/11/23 By Dido 給予 sfs10 預設值 
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:FUN-A60079 10/06/25 By jan s_shortqty加傳參數
# Modify.........: No:CHI-970038 10/12/10 By Summer 1.修改數量未跑ON ROW CHANGE段
#                                                   2.刪除tmp_file時會誤刪其它筆資料
#                                                   3.使用多單位時子單位數量放錯
# Modify.........: No:FUN-B70074 11/07/25 By lixh1 增加行業別TABLE(sfsi_file)的處理 
# Modify.........: No:FUN-BB0084 11/12/13 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No:MOD-D60001 13/06/27 By fengmy  增加傳值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry     DYNAMIC ARRAY OF RECORD   #單身陣列
         check      LIKE type_file.chr1,  	 #VARCHAR(1)
         img03      LIKE img_file.img03,
         img04      LIKE img_file.img04,
         img09      LIKE img_file.img09,
         img10      LIKE img_file.img10,
         new_sfs05  LIKE img_file.img10,      #出貨數量
         imgg09     LIKE imgg_file.imgg09,    #參考單位
         imgg10     LIKE imgg_file.imgg10     #參考單位數量
END RECORD
#s_img (FORMONLY.check, img_file.img03, img_file.img04, img_file.img09, img_file.img10, FORMONLY.new_sfs05, FORMONLY.imgg09, FORMONLY.imgg10)
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD #單身暫存
         check      LIKE type_file.chr1,  	 #VARCHAR(1)
         img03      LIKE img_file.img03,
         img04      LIKE img_file.img04,
         img09      LIKE img_file.img09,
         img10      LIKE img_file.img10,
         new_sfs05  LIKE img_file.img10,      #出貨數量
         imgg09     LIKE imgg_file.imgg09,    #參考單位
         imgg10     LIKE imgg_file.imgg10     #參考單位數量
END RECORD
 
DEFINE   old_check        LIKE type_file.chr1
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE). SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).SMALLINT
DEFINE   mi_cons_index    LIKE type_file.chr1     #CONSTRUCT時回傳哪一個值       VARCHAR(1)
DEFINE   ms_cons_where    STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數 INTEGER
DEFINE   ms_ret1          STRING,
         ms_ret2          STRING,
         ms_ret3          STRING
DEFINE   ms_default1      STRING,
         ms_default2      STRING,
         ms_default3      STRING
DEFINE   g_reconstruct    LIKE type_file.num5     #SMALLINT
DEFINE   g_tot_sfs05      LIKE sfs_file.sfs05     #挑選發料數量總和
DEFINE   g_ima02          LIKE ima_file.ima02
DEFINE   g_ima021         LIKE ima_file.ima021
DEFINE   g_sfp01          LIKE sfp_file.sfp01
DEFINE   g_sfp06          LIKE sfp_file.sfp06
DEFINE   g_sfs02          LIKE sfs_file.sfs02
DEFINE   g_sfs03          LIKE sfs_file.sfs03
DEFINE   g_sfs04          LIKE sfs_file.sfs04
DEFINE   g_sfs06          LIKE sfs_file.sfs06
DEFINE   g_sfs07          LIKE sfs_file.sfs07
DEFINE   g_sfs10          LIKE sfs_file.sfs10
DEFINE   g_sfs26          LIKE sfs_file.sfs26
DEFINE   g_sfa05          LIKE sfa_file.sfa05
DEFINE   g_cnt            LIKE type_file.num5   #FUN-940008 SMALLINT
DEFINE   g_first          LIKE type_file.num5   #FUN-940008 SMALLINT
DEFINE   g_check          LIKE type_file.chr1   #FUN-940008 varchar2(1) 
DEFINE   g_sum_tot        LIKE sfs_file.sfs05
DEFINE   g_wc             STRING
DEFINE   g_sfs27          LIKE sfs_file.sfs27   #FUN-940008 add
DEFINE   g_sfs28          LIKE sfs_file.sfs28   #MOD-D60001
DEFINE   g_sfs012         LIKE sfs_file.sfs012  #MOD-D60001
DEFINE   g_sfs013         LIKE sfs_file.sfs013  #MOD-D60001
 
FUNCTION q_img6a(pi_multi_sel, pi_need_cons, ps_default1, ps_default2, ps_default3,
                   p_sfp01,   #發料單單號
                   p_sfp06,   #發料單型態
                   p_sfs02,   #發料單身項次
                   p_sfs03,   #發料單身工單單號
                   p_sfs04,   #發料單身下階料號
                   p_sfs06,   #發料單身發料單位
                   p_sfs07,   #發料單身倉庫
                   p_sfs10,   #發料單身作業編號
                   p_sfs26,   #發料單身替代碼
                   p_sfa05    #發料單身應發量
                   ,p_sfs27   #被替代料号      #MOD-D60001 add
                   ,p_sfs28   #替代率          #MOD-D60001 add
                   ,p_sfs012  #制程段号        #MOD-D60001 add
                   ,p_sfs013  #制程序          #MOD-D60001 add
                   )
 
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING,
            ps_default2    STRING,
            ps_default3    STRING
   DEFINE   p_sfp01        LIKE sfp_file.sfp01
   DEFINE   p_sfp06        LIKE sfp_file.sfp06
   DEFINE   p_sfs02        LIKE sfs_file.sfs02
   DEFINE   p_sfs03        LIKE sfs_file.sfs03
   DEFINE   p_sfs04        LIKE sfs_file.sfs04
   DEFINE   p_sfs06        LIKE sfs_file.sfs06
   DEFINE   p_sfs07        LIKE sfs_file.sfs07
   DEFINE   p_sfs10        LIKE sfs_file.sfs10
   DEFINE   p_sfs26        LIKE sfs_file.sfs26
   DEFINE   p_sfs27        LIKE sfs_file.sfs27  #MOD-D60001 add
   DEFINE   p_sfs28        LIKE sfs_file.sfs28  #MOD-D60001 add
   DEFINE   p_sfs012       LIKE sfs_file.sfs012 #MOD-D60001 add
   DEFINE   p_sfs013       LIKE sfs_file.sfs013 #MOD-D60001 add
   DEFINE   p_sfa05        LIKE sfa_file.sfa05
   DEFINE   l_sfs02        LIKE sfs_file.sfs02
   DEFINE   l_sfs03        LIKE sfs_file.sfs03
   DEFINE   l_sfs04        LIKE sfs_file.sfs04
   DEFINE   l_sfs05        LIKE sfs_file.sfs05
   DEFINE   l_sfs07        LIKE sfs_file.sfs07
   DEFINE   l_sfs34        LIKE sfs_file.sfs34
   DEFINE   l_sfs31        LIKE sfs_file.sfs31      #No:CHI-970038 add
   DEFINE   l_sfa12        LIKE sfa_file.sfa12      #發料單位
   DEFINE   l_ima108       LIKE ima_file.ima108     #發料前調撥否
   DEFINE   l_ima906       LIKE ima_file.ima906     #單位使用
   DEFINE   l_ima907       LIKE ima_file.ima907     #參考單位
   DEFINE   l_fac          LIKE ima_file.ima55_fac, #發料單位/庫存單位換算率
            l_flag         LIKE type_file.num5,     #FUN-940008 SMALLINT
            l_msg          STRING,
            l_cnt          LIKE type_file.num5,     #FUN-940008 SMALLINT
            ls_token       STRING
   DEFINE   lst_token      base.StringTokenizer,
            l_t1           LIKE apy_file.apyslip,
            l_n            LIKE type_file.num5   #檢查重複用     #No.FUN-680126 SMALLINT
                       
   DEFINE l_tmp      RECORD
          img03      LIKE img_file.img03,      #儲位
          img04      LIKE img_file.img04,      #批號
          img09      LIKE img_file.img09,      #單位庫存
          img10      LIKE img_file.img10,      #
          new_sfs05  LIKE img_file.img10,      #出貨數量
          imgg09     LIKE imgg_file.imgg09,    #參考單位
          imgg10     LIKE imgg_file.imgg10     #參考單位數量
                     END  RECORD
   DEFINE l_sfsi     RECORD LIKE sfsi_file.*   #FUN-B70074
   DEFINE l_sfsud07  LIKE sfs_file.sfsud07     #add by guanyao160720
   DEFINE l_sfs21    LIKE sfs_file.sfs21       #add by guanyao160720
 
   LET mi_multi_sel = pi_multi_sel          #是否需要複選資料(TRUE/FALSE)
   LET mi_need_cons = pi_need_cons          #是否需要CONSTRUCT(TRUE/FALSE)
   LET ms_default1 = ps_default1
   LET ms_default2 = ps_default2
   LET ms_default3 = ps_default3
 
   LET g_sfp01 = p_sfp01                    #發料單單頭
   LET g_sfp06 = p_sfp06                    #發料單單頭
   LET g_sfs02 = p_sfs02                    #發料單身項次
   LET g_sfs03 = p_sfs03                    #發料單身工單單號
   LET g_sfs04 = p_sfs04                    #發料單身下階料號
   LET g_sfs06 = p_sfs06                    #發料單身發料單位
   LET g_sfs07 = p_sfs07                    #發料單身倉庫
   LET g_sfs10 = p_sfs10                    #發料單身作業編號
   LET g_sfs26 = p_sfs26                    #發料單身替代碼
   LET g_sfa05 = p_sfa05                    #發料單身應發量
   LET g_sfs27 = p_sfs27                    #被替代料号     #MOD-D60001 add
   LET g_sfs28 = p_sfs28                    #替代率         #MOD-D60001 add
   LET g_sfs012 = p_sfs012                  #制程段号       #MOD-D60001 add
   LET g_sfs013 = p_sfs013                  #制程序         #MOD-D60001 add
   LET g_tot_sfs05 = 0
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   DROP TABLE tmp_file;
   CREATE TEMP TABLE tmp_file(
      img03      LIKE img_file.img03,
      img04      LIKE img_file.img04,
      img09      LIKE img_file.img09,
      img10      LIKE img_file.img10,
      sfs05      LIKE sfs_file.sfs05,
      imgg09     LIKE imgg_file.imgg09,
      imgg10     LIKE imgg_file.imgg10)
#   CREATE  TABLE tmp_file(
#      img03      varchar(10),
#      img04      varchar(24),
#      img09      varchar(4),             
#      img10      DECIMAL(15,3),
#      sfs05      DECIMAL(15,3),
#      imgg09     varchar(4),
#      imgg10     DECIMAL(15,3))
 
   CREATE INDEX tmp_01 ON tmp_file (tmp03,tmp04);
   DELETE FROM tmp_file WHERE 1=1
 
   #開啟畫面檔
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_img6a" ATTRIBUTE(STYLE="create_qry")
   CALL cl_ui_locale("q_img6a")
 
   #將傳入參數顯示畫面上
   CALL img6a_qry_show()
 
   # 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   # IF (mi_multi_sel) THEN
      # CALL cl_set_comp_font_color("img02", "red")
   # END IF
   IF cl_null(g_sfs03) THEN
      CALL cl_err(g_sfs03,'asf-999',1)  #請輸入正確的工單單號!
      RETURN
   END IF
 
   INPUT l_sfs03,l_sfs04,l_sfs07 WITHOUT DEFAULTS FROM sfs03,sfs04,sfs07
      BEFORE INPUT
         CALL img6a_qry_show()
         IF NOT cl_null(g_sfs03) THEN
            LET l_sfs03 = g_sfs03
         END IF
         IF NOT cl_null(g_sfs04) THEN
            LET l_sfs04 = g_sfs04
         END IF
         IF NOT cl_null(g_sfs07) THEN
            LET l_sfs07 = g_sfs07
         END IF
 
      AFTER FIELD sfs03 #檢查工單單號
         IF g_sfp06 NOT MATCHES '[24]' THEN
            SELECT COUNT(*) INTO l_n FROM sfq_file
             WHERE sfq01 = g_sfp01
               AND sfq02 = l_sfs03
            IF l_n = 0 THEN
               CALL cl_err(l_sfs03,'asf-999',1)  #請輸入正確的工單單號!
               NEXT FIELD sfs03
            END IF
            LET g_sfs03 = l_sfs03
         END IF
         DISPLAY g_sfs03 TO sfs03
 
      AFTER FIELD sfs04 #檢查料號
         IF NOT cl_null(l_sfs04) THEN
            IF g_sfs04 <> l_sfs04 THEN
               NEXT FIELD sfs04
            END IF
         ELSE
            CALL cl_err('null','amr-917',0)  #請輸入料號!
            NEXT FIELD sfs04
         END IF
         LET g_sfs04 = l_sfs04
         DISPLAY g_sfs04 TO sfs04
         CALL img6a_qry_sfa05()  #帶出應發數量
 
      AFTER FIELD sfs07 #檢查倉庫
         IF NOT cl_null(l_sfs07) THEN
            IF g_sfs04 <> l_sfs04 THEN 
               CALL cl_err('g_sfs04','mfg6095',0)  #該料件已預設存在某倉庫或倉庫/儲位,而您所輸入與預設值不符!!!
            END IF
            SELECT imd02 FROM imd_file
            #WHERE imd01=g_sfs07                #MOD-D60001 mark
             WHERE imd01=l_sfs07                #MOD-D60001
               AND imdacti = 'Y' #MOD-4B0169
            IF STATUS THEN
              #CALL cl_err3("sel","imd_file",g_sfs07,"",STATUS,"","sel imd",1)  #No.FUN-660128  #MOD-D60001 mark
               CALL cl_err3("sel","imd_file",l_sfs07,"",STATUS,"","sel imd",1)  #MOD-D60001
               NEXT FIELD sfs07
            END IF
            SELECT ima108 INTO l_ima108 
              FROM ima_file
             WHERE ima01 = g_sfs04
            IF l_ima108 = 'Y' THEN        #若為SMT料必須檢查是否會WIP倉
               SELECT COUNT(*) INTO l_n FROM imd_file
              # WHERE imd01=g_sfs07 AND imd10='W'         #MOD-D60001 mark
                WHERE imd01=l_sfs07 AND imd10='W'         #MOD-D60001 
                  AND imdacti = 'Y' #MOD-4B0169
               IF l_n = 0 THEN
                 #CALL cl_err(g_sfs07,'asf-724',0)        #MOD-D60001 mark
                  CALL cl_err(l_sfs07,'asf-724',0)        #MOD-D60001 
                  NEXT FIELD sfs07
               END IF
            END IF
         END IF
         LET g_sfs07 = l_sfs07
         DISPLAY g_sfs07 TO sfs07
 
     #---------------No.MOD-9A0039 add
      AFTER INPUT 
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
     #---------------No.MOD-9A0039 end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT
 
  #---------------No.MOD-9A0039 add
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      CLOSE WINDOW w_qry
      RETURN
   END IF
  #---------------No.MOD-9A0039 end
 
   CALL img6a_qry_sel()  #畫面顯現與資料的選擇
 
   #檢查有無打勾資料進行匯入
   LET g_check = 'N'
   SELECT COUNT(*) INTO l_cnt
     FROM tmp_file
    WHERE 1=1
   IF l_cnt > 0 THEN LET g_check ='Y' END IF
 
   #若有暫存資料進行處理單身動作
   IF g_check = 'Y' THEN
      DECLARE cur_tmp CURSOR FOR
       SELECT * FROM tmp_file
        WHERE 1=1
      BEGIN WORK
 
      LET l_sfs02 = g_sfs02 
      LET l_cnt = 0
      #檢查單身該項次
      SELECT COUNT(*) INTO l_cnt FROM sfs_file
       WHERE sfs01 = g_sfp01
         AND sfs02 = g_sfs02
         AND sfs03 = g_sfs03
      #str-----add by guanyao160720
      LET l_sfsud07= ''
      LET l_sfs21 = ''
      SELECT sfsud07,sfs21 INTO l_sfsud07,l_sfs21 FROM sfs_file  WHERE sfs01 = g_sfp01 AND sfs02 = g_sfs02
      #end-----add by guanyao160720
      IF l_cnt >0 AND NOT cl_null(l_cnt) THEN
         #刪除選擇單身項次資料
         DELETE FROM sfs_file
          WHERE sfs01 = g_sfp01
            AND sfs02 = g_sfs02
            AND sfs03 = g_sfs03
         IF (SQLCA.SQLCODE AND SQLCA.sqlerrd[3]=0) THEN
            CALL cl_err('DEL sfs', SQLCA.SQLCODE, 1)
            ROLLBACK WORK
      #FUN-B70074 -------------Begin-----------------
         ELSE 
            IF NOT s_industry('std') THEN
               IF NOT s_del_sfsi(g_sfp01,g_sfs02,'') THEN
                  ROLLBACK WORK
               END IF
            END IF
      #FUN-B70074 -------------End-------------------
         END IF
      END IF
      
      #尋找大於該項次之資料
      SELECT COUNT(*) INTO l_cnt FROM sfs_file
       WHERE sfs01 = g_sfp01
         AND sfs02 > g_sfs02
      IF l_cnt >0 AND NOT cl_null(l_cnt) THEN
         #更新項次位移
         SELECT COUNT(*) INTO l_cnt
           FROM tmp_file
          WHERE 1=1
         UPDATE sfs_file SET sfs02 = sfs02 + (l_cnt-1)
          WHERE sfs01 = g_sfp01
            AND sfs02 > g_sfs02
         IF (SQLCA.SQLCODE AND SQLCA.sqlerrd[3]=0) THEN
            CALL cl_err('DEL sfs', SQLCA.SQLCODE, 1)
            ROLLBACK WORK
         END IF
      END IF
 
      FOREACH cur_tmp INTO l_tmp.*
         DISPLAY "ins sfs02:",l_sfs02
         SELECT sfa12 INTO l_sfa12
           FROM sfa_file
          WHERE sfa01 = g_sfs03
            AND sfa03 = g_sfs04
         #庫存對生產換算率
         CALL s_umfchk(g_sfs04,l_tmp.img09,l_sfa12)
               RETURNING l_flag,l_fac
         IF l_flag THEN LET l_fac = 1 END IF
         IF cl_null(l_fac) THEN LET l_fac = 1 END IF
         LET l_sfs05 = l_tmp.new_sfs05/l_fac
         LET l_sfs05 = s_digqty(l_sfs05,l_sfa12)      #FUN-BB0084
        #----------------No:CHI-970038 add
         CALL s_umfchk(g_sfs04,l_sfa12,l_tmp.img09) 
               RETURNING l_flag,l_sfs31 
         IF l_flag THEN LET l_sfs31 = 1 END IF 
        #----------------No:CHI-970038 end
 
         SELECT ima906,ima907 INTO l_ima906,l_ima907
           FROM ima_file
          WHERE ima01 = g_sfs04
         IF cl_null(l_ima907) THEN LET l_ima907 = l_tmp.imgg09 END IF
         CALL s_du_umfchk(g_sfs04,'','','',p_sfs06,l_ima907,l_ima906)
               RETURNING l_flag,l_fac
         LET l_sfs34 = l_fac
         IF l_ima906 <> '3' THEN 
            LET l_ima907 = '' 
            LET l_tmp.imgg10 = ''
            LET l_sfs34=0
         END IF
         IF cl_null(g_sfs10) THEN LET g_sfs10 = ' ' END IF           #MOD-9B0148 
#FUN-BB0084 ------------------Begin-----------------
         LET l_tmp.new_sfs05 = s_digqty(l_tmp.new_sfs05,l_tmp.imgg09)   
         LET l_tmp.imgg10 = s_digqty(l_tmp.imgg10,l_ima907) 
#FUN-BB0084 ------------------End-------------------
         INSERT INTO sfs_file(sfs01,sfs02,sfs03,sfs04,
                              sfs05,sfs06,sfsud02,sfs08,
                              sfs09,sfs10,
                              sfs26,sfs27,sfs28,
                              sfs30,sfs31,sfs32,
                              sfs33,sfs34,sfs35,
                              sfs012,sfs013,            #MOD-D60001 add
                              sfs014,            #FUN-C70014 add
                              sfsplant,sfslegal  #FUN-980012 add
                              ,sfs07,sfsud07,sfs21  #add by guanyao160720
                             )
                       VALUES(g_sfp01,l_sfs02,g_sfs03,g_sfs04,
                             #l_sfs05,l_sfa12,g_sfs07,l_tmp.img03,   #MOD-D60001 mark
                              l_tmp.new_sfs05,l_sfa12,g_sfs07,l_tmp.img03,   #MOD-D60001 mark
                             #l_tmp.img04,' ',                       #MOD-9B0148 mark 
                              l_tmp.img04,g_sfs10,                   #MOD-9B0148
                             #'','','',                              #MOD-D60001  mark
                              '',g_sfs27,g_sfs28,                    #MOD-D60001
                             #------------No:CHI-970038 modify
                             #l_sfa12,1,l_sfs05, 
                              l_tmp.imgg09,l_sfs31,l_tmp.new_sfs05, 
                             #------------No:CHI-970038 end
                              l_ima907,l_sfs34,l_tmp.imgg10,
                              g_sfs012,g_sfs013,                 #MOD-D60001
                              ' ',               #FUN-C70014 add
                              g_plant,g_legal   #FUN-980012 add
                              ,'XBC',l_sfsud07,l_sfs21  #add by guanyao160720
                             )#mod sfs07 to sfsud02 by guanyao160720
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","sfs_file",g_sfs03,"",SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
            EXIT FOREACH
        #FUN-B70074 -----------------Begin------------------
         ELSE 
            IF NOT s_industry('std') THEN
               INITIALIZE l_sfsi.* TO NULL
               LET l_sfsi.sfsi01 = g_sfp01 
               LET l_sfsi.sfsi02 = l_sfs02
               IF NOT s_ins_sfsi(l_sfsi.*,g_plant) THEN                 
                  ROLLBACK WORK
                  EXIT FOREACH
               END IF      
            END IF 
        #FUN-B70074 -----------------End--------------------  
         END IF
         LET l_sfs02 = l_sfs02 + 1
      END FOREACH
      MESSAGE "UPDATE OK"
      COMMIT WORK
   END IF
 
   CLOSE WINDOW w_qry
   RETURN
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author   : 2003/10/16 by saki
# Parameter       : none
# Return   	      : void
# Memo            :
# Modify          :
##################################################
FUNCTION img6a_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100
   LET li_reconstruct = TRUE
   LET g_reconstruct = TRUE     #No.MOD-660044 add
 
   WHILE TRUE
      CLEAR FORM
 
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      CALL img6a_qry_show()
 
      IF (li_reconstruct) THEN  #是否重查
         MESSAGE ""
 
         IF g_first >= 0 THEN
            CONSTRUCT ms_cons_where ON img03,img04,img09,img10
                 FROM s_img[1].img03, s_img[1].img04, s_img[1].img09, s_img[1].img10
            BEFORE CONSTRUCT
               CALL img6a_qry_show()
               CALL img6a_qry_sfa05()
 
            END CONSTRUCT
         END IF
         LET g_first = 1
         CALL img6a_qry_prep_result_set()  #準備查詢畫面的資料集.
         # 2003/07/14 by Hiko : 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 2003/07/14 by Hiko : 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
         IF (mi_page_count >= ma_qry.getLength()) THEN
            LET ls_hide_act = "prevpage,nextpage"
         END IF
 
         IF (NOT mi_need_cons) THEN  #是否需要CONSTRUCT(TRUE/FALSE)
            IF (ls_hide_act IS NULL) THEN
               LET ls_hide_act = "reconstruct"
            ELSE
               LET ls_hide_act = "prevpage,nextpage,reconstruct"
            END IF
         END IF
 
         LET li_start_index = 1
         LET li_reconstruct = FALSE
      END IF
 
      LET li_end_index = li_start_index + mi_page_count - 1
 
      IF (li_end_index > ma_qry.getLength()) THEN
         LET li_end_index = ma_qry.getLength()
      END IF
 
      CALL img6a_qry_set_display_data(li_start_index, li_end_index) #設定查詢畫面的顯現資料.
 
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang  #總筆數
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang  #頁次
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN  #是否需要複選資料
         #採用INPUT ARRAY的方式來顯現查詢過後的資料.
         CALL img6a_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE    
         #採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
         CALL img6a_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
 
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description   : 準備查詢畫面的資料集.
# Date & Author : {格式為:2008/10/10 by TPS.m121752332}
# Parameter     : none
# Return        : void
# Memo        	 :
# Modify        :
##################################################
FUNCTION img6a_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING
   DEFINE   ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	    #No.FUN-680131 INTEGER
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   	 #No.FUN-680131 VARCHAR(1)
            img03      LIKE img_file.img03,      #儲位
            img04      LIKE img_file.img04,      #批號
            img09      LIKE img_file.img09,      #單位庫存
            img10      LIKE img_file.img10,      #
            sfs05      LIKE img_file.img10,      #出貨數量
            imgg09     LIKE imgg_file.imgg09,    #參考單位
            imgg10     LIKE imgg_file.imgg10     #參考單位數量
   END RECORD
   DEFINE   l_fac      LIKE ima_file.ima31_fac,
            l_flag     LIKE type_file.num5       #FUN-940008 SMALLINT
 
   IF cl_null(ms_cons_where) THEN LET ms_cons_where = ' AND 1=1 ' END IF
 
   LET ms_cons_where = ms_cons_where," AND img01 = '",g_sfs04,"'"
   IF NOT cl_null(g_sfs07) THEN
      LET ms_cons_where = ms_cons_where," AND img02 = '",g_sfs07,"'"
   END IF
   DISPLAY "ms_cons_where=",ms_cons_where
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_img6a', 'img_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N', img03,img04, ",
                "       img09,img10,img10,imgg09,imgg10 ",
                " FROM img_file,OUTER imgg_file, ima_file",
                " WHERE img01 = ima01",
                "  AND img01 = imgg_file.imgg01",   #料
                "  AND img02 = imgg_file.imgg02",   #倉
                "  AND img03 = imgg_file.imgg03",   #儲
                "  AND img04 = imgg_file.imgg04",   #批
                "  AND img10 > 0",
                "  AND ",ms_cons_where
 
   LET ls_sql = ls_sql CLIPPED, " ORDER BY img03"
#FUN-990069---begin 
   IF (NOT mi_multi_sel ) THEN
      CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql
   END IF     
#FUN-990069---end  
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      IF li_i-1 >= g_aza.aza38 THEN  #如果大於最大顯示列
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
      LET ma_qry[li_i].* = lr_qry.*  #將撈出資料丟至單身
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description   : 設定查詢畫面的顯現資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	 : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo          : 將單身陣列丟到單身暫存並設定暫存區筆數
# Modify        :
##################################################
FUNCTION img6a_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	   #No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	   #No.FUN-680131 INTEGER
 
   CALL ma_qry_tmp.clear()
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
 
##################################################
# Description   : 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter     : ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	    : li_continue      LIKE type_file.num5     是否繼續
#               : li_reconstruct   LIKE type_file.num5     是否重新查詢
#               : pi_start_index   LIKE type_file.num10    改變後的起始位置
# Memo        	 :
# Modify        :
##################################################
FUNCTION img6a_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   i,l_cnt          LIKE type_file.num5   #FUN-940008 SMALLINT              #i:指標位置 l_cnt:筆數
   DEFINE   ps_hide_act      STRING,               #所要隱藏的Action Button
            pi_start_index   LIKE type_file.num10, #No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  #No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   l_n              LIKE type_file.num5   #檢查重複用         #No.FUN-680126 SMALLINT
 
   #顯示單頭資料
   CALL img6a_qry_show()
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_img.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN  #隱藏ps_hide_act傳入值
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
 
      BEFORE ROW
         LET i=ARR_CURR()
         LET old_check = ma_qry_tmp[i].check
         
      ON ROW CHANGE
         FOR g_cnt = 1 TO ma_qry_tmp.getLength()
            IF ma_qry_tmp[g_cnt].check = 'Y' THEN
               SELECT COUNT(*) INTO l_cnt
                 FROM tmp_file
                WHERE img03 = ma_qry_tmp[g_cnt].img03
                  AND img04 = ma_qry_tmp[g_cnt].img04
               IF l_cnt = 0 THEN
                  INSERT INTO tmp_file VALUES
                   ( ma_qry_tmp[g_cnt].img03,
                     ma_qry_tmp[g_cnt].img04,
                     ma_qry_tmp[g_cnt].img09,
                     ma_qry_tmp[g_cnt].img10,
                     ma_qry_tmp[g_cnt].new_sfs05,
                     ma_qry_tmp[g_cnt].imgg09,
                     ma_qry_tmp[g_cnt].imgg10)
                  IF STATUS THEN 
                     CALL cl_err('ins tmp_file',STATUS,1) 
                  END IF
               END IF
               UPDATE tmp_file SET sfs05 = ma_qry_tmp[g_cnt].new_sfs05
                WHERE img03 = ma_qry_tmp[g_cnt].img03
                  AND img04 = ma_qry_tmp[g_cnt].img04
               IF STATUS THEN CALL cl_err('upd tmp_file',STATUS,1) END IF
            ELSE
              #--------------------No:CHI-970038 add
               IF NOT cl_null(ma_qry_tmp[g_cnt].imgg09) THEN
                  DELETE FROM tmp_file 
                   WHERE img03 = ma_qry_tmp[g_cnt].img03 
                     AND img04 = ma_qry_tmp[g_cnt].img04 
                     AND imgg09 = ma_qry_tmp[g_cnt].imgg09 
               ELSE
              #--------------------No:CHI-970038 end
                  DELETE FROM tmp_file
                   WHERE img03 = ma_qry_tmp[g_cnt].img03
                     AND img04 = ma_qry_tmp[g_cnt].img04
               END IF       #No:CHI-970038 add
               IF STATUS THEN CALL cl_err('del tmp_file',STATUS,1) END IF
            END IF
         END FOR
         
         LET g_tot_sfs05 = 0
         SELECT SUM(sfs05) INTO g_tot_sfs05
           FROM tmp_file
         IF g_tot_sfs05 IS NULL THEN LET g_tot_sfs05 = 0 END IF
         DISPLAY g_tot_sfs05 TO FORMONLY.tot_sfs05
 
      ON CHANGE check
         FOR g_cnt = 1 TO ma_qry_tmp.getLength()
            IF ma_qry_tmp[g_cnt].check = 'Y' THEN
               SELECT COUNT(*) INTO l_cnt
                 FROM tmp_file
                WHERE img03 = ma_qry_tmp[g_cnt].img03
                  AND img04 = ma_qry_tmp[g_cnt].img04
               IF l_cnt = 0 THEN
                  INSERT INTO tmp_file VALUES
                   ( ma_qry_tmp[g_cnt].img03,
                     ma_qry_tmp[g_cnt].img04,
                     ma_qry_tmp[g_cnt].img09,
                     ma_qry_tmp[g_cnt].img10,
                     ma_qry_tmp[g_cnt].new_sfs05,
                     ma_qry_tmp[g_cnt].imgg09,
                     ma_qry_tmp[g_cnt].imgg10)
                  IF STATUS THEN 
                     CALL cl_err('ins tmp_file',STATUS,1) 
                  END IF
               END IF
            ELSE
              #--------------------No:CHI-970038 add
               IF NOT cl_null(ma_qry_tmp[g_cnt].imgg09) THEN
                  DELETE FROM tmp_file 
                   WHERE img03 = ma_qry_tmp[g_cnt].img03 
                     AND img04 = ma_qry_tmp[g_cnt].img04 
                     AND imgg09 = ma_qry_tmp[g_cnt].imgg09 
               ELSE
              #--------------------No:CHI-970038 end
                  DELETE FROM tmp_file
                   WHERE img03 = ma_qry_tmp[g_cnt].img03
                     AND img04 = ma_qry_tmp[g_cnt].img04
               END IF       #No:CHI-970038 add
               IF STATUS THEN CALL cl_err('del tmp_file',STATUS,1) END IF
            END IF
         END FOR
         
         LET g_tot_sfs05 = 0
         SELECT SUM(sfs05) INTO g_tot_sfs05
           FROM tmp_file
         IF g_tot_sfs05 IS NULL THEN LET g_tot_sfs05 = 0 END IF
         DISPLAY g_tot_sfs05 TO FORMONLY.tot_sfs05
         
      ON ACTION prevpage #上一頁
         CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL img6a_qry_reset_multi_sel(pi_start_index, pi_end_index) #重設查詢資料關於'check'欄位的值.
 
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
 
         LET li_continue = TRUE
         EXIT INPUT
 
      ON ACTION nextpage #下一頁
         CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL img6a_qry_reset_multi_sel(pi_start_index, pi_end_index) #重設查詢資料關於'check'欄位的值.
 
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
 
         LET li_continue = TRUE
         EXIT INPUT
 
      ON ACTION refresh #重新整理
         CALL img6a_qry_refresh() #取消單身所有選擇動作
         LET pi_start_index = 1   #顯現第一筆查詢資料位置
 
         LET li_continue = TRUE   #繼續執行
         EXIT INPUT
 
      ON ACTION reconstruct #重新查詢
         #先刪除tmp資料
         DELETE FROM tmp_file
          WHERE 1=1
         IF STATUS THEN CALL cl_err('del tmp_file',STATUS,1) END IF
         LET g_tot_sfs05 = 0   #另挑選發料初始為0
         DISPLAY g_tot_sfs05 TO FORMONLY.tot_sfs05
 
         LET li_reconstruct = TRUE #重新查詢
         LET li_continue = TRUE    #繼續執行
         EXIT INPUT
 
      ON ACTION selectall #勾選全部
         FOR g_cnt = 1 TO ma_qry_tmp.getLength()
            #逐筆打勾
            LET ma_qry_tmp[g_cnt].check = 'Y'
            DISPLAY BY NAME ma_qry_tmp[g_cnt].check
            #定義不明
            SELECT COUNT(*) INTO l_cnt
              FROM tmp_file
             WHERE img03 = ma_qry_tmp[g_cnt].img03
               AND img04 = ma_qry_tmp[g_cnt].img04
            IF l_cnt =0 THEN
               #將單身資料置入tmp_file
               INSERT INTO tmp_file VALUES
                ( ma_qry_tmp[g_cnt].img03,
                  ma_qry_tmp[g_cnt].img04,
                  ma_qry_tmp[g_cnt].img09,
                  ma_qry_tmp[g_cnt].img10,
                  ma_qry_tmp[g_cnt].new_sfs05,
                  ma_qry_tmp[g_cnt].imgg09,
                  ma_qry_tmp[g_cnt].imgg10)
               IF STATUS THEN CALL cl_err('ins tmp_file',STATUS,1) END IF
            END IF
         END FOR
         LET g_tot_sfs05 = 0
         #計算temp內
         SELECT SUM(sfs05) INTO g_tot_sfs05
           FROM tmp_file
         IF g_tot_sfs05 IS NULL THEN LET g_tot_sfs05 = 0 END IF
         DISPLAY g_tot_sfs05 TO FORMONLY.tot_sfs05
 
		   DISPLAY ARRAY ma_qry_tmp TO s_img.*
            BEFORE DISPLAY
            EXIT DISPLAY
         END DISPLAY
 
 
      ON ACTION select_none #取消勾選
        #LET g_sum_tot = 0
         FOR g_cnt = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[g_cnt].check = 'N'
             DISPLAY BY NAME ma_qry_tmp[g_cnt].check
 
             DELETE FROM tmp_file
              WHERE 1=1
             IF STATUS THEN CALL cl_err('del tmp_file',STATUS,1) END IF
         END FOR
         LET g_tot_sfs05 = 0
         SELECT SUM(sfs05) INTO g_tot_sfs05
           FROM tmp_file
         IF g_tot_sfs05 IS NULL THEN LET g_tot_sfs05 = 0 END IF
         DISPLAY g_tot_sfs05 TO FORMONLY.tot_sfs05
 
         DISPLAY ARRAY ma_qry_tmp TO s_img.*
            BEFORE DISPLAY
            EXIT DISPLAY
         END DISPLAY
 
      ON ACTION accept #確定
        #-----------------No:CHI-970038 add
         FOR g_cnt = 1 TO ma_qry_tmp.getLength() 
            IF ma_qry_tmp[g_cnt].check = 'Y' THEN 
               SELECT COUNT(*) INTO l_cnt 
                 FROM tmp_file 
                WHERE img03 = ma_qry_tmp[g_cnt].img03 
                  AND img04 = ma_qry_tmp[g_cnt].img04 
               IF l_cnt = 0 THEN 
                  INSERT INTO tmp_file VALUES 
                   ( ma_qry_tmp[g_cnt].img03, 
                     ma_qry_tmp[g_cnt].img04, 
                     ma_qry_tmp[g_cnt].img09, 
                     ma_qry_tmp[g_cnt].img10, 
                     ma_qry_tmp[g_cnt].new_sfs05, 
                     ma_qry_tmp[g_cnt].imgg09, 
                     ma_qry_tmp[g_cnt].imgg10) 
                  IF STATUS THEN  
                     CALL cl_err('ins tmp_file',STATUS,1)  
                  END IF 
               END IF 
               UPDATE tmp_file SET sfs05 = ma_qry_tmp[g_cnt].new_sfs05 
                WHERE img03 = ma_qry_tmp[g_cnt].img03 
                  AND img04 = ma_qry_tmp[g_cnt].img04 
               IF STATUS THEN CALL cl_err('upd tmp_file',STATUS,1) END IF 
            ELSE 
               IF NOT cl_null(ma_qry_tmp[g_cnt].imgg09) THEN
                  DELETE FROM tmp_file 
                   WHERE img03 = ma_qry_tmp[g_cnt].img03 
                     AND img04 = ma_qry_tmp[g_cnt].img04 
                     AND imgg09 = ma_qry_tmp[g_cnt].imgg09 
               ELSE
                  DELETE FROM tmp_file 
                   WHERE img03 = ma_qry_tmp[g_cnt].img03 
                     AND img04 = ma_qry_tmp[g_cnt].img04 
               END IF 
               IF STATUS THEN CALL cl_err('del tmp_file',STATUS,1) END IF 
            END IF 
         END FOR 
        #-----------------No:CHI-970038 end

         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL img6a_qry_reset_multi_sel(pi_start_index, pi_end_index)
            #CALL img6a_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
            LET ms_ret2 = NULL       #CHI-9C0048
            LET ms_ret3 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE  #離開程式
         EXIT INPUT
 
      ON ACTION cancel #放棄
         LET INT_FLAG = 0 #No.CHI-690081
         FOR g_cnt = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[g_cnt].check = 'N'
             DISPLAY BY NAME ma_qry_tmp[g_cnt].check
 
             DELETE FROM tmp_file
              WHERE 1=1
             IF STATUS THEN CALL cl_err('del tmp_file',STATUS,1) END IF
         END FOR
         LET li_continue = FALSE #離開程式
         EXIT INPUT
 
      ON ACTION exporttoexcel #匯出excel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON IDLE g_idle_seconds #閒置設定
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	. pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION img6a_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION
 
##################################################
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               . pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION img6a_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_img.*
      BEFORE DISPLAY
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT DISPLAY
      ON ACTION nextpage
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT DISPLAY
      ON ACTION refresh
         LET pi_start_index = 1
         LET li_continue = TRUE
 
         EXIT DISPLAY
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         LET g_reconstruct = FALSE     #No.MOD-660044 add
 
         EXIT DISPLAY
      ON ACTION accept
         #CALL img6a_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF NOT mi_multi_sel THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
            LET ms_ret3 = ms_default3
         END IF
 
         LET li_continue = FALSE
 
         EXIT DISPLAY
 
      ON ACTION exporttoexcel  #No.FUN-660161
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION img6a_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'        #取消所有單身勾選
   END FOR
END FUNCTION
 
##################################################
# Description   : 選擇並確認資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter     : pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return        : void
# Memo          : 若需要回傳資料才需使用
# Modify        : TPS.m121752332 該程式只有建立發料單身作業不需回傳處理
##################################################
FUNCTION img6a_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  	#No.FUN-680131 INTEGER
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN  #是否需要複選資料
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN #將單身勾選資料
            IF (lsb_multi_sel.getLength() = 0) THEN
               #CALL lsb_multi_sel.append(ma_qry[li_i].img02 CLIPPED)
            ELSE
               #CALL lsb_multi_sel.append("|" || ma_qry[li_i].img02 CLIPPED)
            END IF
         END IF
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      # LET ms_ret1 = ma_qry[pi_sel_index].img02
      # LET ms_ret2 = ma_qry[pi_sel_index].img03
      # LET ms_ret3 = ma_qry[pi_sel_index].img04
   END IF
END FUNCTION
 
#參考發料單單身產生應發量
FUNCTION img6a_qry_sfa05()
   DEFINE   l_n        LIKE type_file.num5    #檢查重複用  #No.FUN-680121 SMALLINT
   DEFINE   l_sfa05    LIKE sfa_file.sfa05
   DEFINE   l_sfa07    LIKE sfa_file.sfa07
   DEFINE   s_sfa05    LIKE sfa_file.sfa05
   DEFINE   s_sfa07    LIKE sfa_file.sfa07
   DEFINE   t_sfa05    LIKE sfa_file.sfa05
   DEFINE   t_sfa07    LIKE sfa_file.sfa07
   DEFINE   l_sql      string                 #FUN-940008 add
   DEFINE   lr_sfa RECORD LIKE sfa_file.*     #FUN-940008 add
   DEFINE   g_short_qty   LIKE sfa_file.sfa07 #FUN-940008 add
 
   IF (g_sfp06 = '1') OR (g_sfp06 = '2') OR (g_sfp06 = 'D') THEN #MOD-6C0050 #帶應發已發欠料的資料,超領和成套發一樣   #FUN-C70014 add g_sfp06 = 'D'
      IF cl_null(g_sfs26) THEN
      #FUN-940008---Begin
      #  SELECT (sfa05-sfa065),sfa06,sfa07    # 扣除代買部分
      #    INTO l_sfa05,s_sfa07
      #    FROM sfa_file
      #   WHERE sfa01=g_sfs03
      #     AND sfa03=g_sfs04
      #     AND sfa12=g_sfs06
      #     AND sfa08=g_sfs10
         LET l_sql = "SELECT sfa_file.*",
                    #"  FROM sfb_file",             #MOD-D60001 mark
                     "  FROM sfa_file",             #MOD-D60001 
                     " WHERE sfa01='",g_sfs03,"'",
                     "   AND sfa03='",g_sfs04,"'",
                     "   AND sfa12='",g_sfs06,"'",
                     "   AND sfa08='",g_sfs10,"'",
                     "   AND sfa27='",g_sfs27,"'"
         PREPARE img6a_1_pre FROM l_sql
         DECLARE img6a_1 CURSOR FOR img6a_1_pre
         #計算欠料量
         FOREACH img6a_1 INTO lr_sfa.*
            CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                            lr_sfa.sfa12,lr_sfa.sfa27,
                            lr_sfa.sfa012,lr_sfa.sfa013)   #FUN-A60079 add
              RETURNING g_short_qty
            IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF
         END FOREACH  
         LET l_sfa05 = lr_sfa.sfa05-lr_sfa.sfa065     #fengmy   
         LET s_sfa07 = g_short_qty               
      ELSE                                                          
      #  SELECT SUM(sfa05-sfa065),SUM(sfa07)  # 扣除代買部分        
      #    INTO l_sfa05,s_sfa07                                     
      #    FROM sfa_file                                            
      #   WHERE sfa01=g_sfs03                                       
      #     AND sfa03=g_sfs04                                       
      #     AND sfa12=g_sfs06                                       
      #     AND sfa08=g_sfs10
         LET l_sql = "SELECT sfa_file.*",
                    #"  FROM sfb_file",              #MOD-D60001 mark
                     "  FROM sfa_file",              #MOD-D60001 
                     " WHERE sfa01='",g_sfs03,"'",
                     "   AND sfa03='",g_sfs04,"'",
                     "   AND sfa12='",g_sfs06,"'",
                     "   AND sfa08='",g_sfs10,"'",
                     "   AND sfa27='",g_sfs27,"'"
         IF SQLCA.SQLCODE THEN
            LET l_sfa05 = 0
            LET s_sfa07 = 0
         END IF
         PREPARE img6a_2_pre FROM l_sql
         DECLARE img6a_2 CURSOR FOR img6a_2_pre
         #計算欠料量
         FOREACH img6a_2 INTO lr_sfa.*
            CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                            lr_sfa.sfa12,lr_sfa.sfa27,
                            lr_sfa.sfa012,lr_sfa.sfa013)   #FUN-A60079 add
              RETURNING g_short_qty
            IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF
            LET l_sfa05 = l_sfa05 +(lr_sfa.sfa05+lr_sfa.sfa065)
            LET s_sfa07 = s_sfa07 + g_short_qty
         END FOREACH
      #FUN-940008---End    
      END IF
      DISPLAY l_sfa05 TO FORMONLY.sfa05
   END IF
   IF g_sfp06 = '3' THEN
      LET l_n = 0
    #FUN-940008---Begin
    # SELECT (sfa05-sfa065),sfa07             # 扣除代買部分
    #   INTO s_sfa05,s_sfa07
    #   FROM sfa_file
    #  WHERE sfa01=g_sfs03
    #    AND sfa03=g_sfs04
    #    AND sfa12=g_sfs06
    #    AND sfa08=g_sfs10
      LET l_sql = "SELECT sfa_file.*",
                    #"  FROM sfb_file",           #MOD-D60001 mark
                     "  FROM sfa_file",           #MOD-D60001 
                     " WHERE sfa01='",g_sfs03,"'",
                     "   AND sfa03='",g_sfs04,"'",
                     "   AND sfa12='",g_sfs06,"'",
                     "   AND sfa08='",g_sfs10,"'",
                     "   AND sfa27='",g_sfs27,"'"
      IF SQLCA.SQLCODE THEN
         LET s_sfa05 = 0
         LET s_sfa07 = 0
      ELSE
         LET l_n = l_n + 1
      END IF   
      PREPARE img6a_3_pre FROM l_sql
      DECLARE img6a_3 CURSOR FOR img6a_3_pre
      FOREACH img6a_3 INTO lr_sfa.*
         #計算欠料量
         CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                         lr_sfa.sfa12,lr_sfa.sfa27,
                         lr_sfa.sfa012,lr_sfa.sfa013)   #FUN-A50066 add
           RETURNING g_short_qty
         IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF
         LET s_sfa05 = lr_sfa.sfa05-lr_sfa.sfa065     
         LET s_sfa07 = g_short_qty
      END FOREACH 
    #FUN-940008---End     
      IF cl_null(s_sfa05) THEN LET s_sfa05 = 0 END IF
      IF cl_null(s_sfa07) THEN LET s_sfa07 = 0 END IF
      IF g_sfs26 MATCHES '[SU]' THEN
      #FUN-940008---Begin
      #  SELECT SUM(sfa05-sfa065),SUM(sfa07)  # 扣除代買部分
      #    INTO t_sfa05,t_sfa07
      #    FROM sfa_file
      #   WHERE sfa01=g_sfs03
      #     AND sfa03=b_sfs.sfs27
      #     AND sfa12=g_sfs06
      #     AND sfa08=g_sfs10
         IF SQLCA.sqlcode THEN
            LET t_sfa05=0
            LET t_sfa07=0
         ELSE
            LET l_n = l_n + 1
         END IF
         PREPARE img6a_4_pre FROM l_sql
         DECLARE img6a_4 CURSOR FOR img6a_4_pre
         FOREACH img6a_4 INTO lr_sfa.*
            #計算欠料量
            CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                            lr_sfa.sfa12,lr_sfa.sfa27,
                            lr_sfa.sfa012,lr_sfa.sfa013)   #FUN-A50066 add
              RETURNING g_short_qty
            IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF
            LET t_sfa05 = l_sfa05 +(lr_sfa.sfa05+lr_sfa.sfa065)
            LET t_sfa07 = t_sfa07 + g_short_qty
         END FOREACH
      #FUN-940008---End   
      END IF
      IF cl_null(t_sfa05) THEN LET t_sfa05 = 0 END IF
      IF cl_null(t_sfa07) THEN LET t_sfa07 = 0 END IF
      LET l_sfa05 = s_sfa05 + t_sfa05
      LET s_sfa07 = s_sfa07 + t_sfa07
   END IF
 
   IF g_sfp06='3' THEN
     LET l_sfa05 = s_sfa07
   END IF
   DISPLAY l_sfa05 TO FORMONLY.sfa05
END FUNCTION 
 
FUNCTION img6a_qry_show()
   DISPLAY g_sfp01 TO FORMONLY.old_sfs01
   DISPLAY g_sfs02 TO FORMONLY.old_sfs02
   DISPLAY g_sfs03 TO sfs03
   DISPLAY g_sfs04 TO sfs04
   SELECT ima02,ima021 INTO g_ima02, g_ima021
     FROM ima_file
    WHERE ima01=g_sfs04
   DISPLAY g_ima02 TO FORMONLY.old_ima02
   DISPLAY g_ima021 TO FORMONLY.old_ima021
   DISPLAY g_sfs07 TO sfs07
   DISPLAY g_tot_sfs05 TO FORMONLY.tot_sfs05
END FUNCTION 
#FUN-8A0140
