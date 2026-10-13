/*
================================================================================
檔案代號:apa_file
檔案名稱:应付账款单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table apa_file
(
apa00       varchar2(2),             /*帐款性质                               */
                                     /*帳款性質                               */
                                     /*  11.進貨發票 12.雜項發票 15.預付申請  */
                                     /*  16.請款付款 17.借款申請              */
                                     /*  21.折讓 22.D.M. 23.預付 24.暫付      */
apa01       varchar2(20) NOT NULL,   /*帐款编号                               */
                                     /*帳款編號                               */
apa02       date,                    /*帐款日期                               */
                                     /*帳款日期                               */
apa05       varchar2(10),            /*送货厂商编号                           */
                                     /*送貨廠商編號  pmc01                    */
apa06       varchar2(10),            /*付款厂商编号                           */
                                     /*付款廠商編號  pmc01                    */
apa07       varchar2(40),            /*付款厂商简称                           */
                                     /*付款廠商簡稱                           */
apa08       varchar2(1000),          /*发票号码                               */
                                     /*發票號碼      apk03,apa01=apk01        */
apa09       date,                    /*发票日期                               */
                                     /*發票日期                               */
apa11       varchar2(10),            /*付款方式                               */
                                     /*付款方式      pma01                    */
apa12       date,                    /*应付款日                               */
                                     /*應付款日                               */
apa13       varchar2(4),             /*币种                                   */
                                     /*幣別          azi01                    */
apa14       number(20,10),           /*汇率                                   */
                                     /*匯率     No.7952                       */
apa15       varchar2(4),             /*税种                                   */
                                     /*稅別          gec01                    */
apa16       number(9,4),             /*税率                                   */
                                     /*稅率          default gec04            */
apa17       varchar2(1),             /*扣抵区分                               */
                                     /*扣抵區分                               */
                                     /*  1.可扣抵進貨及費用                   */
                                     /*  2.可扣抵固定資產                     */
                                     /*  3.不可扣抵進貨及費用                 */
                                     /*  4.不可扣抵固定資產                   */
apa171      varchar2(2),             /*格式                                   */
                                     /*格式       default gec08               */
                                     /*  21.進項三聯式, 電子計算機            */
                                     /*  22.載有稅額的其它憑證                */
                                     /*  23.三聯式,退出折讓                   */
                                     /*  24.二聯式                            */
                                     /*  25.收銀機                            */
                                     /*  26.彙總登錄每張稅額伍佰元以下之      */
