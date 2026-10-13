/*
================================================================================
檔案代號:hrdta_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdta_file
(
hrdta01     varchar2(10) NOT NULL,   /*统筹体系编码                           */
hrdta02     varchar2(20) NOT NULL,   /*参数ID                                 */
hrdta03     varchar2(20),            /*统筹类型                               */
hrdta04     number(20,6),            /*定额基数                               */
hrdta05     varchar2(20),            /*薪资基数                               */
hrdta06     varchar2(20),            /*保留方式                               */
hrdta07     number(5),               /*保留小数位                             */
hrdta08     number(20,6),            /*公司比例                               */
hrdta09     number(20,6),            /*个人比例                               */
hrdta10     number(20,6),            /*公司最小扣款                           */
hrdta11     number(20,6),            /*公司最大扣款                           */
hrdta12     number(20,6),            /*个人最小扣款                           */
hrdta13     number(20,6),            /*个人最大扣款                           */
hrdtaacti   varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdtauser   varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdtagrup   varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdtamodu   varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdtadate   date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdtaoriu   varchar2(10),            /*资料建立者                             */
hrdtaorig   varchar2(10),            /*资料建立部门                           */
hrdtaud01   varchar2(255),           /*自订栏位-Textedit                      */
hrdtaud02   varchar2(40),            /*自订栏位-文字                          */
hrdtaud03   varchar2(40),            /*自订栏位-文字                          */
hrdtaud04   varchar2(40),            /*自订栏位-文字                          */
hrdtaud05   varchar2(40),            /*自订栏位-文字                          */
hrdtaud06   varchar2(40),            /*自订栏位-文字                          */
hrdtaud07   number(15,3),            /*自订栏位-数值                          */
hrdtaud08   number(15,3),            /*自订栏位-数值                          */
hrdtaud09   number(15,3),            /*自订栏位-数值                          */
hrdtaud10   number(10),              /*自订栏位-整数                          */
hrdtaud11   number(10),              /*自订栏位-整数                          */
hrdtaud12   number(10),              /*自订栏位-整数                          */
hrdtaud13   date,                    /*自订栏位-日期                          */
hrdtaud14   date,                    /*自订栏位-日期                          */
hrdtaud15   date                     /*自订栏位-日期                          */
);

alter table hrdta_file add  constraint tpc_hrdta_pk primary key  (hrdta01,hrdta02) enable validate;
grant select on hrdta_file to tiptopgp;
grant update on hrdta_file to tiptopgp;
grant delete on hrdta_file to tiptopgp;
grant insert on hrdta_file to tiptopgp;
grant index on hrdta_file to public;
grant select on hrdta_file to ods;
