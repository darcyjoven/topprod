/*
================================================================================
檔案代號:hrax_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table hrax_file
(
hrax01      varchar2(20) NOT NULL,   /*工号                                   */
hrax02      varchar2(20),            /*姓名                                   */
hrax03      varchar2(20),            /* 公司编码                              */
hrax04      varchar2(20),            /* 部门编码                              */
hrax05      varchar2(20),            /*职位编码                               */
hrax06      date,                    /* 入司日期                              */
hrax07      varchar2(20),            /*直接主管编码                           */
hrax08      date,                    /* 预计转正日期                          */
hrax09      date,                    /* 试用开始日期                          */
hrax10      date,                    /* 现试用日期                            */
hrax11      varchar2(20),            /*员工状态编码                           */
hrax12      date,                    /* 离职日期                              */
hrax13      varchar2(20),            /*备注                                   */
hrax14      varchar2(20),            /*证件类型                               */
hrax15      varchar2(20),            /*证件号码                               */
hrax16      date,                    /*出生日期                               */
hrax17      varchar2(20),            /*性别                                   */
hrax18      varchar2(20),            /*员工属性                               */
hrax19      varchar2(20),            /*最高学历                               */
hrax20      varchar2(20),            /*直接/间接                              */
hraxacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hraxuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hraxgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hraxmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hraxdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hraxoriu    varchar2(10),            /*资料建立者                             */
hraxorig    varchar2(10),            /*资料建立部门                           */
hrax21      varchar2(20),
hraxud01    varchar2(20),
hraxud02    number(20),
hraxud03    date
);

alter table hrax_file add  constraint tpc_hrax_pk primary key  (hrax01) enable validate;
grant select on hrax_file to tiptopgp;
grant update on hrax_file to tiptopgp;
grant delete on hrax_file to tiptopgp;
grant insert on hrax_file to tiptopgp;
grant index on hrax_file to public;
grant select on hrax_file to ods;
