/*
================================================================================
檔案代號:vbb_file
檔案名稱:APS单据追溯
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbb_file
(
vbb01       varchar2(60) NOT NULL,   /*供给来源单据编号                       */
vbb02       number(15,3),            /*需求来源需求数量                       */
vbb03       varchar2(60) NOT NULL,   /*需求来源单据编号                       */
vbb04       number(1),               /*需求订单                               */
vbb05       number(15,3),            /*预计供给数量                           */
vbb06       number(1),               /*采购单 or 工单                         */
vbb07       number(15,3),            /*供给最大量                             */
vbb08       number(1),               /*是否锁定                               */
vbb09       varchar2(40),            /*料号                                   */
vbbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vbblegal    varchar2(10) NOT NULL,   /*所属法人                               */
vbb10       varchar2(60),            /*APS保留字段文字                        */
vbb11       varchar2(60),            /*APS保留字段文字                        */
vbb12       varchar2(60),            /*APS保留字段文字                        */
vbb13       number(9),               /*APS保留字段数值                        */
vbb14       number(18,8),            /*APS保留字段浮点数                      */
vbb15       number(18,8),            /*APS保留字段浮点数                      */
vbb16       date,                    /*APS保留字段日期                        */
vbb17       date                     /*APS保留字段日期                        */
);

alter table vbb_file add  constraint vbb_pk primary key  (vbblegal,vbbplant,vbb01,vbb03) enable validate;
grant select on vbb_file to tiptopgp;
grant update on vbb_file to tiptopgp;
grant delete on vbb_file to tiptopgp;
grant insert on vbb_file to tiptopgp;
grant index on vbb_file to public;
grant select on vbb_file to ods;
