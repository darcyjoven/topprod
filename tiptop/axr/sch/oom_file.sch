/*
================================================================================
檔案代號:oom_file
檔案名稱:发票簿档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oom_file
(
oom01       number(5) NOT NULL,      /*发票年度                               */
                                     /*發票年度                               */
oom02       number(5) NOT NULL,      /*发票月份-起始                          */
                                     /*發票月份-起始                          */
oom021      number(5) NOT NULL,      /*发票月份-截止                          */
                                     /*發票月份-截止  add in 99/12/24         */
oom03       varchar2(5) NOT NULL,    /*发票别                                 */
                                     /*發票別                                 */
                                     /*  預設'1',輸入時不可空白               */
oom04       varchar2(1) NOT NULL,    /*联数(0.园区收据 2.二联式 3.三          */
                                     /*联数 (2.二联式 3.三联式)               */
oom05       number(5) NOT NULL,      /*簿号                                   */
                                     /*簿號 (每月各發票別各聯式均由'1'編起)   */
oom06       varchar2(1),             /*开立方式                               */
                                     /*開立方式 (1.電腦開立 2.人工開立)       */
oom07       varchar2(20),            /*起始发票号码                           */
                                     /*起始發票號碼                           */
oom08       varchar2(20),            /*截止发票号码                           */
                                     /*截止發票號碼                           */
oom09       varchar2(20),            /*已开发票号码                           */
                                     /*已開發票號碼                           */
oom10       date,                    /*已开发票日期                           */
                                     /*已開發票日期                           */
oomuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
oomgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
oommodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
oomdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
oom11       number(5),               /*发票号码起始流水号位数                 */
oom12       number(5),               /*发票号码截止流水号位数                 */
oom13       varchar2(20),            /*申报税号                               */
oomorig     varchar2(10),            /*资料建立部门                           */
oomoriu     varchar2(10),            /*资料建立者                             */
oom14       varchar2(10),            /*发放门店                               */
oompos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
oom15       varchar2(1) DEFAULT 'C' NOT NULL, /*发票种类*/
oom16       varchar2(20),            /*发票代码                               */
oom17       varchar2(1) DEFAULT 'N' NOT NULL, /*电子发票否*/
oom18       varchar2(10)             /*收银机代码                             */
);

alter table oom_file add  constraint oom_pk primary key  (oom01,oom02,oom021,oom03,oom04,oom05,oom15) enable validate;
grant select on oom_file to tiptopgp;
grant update on oom_file to tiptopgp;
grant delete on oom_file to tiptopgp;
grant insert on oom_file to tiptopgp;
grant index on oom_file to public;
grant select on oom_file to ods;
