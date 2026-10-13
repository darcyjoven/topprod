/*
================================================================================
檔案代號:pjb_file
檔案名稱:WBS基本资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjb_file
(
pjb01       varchar2(10) NOT NULL,   /*项目编号                               */
pjb02       varchar2(30) NOT NULL,   /*wbs编号                                */
pjb03       varchar2(80),            /*WBS名称                                */
pjb04       number(5),               /*WBS层级                                */
pjb05       varchar2(10),            /*本级编码                               */
pjb06       varchar2(30),            /*上层编码                               */
pjb07       varchar2(10),            /*WBS分类                                */
pjb08       varchar2(1),             /*WBS优先级                              */
pjb09       varchar2(1),             /*尾阶wbs否                              */
pjb10       varchar2(1),             /*计划成本否                             */
pjb11       varchar2(1),             /*成本对象否                             */
pjb12       number(15,3),
pjb13       varchar2(1),             /*进度审核方式                           */
pjb14       number(15,6),            /*审核完工率                             */
pjb15       date,                    /*计划开工日                             */
pjb16       date,                    /*计划完工日                             */
pjb17       date,                    /*推算开工日                             */
pjb18       date,                    /*推算完工日                             */
pjb19       date,                    /*实际开工日                             */
pjb20       date,                    /*实际完工日                             */
pjb21       varchar2(1),             /*状态码                                 */
pjb22       varchar2(10),            /*进度审核人                             */
pjb23       date,                    /*进度确认日期                           */
pjb24       date,                    /*最近推算日                             */
pjb25       varchar2(1),             /*带活动                                 */
pjbacti     varchar2(1),             /*资料有效码                             */
pjbdate     date,                    /*最近更改日                             */
pjbgrup     varchar2(10),            /*资料所有部门                           */
pjbmodu     varchar2(10),            /*资料更改者                             */
pjbuser     varchar2(10),            /*资料所有者                             */
pjboriu     varchar2(10),            /*资料建立者                             */
pjborig     varchar2(10)             /*资料建立部门                           */
);

alter table pjb_file add  constraint pjb_pk primary key  (pjb01,pjb02) enable validate;
grant select on pjb_file to tiptopgp;
grant update on pjb_file to tiptopgp;
grant delete on pjb_file to tiptopgp;
grant insert on pjb_file to tiptopgp;
grant index on pjb_file to public;
grant select on pjb_file to ods;
