# Prog. Version..: '5.30.06-13.03.28(00010)'     #
#
# Program name...: s_prg_tab.4gl
# Descriptions...: 產生分錄程式對應資料來源檔案&KEY值欄位代號
# Date & Author..: 
# Memo...........: 傳入 p_prg  回傳 l_file,l_key2,l_key2,l_key3
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690105 06/09/29 By Sarah l_key2欄位定義錯誤
# Modify.........: No.MOD-6C0140 06/12/25 By Sarah afat101應該是要傳入far_file,far01,far02
# Modify.........: No.MOD-760005 07/06/04 By Smapmin 增加axrp310
# Modify.........: No.TQC-760156 07/06/20 By Rayven 新增gxrq600,gapq600,gnmq600的情況
# Modify.........: No.MOD-770161 07/08/06 By Smapmin 增加axrp304
# Modify.........: No.CHI-760003 07/06/21 By wujie  新增axmp840,axmp845,axmp880,axmp885,axmp860的判斷情況
# Modify.........: No.CHI-7C0001 07/12/03 By Smapmin 增加anmt605
# Modify.........: No.MOD-810118 08/01/16 By Smapmin 增加anmt830
# Modify.........: No.MOD-810237 08/01/31 By Smapmin 增加aapt331
# Modify.........: No.MOD-810262 08/01/31 By Smapmin 增加aapt160,aapt260
# Modify.........: No.MOD-840128 08/04/16 By Smapmin 增加aapp310
# Modify.........: No.MOD-830219 08/03/27 By Carol 增加aapt121,aapt151
# Modify.........: No.MOD-860324 08/07/08 By Sarah 增加aapp110,aapp111,aapp112,aapp115,aapp117與aapt110一致
# Modify.........: No.MOD-880056 08/08/07 By Sarah aapt900修改為抓aqa_file
# Modify.........: No.FUN-880027 08/08/11 By Sarah 1.將l_file,l_key1,l_key2,l_ke3放大成CHAR(1000)
#                                                  2.修改anmt150,anmt250,anmt302,afat110
# Modify.........: No.CHI-8B0013 08/11/24 By Sarah gapq600修改為抓apa_file,gxrq600修改為抓oma_file
# Modify.........: No.MOD-8C0202 08/12/19 By sherry 增加anmt920/anmt930/anmt940
# Modify.........: No.MOD-930161 09/03/13 By lilingyu 產生異動碼及摘要處理的部分少設了axrp330
# Modify.........: No.FUN-960141 09/07/10 By dongbg GP5.2修改:增加程序axrt410
# Modify.........: No.MOD-970274 09/07/30 By mike anmt250應多抓取npn_file    
# Modify.........: No.FUN-A10105 10/02/03 By wujie aapt110,aapt330,axrt300,axrt400增加单身栏位
# Modify.........: No:CHI-A20022 10/03/03 By sabrina aapt330、axrt400分錄底稿摘要彈性設定要能抓取單身資料
# Modify.........: No.FUN-A10005 10/08/24 By chenmoyan 增加aglp701
# Modify.........: No:CHI-AA0005 10/10/13 By Summer 多擷取aapt900(aqb)單身資料
# Modify.........: No:MOD-B20024 11/02/10 By Dido axrt210 key 值調整
# Modify.........: No:CHI-B50044 11/06/02 By Dido 增加 anmt610
# Modify.........: No:MOD-B80146 11/08/15 By Carrier 增加axrt401
# Modify.........: No.MOD-B80327 11/09/01 By Polly 設定多table抓摘要、異動碼的程式，key值串接全部移到l_key1
# Modify.........: No:MOD-C40220 12/04/30 By Elise 加入aapt750
# Modify.........: No:MOD-C70024 12/07/03 By Carrier增加aapt332/aapt335
# Modify.........: No:MOD-D30232 13/03/28 By Alberti  anmt150 增加 npl_file 條件為 npl01 = npm01
# Modify.........: No:MOD-D40161 13/04/23 By Vampire aapt120等程式是抓取apa_file串apb_file,請改為OUTER寫法,否則當apb_file沒有維護就會帶不出資料
# Modify.........: No:MOD-DA0074 13/10/14 By fengmy 增加aapt140
# Modify.........: No:MOD-DB0107 13/11/01 By yinhy 增加anmt100



DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_prg_tab(p_prg)
DEFINE p_prg      LIKE zz_file.zz01        # 程式代號
DEFINE l_file     LIKE type_file.chr1000   #LIKE zta_file.zta01   #No.FUN-680147 VARCHAR(15)                                          #FUN-880027 mod
DEFINE l_key1     LIKE type_file.chr1000   #LIKE ztb_file.ztb03   #No.FUN-680147 VARCHAR(30)   #FUN-690105 modify   #nnm_file.nnm01   #FUN-880027 mod
DEFINE l_key2     LIKE type_file.chr1000   #LIKE ztb_file.ztb03   #No.FUN-680147 VARCHAR(30)   #FUN-690105 modify   #nnm_file.nnm02   #FUN-880027 mod
DEFINE l_key3     LIKE type_file.chr1000   #LIKE ztb_file.ztb03   #No.FUN-680147 VARCHAR(30)   #FUN-690105 modify   #nnm_file.nnm03   #FUN-880027 mod
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET l_file=''
   LET l_key1=''
   LET l_key2=''
   LET l_key3=''
   CASE 
     WHEN (p_prg = 'aapt110' OR p_prg = 'aapt120' OR p_prg = 'aapt150' OR
           p_prg = 'aapt210' OR p_prg = 'aapt220' OR p_prg = 'aapt160' OR   #MOD-810262
           p_prg = 'aapt260' OR p_prg = 'aapt121' OR p_prg = 'aapt151' OR   #MOD-830219-modify  #MOD-810262
           p_prg = 'aapt140' OR                                             #MOD-DA0074 add
           p_prg = 'aapp110' OR p_prg = 'aapp111' OR p_prg = 'aapp112' OR   #MOD-860324 add
           p_prg = 'aapp115' OR p_prg = 'aapp117' )                         #MOD-860324 add
#No.FUN-A10105 --begin
#                            LET l_file='apa_file'
#                            LET l_key1='apa01'
                             #LET l_file='apa_file,apb_file' #MOD-D40161 mark 
                            #LET l_key1='apa01'                  #MOD-B80327 mark
                            #LET l_key2='apa01 =apb01 AND apb02' #MOD-B80327 mark
                             #LET l_key1='apa01 =apb01 AND apa01' #MOD-B80327 add  #MOD-D40161 mark 
                             #LET l_key2='apb02'                  #MOD-B80327 add  #MOD-D40161 mark 
                            #MOD-D40161 add start -----
                             LET l_file='apa_file LEFT JOIN apb_file ON apa01=apb01'
                             LET l_key1='apa01'
                             LET l_key2='apb02'
                            #MOD-D40161 add end  -----                             
