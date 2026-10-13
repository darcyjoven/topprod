/*
================================================================================
檔案代號:pne_file
檔案名稱:请购变更单单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pne_file
(
pne01       varchar2(20) DEFAULT ' ' NOT NULL, /*请购单号*/
pne02       number(5) DEFAULT '0' NOT NULL, /*变更序号*/
pne03       date,                    /*变更日期                               */
pne04       varchar2(10),            /*变更理由码                             */
pne05       varchar2(10),            /*变更人员                               */
pne06       varchar2(1) DEFAULT 'N' NOT NULL, /*审核否*/
pne09       varchar2(4),             /*变更前币种                             */
pne09b      varchar2(4),             /*变更后币种                             */
pne10       varchar2(10),            /*变更前付款条件                         */
pne10b      varchar2(10),            /*变更后付款条件                         */
pne11       varchar2(6),             /*变更前价格条件                         */
pne11b      varchar2(6),             /*变更后价格条件                         */
pne12       varchar2(10),            /*变更前送货地址                         */
pne12b      varchar2(10),            /*变更后送货地址                         */
pne13       varchar2(10),            /*变更前帐单地址                         */
pne13b      varchar2(10),            /*变更后帐单地址                         */
pneacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
pneuser     varchar2(10),            /*资料所有者                             */
pnegrup     varchar2(10),            /*资料所有群                             */
pnemodu     varchar2(10),            /*资料更改者                             */
pnedate     date,                    /*最近更改日                             */
pneud01     varchar2(255),           /*自订字段-Textedit                      */
pneud02     varchar2(40),            /*自订字段-文字                          */
pneud03     varchar2(40),            /*自订字段-文字                          */
pneud04     varchar2(40),            /*自订字段-文字                          */
pneud05     varchar2(40),            /*自订字段-文字                          */
pneud06     varchar2(40),            /*自订字段-文字                          */
pneud07     number(15,3),            /*自订字段-数值                          */
pneud08     number(15,3),            /*自订字段-数值                          */
pneud09     number(15,3),            /*自订字段-数值                          */
pneud10     number(10),              /*自订字段-整数                          */
pneud11     number(10),              /*自订字段-整数                          */
pneud12     number(10),              /*自订字段-整数                          */
pneud13     date,                    /*自订字段-日期                          */
pneud14     date,                    /*自订字段-日期                          */
pneud15     date,                    /*自订字段-日期                          */
pneplant    varchar2(10),            /*所属工厂                               */
pnelegal    varchar2(10),            /*所属法人                               */
pneoriu     varchar2(10),            /*资料建立者                             */
pneorig     varchar2(10),            /*资料建立部门                           */
pne14       varchar2(1) DEFAULT '0' NOT NULL, /*状况码*/
pnemksg     varchar2(1) DEFAULT 'N' NOT NULL, /*签核否*/
pneconf     varchar2(1) DEFAULT ' ' NOT NULL, /*发出否*/
pnesendd    date,                    /*发出日期                               */
pnesendt    varchar2(8),             /*发出时间                               */
pnesendu    varchar2(10)             /*发出人员                               */
);

alter table pne_file add  constraint pne_pk primary key  (pne01,pne02) enable validate;
grant select on pne_file to tiptopgp;
grant update on pne_file to tiptopgp;
grant delete on pne_file to tiptopgp;
grant insert on pne_file to tiptopgp;
grant index on pne_file to public;
grant select on pne_file to ods;
