/*
================================================================================
檔案代號:tc_deb_file
檔案名稱:demo作业单身资料1
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_deb_file
(
tc_deb01    varchar2(20) NOT NULL,   /*demo单号                               */
tc_deb02    number(5) NOT NULL,      /*demo项次                               */
tc_deb03    number(5) NOT NULL,      /*demo修改班次                           */
tc_deb04    varchar2(1),             /*demoCheckbox                           */
tc_deb05    varchar2(1),             /*demo                                   */
tc_deb06    varchar2(20),            /*demobtnedit                            */
tc_deb07    varchar2(20),            /*demoComboBox                           */
tc_deb08    varchar2(5),             /*RadioGroup                             */
tc_deb09    number(5),               /*Slider                                 */
tc_deb10    number(5),               /*SpinEdit                               */
tc_deb11    varchar2(20),            /*TimeEdit                               */
tc_deb12    varchar2(500),           /*Image                                  */
tc_deb13    varchar2(500),           /*WebComponent                           */
tc_deb14    varchar2(1000),          /*demo备注                               */
tc_deb15    date NOT NULL,           /*demo创建时间                           */
tc_deb16    varchar2(20) NOT NULL,   /*demo创建人员                           */
tc_deb17    date NOT NULL,           /*demo修改时间                           */
tc_deb18    varchar2(20) NOT NULL,   /*demo修改人员                           */
tc_deb19    date NOT NULL,           /*demo审核时间                           */
tc_deb20    varchar2(20) NOT NULL,   /*demo审核人员                           */
tc_debud01  varchar2(20),
tc_debud02  varchar2(20),
tc_debud03  varchar2(20),
tc_debud04  number(5),
tc_debud05  number(5),
tc_debud06  number(5),
tc_debud07  date,
tc_debud08  date,
tc_debud09  date,
tc_debud10  varchar2(1000)
);

create unique index tic_deb_01 on tc_deb_file (tc_deb01,tc_deb02,tc_deb03);
grant select on tc_deb_file to tiptopgp;
grant update on tc_deb_file to tiptopgp;
grant delete on tc_deb_file to tiptopgp;
grant insert on tc_deb_file to tiptopgp;
grant index on tc_deb_file to public;
grant select on tc_deb_file to ods;