#No.FUN-A10105 --end
 
     WHEN p_prg = 'aapt330' OR p_prg = 'aapt331' OR p_prg = 'aapp310'    #MOD-840128
                            OR p_prg = 'aapt332' OR p_prg = 'aapt335'    #MOD-C70024
                             LET l_file='apf_file,OUTER apg_file,OUTER aph_file'       #CHI-A20022 add apg_file,aph_file 
                            #LET l_key1='apf01'                                                     #MOD-B80327 mark
                            #LET l_key2='apf01=apg_file.apg01 AND apg_file.apg02'   #CHI-A20022 add #MOD-B80327 mark
                            #LET l_key3='apf01=aph_file.aph01 AND aph_file.aph02'   #CHI-A20022 add #MOD-B80327 mark
                             LET l_key1='apf01=apg_file.apg01 AND apf01=aph_file.aph01 AND apf01'   #MOD-860324 add
                             LET l_key2='apg_file.apg02'                                            #MOD-860324 add
                             LET l_key3='aph_file.aph02'                                            #MOD-860324 add
               
     WHEN (p_prg = 'aapt711' OR p_prg = 'aapt720' OR p_prg = 'aapt740' OR
           p_prg = 'aapt741' OR p_prg = 'aapt750' )             #MOD-C40220 add aapt750
                             LET l_file='ala_file'
                             LET l_key1='ala01'
 
     WHEN p_prg = 'aapt810'  LET l_file='alk_file'
                             LET l_key1='alk01'
               
     WHEN p_prg = 'aapt820'  LET l_file='alh_file'
                             LET l_key1='alh01'
               
     WHEN p_prg = 'aapt900'  LET l_file='aqa_file,aqb_file'   #MOD-880056 mod  #'apa_file' #CHI-AA0005 add aqb_file
                            #LET l_key1='aqa01'      #MOD-880056 mod  #'apa01'  #MOD-B80327 mark
                            #LET l_key2='aqa01=aqb01 AND aqb02' #CHI-AA0005 add #MOD-B80327 mark
                             LET l_key1='aqa01=aqb01 AND aqa01' #MOD-B80327 add 
                             LET l_key2='aqb02'                 #MOD-B80327 add 
 
     #AXR
     WHEN p_prg = 'axrt200'  LET l_file='ola_file'
                             LET l_key1='ola01'
               
     WHEN p_prg = 'axrt201'  LET l_file='ole_file'
                             LET l_key1='ole01'
               
     WHEN p_prg = 'axrt210'  LET l_file='olc_file'
                             LET l_key1='olc29'       #MOD-B20024 mod olc01 -> olc29 

   # WHEN (p_prg = 'axrt300' OR p_prg = 'axrp310' OR p_prg = 'axrp304')  #MOD-760005   #MOD-770161  #MOD-930161 MARK
     WHEN (p_prg = 'axrt300' OR p_prg = 'axrp310' OR p_prg = 'axrp304' 
                             OR p_prg = 'axrp330' OR p_prg = 'aglp701') #MOD-930161 #FUN-A10005 add aglp701
                             LET l_file='oma_file'
                             LET l_key1='oma01'
               
   # WHEN p_prg = 'axrt400'  LET l_file='ooa_file'  #FUN-960141
     WHEN (p_prg = 'axrt400' OR p_prg = 'axrt410' OR p_prg = 'axrt401' )  #FUN-960141  #No.MOD-B80146  add axrt401
                             LET l_file='ooa_file,oob_file'     #CHI-A20022 add oob_file
                            #LET l_key1='ooa01'                 #MOD-B80327 mark
                            #LET l_key2='ooa01=oob01 AND oob02' #CHI-A20022 add #MOD-B80327 mark
                             LET l_key1='ooa01=oob01 AND ooa01' #MOD-B80327 add
                             LET l_key2='oob02'                 #MOD-B80327 add 
     #ANM          
     WHEN p_prg = 'anmi820'  LET l_file='gxf_file'
                             LET l_key1='gxf011'
               
    #str FUN-880027 mod
    #WHEN p_prg = 'anmt150'  LET l_file='npm_file' #給單身
    #                        LET l_key1='npm01'
    #                        LET l_key2='npm02'   #FUN-690105 modify
     WHEN p_prg = 'anmt150' #LET l_file='npm_file,nmd_file'                       #MOD-D30232 mark
                             LET l_file='npm_file,nmd_file,npl_file'              #MOD-D30232
                            #LET l_key1='npm01'                 #MOD-B80327 mark
                            #LET l_key2='nmd01=npm03 AND npm02' #MOD-B80327 mark
                            #LET l_key1='nmd01=npm03 AND npm01' #MOD-B80327 add   #MOD-D30232 mark
                             LET l_key1='nmd01=npm03 AND npl01 = npm01 AND npm01' #MOD-D30232 
                             LET l_key2='npm02'                 #MOD-B80327 add
                            
                             
    #end FUN-880027 mod
 
     WHEN p_prg = 'anmt200'  LET l_file='nmh_file'
                             LET l_key1='nmh01'
     WHEN p_prg = 'anmt100'  LET l_file='nmd_file'         #MOD-DB0107
                             LET l_key1='nmd01'            #MOD-DB0107
               
    #str FUN-880027 mod
    #WHEN p_prg = 'anmt250'  LET l_file='npo_file'  #給單身
    #                        LET l_key1='npo01'
    #                        LET l_key2='npo02'
     WHEN p_prg = 'anmt250'  LET l_file='npo_file,nmh_file,npn_file' #MOD-970274 add npn_file  
                            #LET l_key1='npo01'                                 #MOD-B80327 mark
                            #LET l_key2='nmh01=npo03 AND npo01=npn01 AND npo02' #MOD-970274 add npn #MOD-B80327 mark                                 
                             LET l_key1='nmh01=npo03 AND npo01=npn01 AND npo01' #MOD-B80327 add
                             LET l_key2='npo02'                                 #MOD-B80327 add                                 
    #end FUN-880027 mod
 
    #str FUN-880027 mod
    #WHEN p_prg = 'anmt302'  LET l_file='npk_file'  #給單身
    #                        LET l_key1='npk00'
    #                        LET l_key2='npk01'
     WHEN p_prg = 'anmt302'  LET l_file='npk_file,nmg_file'
                            #LET l_key1='npk00'                  #MOD-B80327 mark
                            #LET l_key2='nmg00=npk00 AND npk01'  #MOD-B80327 mark
                             LET l_key1='nmg00=npk00 AND npk00'  #MOD-B80327 add
                             LET l_key2='npk01'                  #MOD-B80327 add
    #end FUN-880027 mod
 
     WHEN p_prg = 'anmt400'  LET l_file='gxc_file'
                             LET l_key1='gxc01'
 
     WHEN p_prg = 'anmt420'  LET l_file='gxe_file'
                             LET l_key1='gxe01'
               
    #-CHI-B50044-add-               
     WHEN p_prg = 'anmt610'  LET l_file='gse_file'
                             LET l_key1='gse01'
    #-CHI-B50044-end-               

     WHEN p_prg = 'anmt710'  LET l_file='nne_file'
                             LET l_key1='nne01'
               
     WHEN p_prg = 'anmt720'  LET l_file='nng_file'
                             LET l_key1='nng01'
               
     WHEN p_prg = 'anmt730'  LET l_file='nnm_file'
                             LET l_key1='nnm01'
                             LET l_key2='nnm02'  #年度
                             LET l_key3='nnm03'  #月份
 
     WHEN p_prg = 'anmt740'  LET l_file='nni_file'
                             LET l_key1='nni01'
               
     WHEN p_prg = 'anmt750'  LET l_file='nnk_file'
                             LET l_key1='nnk01'
 
     WHEN p_prg = 'anmt820'  LET l_file='gxg_file'
                             LET l_key1='gxg011'
                             LET l_key2='gxg02'
               
     WHEN p_prg = 'anmt840'  LET l_file='gxi_file'
                             LET l_key1='gxi01'
               
     WHEN p_prg = 'anmt850'  LET l_file='gxk_file'
                             LET l_key1='gxk01'
 
     WHEN p_prg = 'anmt605'  LET l_file='gsh_file'   #CHI-7C0001
                             LET l_key1='gsh01'   #CHI-7C0001
 
     WHEN p_prg = 'anmt830'  LET l_file='gxh_file'   #MOD-810118
                             LET l_key1='gxh011'  #MOD-810118 
                             LET l_key2='gxh02'  #MOD-810118 
                             LET l_key3='gxh03'  #MOD-810118 
               
     #MOD-8C0202---Begin
     WHEN p_prg = 'anmt920'  LET l_file='nnv_file' 
                             LET l_key1='nnv01'
 
     WHEN p_prg = 'anmt930'  LET l_file='nnw_file'                                                                                  
                             LET l_key1='nnw01'
 
     WHEN p_prg = 'anmt940'  LET l_file='nnw_file'                                                                                  
                             LET l_key1='nnw01' 
     #MOD-8C0202---End 
     #AXM
     WHEN p_prg = 'axmt620'  LET l_file='oga_file'
                             LET l_key1='oga01'
 
     WHEN p_prg = 'axmt650'  LET l_file='oga_file'
                             LET l_key1='oga01'
 
     #GFA
     WHEN p_prg = 'gfat120'  LET l_file='fbt_file'   #FUN-690105 modify  #'fbt_fle'
                             LET l_key1='fbt01'
                             LET l_key2='fbt02'
 
     #AFA
    #start MOD-6C0140 modify fbr->far
     WHEN p_prg = 'afat101'  LET l_file='far_file'   #FUN-690105 modify  #'far_fle'
                             LET l_key1='far01'
                             LET l_key2='far02'
    #end MOD-6C0140 modify fbr->far
 
    #start MOD-6C0140 modify fbt->fat               
     WHEN p_prg = 'afat102'  LET l_file='fat_file'   #FUN-690105 modify  #'fat_fle'
                             LET l_key1='fat01'
                             LET l_key2='fat02'
    #end MOD-6C0140 modify fbt->fat               
               
     WHEN p_prg = 'afat105'  LET l_file='faz_file'   #FUN-690105 modify  #'faz_fle'
                             LET l_key1='faz01'
                             LET l_key2='faz02'
 
     WHEN p_prg = 'afat106'  LET l_file='fbb_file'   #FUN-690105 modify  #'fbb_fle'
                             LET l_key1='fbb01'
                             LET l_key2='fbb02'
               
    #start MOD-6C0140 modify fbc->fbd
     WHEN p_prg = 'afat107'  LET l_file='fbd_file'   #FUN-690105 modify  #'fbd_fle'
                             LET l_key1='fbd01'
                             LET l_key2='fbd02'
    #end MOD-6C0140 modify fbc->fbd
               
     WHEN p_prg = 'afat108'  LET l_file='fbh_file'   #FUN-690105 modify  #'fbh_fle'
                             LET l_key1='fbh01'
                             LET l_key2='fbh02'
               
     WHEN p_prg = 'afat109'  LET l_file='fbh_file'   #FUN-690105 modify  #'fbh_fle'
                             LET l_key1='fbh01'
                             LET l_key2='fbh02'
               
    #str FUN-880027 mod
    #WHEN p_prg = 'afat110'  LET l_file='fbf_file'   #FUN-690105 modify  #'fbf_fle'
    #                        LET l_key1='fbf01'
    #                        LET l_key2='fbf02'
     WHEN p_prg = 'afat110'  LET l_file='fbf_file,fbe_file,occ_file'
                            #LET l_key1='occ01=fbe04 AND fbf01'                  #MOD-B80327 mark
                            #LET l_key2='fbe01=fbf01 AND fbf02'                  #MOD-B80327 mark
                             LET l_key1='fbe01=fbf01 AND occ01=fbe04 AND fbf01'  #MOD-B80327 add
                             LET l_key2='fbf02'                                  #MOD-B80327 add
    #end FUN-880027 mod
               
     #No.TQC-760156 --start--
     WHEN p_prg = 'gxrq600'  LET l_file='oma_file'  #CHI-8B0013 mod #'oox_file'
                             LET l_key1='oma01'     #CHI-8B0013 mod #'oox03'
                            #LET l_key2='oox01'     #CHI-8B0013 mark
                            #LET l_key3='oox02'     #CHI-8B0013 mark
 
     WHEN p_prg = 'gapq600'  LET l_file='apa_file'  #CHI-8B0013 mod #'oox_file'
                             LET l_key1='apa01'     #CHI-8B0013 mod #'oox03'
                            #LET l_key2='oox01'     #CHI-8B0013 mark
                            #LET l_key3='oox02'     #CHI-8B0013 mark
 
     WHEN p_prg = 'gnmq600'  LET l_file='oox_file'
                             LET l_key1='oox03'
                             LET l_key2='oox01'
                             LET l_key3='oox02'
     #No.TQC-760156 --end--
#No.CHI-760003--begin                                                                                                               
     WHEN (g_prog = 'axmp840' OR g_prog = 'axmp880' OR g_prog = 'apmp860') AND p_prg ='axrt300'
                             LET l_file='oma_file'                                                                                  
                             LET l_key1='oma01'                                                                                     
     WHEN (g_prog = 'axmp840' OR g_prog = 'axmp880' OR g_prog = 'apmp860') AND p_prg ='aapt110'
                             LET l_file='apa_file'                                                                                  
                             LET l_key1='apa01'                                                                                     
#No.CHI-760003--end 
 
   END CASE
   RETURN l_file,l_key1,l_key2,l_key3
END FUNCTION
 
