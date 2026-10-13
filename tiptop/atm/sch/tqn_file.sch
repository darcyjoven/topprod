/*
================================================================================
檔案代號:tqn_file
檔案名稱:产品价格单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqn_file
(
tqn01       varchar2(10) NOT NULL,   /*订价编号                               */
tqn02       number(5) NOT NULL,      /*项次                                   */
tqn03       varchar2(40),            /*产品编号                               */
tqn04       varchar2(4),             /*订价单位                               */
tqn05       number(20,6),            /*税前单价                               */
tqn06       date,                    /*生效日期                               */
tqn07       date,                    /*失效日期                               */
tqnud01     varchar2(255),           /*自订字段-Textedit                      */
tqnud02     varchar2(40),            /*自订字段-文字                          */
tqnud03     varchar2(40),            /*自订字段-文字                          */
tqnud04     varchar2(40),            /*自订字段-文字                          */
tqnud05     varchar2(40),            /*自订字段-文字                          */
tqnud06     varchar2(40),            /*自订字段-文字                          */
tqnud07     number(15,3),            /*自订字段-数值                          */
tqnud08     number(15,3),            /*自订字段-数值                          */
tqnud09     number(15,3),            /*自订字段-数值                          */
tqnud10     number(10),              /*自订字段-整数                          */
tqnud11     number(10),              /*自订字段-整数                          */
tqnud12     number(10),              /*自订字段-整数                          */
tqnud13     date,                    /*自订字段-日期                          */
tqnud14     date,                    /*自订字段-日期                          */
tqnud15     date,                    /*自订字段-日期                          */
tqn08       number(20,6) DEFAULT '0' NOT NULL, /*原价格*/
tqn09       number(5,2),             /*折扣率%                                */
tqn10       number(5,2)              /*供货商分摊比率%                        */
);

create        index tqn_02 on tqn_file (tqn01,tqn03,tqn04);
alter table tqn_file add  constraint tqn_pk primary key  (tqn01,tqn02) enable validate;
grant select on tqn_file to tiptopgp;
grant update on tqn_file to tiptopgp;
grant delete on tqn_file to tiptopgp;
grant insert on tqn_file to tiptopgp;
grant index on tqn_file to public;
grant select on tqn_file to ods;
