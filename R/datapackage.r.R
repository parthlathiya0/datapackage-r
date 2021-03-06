#' Frictionless Data Package
#' 
#' @description Work frictionless with 'Data Packages' (<https://frictionlessdata.io/specs/data-package/>). 
#' Allows to load and validate any descriptor for a data package profile, 
#' create and modify descriptors and provides expose methods for reading 
#' and streaming data in the package. When a descriptor is a 'Tabular Data Package', 
#' it uses the 'Table Schema' package (<https://CRAN.R-project.org/package=tableschema.r>) 
#' and exposes its functionality, for each resource object in the resources field.
#' 
#' @docType package
#' 
#' @section Introduction:
#' 
#' A Data Package consists of:
#' \itemize{ 
#' \item{Metadata that describes the structure and contents of the package.}
#' \item{Resources such as data files that form the contents of the package.}
#' }
#' 
#' The Data Package metadata is stored in a "descriptor". This descriptor is what 
#' makes a collection of data a Data Package. The structure of this descriptor is 
#' the main content of the specification below.
#' 
#' In addition to this descriptor a data package will include other resources such as 
#' data files. The Data Package specification does NOT impose any requirements on their 
#' form or structure and can therefore be used for packaging any kind of data.
#' 
#' The data included in the package may be provided as:
#' \itemize{    
#' \item{Files bundled locally with the package descriptor.}
#' \item{Remote resources, referenced by URL.}
#' \item{"Inline" data which is included directly in the descriptor.}
#' }
#'  
#' \href{https://CRAN.R-project.org/package=jsonlite}{Jsolite package} is internally used 
#' to convert json data to list objects. The input parameters of functions could be json strings, 
#' files or lists and the outputs are in list format to easily further process your data in R environment 
#' and exported as desired. It is recommended to use \code{\link{helpers.from.json.to.list}} or 
#' \code{\link{helpers.from.list.to.json}} to convert json objects to lists and vice versa. More details about 
#' handling json you can see jsonlite documentation or vignettes \href{https://CRAN.R-project.org/package=jsonlite}{here}.
#' 
#' Several example data packages can be found in the \href{https://github.com/datasets}{datasets organization on github}, 
#' including:
#' 
#' \itemize{    
#' \item{\href{https://github.com/datasets/gdp}{World GDP}}
#' \item{\href{https://github.com/datasets/country-codes}{ISO 3166-2 country codes}}
#' }
#' 
#' 
#' @section Specification:
#' #
#' @section Descriptor:
#' 
#' The descriptor is the central file in a Data Package. It provides:
#'   
#' \itemize{    
#' \item{General metadata such as the package's title, license, publisher etc}
#' \item{A list of the data "resources" that make up the package including their 
#' location on disk or online and other relevant information (including, possibly, 
#' schema information about these data resources in a structured form)}
#' }
#' 
#' A Data Package descriptor \code{MUST} be a valid JSON object. (JSON is defined in 
#' \href{https://github.com/datasets/country-codes}{RFC 4627}). When available as a file it 
#' \code{MUST} be named \code{datapackage.json} and it \code{MUST} be placed in the top-level directory 
#' (relative to any other resources provided as part of the data package).
#' 
#' The descriptor \code{MUST} contain a \code{resources} property describing the data resources.
#' 
#' All other properties are considered \code{metadata} properties. The descriptor \code{MAY} contain any number of 
#' other \code{metadata} properties. The following sections provides a description of required and optional 
#' metadata properties for a Data Package descriptor.
#' 
#' Adherence to the specification does not imply that additional, non-specified properties cannot be used: 
#' a descriptor \code{MAY} include any number of properties in additional to those described as required and optional properties. 
#' For example, if you were storing time series data and wanted to list the temporal coverage of the data in the Data Package 
#' you could add a property \code{temporal} (cf \href{http://dublincore.org/documents/usageguide/qualifiers.shtml#temporal}{Dublin Core}):
#' 
#' \code{
#' "temporal": {
#' "name": "19th Century",
#' "start": "1800-01-01",
#' "end": "1899-12-31"
#' }
#' }
#' 
#' This flexibility enables specific communities to extend Data Packages as appropriate for the data 
#' they manage. As an example, the \href{https://frictionlessdata.io/specs/tabular-data-package/}{Tabular Data Package} 
#' specification extends Data Package to the case where all the data is tabular and stored in CSV.
#' 
#' @section Resource Information: 
#' Packaged data resources are described in the \code{resources} property of the package descriptor. 
#' This property \code{MUST} be an array/list of \code{objects}. Each object \code{MUST} follow the 
#' \href{https://frictionlessdata.io/specs/data-resource/}{Data Resource specification}.
#' 
#' See also \code{\link{Resource}} Class
#' 
#' @section Metadata:
#' #
#' @section Required Properties:
#' The \code{resources} property is required, with at least one resource.
#' 
#' @section Recommended Properties:
#' In addition to the required properties, the following properties \code{SHOULD} be included 
#' in every package descriptor:
#' 
#' \describe{
#' 
#' \item{\code{name}}{
#' A short url-usable (and preferably human-readable) name of the package. This \code{MUST} be lower-case and 
#' contain only alphanumeric characters along with ".", "_" or "-" characters. It will function as a unique identifier 
#' and therefore \code{SHOULD} be unique in relation to any registry in which this package will be deposited 
#' (and preferably globally unique).
#' 
#' The name \code{SHOULD} be invariant, meaning that it \code{SHOULD NOT} change when a data package is updated, 
#' unless the new package version should be considered a distinct package, e.g. due to significant changes in structure or 
#' interpretation. Version distinction \code{SHOULD} be left to the version property. As a corollary, the name also 
#' \code{SHOULD NOT} include an indication of time range covered.}
#' 
#' 
#' \item{\code{id}}{
#' A property reserved for globally unique identifiers. Examples of identifiers that are unique include UUIDs and DOIs.
#' 
#' A common usage pattern for Data Packages is as a packaging format within the bounds of a system or platform. 
#' In these cases, a unique identifier for a package is desired for common data handling workflows, such as updating 
#' an existing package. While at the level of the specification, global uniqueness cannot be validated, consumers using 
#' the \code{id} property \code{MUST} ensure identifiers are globally unique.
#' 
#' 
#' Examples: 
#' \itemize{
#' \item{\code{{"id": "b03ec84-77fd-4270-813b-0c698943f7ce"}}}
#' \item{\code{{"id": "https://doi.org/10.1594/PANGAEA.726855"}}}
#' }
#' }
#' \item{\code{licenses}}{
#' The license(s) under which the package is provided.
#' 
#' \strong{This property is not legally binding and does not guarantee the package is licensed 
#' under the terms defined in this property.}
#' 
#' \code{licenses} \code{MUST} be an array. Each item in the array is a License. 
#' Each \code{MUST} be an \code{object}. The object \code{MUST} contain a \code{name} property 
#' and/or a \code{path} property. It \code{MAY} contain a \code{title} property.
#' 
#' Here is an example:
#' 
#' \code{
#' "licenses": [{
#' "name": "ODC-PDDL-1.0",
#' "path": "http://opendatacommons.org/licenses/pddl/",
#' "title": "Open Data Commons Public Domain Dedication and License v1.0"
#' }]
#' }
#' 
#' \itemize{
#' \item{\code{name}: The \code{name} \code{MUST} be an \href{http://licenses.opendefinition.org/}{Open Definition license ID}.}
#' \item{\code{path}: A \href{https://frictionlessdata.io/specs/data-resource/#url-or-path}{url-or-path string}, 
#' that is a fully qualified HTTP address, or a relative POSIX path (see 
#' \href{https://frictionlessdata.io/specs/data-resource/#url-or-path}{the url-or-path definition in Data Resource for details}).}
#' \item{\code{title}: A human-readable title.}
#' }
#' }
#' 
#' \item{\code{profile}}{
#' A string identifying the \href{https://frictionlessdata.io/specs/profiles/}{profile} of this descriptor as per 
#' the \href{https://frictionlessdata.io/specs/profiles/}{profiles} specification.}
#' 
#' Examples: 
#' \itemize{
#' \item{\code{{"profile": "tabular-data-package"}}}
#' \item{\code{{"profile": "http://example.com/my-profiles-json-schema.json"}}}
#' }
#' }
#' 
#' 
#' 
#' @section Optional Properties:
#' The following are commonly used properties that the package descriptor \code{MAY} contain:
#' \describe{
#' 
#' \item{\code{title}}{A string providing a \code{title} or one sentence description for this package.}
#' 
#' \item{\code{description}}{A description of the package. The description \code{MUST} be \href{http://commonmark.org/}{markdown} 
#' formatted -- this also allows for simple plain text as plain text is itself valid markdown. The first paragraph 
#' (up to the first double line break) should be usable as summary information for the package.}
#' 
#' \item{\code{homepage}}{A URL for the home on the web that is related to this data package.}
#' 
#' \item{\code{version}}{A version string identifying the version of the package. It should conform to the 
#' \href{http://semver.org/}{Semantic Versioning} requirements and should follow the 
#' \href{https://frictionlessdata.io/specs/patterns/#data-package-version}{Data Package Version} pattern.}
#' 
#' \item{\code{sources}}{The raw sources for this data package. It \code{MUST} be an array of Source objects. Each Source object \code{MUST} have a \code{title} and \code{MAY} have \code{path} and/or \code{email} properties. 
#' 
#' Example:
#' 
#' \code{
#'   "sources": [{
#'     "title": "World Bank and OECD",
#'     "path": "http://data.worldbank.org/indicator/NY.GDP.MKTP.CD"
#'   }]
#' }
#' 
#' \itemize{
#' \item{\code{title}: Title of the source (e.g. document or organization name).}
#' \item{\code{path}: A \href{https://frictionlessdata.io/specs/data-resource/#url-or-path}{url-or-path string}, 
#' that is a fully qualified HTTP address, or a relative POSIX path (see 
#' \href{https://frictionlessdata.io/specs/data-resource/#url-or-path}{the url-or-path definition in Data Resource for details}).}
#' \item{\code{email}: An email address.}
#' }
#' }
#' 
#' 
#' \item{\code{contributors}}{
#' The people or organizations who contributed to this Data Package. It \code{MUST} be an array. 
#' Each entry is a Contributor and \code{MUST} be an \code{object}. 
#' A Contributor \code{MUST} have a \code{title} property and \code{MAY} contain \code{path}, 
#' \code{email}, \code{role} and \code{organization} properties. An example of the object structure is as follows:
#' 
#' 
#' Example:
#' 
#' \code{
#'    "contributors": [{
#'      "title": "Joe Bloggs",
#'      "email": "joe@bloggs.com",
#'      "path": "http://www.bloggs.com",
#'      "role": "author"
#'    }]
#' }
#' 
#' \itemize{
#' \item{\code{title}: Name/Title of the contributor (name for person, name/title of organization).}
#' \item{\code{path}: A fully qualified http URL pointing to a relevant location online for the contributor.}
#' \item{\code{email}: An email address.}
#' \item{\code{role}: A string describing the role of the contributor. It \code{MUST} be one of: \code{author}, 
#'   \code{publisher}, \code{maintainer}, \code{wrangler}, and \code{contributor}. Defaults to \code{contributor}.
#'   \itemize{
#'    \item{Note on semantics: use of the "author" property does not imply that that person was the original creator of 
#'    the data in the data package - merely that they created and/or maintain the data package. It is common for data 
#'    packages to "package" up data from elsewhere. The original origin of the data can be indicated with the \code{sources} 
#'    property - see above.}}
#' }
#' \item{\code{organization}: A string describing the organization this contributor is affiliated to.}
#' }
#' }
#' 
#' \item{\code{image}}{
#' An image to use for this data package. For example, when showing the package in a listing.
#' 
#' The value of the image property \code{MUST} be a string pointing to the location of the image. 
#' The string must be a \href{https://frictionlessdata.io/specs/data-resource/#url-or-path}{url-or-path}, 
#' that is a fully qualified HTTP address, or a relative POSIX path (see 
#' \href{https://frictionlessdata.io/specs/data-resource/#url-or-path}{the url-or-path definition in Data Resource for details}).}
#' 
#' 
#' \item{\code{created}}{ 
#' The datetime on which this was created.
#' 
#' Note: semantics may vary between publishers -- for some this is the datetime the data was created, 
#' for others the datetime the package was created.
#' 
#' The datetime must conform to the string formats for datetime as described in 
#' \href{https://tools.ietf.org/html/rfc3339#section-5.6}{RFC3339}.
#' 
#' Example:
#' 
#' \code{
#' {"created": "1985-04-12T23:20:50.52Z"}
#' }
#' 
#' }
#' 
#' 
#' }
#' 
#' @section Details:
#' 
#' \href{https://CRAN.R-project.org/package=jsonlite}{Jsolite package} is internally used to convert json data to list objects. The input parameters of functions could be json strings, 
#' files or lists and the outputs are in list format to easily further process your data in R environment and exported as desired. 
#' It is recommended to use \code{\link{helpers.from.json.to.list}} or \code{\link{helpers.from.list.to.json}} to convert json objects to lists and vice versa.
#' More details about handling json you can see jsonlite documentation or vignettes \href{https://CRAN.R-project.org/package=jsonlite}{here}.
#' 
#' Term array refers to json arrays which if converted in R will be \code{\link[base:list]{list objects}}.
#' 
#' @section Language:
#' The key words \code{MUST}, \code{MUST NOT}, \code{REQUIRED}, \code{SHALL}, \code{SHALL NOT}, 
#' \code{SHOULD}, \code{SHOULD NOT}, \code{RECOMMENDED}, \code{MAY}, and \code{OPTIONAL} 
#' in this package documents are to be interpreted as described in \href{https://www.ietf.org/rfc/rfc2119.txt}{RFC 2119}.
#' 
#' 
#' @name datapackage.r-package
#' 
#' @seealso 
#' \href{https://frictionlessdata.io/specs/data-package/}{Data Package Specifications}
#' 
NULL