apa172      varchar2(1),             /*课税种                                 */
apa173      number(5),               /*申报年度                               */
apa174      number(5),               /*申报月份                               */
apa175      number(10),              /*申报流水编号                           */
apa18       varchar2(20),            /*厂商税号                               */
apa19       varchar2(10),            /*留置原因                               */
apa20       number(20,6),            /*原币留置金额                           */
apa21       varchar2(10),            /*请款人员                               */
apa22       varchar2(10),            /*请款部门                               */
apa23       varchar2(10),            /*付款营运中心                           */
apa24       number(5),               /*允许票期                               */
apa25       varchar2(255),           /*备注                                   */
apa31f      number(20,6) NOT NULL,   /*原币税前                               */
apa32f      number(20,6) NOT NULL,   /*原币税额                               */
apa33f      number(20,6) NOT NULL,   /*原币差异                               */
apa34f      number(20,6) NOT NULL,   /*原币合计                               */
apa35f      number(20,6) NOT NULL,   /*原币已付                               */
apa31       number(20,6) NOT NULL,   /*本币税前                               */
apa32       number(20,6) NOT NULL,   /*本币税额                               */
apa33       number(20,6) NOT NULL,   /*本币差异                               */
apa34       number(20,6) NOT NULL,   /*本币合计                               */
apa35       number(20,6) NOT NULL,   /*本币已付                               */
apa36       varchar2(10),            /*帐款类型                               */
apa41       varchar2(1),             /*确认码                                 */
apa42       varchar2(2),             /*作废码                                 */
apa43       date,                    /*抛转凭证日期                           */
apa44       varchar2(20),            /*抛转凭证编号                           */
apa45       date,                    /*No Use                                 */
apa46       varchar2(20),            /*发票代码                               */
apa51       varchar2(24),            /*税前科目                               */
apa52       varchar2(24),            /*税额科目                               */
apa53       varchar2(24),            /*差异科目                               */
apa54       varchar2(24),            /*合计金额科目                           */
apa55       varchar2(1),             /*付款处理                               */
apa56       varchar2(1),             /*差异处理                               */
apa57f      number(20,6) NOT NULL,   /*原币单身合计金额                       */
apa57       number(20,6),            /*本币单身合计金额                       */
apa58       varchar2(1),             /*折让性质                               */
apa59       varchar2(1),             /*自动生成价格折让单否                   */
apa60f      number(20,6) NOT NULL,   /*原币折让扣款金额                       */
apa61f      number(20,6) NOT NULL,   /*原币折让扣款税额                       */
apa60       number(20,6) NOT NULL,   /*本币折让扣款金额                       */
apa61       number(20,6) NOT NULL,   /*本币折让扣款税额                       */
apa62       varchar2(20),            /*待抵预付帐款编号                       */
apa63       varchar2(6),             /*签核状态                               */
apa64       date,                    /*票据到期日                             */
apa65f      number(20,6) NOT NULL,   /*原币直接冲帐金额                       */
apa65       number(20,6) NOT NULL,   /*本币直接冲帐金额                       */
apa66       varchar2(10),            /*项目编号                               */
apa67       varchar2(30),            /*核算项一                               */
apa68       varchar2(30),            /*核算项二                               */
apa69       varchar2(30),            /*核算项三                               */
apa70       varchar2(30),            /*核算项四                               */
apa71       varchar2(10),            /*预算编号                               */
apa72       number(20,10),           /*重估汇率                               */
apa73       number(20,6),            /*本币未冲金额                           */
apa74       varchar2(1),             /*外购付款否                             */
apa75       varchar2(1),             /*外购资料                               */
apa99       varchar2(17),            /*多角序号                               */
apainpd     date,                    /*录入日期                               */
apamksg     varchar2(1),             /*是否签核                               */
apasign     varchar2(4),             /*签核等级                               */
apadays     number(5),               /*签核完成天数                           */
apaprit     number(5),               /*签核优先等级                           */
apasmax     number(5),               /*应签等级                               */
apasseq     number(5),               /*已签等级                               */
apaprno     number(5),               /*打印次数                               */
apaacti     varchar2(1),             /*资料有效码                             */
apauser     varchar2(10),            /*资料所有者                             */
apagrup     varchar2(10),            /*资料所有群                             */
apamodu     varchar2(10),            /*资料更改者                             */
apadate     date,                    /*最近更改日                             */
apa100      varchar2(10),            /*收货来源营运中心代码                   */
apa930      varchar2(10),            /*成本中心                               */
apa511      varchar2(24),            /*税前科目二                             */
apa521      varchar2(24),            /*税额科目二                             */
apa531      varchar2(24),            /*差异科目二                             */
apa541      varchar2(24),            /*合计金额科目二                         */
apa992      varchar2(20),            /*集团代付单号                           */
                                     /*For 內部帳戶                           */
apa37       number(20,6),            /*本币还款金额                           */
apa37f      number(20,6),            /*原币还款金额                           */
apa101      varchar2(20),            /*还款银行                               */
apa102      varchar2(2),             /*还款异动码                             */
apa26       varchar2(1),             /*直接扣抵类型                           */
apaud01     varchar2(255),           /*自订字段-Textedit                      */
apaud02     varchar2(40),            /*财务已阅                               */
apaud03     varchar2(40),            /*自订字段-文字                          */
apaud04     varchar2(40),            /*自订字段-文字                          */
apaud05     varchar2(40),            /*自订字段-文字                          */
apaud06     varchar2(40),            /*自订字段-文字                          */
apaud07     number(15,3),            /*自订字段-数值                          */
apaud08     number(15,3),            /*自订字段-数值                          */
apaud09     number(15,3),            /*自订字段-数值                          */
apaud10     number(10),              /*自订字段-整数                          */
apaud11     number(10),              /*自订字段-整数                          */
apaud12     number(10),              /*自订字段-整数                          */
apaud13     date,                    /*自订字段-日期                          */
apaud14     date,                    /*自订字段-日期                          */
apaud15     date,                    /*自订字段-日期                          */
apa76       varchar2(1),             /*经营方式                               */
apalegal    varchar2(10) NOT NULL,   /*所属法人                               */
apa77       varchar2(20),            /*申报税号                               */
apaoriu     varchar2(10),            /*资料建立者                             */
apaorig     varchar2(10),            /*资料建立部门                           */
apa78       varchar2(20),            /*开账来源AP单据号码                     */
apa79       varchar2(1) DEFAULT '0' NOT NULL, /*调帐生成*/
apa80       varchar2(20)             /*代冲暂估款单号                         */
);

create        index apa_03 on apa_file (apa12);
create        index apa99 on apa_file (apa99);
create        index apa_02 on apa_file (apa08);
create        index apa_05 on apa_file (apa44);
create        index apa_04 on apa_file (apa06);
alter table apa_file add  constraint apa_pk primary key  (apa01) enable validate;
grant select on apa_file to tiptopgp;
grant update on apa_file to tiptopgp;
grant delete on apa_file to tiptopgp;
grant insert on apa_file to tiptopgp;
grant index on apa_file to public;
grant select on apa_file to ods;
