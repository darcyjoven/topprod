/*
================================================================================
檔案代號:vle_file
檔案名稱:MDS沖銷關聯檔--暫存
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vle_file
(
vle01       varchar2(10) NOT NULL,   /*aps版本                                */
vle02       varchar2(10) NOT NULL,   /*储存版本                               */
vle03       varchar2(40) NOT NULL,   /*料号                                   */
vle04       date NOT NULL,           /*归属时距日                             */
vle05       varchar2(1),             /*需求纳入方式                           */
vle06       number(15,3),            /*时距内总需求量                         */
vle07       number(15,3),            /*时距内冲销结果(+:表有余量 -:           */
vle08       date,                    /*需求日期                               */
vle09       number(15,3),            /*数量                                   */
vle10       varchar2(4),             /*单位                                   */
vle11       varchar2(20),            /*单据编号                               */
vle12       number(5),               /*项次                                   */
vle13       date,                    /*单据开立日期                           */
vle14       varchar2(10),            /*客户编号                               */
vle15       varchar2(10),            /*业务员                                 */
vle16       varchar2(1),             /*需求来源型式                           */
vleplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vlelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index vle_01 on vle_file (vle01,vle02);
grant select on vle_file to tiptopgp;
grant update on vle_file to tiptopgp;
grant delete on vle_file to tiptopgp;
grant insert on vle_file to tiptopgp;
grant index on vle_file to public;
grant select on vle_file to ods;
