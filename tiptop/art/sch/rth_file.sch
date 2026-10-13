/*
================================================================================
檔案代號:rth_file
檔案名稱:价格信息资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rth_file
(
rth01       varchar2(40) DEFAULT ' ' NOT NULL, /*产品编号*/
rth02       varchar2(4) NOT NULL,    /*计价单位                               */
rth03       number(20,8),            /*单位转换率                             */
rth04       number(20,6),            /*自定售价                               */
rth05       number(20,6),            /*自定会员价                             */
rth06       number(20,6),            /*自定最低价                             */
rthacti     varchar2(1),             /*有效否                                 */
rthcrat     date,                    /*资料创建日                             */
rthdate     date,                    /*最近更改日                             */
rthgrup     varchar2(10),            /*资料所有部门                           */
rthlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rthmodu     varchar2(10),            /*资料更改者                             */
rthplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rthpos      varchar2(1) DEFAULT '1', /*已传POS否                              */
rthuser     varchar2(10),            /*资料所有者                             */
rthorig     varchar2(10),            /*资料建立部门                           */
rthoriu     varchar2(10),            /*资料建立者                             */
rth07       varchar2(1) DEFAULT 'N' NOT NULL, /*開價否*/
rth08       number(20,6),            /*最高退价                               */
rth09       date                     /*生效日期                               */
);

alter table rth_file add  constraint rth_pk primary key  (rth01,rth02,rthplant) enable validate;
grant select on rth_file to tiptopgp;
grant update on rth_file to tiptopgp;
grant delete on rth_file to tiptopgp;
grant insert on rth_file to tiptopgp;
grant index on rth_file to public;
grant select on rth_file to ods;
